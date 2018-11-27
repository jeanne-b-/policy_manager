class MarkedInput < SimpleForm::Inputs::TextInput
  def input(wrapper_options)
    template.content_tag(:div, {class: 'row marked'}) do
      out = []
      out << template.content_tag(:div, {class: 'col-sm-6'}) do
        super
      end
      out << template.content_tag(:div, {class: 'col-sm-6 markdown-preview bg-light'}) do
      end
      template.concat out.join.html_safe
    end
  end
end
