# encoding: utf-8
# 头图

class Headpic
  include Mongoid::Document
  field :sid, type: Integer
  field :img
  field :od, type: Integer
  mount_uploader(:img, PhotoUploader)
  process_in_background :img

  belongs_to :shop, :foreign_key => 'sid'

  scope :eq_sid, ->(sid){where(sid: sid)}

  before_create :set_od

  def set_od
    self.od = Headpic.eq_sid(self.sid).count + 1
  end

  def img_url(type=nil)
    if type
      "http://dface.img.aliyuncs.com/#{self.id}/0.jpg@200w_200h_1e_1c_90Q.jpg"
    else
      "http://dface.oss.aliyuncs.com/#{self.id}/0.jpg"
    end
  end  
end