require 'spec_helper'

describe "users/new.html.haml" do

  before(:each) do
    controller.stub(:can?).and_return(true)
    assign(:user, @user = stub_model(User,
      :email => "MyString",
      :password => "MyString"
    ).as_new_record)
  end

  it "renders new user form" do
    render
    view.should render_template(:partial => "users/_form")
    assert_select "a[href='/en/users']"
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_name[name=?]", "user[name]", 1
      assert_select "input#user_email", :name => "user[email]"
      assert_select "input#user_password", :name => "user[password]"
      assert_select "input#user_admin", :name => "user[roles]"
    end
  end

  it 'should not render roles if cannot?(:set_roles, User)' do
    controller.should_receive(:can?).with(:set_roles, @user).and_return(false)
    render
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_admin", 0
    end
  end

  it 'should not render link to :index if cannot?(:index, User)' do
    controller.should_receive(:can?).with(:index, User).and_return(false)
    render
    assert_select "a[href='/en/users']", 0
  end

end
