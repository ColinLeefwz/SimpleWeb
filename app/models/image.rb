# encoding: utf-8
#个人聊天时发送图片

class Image
  include Mongoid::Document
  
  field :article_id, type: Moped::BSON::ObjectId
  field :img
  mount_uploader(:img, ArticleImgUploader)
  field :img_tmp
  field :img_processing, type:Boolean
  process_in_background :img
    
  def self.img_url(id,type=nil)
    if type
      "http://dface.oss.aliyuncs.com/#{id}/#{type}_0.jpg"
    else
      "http://dface.oss.aliyuncs.com/#{id}/0.jpg"
    end
  end

  
end
