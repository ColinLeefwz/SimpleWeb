class Session < ActiveRecord::Base
  CATEGORY = %w(Big_Picture Business Entrepreneurship Technology Culture).freeze

  belongs_to :expert

  default_scope { order "created_at desc" }

  has_attached_file :cover,
    path: ":rails_root/public/system/sessions/:attachment/:id_partition/:style/:filename",
    url: "/system/sessions/:attachment/:id_partition/:style/:filename"

  has_attached_file :video,
    path: ":rails_root/public/system/sessions/:attachment/:id_partition/:style/:filename",
    url: "/system/sessions/:attachment/:id_partition/:style/:filename"

end
