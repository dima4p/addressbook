class UsersController < ApplicationController

  before_filter :set_current_user_id
  load_and_authorize_resource

  # GET /users
  # GET /users.json
  def index
    #@users = User.all
    @users = @users.order('id ASC')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    #@user = User.find(params[:id])
    return redirect_to login_path unless @user
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    #@user = User.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    #@user = User.find(params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    #@user = User.new(params[:user])
    @user.roles = [] unless can? :set_roles, User
    if User.count == 0
      @user.save
    else
      @user.save_without_session_maintenance and @user.deliver_activation_instructions!
      notice = t('users.was_created.')
    end
    respond_to do |format|
      if @user.valid?
        format.html { redirect_to(login_url, :notice => notice) }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render :action => "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    #@user = User.find(params[:id])
    respond_to do |format|
      params[:user].delete(:roles) unless can? :set_roles, @user
      if @user.update_attributes(params[:user])
        format.html { redirect_to(@user, :notice => t('users.was_updated.')) }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    #@user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url, :notice => t('users.was_deleted.')) }
      format.json { head :ok }
    end
  end

  private

  def set_current_user_id
    params[:id] = current_user.id if params[:id] == 'current'
  end

end
