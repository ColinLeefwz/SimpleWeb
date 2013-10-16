class AdminUser < User
  include DeviseInvitable::Inviter
end
