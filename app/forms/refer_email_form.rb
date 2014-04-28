class ReferEmailForm
  include ActiveModel::Model

  delegate :to, :subject, :message, :copy_me, :invited_type, to: :email_message

  def initialize(params)
    type = params[:invite_type]

    subject = params[:subject].blank? ?  "Invitation to be an #{type} on Prodygia" : params[:subject]
    message = params[:message].blank? ?  build_message_content(type) : params[:message]

    @email_message = EmailMessage.new(subject: subject, message: message, reply_to: "no-reply@prodygia.com", invited_type: type)
  end

  def email_message
    @email_message ||= EmailMessage.new
  end

  private
  def build_message_content(type)
    load_refer_message["refer_#{type}"]['content']
  end

  def load_refer_message
    messages ||= YAML.load_file(File.join(Rails.root, 'config', 'refer_message.yml'))
  end

end
