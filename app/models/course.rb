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
      if current_user.is_a? Expert
        staff_courses = Expert.staff.courses.take(3)
        if staff_courses.count <= 3
          other_courses = Course.includes(:experts).references(:experts).where.not(users: {id: [Expert.staff, current_user]}).sample(3 - staff_courses.count)
          staff_courses.concat(other_courses) unless other_courses.empty?
        end
      elsif current_user.is_a? Member
        Course.includes(:experts).references(:experts).where.not(users: {id: Expert.staff}).sample(3)
      end
    end


    def producers
      "by " + self.experts.pluck(:name).join(" and ")
    end

    def free?
      self.price == 0
    end
end
