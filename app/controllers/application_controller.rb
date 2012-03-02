class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization

  before_filter :set_timezone
  
  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    flash[:notice] = 'You cannot do that.'
    redirect_to root_url
  end

  protected
  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end

  def authenticate
    unless current_user
      flash[:notice] = 'You must be logged in to do that.'
      redirect_to login_path
      return false
    end
  end

  def set_timezone
    current_user_zone = current_user.nil? ? nil : current_user.time_zone
    current_user_zone = nil if current_user_zone == ""
    Time.zone = current_user_zone || CloudLeagues::Application.config.time_zone
  end
end
