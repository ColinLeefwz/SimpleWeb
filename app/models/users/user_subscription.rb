require 'mailchimp'


class UserSubscription
  attr_reader :user, :message

  def initialize(user, list_id)
    @user = user
    @mail_chimp = Mailchimp::API.new ENV["MAILCHIMP_API_KEY"]
    @list_id = list_id
  end


  def toggle
    begin
      @user.subscribed ? destroy : create
    rescue Mailchimp::ListAlreadySubscribedError
      @message = "You are already subscribed."
    rescue Mailchimp::EmailAlreadyUnsubscribedError
      @message = "You have already unsubscribed."
    rescue Mailchimp::Error
      @message = "We are sorry, but something went wrong."
    end
  end


  private
  def create
    @mail_chimp.lists.subscribe(@list_id, {email: @user.email}, {FNAME: @user.first_name, LNAME: @user.last_name})
    @user.update_attributes(subscribe_newsletter: true) # guest return nil because of method_missing
    @message = "High Fives! Subscribed successfully! Please confirm the email sending to you"
  end

  def destroy
    @mail_chimp.lists.unsubscribe(@list_id, {email: @user.email})
    @user.update_attributes(subscribe_newsletter: false)
    @message = "Unsubscribed."
  end

end
