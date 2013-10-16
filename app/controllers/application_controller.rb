class ApplicationController < ActionController::Base

  before_filter :configure_permitted_parameters, if: :devise_controller?

  after_action :store_location

  protect_from_forgery with: :exception

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
  end

  def store_location
    previous_path = request.fullpath

    if(previous_path == "/admin/login")
      cookies[:previous_path] = request.base_url + "/admin"
    elsif(previous_path != "/users/sign_in" && previous_path != "/users/sign_up" && previous_path != "/users/password" && !request.xhr?)
      cookies[:previous_path] = request.original_url
    end

  end

  def after_sign_in_path_for(resource)
    cookies[:previous_path] || root_path
  end

  ## ActiveAdmin user to User table
  def authenticate_admin_user! #use predefined method name
    redirect_to '/' and return if user_signed_in? && !(current_user.is_a? AdminUser)
    authenticate_user!
  end
  def current_admin_user #use predefined method name
    return nil if user_signed_in? && !(current_user.is_a? AdminUser)
    current_user
  end

  protected
  ## Override devise-invitable before_filter
  def authenticate_inviter!
    unless current_admin_user.nil?
      current_admin_user
    end
  end
end

