class Users::PasswordsController < Devise::PasswordsController

  ## override it if want to customize the reset_password method
  # def create
  # end

  protected
  def after_sending_reset_password_instructions_path_for(resource_name)
    root_path
  end

end
