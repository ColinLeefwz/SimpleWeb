# encoding: utf-8
# 头图

class Headpic
  include Mongoid::Document
  field :sid, type: Integer
  field :img
  mount_uploader(:img, PhotoUploader)
  process_in_background :img

  def img_url(type=nil)
    if type
      "http://dface.img.aliyuncs.com/#{self.id}/0.jpg@200w_200h_1e_1c_90Q.jpg"
    else
      "http://dface.oss.aliyuncs.com/#{self.id}/0.jpg"
    end
  end  
end