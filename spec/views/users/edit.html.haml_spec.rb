require 'spec_helper'

# {"skip_namespace"=>false, "old_style_hash"=>false, "force_plural"=>false, "orm"=>:active_record, "template_engine"=>:haml, "controller_specs"=>true, "view_specs"=>true, "webrat"=>false, "webrat_matchers"=>false, "helper_specs"=>true, "routing_specs"=>true, "integration_tool"=>:rspec}

describe "users/edit.html.haml" do
  before(:each) do
    controller.stub(:can?).and_return(true)
    @user = assign(:user, @user = stub_model(User,
      :new_record? => false,
      :email => "MyString",
      :password => "MyString"
    ))
  end

  it "renders the edit user form" do
    render

    view.should render_template(:partial => "users/_form")
    assert_select "a[href='/en/users']", 1
    assert_select "a[href='/en/users/#{@user.id}']", 1
    assert_select "form", :action => user_path(@user), :method => "post" do
      assert_select "input#user_email[name=?]", "user[email]", 1
      assert_select "input#user_password[name=?]", "user[password]"
      assert_select "input#user_admin", 1
    end
  end

  it 'should not render roles if cannot?(:set_roles, User)' do
    controller.should_receive(:can?).with(:set_roles, @user).and_return(false)
    render
    assert_select "a[href='/en/users']", 1
    assert_select "form", :action => users_path, :method => "post" do
      assert_select "input#user_name[name=?]", "user[name]", 1
      assert_select "input#user_email[name=?]", "user[email]", 1
      assert_select "input#user_password[name=?]", "user[password]"
      assert_select "input#user_admin", 0
    end
  end

  it 'should not render link to :index if cannot?(:index, User)' do
    controller.should_receive(:can?).with(:index, User).and_return(false)
    render
    assert_select "a[href='/en/users']", 0
  end

  it 'should not render link to :show if cannot?(:show, User)' do
    controller.should_receive(:can?).with(:show, @user).and_return(false)
    render
    assert_select "a[href='/en/users/#{@user.id}']", 0
  end

end
