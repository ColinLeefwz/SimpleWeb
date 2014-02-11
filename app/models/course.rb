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

  def producers
    "by " + self.experts.map(&:name).join(" and ")
  end

  def free?
    self.price == 0
  end

  private
  def create_an_intro_video
    self.create_intro_video
  end
end
