require 'spec_helper'

describe "users/index.html.haml" do
  before(:each) do
    controller.stub(:can?).and_return(true)
    assign(:users, [
      stub_model(User,
        :email => "Email",
        :active => true
      ),
      stub_model(User,
        :email => "Email",
        :active => true
      )
    ])
  end

  it "renders a list of users" do
    render
    # rendered.should == ''

    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => I18n.t("true"), :count => 2
  end
end
