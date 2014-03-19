require 'mailchimp'


class UserSubscription
  attr_reader :user, :message

  def initialize(user, list_id)
    @user = user
    @mc = Mailchimp::API.new ENV["MAILCHIMP_API_KEY"]
    @list_id = list_id
  end

  def create
    begin
      @mc.lists.subscribe(@list_id, {email: @user.email}, {FNAME: @user.first_name, LNAME: @user.last_name})
      @message = "High Fives! Subscribed successfully! Please confirm the email sending to you"
    rescue Mailchimp::ListAlreadySubscribedError
      @message = "You are already subscribed."
    rescue Mailchimp::Error
      @message = "We are sorry, but something went wrong."
    end
  end

  def destroy
    begin
      @mc.lists.unsubscribe(@list_id, {email: @user.email})
      @message = "Unsubscribed."
    rescue Mailchimp::EmailAlreadyUnsubscribedError
      @message = "You have already unsubscribed."
    rescue Mailchimp::Error
      @message = "We are sorry, but something went wrong."
    end
  end
end
