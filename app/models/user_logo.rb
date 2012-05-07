class UserLogo < ActiveRecord::Base
  has_attachment :content_type => :image,
                 :storage      => :file_system,
                 :thumbnails   => {:small => '96x96>', :medium => '250x250>'},
                 :max_size     => 1.megabyte


  #validates_as_attachment

  before_thumbnail_saved do |thumbnail|
    record           = thumbnail.parent
    thumbnail.user_id=record.user_id
  end

  belongs_to :user

  def swf_uploaded_data=(data)
    data.content_type  = MIME::Types.type_for(data.original_filename)
    self.uploaded_data = data
  end

end
