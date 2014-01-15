class Section < ActiveRecord::Base
  validates :title, presence: true

  belongs_to :chapter
  has_many :resources, dependent: :destroy

  accepts_nested_attributes_for :resources, allow_destroy: true  #todo add "reject_if" block

  default_scope {order(order: :asc)}

  def has_video?
    self.resources.inject(false) { |memo, obj|  memo or obj.attached_file_file_path.present? }
  end

  def sd_url
    self.resources.where(video_definition: "SD").first.attached_file.url || " "
  end

  def hd_url
    self.resources.where(video_definition: "HD").first.attached_file.url  || " "
  end
end
