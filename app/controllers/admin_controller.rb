class AdminController < ApplicationController

  def index 
		
  end

  def authenticate
    username = params[:admin][:username]
    password = params[:admin][:password]
    if (username == 'sameer') && (password == '123')
    	session[:login] = true
    	render 'index'
    else
    	redirect_to sign_in_admin_index_path
    end
  end 

  def sign_in

  end
end
