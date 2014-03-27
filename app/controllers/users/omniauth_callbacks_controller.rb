class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in @user
      @user.update_attributes type: "Member"
      redirect_to cookies[:previous_path]

    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

  def linkedin
    @user = User.find_for_linkedin(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in @user
      @user.update_attributes type: "Member"
      redirect_to cookies[:previous_path]
    else
      session["devise.linkedin.data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end
