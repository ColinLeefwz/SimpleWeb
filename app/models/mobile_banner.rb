class MobileBanner

  include Mongoid::Document

  field :sid
  field :img
  field :url

  mount_uploader(:img, MobileBannerImgUploader)

  def self.img_url(id,type=nil)
    if type
      "http://oss.aliyuncs.com/dface/#{id}/#{type}_0.jpg"
    else
      "http://oss.aliyuncs.com/dface/#{id}/0.jpg"
    end
  end

end