class Article < ActiveRecord::Base
  include ParamsConfig

  belongs_to :expert
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions
  has_one :visit, as: :visitable
  has_attached_file :cover
  default_scope{ where("canceled = false") }

  validates :title, presence: true
  validate :empty_categories
  validates :expert, presence: true

  def producers
    "by " + self.expert.name
  end

  private
  # validation
  def empty_categories
    errors.add(:categories, "cannot be blank") unless categories.any? {|string| string.length > 0}
  end
end

