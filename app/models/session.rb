class Session < ActiveRecord::Base
  CATEGORY = %w(macro business entrepreneurship tech culture).freeze
  CONTENT_TYPE = %w(ArticleSession VideoSession LiveSession Announcement).freeze

	self.inheritance_column = 'content_type'

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

end
