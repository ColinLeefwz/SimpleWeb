class UserLogo < ActiveRecord::Base
  belongs_to :user
  has_attached_file :avatar, :styles => { :thumb => "75x75>", :thumb2 => "150x150>"  }

  validates_attachment_presence :avatar
  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/gif', 'image/png']

end
