# coding: utf-8

class PhoneController < ApplicationController
  before_filter :user_login_filter, :only => [:bind, :unbind, :change_password] 
  before_filter :code_match, :only => [:register, :forgot_password, :bind] 
  before_filter :password_check, :only => [:register, :forgot_password, :change_password, :bind] 
  
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
    if params[:code] != session[:phone_code]
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
      code = rand(999999).to_s
      code = "13579" if fake
    else
      code = "123456"
    end
    if !fake && (params[:phone].size != 11 || params[:phone].to_i<10000000000)
      render :json => {"error" => "#{params[:phone]}不是有效的手机号码。"}.to_json
      return
    end
    sms = "您的验证码是：#{code}。请不要把验证码泄露给其他人。"
    #TODO: 短信发送限流
    Resque.enqueue(SmsSender, params[:phone], sms )  unless fake
    session[:phone_code] = code
    session[:phone_try] = 5
    render :json => {"code"=>Digest::SHA1.hexdigest("#{code}@dface.cn")[0,16]}.to_json
  end
  
  def register
    user = User.find_by_phone(params[:phone], false)
    if user
      render :json => {"error"=>"手机号码不可用或已被注册"}.to_json
      return      
    end
    user = User.new
    user.phone = params[:phone]
    user.psd = slat_hash_pass(params[:password])
    user.name = "" #user.phone
    user.save!
    $redis.set("P:#{user.phone}", user.id)
    data = {:id => user.id, :password => user.password, :phone => user.phone}
    session[:new_user_flag] = true
    data.merge!({newuser:1})
    session[:user_id] = user.id
    save_device_info(user.id, true)
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
      shop = Shop.find_by_id( params[:phone])
      if shop
        if shop.password == params[:password]
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
    session[:user_id] = user.id
    save_device_info(user.id, false)
	  render :json => user.output_self.to_json
  end
  
  def bind
    user = User.find_by_phone(params[:phone])
    if user && user.id != session_user.id
      render :json => {"error"=>"手机号码不可用或已被注册"}.to_json
      return      
    end
    if session_user.phone && params[:phone] != session_user.phone
      Xmpp.error_nofity("用户手机号码#{session_user.phone}，重新绑定新的手机号码#{params[:phone]}")
    end
    user = session_user_no_cache
    user.psd = slat_hash_pass(params[:password])    
    user.phone = params[:phone]
    user.save!
    render :json => {bind: true}.to_json
  end
  
  def unbind
    render :json => {"error"=>"无法解除手机号码的绑定"}.to_json
  end

  private 
  def slat_hash_pass(password)
    Digest::SHA1.hexdigest(":dFace.#{password}@cn")[0,16]
  end
  
  def fake_phone(phone)
    phone[0,3]=="000"
  end
  
  
end
