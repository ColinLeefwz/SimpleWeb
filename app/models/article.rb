class Article < ActiveRecord::Base
  include ParamsConfig
  include Searchable

  belongs_to :expert
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  has_many :comments, -> {order "updated_at DESC"}, as: :commentable
  has_one :visit, as: :visitable
  has_attached_file :cover
  default_scope{ where(canceled: [nil, false]) }

  validates :title, presence: true
  validate :empty_categories
  validates :expert, presence: true

  def producers
    "by " + self.expert.name
  end

  def editable
    true
  end

  private
  # validation
  def empty_categories
    errors.add(:categories, "cannot be blank") unless categories.any? {|string| string.length > 0}
  end
end

