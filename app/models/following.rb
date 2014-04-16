class Following < ActiveRecord::Base

  def self.follow?(user, target)
    following = Following.where(follower_id: user.id, followed_id: target.id).first
    following ? true : false
  end

end
