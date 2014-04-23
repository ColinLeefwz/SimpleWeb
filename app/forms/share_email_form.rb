require 'mandrill_api'

class ShareEmailForm
  include ActiveModel::Model
  include Rails.application.routes.url_helpers

  attr_accessor :item_url

  validates :to, presence: true

  delegate :to, :subject, :message, to: :email_message

  def initialize(params = {}, user)
    item_params = params[:item]
    item = item_params[:type].classify.constantize.find item_params[:id] if params[:item]

    subject = params[:subject].blank? ?  "share this to friend" : params[:subject]
    message = params[:message].blank? ?  "share this #{item.title}" : params[:message]

    @item_url = polymorphic_url(item) if params[:item]
    @email_message = user.shared_emails.build(subject: subject,
                                              message: message)
    @user = user
  end

  def email_message
    @email_message ||= EmailMessage.new
  end

  def submit(email_params)
    @email_message.to = email_params[:to]
    @email_message.from_address = @user.email
    @email_message.from_name = @user.name
    @email_message.item_url = email_params[:item_url]
    if valid?
      @email_message.save
      send_share_message
      true
    else
      false
    end
  end

  private
  def send_share_message
    MandrillApi.new.share_item_email(@user, @email_message)
  end
end
