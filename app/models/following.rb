class Following < ActiveRecord::Base
  validates :the_followed, :follower, presence: true
  validates :the_followed, :follower, numericality: { only_integer: true }
  validate :can_follow

  def can_follow
    ## users can not follow themselves
    self_flag = (the_followed == follower)

    ## users can not follow the same person twice
    duplicate_flag = false 
    user = User.find follower
    duplicate_flag = true if user.follow? the_followed

    if self_flag || duplicate_flag
      errors.add(:can_follow, "you can't follow yourself or someone you already followed")
    end
  end
end
