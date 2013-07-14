# coding: utf-8
#用户头像，最多只有8张

class UserLogo
  include Mongoid::Document
  
  field :user_id, type: Moped::BSON::ObjectId
  field :ord, type: Float
  field :t, type:Integer #图片类型：1拍照；2选自相册
  field :img
  mount_uploader(:img, LogoUploader)
  
  field :img_tmp
  field :img_processing, type:Boolean
  process_in_background(:img) unless ENV["RAILS_ENV"] == "test"
    
  index({ user_id: 1, ord: 1 })
  
  
  def self.img_url(id,type=nil)
    if type
      "http://oss.aliyuncs.com/logo/#{id}/#{type}_0.jpg"
    else
      "http://oss.aliyuncs.com/logo/#{id}/0.jpg"
    end
  end  

  def user
    User.find_by_id(self.user_id)
  end
  
  def self.logos(uid)
    UserLogo.where({user_id: uid}).order_by([:ord,:asc])
  end

  def logo_thumb_hash
    {:logo => self.img.url, :logo_thumb => self.img.url(:t1), :logo_thumb2 => self.img.url(:t2)  }
  end
  
  def output_hash
    logo_thumb_hash.merge!({id: self._id, user_id:self.user_id})
  end
  
  def self.ids_no_cache(uid)
    UserLogo.only(:id).where({user_id: uid}).order_by([:ord,:asc]).map{|x| x.id}
  end
  
  def self.ids_cache(uid)
    ret = Rails.cache.fetch("ULOGOS#{uid}") do 
      ids_no_cache(uid)
    end
    Rails.cache.delete("ULOGOS#{uid}") if ret.size==0
    return ret
  end
  
  def self.next_ord(uid)
    max = UserLogo.logos(uid).last
    if max
      max.ord+10
    else
      1
    end
  end
  
  before_create do |logo|
    logo.ord = UserLogo.next_ord logo.user_id
  end
  
  def self.fix_error(delete_error=false,pcount=1000)
    UserLogo.where({img_tmp:{"$ne" => nil}}).sort({_id:-1}).limit(pcount).each do |logo|
      next if (Time.now.to_i-logo.id.generation_time.to_i < 60)
      begin
       CarrierWave::Workers::StoreAsset.perform("UserLogo",logo.id.to_s,"img")
      rescue Errno::ENOENT => e
        puts "#{logo.id}, 图片有数据库记录，但是文件不存在。"
        if delete_error
          user = logo.user
          logo.destroy 
          user.fix_pcount_error
        end
      end 
    end
    delete_nil_img
  end
  
  def self.delete_nil_img
    UserLogo.only(:id).where({img_tmp:nil,img_filename:nil}).each {|x| x.destroy}
  end

end
