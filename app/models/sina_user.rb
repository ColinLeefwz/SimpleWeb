# encoding: utf-8
class SinaUser
  include Mongoid::Document
  #  field :_id, type: String
  store_in({:database => "sina"})  if Rails.env != "test"

  Logger = Logger.new('log/weibo/sina_user.log', 0, 100 * 1024 * 1024)

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
      #CarrierWave::Workers::StoreAsset.perform("UserLogo",user_logo.id.to_s,"img")
    end
    user
  end
  
  def self.gen_head_logo(user, token=$sina_token)
    sina_info = SinaUser.get_user_info(user.wb_uid,token)
    return if sina_info.nil?
    user_logo = UserLogo.new({user_id: user._id})
    if SinaUser.logo_store_local(sina_info["avatar_large"],"public/uploads/tmp/#{user_logo.id}.jpg")
      user_logo.img_tmp = "#{user_logo.id.to_s}.jpg"
      user.head_logo_id = user_logo.id
      user.save
      UserLogo.collection.insert(user_logo.attributes)
      Resque.enqueue_in(3.seconds, CarrierWave::Workers::StoreAsset, "UserLogo",user_logo.id.to_s,"img")
    else
      User.collection.find({_id:user._id}).update("$set" => {no_wb_logo:true}) 
    end
  end

  def dface_gender
    return "1" if self.gender == 'm'
    return '2' if self.gender == 'f'
    '0'
  end

  def logo_store_local(path)
    SinaUser.logo_store_local(self.avatar_large, path)
  end
  
  def self.logo_store_local(url,path, err_num=0)
    begin
      logo_data= RestClient.get(url)
      return nil if logo_data.size<8000
      open(path, "wb") { |file| file.write(logo_data)}
      true
    rescue
      err_num += 1
      puts "retry#{err_num}: #{path}"
      return nil if err_num == 4
      logo_store_local(url, path, err_num)
    end
  end
  
  def self.get_user_info(uid,token)
    require 'open-uri'
    begin
      url = "https://api.weibo.com/2/users/show.json?uid=#{uid}&source=#{$sina_api_key}&access_token=#{token}"
      
      open(url) do |f|
        return ActiveSupport::JSON.decode( f.gets )
      end
    rescue Exception => e
      puts e
      return nil
    end
  end

  def self.poi_suser_convert(poi)
    sina_users = SinaPoi.find_by_id(poi).datas.select{|su| su[2].match(/iphone|ipad/i)}
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
