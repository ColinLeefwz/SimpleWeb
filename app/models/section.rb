class Section < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :chapter
  has_one :video, as: :videoable
  accepts_nested_attributes_for :video, allow_destroy: true

  before_save :convert_duration
  after_save :update_parent_duration

  def course
    @course || self.chapter.course
  end

  def available_for?(user)
    available = (user && user.enrolled?(self.course)) || (self.free_preview)
    return available ? true : false
  end

  private
  def convert_duration
    matcher = /(?<hour>\d*):(?<minute>[0-5]?[0-9]):(?<second>[0-5]?[0-9])/
    result = matcher.match(self.duration)

    if result
      hour = result[:hour].to_i
      minute = result[:minute].to_i
      second = result[:second].to_i

      self.duration = (second + minute*60 + hour*3600).to_s
    end
  end

  def update_parent_duration
    chapter = self.chapter
    duration = chapter.sections.inject(0) { |memo, obj| memo + obj.duration.to_i }
    chapter.update_attributes duration: duration.to_s
  end
end
