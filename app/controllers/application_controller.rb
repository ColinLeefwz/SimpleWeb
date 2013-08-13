# coding: utf-8

require "compress.rb"

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time


  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  #protect_from_forgery # :secret => '0ece657db3ad4f380b628ea9c23cb2d0'

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  #  filter_parameter_logging :password


  after_filter OutputCompressionFilter

  #  before_filter :set_process_name_from_request
  #  after_filter :unset_process_name_from_request

  def set_process_name_from_request
    $0 = request.path[0,16]
  end

  def unset_process_name_from_request
    $0 = request.path[0,15] + "*"
  end

  def error_log(msg)
    File.open("log/dface-error.log","a") {|f| f.puts msg.to_s}
  end

  around_filter :exception_catch if ENV["RAILS_ENV"] == "production"
  def exception_catch
    begin
      yield
    rescue  Exception => err
      error_log "\nInternal Server Error: #{err.class.name}, #{Time.now}"
      error_log "#{request.path}  #{request.params}"
      #error_log request.env["HTTP_USER_AGENT"]
      #if session_user
      #  error_log "ver:#{session_user.ver},os:#{session_user.os}"
      #end
      err_str = err.to_s
      error_log err_str
      err.backtrace.each {|x| error_log x}
      render :json => {:error => err_str }.to_json   
    end
  end


  def memo_original_url
    session[:o_uri] = request.request_uri unless request.request_uri =~ /\/login/
  end

  def admin_authorize
    unless Admin.find_by_id(session[:admin_id])
      flash[:notice] = "请登录"
      memo_original_url()
      redirect_to( :controller => "admin_login" , :action => "login")
    end
    unless Right.check(self.controller_name, action_name, session[:admin_id] )
      render :text => "无权限:#{self.controller_name},#{action_name}"
    end
  end

  def shop_authorize
    if session[:shop_id].nil?
      session[:o_uri_path] = request.path unless request.path =~ /\/login/
      redirect_to(:controller => 'shop_login', :action => 'login' )
    end
  end

  #  def right_check
  #    model=self.controller_name
  #    flag = Right.check(session_admin,model,self.action_name)
  #    #save_operation_log(session_admin.id,model,self.action_name,flag)
  #    flag
  #  end

  #  def save_operation_log(admin_id,model,action,flag)
  #    log=OperationLog.new
  #    log.admin_id=admin_id
  #    log.model=model
  #    log.action=action
  #    log.object_id=params[:id]
  #    log.allow=flag
  #    log.save
  #  end


  def user_login_filter
    if session[:user_id].nil?
      render :json => {:error => "not login"}.to_json
    end
  end
  
  def user_is_session_user
    if params[:user_id] != session[:user_id].to_s
      render :json => {:error => "user #{params[:user_id]} != session user #{session[:user_id]}"}.to_json
      return
    end
  end
  
  def is_session_user_kx
    is_kx_user?(session[:user_id].to_s)
  end

  def session_user
    return nil if session[:user_id].nil?
    u=User.find_by_id(session[:user_id])
    u
  end
  
  def session_user_no_cache
    return nil if session[:user_id].nil?
    return nil if User.is_shop_id?(session[:user_id])
    User.find_primary(session[:user_id])
  end

  def session_admin
    Admin.find_by_id(session[:admin_id])
  end

  def session_shop
    Shop.find_by_id(session[:shop_id])
  end

  class TransactionFilter
    def filter(controller)
      return yield if controller.request.get?
      ActiveRecord::Base.transaction do
        yield
      end
    end
  end


  def transaction_filter(&block)
    TransactionFilter.new.filter(self, &block)
  end
  #around_filter :transaction_filter
  
  def real_ip
    if ENV["RAILS_ENV"] == "production"
      #logger.warn request.headers["HTTP_X_FORWARDED_FOR"]
      #logger.warn request.headers["HTTP_X_REAL_IP"]
      #request.headers["HTTP_X_FORWARDED_FOR"]
      request.headers["HTTP_X_REAL_IP"]
    else
      request.ip
    end
  end


  def has_value(s)
    if s.nil?
      false
    elsif s.empty?
      false
    else
      true
    end
  end
  
  def android_version
    version = $redis.get("android_version")
    if version
      ver = version.to_f
    else
      ver = 1.0
    end
  end
  
  def output_users(fs)
    users = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    page = page.to_i
    pcount = pcount.to_i
    
    fs2 = fs[(page-1)*pcount,pcount]
    fs2.each {|f| users << f.safe_output_with_location(params[:id]) } if fs2
    if params[:hash]
      ret = {:count => fs.size}
      ret.merge!( {:data => users})
    else
      ret = [{:count => fs.size}]
      ret << {:data => users}
    end
    render :json => ret.to_json
  end
  
  def save_device_info(uid, new_user)
    ud = session[:user_dev]
    if ud
      if new_user
        ud.save_new(uid) 
      else
        ud.save_to(uid) if UserDevice.user_ver_redis(uid) != ud.ds[0][3]
      end
    end
    session[:user_dev] = nil
  end
  

end

