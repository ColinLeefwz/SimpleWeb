class Member < User
  def name
    "#{first_name} #{last_name}"
  end

  def build_refer_message(invited_type)
    self.email_messages.build(from_name: "#{self.first_name} #{self.last_name}", from_address: "no-reply@prodygia", reply_to: "#{self.email}", invited_type: invited_type)
  end
end
