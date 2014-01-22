class Section < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :chapter
  has_many :resources, dependent: :destroy

  accepts_nested_attributes_for :resources, allow_destroy: true  #todo add "reject_if" block

  default_scope {order(order: :asc)}
  before_save :convert_duration

  def has_video?
    self.resources.inject(false) { |memo, obj|  memo or obj.attached_file_file_name.present? }
  end

  def sd_url
    self.resources.where(video_definition: "SD").first.attached_file.url || " "
  end

  def hd_url
    self.resources.where(video_definition: "HD").first.attached_file.url  || " "
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

end
