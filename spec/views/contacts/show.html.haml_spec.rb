require 'spec_helper'

describe "contacts/show.html.haml" do
  before(:each) do
    controller.stub(:can?).and_return(true)
    @contact = assign(:contact, stub_model(Contact,
      :first_name => "First Name",
      :middle_name => "Middle Name",
      :last_name => "Last Name",
      :phone => "Phone"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/First Name/)
    rendered.should match(/Middle Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/Phone/)
  end
end
