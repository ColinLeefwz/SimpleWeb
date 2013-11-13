class MobileArticle

  include Mongoid::Document
  include Mongoid::Timestamps

  field :title
  field :text #简单摘要
  field :img

  field :content

  mount_uploader(:img, MobileArticleImgUploader)

  belongs_to :mobile_space

  def self.img_url(id,type=nil)
    if type
      "http://oss.aliyuncs.com/dface/#{id}/#{type}_0.jpg"
    else
      "http://oss.aliyuncs.com/dface/#{id}/0.jpg"
    end
  end

end