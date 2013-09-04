class Session < ActiveRecord::Base
  belongs_to :expert

  has_attached_file :cover,
		                path: ":rails_root/public/system/sessions/:attachment/:id_partition/:style/:filename",
										url: "/system/sessions/:attachment/:id_partition/:style/:filename"

end
