class CategoriesExistValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.any? {|x| !x.empty?}
      record.errors[attribute] << (options[:message] || "can not be blank")
    end
  end
end

class Session < ActiveRecord::Base
	include Storagable
  include ParamsConfig

  validates :title, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}
  validates :categories, presence: true, categories_exist: true

  CONTENT_TYPE = %w(ArticleSession LiveSession).freeze

  COMMIT_TYPE = { draft: "Save Draft", publish:  "Publish", preview: "Preview", cancel: "Cancel" }
  attr_accessor :format, :strategic_question, :save_draft, :preview

  self.inheritance_column = 'content_type'

	attached_file :cover, styles: {}
	attached_file :video

  default_scope where("canceled is null or canceled = false")
  # relationship with expert
  belongs_to :expert
  validates :expert, presence: true

  # enrollments and orders
  has_many :enrollments, as: :enrollable
  has_many :orders

  # has_many :subscriptions, foreign_key: "subscribed_session_id"
  has_many :subscriptions, as: :subscribable
  has_many :subscribers, through: :subscriptions

  # page view statistics
  has_one :visit, as: :visitable

  # def categories_can_not_be_blank
  #   errors.add(:categories, "cannot be blank") unless categories.any? {|x| !x.empty?}
  # end

  def free?
    self.price <= 0.0
  end

  def producers
    "by " + self.expert.name
  end

  def date 
    self.start_date ||= DateTime.now
    self.start_date.strftime("%Y-%m-%d")  
  end

  def start_time
    self.start_date ||= DateTime.now
    self.start_date.strftime("%H:%M") 
  end

  def end_time
    self.end_date_time ||= DateTime.now
    self.end_date_time.strftime("%H:%M")
  end

  def date=(date)
    self.start_date ||= DateTime.now
    original = start_date
    d = date.to_date
    self.start_date = DateTime.new(d.year, d.month, d.day, original.hour, original.min, original.sec)
    self.end_date_time = DateTime.new(d.year, d.month, d.day, original.hour, original.min, original.sec)
  end

  def start_time=(time)
    self.start_date ||= DateTime.now
    original = start_date
    t = time.to_time
    self.start_date = DateTime.new(original.year, original.month, original.day, t.hour, t.min, t.sec)
  end

  def end_time=(time)
    self.end_date_time ||= DateTime.now
    original = end_date_time
    t = time.to_time
    self.end_date_time = DateTime.new(original.year, original.month, original.day, t.hour, t.min, t.sec)
  end
end

