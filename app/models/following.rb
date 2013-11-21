class Following < ActiveRecord::Base
  validates :the_followed, :follower, presence: true
  validates :the_followed, :follower, numericality: { only_integer: true }
  validate :duplicate

  def duplicate
    user = User.find follower
    if user.follow? the_followed
      errors.add(:duplicate, "you can't follow someone you already followed")
    end
  end

end
