class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
	def facebook
		@user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

		if @user.persisted?
			logger.info "user signed in with FB"

			sign_in @user
			redirect_to root_path
		else
			session["devise.facebook_data"] = request.env["omniauth.auth"]
			redirect_to new_user_registration_url
		end
	end

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
