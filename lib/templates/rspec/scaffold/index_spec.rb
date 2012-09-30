require 'spec_helper'

<% output_attributes = attributes.reject{|attribute| [:datetime, :timestamp, :time, :date].index(attribute.type) } -%>
describe "<%= table_name %>/index.html.<%= options[:template_engine] %>" do
  before(:each) do
    controller.stub!(:can?).and_return(true)
<% if options[:fixture_replacement] == :factory_girl -%>
    @<%= file_name %> = create(:<%= file_name %>)
    result_set = [@<%= file_name %>, @<%= file_name %>]
<% else -%>
    # assign(:<%= table_name %>, [
    result_set = [
<% [1,2].each_with_index do |id, model_index| -%>
      stub_model(<%= class_name %><%= output_attributes.empty? ? (model_index == 1 ? ')' : '),') : ',' %>
<% output_attributes.each_with_index do |attribute, attribute_index| -%>
        :<%= attribute.name %> => <%= value_for(attribute) %><%= attribute_index == output_attributes.length - 1 ? '' : ','%>
<% end -%>
<% if !output_attributes.empty? -%>
      <%= model_index == 1 ? ')' : '),' %>
<% end -%>
<% end -%>
    ]
<% end -%>
    <%= class_name %>.should_receive(:paginate).and_return(result_set)
    result_set.should_receive(:total_entries).and_return(result_set.size)
    result_set.should_receive(:total_pages).exactly(result_set.size).and_return(1)
    result_set.should_receive(:offset).exactly(result_set.size).and_return(0)
    Wice::JsAdaptor.init
    assign(:grid, Wice::WiceGrid.new(<%= class_name %>, controller))
  end

  it "renders a list of <%= table_name %>" do
    render

<% for attribute in output_attributes -%>
<% if webrat? -%>
    rendered.should have_selector("tr>td", :content => <%= value_for(attribute) %>.to_s, :count => 2)
<% elsif options[:fixture_replacement] == :factory_girl -%>
    assert_select "tr>td", :text => @<%= file_name %>.<%= attribute %>.to_s, :count => 2
<% else -%>
    assert_select "tr>td", :text => <%= value_for(attribute) %>.to_s, :count => 2
<% end -%>
<% end -%>
  end
end
