class Article < ActiveRecord::Base
  include ParamsConfig

  validates :title, presence: true
  validate :empty_categories

  COMMIT_TYPE = { draft: "Save Draft", publish:  "Publish", preview: "Preview", cancel: "Cancel" }

  self.inheritance_column = 'content_type'

  has_attached_file :cover, styles: {}
  has_attached_file :video

  default_scope{ where("canceled is null or canceled = false") }

  belongs_to :expert
  # validates :expert, presence: true

  # enrollments and orders
  has_many :enrollments, as: :enrollable
  has_many :orders

  # has_many :subscriptions, foreign_key: "subscribed_session_id"
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  # page view statistics
  has_one :visit, as: :visitable

  def producers
    "by " + self.expert.name
  end

  private
  def empty_categories
    errors.add(:categories, "cannot be blank") unless categories.any? {|string| string.length > 0}
  end

end

