class Section < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :chapter
  has_many :resources, dependent: :destroy

  accepts_nested_attributes_for :resources, allow_destroy: true  #todo add "reject_if" block

  before_save :convert_duration
  after_save :update_parent_duration

  def has_video?
    self.resources.inject(false) { |memo, obj|  memo or obj.attached_file_file_name.present? }
  end

  def sd_url
    self.resources.where(video_definition: "SD").first.attached_file.url || " "
  end

  def hd_url
    self.resources.where(video_definition: "HD").first.attached_file.url  || " "
  end

  def course
    @course || self.chapter.course
  end

  def available_for(user)
    available = (user && user.enrolled?(self.course)) or (self.free_preview)
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
