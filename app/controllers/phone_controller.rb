# coding: utf-8

class PhoneController < ApplicationController
  before_filter :user_login_filter, :only => [:bind, :unbind, :change_password, :set_password] 
  before_filter :code_match, :only => [:register, :forgot_password, :bind] 
  before_filter :password_check, :only => [:forgot_password, :change_password, :set_password] 
  before_filter :phone_check, :only => [:unbind, :set_password, :upload_address_list] 
  before_filter :phone_register_check, :only => [:register, :do_register] 

  extend PhoneUtil 

  FAKE_CODE = "12321"

  def phone_check
    user = session_user
    if user.phone != params[:phone]
      str = "手机号码#{params[:phone]}不是以前绑定的那个#{user.phone}"
      Xmpp.error_notify(str)
      render :json => {"error"=>str}.to_json
    end
  end
  
  def phone_register_check
    user = User.find_by_phone(params[:phone], false)
    if user
      render :json => {"error"=>"手机号码不可用或已被注册"}.to_json
      return      
    end
  end
    
  def password_check
    if params[:password].nil? || params[:password].size<3
      render :json => {"error"=>"密码长度太短，请选择一个长一点的密码"}.to_json
    end
  end
  
  def code_match
    if session[:phone_try].nil? || session[:phone_try]<1 || session[:phone_code].nil?
      render :json => {"error"=>"验证码错误"}.to_json
      return
    end
    if params[:code] != session[:phone_code] && params[:code] != FAKE_CODE
      session[:phone_try] -= 1
      if session[:phone_try]<1
        session[:phone_try] = nil 
        session[:phone_code] = nil 
        render :json => {"error"=>"验证码错误"}.to_json
      else
        render :json => {"error"=>"验证码错误, 还有#{session[:phone_try]}次机会"}.to_json
      end
    end
  end
  
  
  def init
    type = params[:type].to_i
    user = User.find_by_phone(params[:phone])
    if type==1
      if user
        render :json => {"error" => "手机号码#{params[:phone]}不可用或已被注册。"}.to_json
        return
      end
    end
    if type==2
      unless session_user
        render :json => {:error => "not login"}.to_json
        return
      end
      if user && user.id != session_user.id
        render :json => {"error" => "手机号码#{params[:phone]}不可用或已被注册。"}.to_json
        return
      end
    end   
    if type==3
      unless user
        render :json => {"error" => "#{params[:phone]}不存在。"}.to_json
        return
      end
    end 
    fake = fake_phone(params[:phone]) 
    if Rails.env == "production"
      if fake
        code = FAKE_CODE
      else
        str = Digest::SHA1.hexdigest("#{params[:phone]}@dface#{Time.now.day}")[0,6]
        code = str.to_i(16).to_s[0,5]
        while code.size<5
          code = "0#{code}" 
        end
      end
    else
      code = "123456"
    end
    if !valid_phone(params[:phone])
      render :json => {"error" => "#{params[:phone]}不是有效的手机号码。"}.to_json
      return
    end
    sms = "您的验证码是：#{code}。请不要把验证码泄露给其他人。"
    Resque.enqueue(SmsSender, params[:phone], sms )  unless fake
    session[:phone_code] = code
    session[:phone_try] = 5
    render :json => {"code"=>""}.to_json
  end
  
  def register
    user = User.new
    user.phone = params[:phone]
    user.psd = slat_hash_pass(params[:password]) if params[:password]
    user.name = "" #user.phone
    user.save!
    $redis.set("P:#{user.phone}", user.id)
    data = {:id => user.id, :password => user.password, :phone => user.phone}
    session[:new_user_flag] = true
    data.merge!({newuser:1})
    session[:user_id] = user.id
    save_device_info(user.id, true)
    Resque.enqueue(LoginNotice, user.id, request.session_options[:id], true)
    Resque.enqueue(NewPhoneReg, user.id, user.phone)
    Rails.cache.write("PHONEREG#{user.id}", 1, :expires_in => 2.hours)
    render :json => data.to_json
  end
  
  def forgot_password
    user = User.find_by_phone(params[:phone])
    if user.nil?
      Xmpp.error_notify("忘记密码时，手机号#{params[:phone]}验证通过，但是数据库中没有这个号码")
      render :json => {"error"=>"手机号码不存在"}.to_json
      return
    end
    user.psd = slat_hash_pass(params[:password])
    user.unset(:phone_hidden)  if user.phone_hidden
    user.save!
    session[:user_id] = user.id
    render :json => user.safe_output.to_json
  end
  
  def change_password
    user = session_user
    if params[:oldpass].nil? || user.psd != slat_hash_pass(params[:oldpass])
      render :json => {"error"=>"原密码输入错误"}.to_json
      return
    end
    user.psd = slat_hash_pass(params[:password])
    user.save!
    render :json => user.safe_output.to_json
  end
  
  def login
    if params[:phone] && params[:phone].size<11 && !fake_phone(params[:phone]) 
      shop = Shop.find_by_id_or_id2( params[:phone])
      if shop
        if shop.password == Shop.hashize_string(params[:password])
          session[:user_id] = "s#{shop.id}"
    	    render :json => User.find_by_id("s#{shop.id}").output_self.to_json
        else
          render :json => {"error"=>"用户名或者密码不正确"}.to_json
        end
        return
      end
    end
    user = User.find_by_phone(params[:phone])
    if user.nil? || user.psd != slat_hash_pass(params[:password])
      render :json => {"error"=>"手机号码或者密码不正确"}.to_json
      return      
    end
    if user.phone_hidden
      return render :json => {"error"=>"该手机号码不能直接登录，请先注册或者登录后绑定该手机号码"}.to_json
    end
    session[:user_id] = user.id
    Resque.enqueue(LoginNotice, user.id, request.session_options[:id] )
    save_device_info(user.id, false)
	  render :json => user.output_self.to_json
  end
  
  def bind
    user = User.find_by_phone(params[:phone])
    if user && user.id != session_user.id
      if user.phone_hidden
        user.unset(:phone)
        user.unset(:phone_hidden)
      else
        return render :json => {"error"=>"手机号码不可用或已被注册"}.to_json
      end
    end
    if session_user.phone && params[:phone] != session_user.phone
      Xmpp.error_notify("用户手机号码#{session_user.phone}，重新绑定新的手机号码#{params[:phone]}")
      ua = UserAddr.find_by_id(session_user.id)
      ua.delete if ua
      session_user.set(:pmatch, false)
      session_user.change_phone_redis(session_user.phone, params[:phone])
    end
    user = session_user_no_cache
    user.phone = params[:phone]
    user.unset(:phone_hidden)  if user.phone_hidden
    user.save!
    render :json => {bind: true}.to_json
  end
  
  def set_password
    user = session_user_no_cache
    user.set(:psd, slat_hash_pass(params[:password]) )
    render :json => {set_password: true}.to_json
  end
  
  def unbind
    user = session_user_no_cache
    if !(user.has_qq? || user.has_wb?)
      render :json => {"error"=>"至少有一种以上的绑定关系才能解绑"}.to_json
    else
      user.set(:phone_hidden, true)
      user.set(:pmatch, false)
      render :json => {unbind: true}.to_json
    end
  end
  
  def upload_address_list
    ua = UserAddr.find_or_new(session_user.id)
    Xmpp.error_notify("用户#{session_user.name}，#{ua.phone}已经有通讯录了") if ua.phone
    ua.phone = params[:phone]
    list = JSON.parse(params[:list])
    list.delete_if {|x| x["number"].size<6}
    ua.list = list
    ua.save!
    session_user_no_cache.set(:pmatch, true)
    begin
      Resque.enqueue(PhoneFriend, session_user.id)
    rescue
    end
    render :json => {imported: ua.list.size}.to_json
  end
  
  def sms_up
    if fake_phone(params[:phone])
      up = "+#{params[:phone]}"
      ret = {phone:up, txt:"注册码#{params[:phone][3..-1]}, 发送此短信立刻注册脸脸"}
    else
      up = "1069800020086645"
      ret = {phone:up, txt:"注册码#{params[:phone][3..-1]}, 发送此短信立刻注册脸脸"}
      Rails.cache.write("SMS_CHECK", params[:phone], :expires_in => 2.minutes)
    end
    render :json => ret.to_json
  end
  
  def do_register
    if fake_phone(params[:phone])
      register
      return
    end
    (1..5).each do |x|
      if Rails.cache.read("SMSUP#{params[:phone]}")
        register
        return
      end
      sleep 1
    end
    render :json => {"error"=>"还未收到短信"}.to_json
  end

  private 
  def slat_hash_pass(password)
    Digest::SHA1.hexdigest(":dFace.#{password}@cn")[0,16]
  end
  

end
