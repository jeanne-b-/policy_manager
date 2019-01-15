class <%= class_name %>PortabilitySerializer < <%= parent_class_name %>
  attributes <%= attributes_names.map(&:inspect).join(",\n             ") %>

  <% has_ones.each do |attribute| -%>
has_one :<%= attribute %>, serializer: <%= attribute.to_s.classify + 'PortabilitySerializer' %>
  <% end -%>

  <% has_manys.each do |attribute| -%>
has_many :<%= attribute %>, serializer: <%= attribute.to_s.classify + 'PortabilitySerializer' %>
  <% end -%>
  
end
