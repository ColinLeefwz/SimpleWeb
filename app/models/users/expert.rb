class Expert < Member
	has_one :profile, class_name: 'ExpertProfile'
	accepts_nested_attributes_for :profile

	def name
		"#{first_name} #{last_name}"
	end

	def password_required?
		new_record? ? false : super
	end

end
