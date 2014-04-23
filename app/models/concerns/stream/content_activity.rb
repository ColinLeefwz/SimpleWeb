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
        subject_type: subject.class.name,
        subject_id: subject.id,
        object_type: object.class.name,
        object_id: object.id,
        action: action)
    end
  end


  # ----- clean_activities -----
  def clean_activities
    activity_streams.each do |stream|
      activities = stream.activities.where(
        subject_type: subject.class.name,
        subject_id: subject.id,
        object_type: object.class.name,
        object_id: object.id)
      activities.destroy
    end
  end
  

  # ----- shared helpers -----
  def activity_streams
    streams = ActivityStream.in(user_id: user_list)
  end

  # ----- override these private methods in models to customize activity pushing -----
  def user_list
    favorite_list = Subscription.where(subscribable: object).pluck(:subscriber_id) 
    follower_list = Following.where(followed_id: subject.id).pluck(:follower_id)
    author_id = [subject.id]
    user_list = (favorite_list + follower_list + author_id).uniq
  end

  def action
    (self.id_changed?) ? "post" : "update"
  end

  def subject
    expert
  end

  def object
    self
  end
end

