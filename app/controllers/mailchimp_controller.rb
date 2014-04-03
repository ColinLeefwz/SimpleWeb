class MailchimpController < ApplicationController

  def subscription
    user = current_user || Guest.new(guest_params)
    subscription = UserSubscription.new(user, ENV["MAILCHIMP_LIST_ID"])
    subscription.toggle

    flash[:success] = subscription.message
    redirect_to root_path
    # path = current_user.is_a?(Expert) ? dashboard_expert_path(current_user) : dashboard_member_path(current_user)
  end


  private
  def guest_params
    params.require(:guest).permit(:email)
  end

end
