class Session < ActiveRecord::Base
  validates :title, presence: true
  CONTENT_TYPE = %w(ArticleSession VideoSession LiveSession Announcement).freeze

  self.inheritance_column = 'content_type'

  after_initialize :set_default

  belongs_to :expert
  has_many :orders

  has_and_belongs_to_many :enroll_users, class_name: 'User'

  default_scope { order("always_show desc, created_at desc") }

  has_attached_file :cover,
    path: ":rails_root/public/system/sessions/:attachment/:id_partition/:style/:filename",
    url: "/system/sessions/:attachment/:id_partition/:style/:filename"

  has_attached_file :video,
    path: ":rails_root/public/system/sessions/:attachment/:id_partition/:style/:filename",
    url: "/system/sessions/:attachment/:id_partition/:style/:filename"

  def is_free?
    self.price <= 0.0
  end

  def set_default
    self.price ||= 0.00
  end


  attr_accessor :format, :date, :start_time, :end_time, :time_zone, :strategic_question, :save_draft, :preview

end
