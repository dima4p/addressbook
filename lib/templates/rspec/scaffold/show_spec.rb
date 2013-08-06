require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= table_name %>/show.html.<%= options[:template_engine] %>" do
  before(:each) do
    controller.stub(:can?).and_return(true)
<% if options[:fixture_replacement] == :factory_girl -%>
    @<%= file_name %> = assign(:<%= file_name %>, create(:<%= file_name %>))
<% else -%>
    @<%= file_name %> = assign(:<%= file_name %>, stub_model(<%= class_name %><%= output_attributes.empty? ? '))' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<% if !output_attributes.empty? -%>
    ))
<% end -%>
<% end -%>
  end

  it "renders attributes in <p>" do
    render
<% for attribute in output_attributes -%>
<% if webrat? -%>
    rendered.should contain(<%= value_for(attribute) %>.to_s)
<% elsif options[:fixture_replacement] == :factory_girl -%>
    rendered.should match(Regexp.new @<%= file_name %>.<%= attribute %>.to_s)
<% else -%>
    rendered.should match(/<%= eval(value_for(attribute)) %>/)
<% end -%>
<% end -%>
  end
end
