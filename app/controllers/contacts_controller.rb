class ContactsController < ApplicationController

  load_and_authorize_resource index: [:export], except: [:import, :upload]
  before_filter :set_order, only: [:index, :new, :create, :import, :upload]

  # GET /contacts
  # GET /contacts.json
  def index
    #@contacts = Contact.all
    if @sort
      @contacts = @contacts.order(@sort) if Contact.attribute_names.include? @sort
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    #@contact = Contact.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  # GET /contacts/new.js
  def new
    #@contact = Contact.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
      format.js
    end
  end

  # GET /contacts/1/edit
  # GET /contacts/1/edit.json
  # GET /contacts/1/edit.js
  def edit
    #@contact = Contact.find(params[:id])
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
      format.js { render 'new' }
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create
    #@contact = Contact.new(params[:contact])
    respond_to do |format|
      if @contact.save
        format.html { redirect_to(contacts_url, :notice => t('contacts.was_created.')) }
        format.json { render json: @contact, status: :created, location: @contact }
        format.js {
        @contacts = Contact.accessible_by current_ability
        @contacts = @contacts.order(@sort) if @sort and Contact.attribute_names.include? @sort
      }
      else
        format.html { render :action => "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.js { render 'failure' }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  # PUT /contacts/1.js
  def update
    #@contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(contacts_url, :notice => t('contacts.was_updated.')) }
        format.json { head :ok }
        format.js { render 'success' }
      else
        format.html { render :action => "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
        format.js { render 'failure' }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    #@contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to(contacts_url, :notice => t('contacts.was_deleted.')) }
      format.json { head :ok }
      format.js
    end
  end

  # GET /contacts/export
  # GET /contacts/export.json
  def export
    #@contacts = Contact.all
    send_data Contact.to_csv(@contacts),
        :filename => 'addressbook.csv',
        :type => 'text/csv; charset=utf-8',
        :disposition => 'attachment'
  end

  # GET /contacts/import
  # GET /contacts/import.js
  def import
    authorize! :import, Contact
    respond_to do |format|
      format.html # new.html.erb
      format.js
    end
  end

  # POST /contacts/import
  def upload
    authorize! :upload, Contact
    Contact.merge_csv params[:csv][:name].read, current_user
    respond_to do |format|
      format.html {redirect_to contacts_url}
      format.js {
        @contacts = Contact.accessible_by current_ability
        @contacts = @contacts.order(@sort) if @sort and Contact.attribute_names.include? @sort
        render 'create'
      }
    end
  end

  private

  def set_order
    @sort = params[:sort]
  end

end
