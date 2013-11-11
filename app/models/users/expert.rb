class Expert < Member
  has_one :expert_profile
  has_many :sessions
  has_many :email_messages
  accepts_nested_attributes_for :expert_profile
  alias_method :expert_profile=, :expert_profile_attributes=   # NOTE add this line for active admin working properly

  def name
    "#{first_name} #{last_name}"
  end

  def password_required?
    new_record? ? false : super
  end

	def build_refer_message
    self.email_messages.build(from_name: "#{self.first_name} #{self.last_name}", from_address: "no-reply@prodygia", reply_to: "#{self.email}")
	end

  def sessions_with_draft
    self.sessions.order('draft desc') 
  end


	## override Devise::Invitable invited_to_sign_up?
	def invited_to_sign_up?
		logger.info "in model Expert line 27"
		is_expert = self.type == "Expert"
		(is_expert || persisted?) && invitation_token.present?
		debugger
		# persisted? && invitation_token.present?
	end
end
