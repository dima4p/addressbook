class ContactsController < ApplicationController

  load_and_authorize_resource index: [:export], except: [:import, :upload]

  # GET /contacts
  # GET /contacts.json
  def index
    #@contacts = Contact.all
    if sort = params[:sort]
      @contacts = @contacts.order(sort) if Contact.attribute_names.include? sort
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
  def new
    #@contact = Contact.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    #@contact = Contact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.json
  def create
    #@contact = Contact.new(params[:contact])
    respond_to do |format|
      if @contact.save
        format.html { redirect_to(contacts_url, :notice => t('contacts.was_created.')) }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render :action => "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def update
    #@contact = Contact.find(params[:id])
    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to(contacts_url, :notice => t('contacts.was_updated.')) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
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
  def import
    authorize! :import, Contact
  end

  # POST /contacts/import
  def upload
    authorize! :upload, Contact
    Contact.merge_csv params[:csv][:name].read, current_user
    redirect_to contacts_url
  end

end
