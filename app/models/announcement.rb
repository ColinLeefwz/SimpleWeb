class Announcement < ActiveRecord::Base
  include ParamsConfig

  belongs_to :expert
  validates :expert, presence: true

  has_one :video, as: :videoable
  accepts_nested_attributes_for :video, allow_destroy: true
  has_many :comments, as: :commentable

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  has_one :visit, as: :visitable

  has_attached_file :cover
end
