class Member < User
  def name
    "#{first_name} #{last_name}"
  end

end
