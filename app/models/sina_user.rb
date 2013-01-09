# encoding: utf-8
class SinaUser
  include Mongoid::Document
  #  field :_id, type: String
  store_in session: "dooo"

  Logger = Logger.new('log/weibo/sina_user.log', 0, 100 * 1024 * 1024)

  def self.find_by_id(id)
    begin
      self.find(id)
    rescue
      nil
    end
  end

  def self.has_user?(id)
    return true if find_by_id(id.to_s)
    return true if find_by_id(id.to_i)
  end

  def convert_to_user
    oldu = User.where({wb_uid:self._id}).first
    return oldu if oldu
    user = User.new({wb_uid:self.id, name:self.screen_name, gender:dface_gender, wb_v:self.verified, wb_vs:self.verified_reason, auto:true  })
    user.save!
    user_logo = UserLogo.new({user_id: user._id})
    if logo_store_local("public/uploads/tmp/#{user_logo.id}.jpg")
      user_logo.img_tmp = "#{user_logo.id.to_s}.jpg"
      user.head_logo_id = user_logo.id
      user.save
      UserLogo.collection.insert(user_logo.attributes)
      CarrierWave::Workers::StoreAsset.perform("UserLogo",user_logo.id.to_s,"img")
    end
    user
  end

  def dface_gender
    return "1" if self.gender == 'm'
    return '2' if self.gender == 'f'
    '0'
  end

  def logo_store_local(path, err_num=0)
    begin
      logo_data= RestClient.get(self.avatar_large)
      open(path, "wb") { |file| file.write(logo_data)}
      true
    rescue
      err_num += 1
      puts "retry#{err_num}: #{path}"
      return nil if err_num == 4
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

  def self.user_page(token, wb_uid, err_num=0)
    url = "https://api.weibo.com/2/users/show.json?uid=#{wb_uid}&access_token=#{token}"
    begin
      response = RestClient.get(url)
      Logger.info "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaUser.user_page get #{url}"
    rescue RestClient::BadRequest
      return nil
    rescue
      err_num += 1
      Logger.error "#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaUser.user_page get #{url}错误#{err_num}次. #{$!}"
      Emailer.send_mail('获取用户信息出错',"#{Time.now.strftime("%Y-%m-%d %H:%M:%S")} SinaUser.user_page get #{url}错误. #{$!}").deliver if err_num == 4
      return nil if err_num == 4
      sleep err_num * 20
      return user_page(token, wb_uid, err_num )
    end
    JSON.parse response
  end

end
