
module NullableUser
  def nullable(user)
    user == nil ? Guest.new : user
  end
end
