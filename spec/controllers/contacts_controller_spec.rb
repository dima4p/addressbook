require 'spec_helper'

describe ContactsController do

  def mock_contact(stubs={})
    attrs = {user_id: current_user.id}.reverse_merge(stubs)
    @mock_contact ||= mock_model(Contact, attrs).as_null_object
  end

  before :each do
    controller.stub(:current_user).and_return(current_user)
  end

  describe "GET index" do
    it "assigns all contacts as @contacts" do
      get :index
      assigns(:contacts).should be_a_kind_of(ActiveRecord::Relation)
    end
  end

  describe "GET show" do
    it "assigns the requested contact as @contact" do
      Contact.stub(:find).with("37") { mock_contact }
      get :show, :id => "37"
      assigns(:contact).should be(mock_contact)
    end
  end

  describe "GET new" do
    it "assigns a new contact as @contact" do
      Contact.stub(:new) { mock_contact }
      get :new
      assigns(:contact).should be(mock_contact)
    end
  end

  describe "GET edit" do
    it "assigns the requested contact as @contact" do
      Contact.stub(:find).with("37") { mock_contact }
      get :edit, :id => "37"
      assigns(:contact).should be(mock_contact)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created contact as @contact" do
        Contact.stub(:new).with({'these' => 'params'}) { mock_contact(:save => true) }
        post :create, :contact => {'these' => 'params'}
        assigns(:contact).should be(mock_contact)
      end

      it "redirects to the created contact" do
        Contact.stub(:new) { mock_contact(:save => true) }
        post :create, :contact => {}
        response.should redirect_to(contacts_url)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contact as @contact" do
        Contact.stub(:new).with({'these' => 'params'}) { mock_contact(:save => false) }
        post :create, :contact => {'these' => 'params'}
        assigns(:contact).should be(mock_contact)
      end

      it "re-renders the 'new' template" do
        Contact.stub(:new) { mock_contact(:save => false) }
        post :create, :contact => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested contact" do
        Contact.stub(:find).with("37") { mock_contact }
        mock_contact.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :contact => {'these' => 'params'}
      end

      it "assigns the requested contact as @contact" do
        Contact.stub(:find) { mock_contact(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:contact).should be(mock_contact)
      end

      it "redirects to the contact" do
        Contact.stub(:find) { mock_contact(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(contacts_url)
      end
    end

    describe "with invalid params" do
      it "assigns the contact as @contact" do
        Contact.stub(:find) { mock_contact(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:contact).should be(mock_contact)
      end

      it "re-renders the 'edit' template" do
        Contact.stub(:find) { mock_contact(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested contact" do
      Contact.stub(:find).with("37") { mock_contact }
      mock_contact.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the contacts list" do
      Contact.stub(:find) { mock_contact }
      delete :destroy, :id => "1"
      response.should redirect_to(contacts_url)
    end
  end

  describe "GET export" do
    it 'forms the csv file for the available contacts and renders as file' do
      Contact.should_receive(:to_csv) {'csv text'}
      get :export
      response.body.should == 'csv text'
    end
  end

  describe "GET import" do
    it 'renders the "import" template' do
      get :import
      response.should render_template("import")
    end
  end

  describe "POST upload" do
    it 'renders the "import" template' do
      filename = File.join(['', 'files', 'address_book.csv'])
      file = fixture_file_upload(filename, 'text/scv')
      Contact.should_receive(:merge_csv).with(file.read, current_user)
      file = fixture_file_upload(filename, 'text/scv')
      post :upload, csv: {name: file}
      response.should redirect_to(contacts_url)
    end
  end

end
