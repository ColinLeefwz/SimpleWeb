class AdminUser < User
  include DeviseInvitable::Inviter

  before_create :default_name

  def delete(object)
    object.update_attributes(soft_deleted: true)
  end

  def default_name
    self.name = self.email
  end
end

