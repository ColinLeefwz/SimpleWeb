require 'paypal'
require 'mandrill_api'

class ApplicationController < ActionController::Base
  before_filter do
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_filter :configure_permitted_parameters, if: :devise_controller?
  after_action :store_location

  protect_from_forgery with: :exception


  def current_ability
    @current_ability ||= Ability.new(current_user, params)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Access Denied"
    redirect_to root_url
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :time_zone) }
  end


  def store_location
    previous_path = request.fullpath

    if(previous_path == "/admin/login")
      cookies[:previous_path] = request.base_url + "/admin"
    elsif(previous_path != "/users/sign_in" && previous_path != "/users/sign_up" && !previous_path.start_with?("/users/password") && !request.xhr? && previous_path != "/users")
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

  ## payments and enrollments
  # paypal
  def paypal_pay(item)
    order = Order.new(user: current_user, enrollable: item)

    if order.save
      Paypal.create_payment_with_paypal(item, order, order_execute_url(order.id))

      if order.approve_url
        redirect_to order.approve_url
      else
        redirect_to send("#{item.class.name.downcase}_path", item.id), flash: {error: "Opps, something went wrong"}
      end
    else
      redirect_to send("#{item.class.name.downcase}_path", item.id), flash: {error: order.errors.messages}
    end
  end

  # todo: move it to concern
  # send mail after user successfully enrolled 
  def send_enrolled_mail(item)
    domain_url = request.base_url
    if domain_url == "http://localhost:3000"
      domain_url = "http://www.prodygia.com"
    end
    mandrill = MandrillApi.new
    mandrill.enroll_comfirm(current_user, item, item.cover.url)
  end
  


  protected
  ## Override devise-invitable before_filter
  def authenticate_inviter!
    unless current_admin_user.nil?
      current_admin_user
    end
  end
  
end

