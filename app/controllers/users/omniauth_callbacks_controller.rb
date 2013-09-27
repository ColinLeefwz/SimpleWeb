class Users::OmniauthCallbacksController <Devise::OmniauthCallbacksController
  def linkedin
    @user = User.find_for_linkedin(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session["devise.linkedin.data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end 
end
