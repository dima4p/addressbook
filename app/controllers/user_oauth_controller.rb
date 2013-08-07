class UserOauthController < ApplicationController
  def create
    @current_user = User.find_or_create_from_oauth(auth_hash)
    if @current_user
      UserSession.create(@current_user, true)
      redirect_to root_url, :notice => t("omniauth.logged_in")
    else
      redirect_to root_url, :flash => {:error => t("omniauth.not_authorized")}
    end
  end

  def failure
    redirect_to root_url,
        :flash => {:error => t("omniauth.not_authorized_with_message",
                               message: params[:message])}
  end

  protected

  def auth_hash
    logger.debug "UserOauthController@#{__LINE__}#auth_hash #{request.env['omniauth.auth'].inspect}" if logger.debug?
    request.env['omniauth.auth']
  end
end