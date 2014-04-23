class ShareEmailForm
  include ActiveModel::Model

  validates :to, presence: true

  delegate :to, :subject, :message, to: :email_message

  def initialize(params = {}, user)
    item_params = params[:item]
    item = item_params[:type].classify.constantize.find item_params[:id]

    @email_message = user.shared_emails.build(subject: "share this to friend",
                                     message: "share this #{item.title}")
  end

  def email_message
    @email_message ||= EmailMessage.new
  end


end
