class Course < ActiveRecord::Base
  include ParamsConfig

  validates :title, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}

  # enrollments and orders
  has_many :enrollments, as: :enrollable
  has_many :orders, as: :enrollable

  has_and_belongs_to_many :experts
  validates :experts, presence: true

  has_many :chapters, -> {order(order: :asc)}, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: lambda{|c| c[:title].blank?}, allow_destroy: true

  has_one :intro_video, as: :introable, dependent: :destroy

  accepts_nested_attributes_for :intro_video

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  has_one :visit, as: :visitable

  has_attached_file :cover

  after_create :create_an_intro_video

  class << self
    def recommend_courses(current_user)
      show_courses = []
      if current_user.is_a? Expert
        staff_courses = Expert.staff.courses.take(3)
        show_courses = staff_courses
        if staff_courses.count <= 3
          other_courses = Course.includes(:experts).references(:experts).where.not(users: {id: [Expert.staff, current_user]}).sample(3 - staff_courses.count)
          # staff_courses.concat(other_courses) unless other_courses.empty?
          show_courses.concat(other_courses) unless other_courses.empty?
        end
      elsif current_user.is_a? Member
        show_courses = Course.includes(:experts).references(:experts).where.not(users: {id: Expert.staff}).sample(3)
      end
      show_courses
    end
  end


  def producers
    "by " + self.experts.pluck(:name).join(" and ")
  end

  def free?
    self.price == 0
  end

  def editable
    false
  end

  def has_video_to_present?
    self.intro_video.attached_video_hd_file_name.present? || self.intro_video.attached_video_sd_file_name.present?
  end

  private
  def create_an_intro_video
    self.create_intro_video
  end
end
