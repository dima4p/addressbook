require 'spec_helper'

# {"skip_namespace"=>false, "old_style_hash"=>false, "force_plural"=>false, "orm"=>:active_record, "template_engine"=>:haml, "controller_specs"=>true, "view_specs"=>true, "webrat"=>false, "webrat_matchers"=>false, "helper_specs"=>true, "routing_specs"=>true, "integration_tool"=>:rspec}

describe "contacts/edit.html.haml" do
  before(:each) do
    controller.stub!(:can?).and_return(true)
    @contact = assign(:contact, stub_model(Contact,
      :first_name => "MyString",
      :middle_name => "MyString",
      :last_name => "MyString",
      :phone => "MyString"
    ))
  end

  it "renders the edit contact form" do
    render

    assert_select "form", :action => contacts_path(@contact), :method => "post" do
      assert_select "input#contact_first_name[name=?]", "contact[first_name]"
      assert_select "input#contact_middle_name[name=?]", "contact[middle_name]"
      assert_select "input#contact_last_name[name=?]", "contact[last_name]"
      assert_select "input#contact_phone[name=?]", "contact[phone]"
    end
  end
end
