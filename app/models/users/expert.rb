class Expert < Member
  has_one :expert_profile
  accepts_nested_attributes_for :expert_profile
  alias_method :expert_profile=, :expert_profile_attributes=   # NOTE add this line for active admin working properly

  def name
    "#{first_name} #{last_name}"
  end

  def password_required?
    new_record? ? false : super
  end

end
