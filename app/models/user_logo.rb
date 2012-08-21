class UserLogo
  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :user_id, type: Moped::BSON::ObjectId
  field :ord, type: Float
  

  has_mongoid_attached_file :avatar,
      :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
      :url => "/system/:attachment/:id/:style/:filename",
      :styles => {
        :thumb   => ['75x75',    :jpg],
        :thumb2    => ['150x150',   :jpg]
      }
  
  validates_presence_of :user_id
  
  validates_attachment_presence :avatar
  validates_attachment_size :avatar, :less_than => 5.megabytes
  validates_attachment_content_type :avatar, :content_type => ['image/jpeg', 'image/gif', 'image/png']
  
  def user
    User.find(self.user_id)
  end
  
  
  def self.next_ord(user_id)
    max = UserLogo.where(:user_id => user_id).order_by([:ord,:desc]).first
    if max
      max.ord+10
    else
      1
    end
  end
  
  before_create do |logo|
    logo.ord = UserLogo.next_ord logo.user_id
  end
  
  def change_ord(position)
    if position==0
      self.ord = self.user.head_logo.ord/2
    elsif position>=self.user.user_logos.count-1
      self.ord = self.user_logos.last.ord*2
    else
      logos = self.user.user_logos.skip(position-1).limit(2)
      self.ord = (logos.first + logos.last)/2
    end
    self.update_attribute(:ord , self.ord)
  end
  
  def logo_thumb_hash
    {:logo => self.avatar.url, :logo_thumb => self.avatar.url(:thumb), :logo_thumb2 => self.avatar.url(:thumb2)  }
  end
  
  def output_hash
    self.attributes.slice("user_id", "avatar_file_size","updated_at","ord").merge!( logo_thumb_hash).merge!({id: self._id})
  end

end
