class Course < ActiveRecord::Base
  include ParamsConfig

  validates :title, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}

  # enrollments and orders
  has_many :enrollments, as: :enrollable

  has_and_belongs_to_many :experts
  validates :experts, presence: true

  has_many :chapters, -> {order(order: :asc)}, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: lambda{|c| c[:title].blank?}, allow_destroy: true

	has_one :intro_video, as: :introable, dependent: :destroy

	accepts_nested_attributes_for :intro_video

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  # page view statistics
  has_one :visit, as: :visitable

  has_attached_file :cover,
    storage: :s3,
    s3_credentials: {
      bucket: ENV["AWS_BUCKET"],
      access_key_id: ENV["AWS_ACCESS_KEY_ID"],
      secret_access_key: ENV["AWS_SECRET_ACCESS_KEY"]
    },
    s3_host_name: "s3-us-west-1.amazonaws.com",
    path: ":class/:attachment/:id/:style/:filename",
    styles: {

    }

  class << self
    def recommend_courses(current_user)
      show_courses = []
      if current_user.is_a? Expert
        own_courses = current_user.courses
        staff_courses = Expert.staff.courses.take(3)
        show_courses = staff_courses
        if staff_courses.count <= 3
          other_courses = Course.all.sample(3 - staff_courses.count)
          other_courses = (Course.all - own_courses - staff_courses).sample(3 - staff_courses.count)
          show_courses << other_courses unless other_courses.empty?
        end
      elsif current_user.is_a? Member
        show_courses = (Course.all - Expert.staff.courses).sample(3)
      end
      show_courses
    end
  end


  def producers
    "by " + self.experts.map(&:name).join(" and ")
  end

  def free?
    self.price == 0
  end
end
