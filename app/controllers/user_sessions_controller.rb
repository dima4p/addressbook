class UserSessionsController < ApplicationController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = t 'authlogic.logged_in', :name => @user_session.record.email
      redirect_to_target_or_default(root_url)
    else
      logger.info "UserSessionsController#create@#{__LINE__} #{@user_session.errors.inspect}"
      login_fields = [:email, :password]
      if (@user_session.errors.keys & login_fields).present?
        (login_fields - @user_session.errors.keys).each do |key|
          mkey = key == :login ? 'login_not_found' : 'password_invalid'
          @user_session.errors[key] = t "authlogic.error_messages.#{mkey}"
        end
      elsif params[:resend_activation]
        @user_session.attempted_record.deliver_activation_instructions!
        flash[:notice] = t 'authlogic.new_activation_code'
        @user_session.errors.clear
      else
        @resend_activation = true
      end
      render :action => 'new'
    end
  end

  def destroy
    session[:return_to] = nil
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = t 'authlogic.lgged_out'
    redirect_to login_url
  end
end
