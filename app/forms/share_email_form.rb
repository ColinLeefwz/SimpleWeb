class ShareEmailForm
  include ActiveModel::Model

  validates :to, presence: true

  delegate :to, :subject, :message, to: :email_message

  def initialize(params = {}, user)
    item_params = params[:item]
    item = item_params[:type].classify.constantize.find item_params[:id] if params[:item]

    suject = params[:subject].blank? ?  "share this to friend" : params[:subject]
    message = params[:message].blank? ?  "share this #{item.title}" : params[:message]

    @email_message = user.shared_emails.build(subject: subject,
                                              message: message)
    @user = user
  end

  def email_message
    @email_message ||= EmailMessage.new
  end

  def submit
    ## todo: 1. save the email_message to DB
    #  2. send_email_via_mandrill
    if valid?
      @email_message.from_address = @user.email
      @email_message.from_name = @user.name
      @email_message.save
      true
    else
      false
    end
  end

end
