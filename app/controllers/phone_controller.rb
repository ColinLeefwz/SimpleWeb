# coding: utf-8

class PhoneController < ApplicationController
  before_filter :user_login_filter, :only => [:bind, :unbind, :change_password] 
  
  
  def init
    #user = User.where({phone: params[:phone]}).first
    #if user
    #  render :json => {"error"=>"手机号码不可用或已被注册"}.to_json
    #end
    if Rails.env == "production"
      code = rand(999999).to_s
      code = "13579" if params[:phone][0,3]=="000"
    else
      code = "123456"
    end
    sms = "您的验证码是：#{code}。请不要把验证码泄露给其他人。"
    Resque.enqueue(SmsSender, params[:phone], sms )
    session[:phone_code] = code
    render :json => {"code"=>Digest::SHA1.hexdigest("#{code}@dface.cn")[0,16]}.to_json
  end
  
  def register
    if params[:code] != session[:phone_code]
      render :json => {"error"=>"验证码错误"}.to_json
      return
    end
    user = User.where({phone: params[:phone]}).first
    if user
      render :json => {"error"=>"手机号码不可用或已被注册"}.to_json
      return      
    end
    user = User.new
    user.phone = params[:phone]
    user.password = slat_hash_pass(params[:password])
    user.name = user.phone
    user.save!
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
    if params[:code] != session[:phone_code]
      render :json => {"error"=>"验证码错误"}.to_json
      return
    end
    user = User.where({phone: params[:phone]}).first
    if user.nil?
      render :json => {"error"=>"手机号码不存在"}.to_json
      return      
    end
    user.password = slat_hash_pass(params[:password])
    user.save!
    render :json => user.safe_output.to_json
  end
  
  def change_password
    user = session_user
    if params[:oldpass].nil? || user.password != slat_hash_pass(params[:oldpass])
      render :json => {"error"=>"原密码输入错误"}.to_json
      return
    end
    user.password = slat_hash_pass(params[:password])
    user.save!
    render :json => user.safe_output.to_json
  end
  
  def login
    user = User.where({phone: params[:phone]}).first
    if user.nil? || user.password.nil? || user.password != slat_hash_pass(params[:password])
      render :json => {"error"=>"手机号码或者密码不正确"}.to_json
      return      
    end
    session[:user_id] = user.id
    save_device_info(user.id, false)
	  render :json => user.output_self.to_json
  end
  
  def bind
    if params[:code] != session[:phone_code]
      render :json => {"error"=>"验证码错误"}.to_json
      return
    end
    user = User.where({phone: params[:phone]}).first
    if user
      render :json => {"error"=>"手机号码不可用或已被注册"}.to_json
      return      
    end
    #    if session_user_no_cache.phone
    #      render :json => {error: "你已经绑定了一个手机号码"}.to_json #可以更换手机号码
    #      return
    #    end
    user = session_user_no_cache
    user.password = slat_hash_pass(params[:password])
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
  
  
end
