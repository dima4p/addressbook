class ActivationsController < ApplicationController

#   before_filter :require_no_user

  def create
    @user = User.find_using_perishable_token(params[:code], 1.week)

    if not @user
      flash[:notice] = t 'users.can_not_find_activation'
    elsif @user.activate!
      flash[:notice] = t 'users.account_activated'
      UserSession.create(@user, false) # Log user in manually
      @user.deliver_welcome!
    end
    redirect_to root_url
  end

end
