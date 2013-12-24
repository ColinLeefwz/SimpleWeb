class Session < ActiveRecord::Base
  validates :title, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0}

  CONTENT_TYPE = %w(ArticleSession LiveSession).freeze

  COMMIT_TYPE = { draft: "Save Draft", publish:  "Publish", preview: "Preview", cancel: "Cancel" }

  self.inheritance_column = 'content_type'

  belongs_to :expert
  has_many :orders

  has_many :subscriptions, foreign_key: "subscribed_session_id"
  has_many :subscribers, through: :subscriptions

  has_and_belongs_to_many :enroll_users, class_name: 'User'

  has_attached_file :cover,
    path: ":rails_root/public/system/sessions/:attachment/:id_partition/:style/:filename",
    url: "/system/sessions/:attachment/:id_partition/:style/:filename",
    default_url: 'missing.png'

  has_attached_file :video,
    path: ":rails_root/public/system/sessions/:attachment/:id_partition/:style/:filename",
    url: "/system/sessions/:attachment/:id_partition/:style/:filename",
    default_url: 'missing.png'

  def is_free?
    self.price <= 0.0
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

  attr_accessor :format, :strategic_question, :save_draft, :preview

end
