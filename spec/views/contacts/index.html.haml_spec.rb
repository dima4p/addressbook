require 'spec_helper'

describe "contacts/index.html.haml" do
  before(:each) do
    controller.stub!(:can?).and_return(true)
    assign(:contacts, [
      stub_model(Contact,
        :first_name => "First Name",
        :middle_name => "Middle Name",
        :last_name => "Last Name",
        :phone => "Phone"
      ),
      stub_model(Contact,
        :first_name => "First Name",
        :middle_name => "Middle Name",
        :last_name => "Last Name",
        :phone => "Phone"
      )
    ])
  end

  it "renders a list of contacts" do
    render

    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Middle Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
  end
end
