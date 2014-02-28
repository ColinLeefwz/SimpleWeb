class VideoInterview < ActiveRecord::Base
  include ParamsConfig

  has_one :video, as: :videoable, dependent: :destroy
  accepts_nested_attributes_for :video, allow_destroy: true

  has_many :comments, -> {order "updated_at DESC"}, as: :commentable

  belongs_to :expert
  validates :expert, presence: true

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  has_one :visit, as: :visitable

  has_attached_file :cover

  def editable
    true
  end
end
