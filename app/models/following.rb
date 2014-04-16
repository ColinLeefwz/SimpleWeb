class Following < ActiveRecord::Base
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  def self.follow?(user, target)
    following = Following.where(follower_id: user.id, followed_id: target.id).first
    following ? true : false
  end

end
