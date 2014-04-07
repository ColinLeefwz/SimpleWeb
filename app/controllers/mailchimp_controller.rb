class MailchimpController < ApplicationController

  def subscription
    # responsibility: guest subscription, dashboard settings
    user = current_user || Guest.new(guest_params[:email])
    subscription = UserSubscription.new(user, ENV["MAILCHIMP_LIST_ID"])
    subscription.toggle

    respond_to do |format|
      format.html{
        flash[:success] = subscription.message
        redirect_to root_path
      }

      format.js{
        render partial: 'dashboard/newsletter', locals: {message: subscription.message}
      }
    end
  end


  private
  def guest_params
    params.require(:guest).permit(:email)
  end

end
