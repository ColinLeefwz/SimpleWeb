require 'mandrill_api'

class ShareEmailForm
  include ActiveModel::Model

  attr_accessor :item_url

  validates :to, presence: true

  delegate :to, :subject, :message, to: :email_message

  def initialize(user)
    @user = user
  end

  def email_message
    @email ||= EmailMessage.new
  end

  def init_new_form(params = {})
    item_params = params[:item]
    item = item_params[:type].classify.constantize.find item_params[:id]
    subject = params[:subject].blank? ?  "share this to friend" : params[:subject]
    message = params[:message].blank? ?  "share this #{item.title}" : params[:message]

    @item_url = item_params[:item_url]
    @email = @user.shared_emails.build(subject: subject,
                                              message: message)
    self
  end

  def create_form(params)
    params[:share_email_form][:from_name] = @user.name
    params[:share_email_form][:from_address] = @user.email
    @email = @user.shared_emails.build(email_params(params))
    self
  end

  def submit()
    if valid?
      @email.save
      send_share_message
      true
    else
      false
    end
  end

  private
  def send_share_message
    MandrillApi.new.share_item_email(@user, @email)
  end

  def email_params(params)
    params.require(:share_email_form).permit(:item_url, :subject, :to, :message, :from_address, :from_name)
  end
end
