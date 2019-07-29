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

/*

      DANS CE FICHIER NON COMPILE AVEC BABEL IL EST OBLIGATOIRE DECRIRE DU JAVASCRIPT COMPATIBLE AVEC IE (10,11)

*/


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
  $("textarea.marked").each(function() {
    $(this).on('keyup', function() {
      $(this).css('height', this.scrollHeight + 'px');
    });
  })

  // marked content
  $('.marked-content').each(function() {
    this.innerHTML = myMarked(this.innerHTML);
  });

  // marked inputs
  $('.row .marked').each(function() {
    var input = this.find('textarea').first();
    input.addEventListener('keyup', function() {
      var value = this.find('textarea').first().value;
      this.find('.markdown-preview').first().innerHTML = myMarked(value);
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

