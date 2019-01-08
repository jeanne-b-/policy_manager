// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//= require turbolinks
//= require jquery
//= require cocoon
//= require_tree .

var myMarked = marked;
myMarked.setOptions({
  renderer: new myMarked.Renderer(),
  breaks: false,
  gfm: true,
  sanitize: true,
  smartLists: true,
  smartypants: true,
  xhtml: false
});

function init() {
  Array.from($("textarea.marked")).forEach(function(input) {
    $(input).on('keyup', function() {
      var scroll_height = this.scrollHeight;
    
      $(this).css('height', scroll_height + 'px');
    });
  });

  // marked content
  Array.from(document.getElementsByClassName('marked-content')).forEach(function(elem) {
      elem.innerHTML = myMarked(elem.innerHTML);
  });

  // marked inputs
  Array.from(document.getElementsByClassName('row marked')).forEach(function(elem) {
    var input;
    var e;
    input = elem.getElementsByTagName('textarea')[0];
    e = input.addEventListener('keyup', function(input) {
      value = elem.getElementsByTagName('textarea')[0].value;
      elem.getElementsByClassName('markdown-preview')[0].innerHTML = myMarked(value);
    });
    input.dispatchEvent(new Event('keyup'));
  });

}


$(document).ready(function() {
  init();
});

$(document).on("turbolinks:load", function() {
  init();
});

$(document).on('cocoon:after-insert', function() {
  init();
});

