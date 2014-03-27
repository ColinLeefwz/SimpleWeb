class Chapter < ActiveRecord::Base
  include Searchable
  validates :title, presence: true

  belongs_to :course
  has_many :sections, -> {order(order: :asc)}, dependent: :destroy
  accepts_nested_attributes_for :sections, reject_if: lambda{|s| s[:title].blank?}, allow_destroy: true

  after_save :update_parent_duration

  private
  def update_parent_duration
    course = self.course
    duration = course.chapters.inject(0) { |memo, obj| memo + obj.duration.to_i  }
    course.update_attributes duration: duration.to_s
  end
end
