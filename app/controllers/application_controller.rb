class ApplicationController < ActionController::Base
  include Authentication

  protect_from_forgery
  before_filter :set_locale
  before_filter :set_hostname

  def default_url_options(options={})
    options.merge(:locale => I18n.locale)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t :access_denied
    store_target_location
    logger.debug "ApplicationController@#{__LINE__}#rescue_from #{request.fullpath}\n#{current_ability.inspect}" if logger.debug?
    redirect_to new_user_session_url
  end

  private

  def set_locale
    I18n.locale = params[:locale] =
      if params[:locale] and I18n.available_locales.include? params[:locale].to_sym
        params[:locale]
      else
        preferred_language
      end
    @text_direction = RTL_LANGS.include?(I18n.locale) ? 'rtl' : 'ltr'
    logger.info "ApplicationController@#{__LINE__}#set_locale locale is #{I18n.locale.inspect} user is #{logged_in? ? current_user.email + "(#{current_user.id})" : '_guest_'}"
#     @debug_ability = current_ability.send(:rules).map do |r|
#       {:a => r.actions, :r => r.conditions, :s => r.subjects.map{|klass|klass.name}}
#     end
  end

  def user_preferred_languages
    request.headers['Accept-Language'].split(',').collect do |l|
      l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
      l.split(';q=')
    end.sort do |x,y|
      raise "Not correctly formatted" unless x.first =~ /^[a-z\-]+$/i
      y.last.to_f <=> x.last.to_f
    end.collect do |l|
      l.first.downcase.gsub(/-[a-z]+$/i) { |x| x.upcase }
    end
  rescue # Just rescue anything if the browser messed up badly.
    []
  end

  def preferred_language
    (user_preferred_languages & I18n.available_locales.map(&:to_s)).first || I18n.default_locale
  end

  def require_no_user
    if logged_in?
      flash[:notice] = t :no_login_to_acces
      redirect_to root_url
      return false
    end
  end

  def set_hostname
    @hostname = request.host
    port = request.port
    @hostname << ":#{port}" if port != 80
#     @hostname << "/#{I18n.locale}"
    Rails.application.config.action_mailer.default_url_options =
      {:host => @hostname, :locale => I18n.locale}
  end

end
