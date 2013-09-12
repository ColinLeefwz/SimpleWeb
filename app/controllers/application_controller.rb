class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    def check
      logger.info "this is application check method, the session is : #{session[:login]}"
      if session[:login] == nil
        redirect_to sign_in_admin_index_path
      end
    end
  end

