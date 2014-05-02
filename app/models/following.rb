class Following < ActiveRecord::Base
  include Stream::ContentActivity
  
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  def self.follow?(user, target)
    following = Following.where(follower_id: user.id, followed_id: target.id).first
    following ? true : false
  end

  private
  def user_list
    follower_list = Following.where(followed_id: follower.id).pluck(:follower_id) # the follower's followers
    followed_id = [followed.id]
    follower_id = [follower.id]
    (follower_list + followed_id + follower_id).uniq
  end

  def subject
    follower
  end

  def object
    followed
  end

  def action
    "follow"
  end
end

