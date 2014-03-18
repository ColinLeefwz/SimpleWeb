class Article < ActiveRecord::Base
  include ParamsConfig

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

  after_save :added_to_landingitems

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

  def added_to_landingitems
    Landingitem.create(landingable_type: self.class.name, landingable_id: self.id, updated_at: self.updated_at, created_at: self.created_at, only_index: true, expert: self.expert)
  end
end

