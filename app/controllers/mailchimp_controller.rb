class MailchimpController < ApplicationController

  def subscription
    subscription = UserSubscription.new(current_user, ENV["MAILCHIMP_LIST_ID"])
    subscription.toggle(params[:subscription][:newsletter])
    
    from = params[:from]
    logger.info "from: #{from}"

    respond_to do |format|
      format.js{
        if from == :landing_page
          render nothing: true
        else
          render partial: 'dashboard/newsletter', locals: {message: subscription.message}
        end
      }
    end
  end


  def guest_subscription
    user = Guest.new(params[:guest][:email])
    subscription = UserSubscription.new(user, ENV["MAILCHIMP_LIST_ID"])
    subscription.toggle(:create)

    flash[:success] = subscription.message
    redirect_to root_path
  end

end
