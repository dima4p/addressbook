class Notifier < ActionMailer::Base

  default :from => "dima@koulikoff.ru"

  def activation_instructions(user)
    @user = user
    @url = activate_url :code => user.perishable_token
    mail  :to => user.email,
          :subject => I18n.t(:application_name) + ': ' + I18n.t(:activation_instructions)
  end

  def welcome(user)
    @url = root_url
    mail  :to => user.email,
          :subject => I18n.t(:application_name) + ': ' + I18n.t('welcome.text')
  end

  def password_reset_instructions(user)
    @url = edit_password_reset_url(user.perishable_token)
    mail  :to => user.email,
          :subject => I18n.t(:application_name) + ': ' + I18n.t(:password_reset_instructions)
  end

end
