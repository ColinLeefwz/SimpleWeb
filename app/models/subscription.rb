class Subscription < ActiveRecord::Base
  include Stream::ContentActivity

  belongs_to :subscriber, class_name: "User"
  belongs_to :subscribable, polymorphic: true
  validates :subscriber, presence: true


  private
  def user_list
    follower_list = Following.where(followed_id: subscriber.id).pluck(:follower_id)
    author_id = subscribable.experts.pluck(:id)
    subscriber_id = [subscriber.id]
    (follower_list + author_id + subscriber_id).uniq
  end

  def subject
    subscriber
  end

  def object
    subscribable
  end

  def action
    "favorited"
  end
end

