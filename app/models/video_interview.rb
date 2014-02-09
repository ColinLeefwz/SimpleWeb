class VideoInterview < ActiveRecord::Base
  include ParamsConfig

  # video interviews always belongs to an expert
  belongs_to :expert
  validates :expert, presence: true

  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  # page view statistics
  has_one :visit, as: :visitable

  has_attached_file :cover

  def to_param
    permalink
  end

  protected
  def permalink
    "#{id}-#{title.parameterize}"
  end
end
