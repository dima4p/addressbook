require 'spec_helper'

describe UsersController do

  def mock_user(stubs={})
    attrs = {email: 'boss@abook.ru'}.reverse_merge(stubs)
    @mock_user ||= mock_model(User, attrs).as_null_object
  end

  before :each do
    controller.stub!(:current_user).and_return(current_user)
  end

  describe "GET index" do
    it "assigns all users as @users" do
      get :index
      assigns(:users).should be_a_kind_of(ActiveRecord::Relation)
    end
  end

  describe "GET show" do
    it 'redirects to :login if not logged in' do
      controller.should_receive(:current_user).and_return(User.new)
      User.should_receive(:find).with(current_user.id).and_return(nil)
      get :show, :id => "current"
      response.should redirect_to(login_path)
    end

    it "assigns the requested user as @user" do
      User.stub(:find).with("37") { mock_user }
      get :show, :id => "37"
      assigns(:user).should be(mock_user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      User.stub(:new) { mock_user }
      get :new
      assigns(:user).should be(mock_user)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      User.stub(:find).with("37") { mock_user }
      get :edit, :id => "37"
      assigns(:user).should be(mock_user)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created user as @user" do
        User.stub(:new).with({'these' => 'params'}) { mock_user(:save => true) }
        post :create, :user => {'these' => 'params'}
        mock_user.should_not_receive(:roles=)
        assigns(:user).should be(mock_user)
      end

      it "redirects to the created user" do
        User.stub(:new) { mock_user(:save => true) }
        post :create, :user => {}
        response.should redirect_to(user_url(mock_user))
      end

      it "sends the notification to the created user" do
        User.should_receive(:count).and_return(1)
        User.stub(:new) { mock_user(:save_without_session_maintenance => true, :valid? => true) }
        mock_user.should_receive(:deliver_activation_instructions!)
        post :create, :user => {}
      end

      it 'clears user roles if current user can not :set_roles' do
        User.stub(:new) { mock_user }
        controller.should_receive(:can?).with(:set_roles, User).and_return(false)
        mock_user.should_receive(:roles=).with([])
        post :create, :user => {}
      end

      it 'makes the new user to be admin and activates it if it is the first one' do
        User.stub(:new) { mock_user }
        User.should_receive(:count).and_return(0)
        mock_user.should_not_receive(:deliver_activation_instructions!)
        post :create, :user => {}
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        User.stub(:new).with({'these' => 'params'}) { mock_user(:save => false) }
        post :create, :user => {'these' => 'params'}
        assigns(:user).should be(mock_user)
      end

      it "re-renders the 'new' template" do
        User.stub(:new) { mock_user(:valid? => false) }
        post :create, :user => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        User.stub(:find).with("37") { mock_user }
        mock_user.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :user => {'these' => 'params'}
      end

      it "assigns the requested user as @user" do
        User.stub(:find) { mock_user(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:user).should be(mock_user)
      end

      it "redirects to the user" do
        User.stub(:find) { mock_user(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(user_url(mock_user))
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        User.stub(:find) { mock_user(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:user).should be(mock_user)
      end

      it "re-renders the 'edit' template" do
        User.stub(:find) { mock_user(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      User.stub(:find).with("37") { mock_user }
      mock_user.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the users list" do
      User.stub(:find) { mock_user }
      delete :destroy, :id => "1"
      response.should redirect_to(users_url)
    end
  end

end
