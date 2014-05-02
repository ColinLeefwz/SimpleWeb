class Enrollment< ActiveRecord::Base
  include Stream::ContentActivity

  belongs_to :enrollable, polymorphic: true 
  belongs_to :user

  validates :user_id, :enrollable_id, :enrollable_type, presence: true
  validates :user_id, uniqueness: { scope: [:enrollable_type, :enrollable_id], message: "can not enroll twice" }

  private
  def user_list
    follower_list = Following.where(followed_id: user.id).pluck(:follower_id)
    author_id = enrollable.experts.pluck(:id)
    user_id = [user.id]
    (follower_list + author_id + user_id).uniq
  end

  def subject
    user
  end

  def object
    enrollable
  end

  def action
    "subscribe"
  end
end
