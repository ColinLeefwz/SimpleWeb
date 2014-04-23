class EmailMessage < ActiveRecord::Base
  MESSAGE_TYPE = { refer: "refer", share: "share" }.freeze
  belongs_to :user

  after_initialize :set_default
  validates :to, presence: true

  attr_accessor :item_url

  def expert_email_content
    build_message_content("expert")
  end

  def member_email_content
    build_message_content("member")
  end

  private
  def load_refer_message
    messages ||= YAML.load_file(File.join(Rails.root, 'config', 'refer_message.yml'))
  end

  def build_message_content(type)
    self.subject ||=  "Invitation to be an #{type} on Prodygia"
    message_content ||= load_refer_message["refer_#{type}"]['content']
    message_from_name = "<p>#{self.from_name.titleize}</p>"
    self.message = [message_content, message_from_name].join

    self.from_address = "no-reply@prodygia.com"
    self.reply_to = "no-reply@prodygia.com"
  end

  def set_default
    if self.invited_type == User::USER_TYPE[:expert]
      expert_email_content
    elsif self.invited_type  == User::USER_TYPE[:member]
      member_email_content
    end
  end
end
