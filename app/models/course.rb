class Course < ActiveRecord::Base
  include ParamsConfig

  validates :title, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}

  # enrollments and orders
  has_many :enrollments, as: :enrollable

  has_and_belongs_to_many :experts
  has_many :chapters, dependent: :destroy
  accepts_nested_attributes_for :chapters, reject_if: lambda{|c| c[:title].blank?}, allow_destroy: true

	has_one :intro_video, as: :introable, dependent: :destroy

	accepts_nested_attributes_for :intro_video

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

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

  def num_of_experts 
    self.experts.length
  end

  def first_expert
    self.experts.first
  end

  def second_expert
    self.experts.second
  end

  def producers
    "by " + self.experts.map(&:name).join(" and ")
  end

  def free?
    self.price == 0
  end
end
