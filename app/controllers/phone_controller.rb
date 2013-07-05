# coding: utf-8

class PhoneController < ApplicationController
  before_filter :user_login_filter, :only => [:bind, :unbind] 
  
  
  def init
    user = User.where({phone: params[:phone]}).first
    if user.nil?
      # send sms 
      code = "123456"
      session[:phone_code] = code
      render :json => {"code"=>code}.to_json
    else
      render :json => {"error"=>"手机号码不可用或已被注册"}.to_json
    end
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
    save_device_info(user.id)
    render :json => data.to_json
  end
  
  def login
    user = User.where({phone: params[:phone]}).first
    if user.nil?  user.password.nil? || user.password != slat_hash_pass(params[:password])
      render :json => {"error"=>"手机号码或者密码不正确"}.to_json
      return      
    end
    session[:user_id] = user.id
    save_device_info(user.id)
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
    user.update_attribute(:phone, params[:phone])
    render :json => {bind: true}.to_json
  end
  
  def unbind
    render :json => {"error"=>"无法解除手机号码的绑定"}.to_json
  end
  
  def save_device_info(uid)
    ud = session[:user_dev]
    ud.save_to(uid) if ud
    session[:user_dev] = nil
  end

  private 
  def slat_hash_pass(password)
    Digest::SHA1.hexdigest(":dFace.#{password}@cn")[0,16]
  end
  
end
