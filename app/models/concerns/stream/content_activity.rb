module Stream::ContentActivity
  extend ActiveSupport::Concern

  included do
    after_save :push_activities
    before_destroy :clean_activities
  end

  private

  # ----- push_activities -----
  def push_activities
    activity_streams.each do |stream|
      stream.activities.create(
        subject_name: author.name,
        subject_id: author.id,
        object_type: self.class.name,
        object_id: self.id,
        action: activity_name)
    end
  end


  # ----- clean_activities -----
  def clean_activities
    activity_streams.each do |stream|
      activities = stream.activities.where(subject_type: self.class.name, subject_id: self.id)
      activities.destroy
    end
  end
  

  # ----- shared helpers -----
  def activity_streams
    favorite_list = Subscription.where(subscribable: self).pluck(:subscriber_id) 
    follower_list = Following.where(followed_id: author.id).pluck(:follower_id)
    user_list = (favorite_list + follower_list).uniq
    streams = ActivityStream.in(user_id: user_list)
  end

  def activity_name
    action = (self.id_changed?) ? "create" : "update"
  end

  def author
    expert || user
  end
end

