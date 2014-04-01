require 'mandrill_api'

class ApplicationController < ActionController::Base
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_action :store_location

  ## Peter: based on this site https://gist.github.com/hbrandl/5253211 to show flash mesaage when using AJAX
  # after_action :flash_to_headers 

  protect_from_forgery with: :exception


  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access Denied"
    redirect_to root_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :time_zone, :subscribe_newsletter) }
  end


  def store_location
    previous_path = request.fullpath

    if(previous_path == "/admin/login")
      cookies[:previous_path] = request.base_url + "/admin"
    elsif((previous_path != "/users/sign_in") && (previous_path != "/users/sign_up") && (!previous_path.start_with?("/users/password")) && (!previous_path.start_with?("/users/invitation/accept")) && (!request.xhr?) && (previous_path != "/users"))
      cookies[:previous_path] = request.original_url
    end
  end

  def after_sign_in_path_for(resource)
    if current_user.is_a? AdminUser
      admin_dashboard_path
    else
      cookies[:previous_path] || root_path
    end
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

  private
  # def flash_to_headers
  #   return unless request.xhr?
  #   msg = flash_message
  #   response.headers["X-Message"] = msg
  #   response.headers["X-Message-Type"] = flash_type.to_s

  #   flash.discard 
  # end

  # def flash_message
  #   [:success, :error, :warning, :notice].each do |type|
  #     return flash[type] unless flash[type].blank?
  #   end

  #   return ""
  # end

  # def flash_type
  #   [:success, :error, :warning, :notice, :keep].each do |type|
  #     return type unless flash[type].blank?
  #   end
  #   return :empty
  # end
  
end

