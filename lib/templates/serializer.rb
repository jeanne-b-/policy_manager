class <%= class_name %>PortabilitySerializer < <%= parent_class_name %>
  attributes <%= attributes_names.map(&:inspect).join(",\n              ") %>

  <% has_ones.each do |attribute| -%>
has_one :<%= attribute %>
  <% end -%>

  <% has_manys.each do |attribute| -%>
has_many :<%= attribute %>
  <% end -%>
  
end
