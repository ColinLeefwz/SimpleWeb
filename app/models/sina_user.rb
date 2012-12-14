class SinaUser
  include Mongoid::Document
  #  field :_id, type: String
  store_in session: "dooo"

  def self.find_by_id(id)
    begin
      self.find(id)
    rescue
      nil
    end
  end

  def convert_to_user
    return if User.where({wb_uid:self._id}).to_a.first
    User.collection.insert({wb_uid:self.id, name:self.screen_name, gender:dface_gender, wb_v:self.verified, wb_vs:self.verified_reason, auto:true, pcount:1  })
    user = User.where({wb_uid:self._id}).to_a.first
    user_logo = UserLogo.new({user_id: user._id})
    user_logo.save
    if logo_store_local("public/uploads/tmp/#{user_logo.reload.id.to_s}.jpg")
      user_logo.img_tmp = "#{user_logo.id.to_s}.jpg"
      user.head_logo_id = user_logo.id
      user.save
      user_logo.save
      CarrierWave::Workers::StoreAsset.perform("UserLogo",user_logo.id.to_s,"img")
    end
  end

  def dface_gender
    return "1" if self.gender == 'm'
    return '2' if self.gender == 'f'
    '0'
  end

  def logo_store_local(path, err_num=0)
    begin
      sleep(1)
      logo_data= RestClient.get(self.avatar_large)
      open(path, "wb") { |file| file.write(logo_data)}
      true
    rescue
      err_num += 1
      return nil if err_num == 4
      sleep(err_num * 2)
      logo_store_local(path, err_num)
    end
  end

  def self.poi_suser_convert(poi)
    sina_users = SinaPoi.find(poi).datas.select{|su| su[2].match(/iphone|ipad/i)}
    sina_users.each do |s|
      su = SinaUser.find_by_id(s[0])
      su.convert_to_user if su
    end
  end


end
