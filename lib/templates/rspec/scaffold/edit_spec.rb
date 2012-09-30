require 'spec_helper'

# <%= options.inspect %>

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= table_name %>/edit.html.<%= options[:template_engine] %>" do
  before(:each) do
    controller.stub!(:can?).and_return(true)
<% if options[:fixture_replacement] == :factory_girl -%>
    @<%= file_name %> = assign(:<%= file_name %>, create(:<%= file_name %>))
<% else -%>
    @<%= file_name %> = assign(:<%= file_name %>, stub_model(<%= class_name %><%= output_attributes.empty? ? '))' : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
      :<%= attribute.name %> => <%= attribute.default.inspect %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<%= output_attributes.empty? ? "" : "    ))\n" -%>
<% end -%>
  end

  it "renders the edit <%= file_name %> form" do
    render

<% if webrat? -%>
    rendered.should have_selector("form", :action => <%= file_name %>_path(@<%= file_name %>), :method => "post") do |form|
<% for attribute in output_attributes -%>
      form.should have_selector("<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %>", :name => "<%= file_name %>[<%= attribute.name %>]")
<% end -%>
    end
<% else -%>
    assert_select "form", :action => <%= index_helper %>_path(@<%= file_name %>), :method => "post" do
<% for attribute in output_attributes -%>
      assert_select "<%= attribute.input_type -%>#<%= file_name %>_<%= attribute.name %>[name=?]", "<%= file_name %>[<%= attribute.name %>]"
<% end -%>
    end
<% end -%>
  end
end
