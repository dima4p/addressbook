require 'spec_helper'

describe "users/show.html.haml" do
  before(:each) do
    controller.stub!(:can?).and_return(true)
    @user = assign(:user, stub_model(User,
      :email => "Email"
    ))
  end

  it "renders attributes in <p>" do
    render
    rendered.should match(/Email/)
  end
end
