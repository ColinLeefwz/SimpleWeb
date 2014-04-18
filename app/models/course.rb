class Course < ActiveRecord::Base
  include ParamsConfig
  include ActAsCategoriable
  include Landingable
  include Searchable

  validates :title, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}

  # enrollments and orders
  has_many :enrollments, as: :enrollable
  has_many :orders, as: :enrollable

  has_and_belongs_to_many :experts
  validates :experts, presence: true

  has_many :chapters, -> {order(order: :asc)}, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: lambda{|c| c[:title].blank?}, allow_destroy: true

  has_one :video, as: :videoable
  accepts_nested_attributes_for :video, allow_destroy: true

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  has_one :visit, as: :visitable
  has_many :comments, -> {order "updated_at DESC"}, as: :commentable

  has_attached_file :cover

  after_create :create_a_video, :expert_enrolled_own

  class << self
    def recommend_courses(current_user)
      show_courses = []
      if current_user.is_a? Expert
        staff_courses = Expert.staff.courses.take(3)
        show_courses = staff_courses
        if staff_courses.count <= 3
          other_courses = Course.includes(:experts).references(:experts).where.not(users: {id: [Expert.staff, current_user]})
          other_courses -= current_user.enrolled_courses
          other_courses = other_courses.sample(3 - staff_courses.count)

          show_courses.concat(other_courses) unless other_courses.empty?
        end
      elsif current_user.is_a? Member
        show_courses = Course.includes(:experts).references(:experts).where.not(users: {id: Expert.staff})
        show_courses = (show_courses - current_user.enrolled_courses).sample(3)
      end
      show_courses
    end

    def all_without_staff
      Course.joins(:experts).where.not(users: {id: 2}).uniq
    end
  end


  def producers
    "by " + self.experts.map(&:name).to_sentence
  end

  def free?
    self.price == 0
  end

  def editable
    false
  end

  def draft
    false
  end

  private
  def create_a_video
    self.create_video
  end

  def expert_enrolled_own
    self.experts.each do |exp|
      exp.enroll self
    end
  end
end
