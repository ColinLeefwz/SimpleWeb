class AdminUser < User
  include DeviseInvitable::Inviter

  def delete(object)
    object.update_attributes(soft_deleted: true)
  end

end

