class Photo
  include Mongoid::Document
  include Mongoid::Paperclip
  
  field :user_id, type: Moped::BSON::ObjectId
  field :room #发给聊天室
  field :weibo, type:Boolean
  field :to_uid #发给个人
  

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

  
  def logo_thumb_hash
    {:logo => self.avatar.url, :logo_thumb => self.avatar.url(:thumb), :logo_thumb2 => self.avatar.url(:thumb2)  }
  end
  
  def output_hash
    self.attributes.merge!( logo_thumb_hash).merge!({id: self._id})
  end

end
