class ApplicationController < ActionController::Base
	before_filter :configure_permitted_parameters, if: :devise_controller?

	after_action :store_location

	protect_from_forgery with: :exception

	def configure_permitted_parameters
		devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password) }
	end

	def store_location
		previous_path = request.fullpath

		if (previous_path != "/users/sign_in" && previous_path != "/users/sign_up" && previous_path != "/users/password" && !request.xhr?)
			cookies[:previous_path] = request.original_url
		elsif(previous_path == "/admin/login")
			cookies[:previous_path] = request.base_url + "/admin"
		end

	end

	def after_sign_in_path_for(resource)
		cookies[:previous_path] || root_path
	end

end

