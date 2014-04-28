class Comment < ActiveRecord::Base
  include Stream::ContentActivity

  belongs_to :commentable, polymorphic: true
  belongs_to :user

  validates :user, presence: true
  validates :content, presence: true

  scope :visible, -> {where(soft_deleted: false)}

  private
  def user_list
    follower_list = Following.where(followed_id: user.id).pluck(:follower_id)
    favorite_list = Subscription.where(subscribable: commentable).pluck(:subscriber_id)
    user_id = [user.id]
    (follower_list + favorite_list + user_id).uniq
  end

  def subject
    user
  end

  def object
    commentable
  end

  def action
    "comment"
  end
end

