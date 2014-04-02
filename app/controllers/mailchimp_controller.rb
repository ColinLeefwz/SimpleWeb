class MailchimpController < ApplicationController

  def subscription
    subscription = UserSubscription.new(current_user, ENV["MAILCHIMP_LIST_ID"])

    status = current_user.subscribed
    status ? subscription.destroy : subscription.create
    current_user.update_attributes(subscribed: !status)

    #note: gecko: we will unify the ExpertDashboard and MemberDashboard
    flash[:success] = subscription.message
    path = current_user.is_a?(Expert) ? dashboard_expert_path(current_user) : dashboard_member_path(current_user)
    redirect_to path
  end

end
