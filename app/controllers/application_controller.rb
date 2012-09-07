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

  around_filter :exception_catch if ENV["RAILS_ENV"] == "production"
  def exception_catch
    begin
      yield
    rescue  Exception => err
      logger.error "Internal Server Error: #{err.class.name}"
      err.backtrace.each {|x| logger.error x}
      err_str = err.to_s
      render :json => {:error => err_str }.to_json   
    end
  end


  def memo_original_url
    session[:o_uri] = request.request_uri unless request.request_uri =~ /\/login/
  end

  def admin_authorize
    unless Admin.find(session[:admin_id])
      flash[:notice] = "请登录"
      memo_original_url()
      redirect_to( :controller => "admin_login" , :action => "login")
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

  def session_user
    u=User.find(session[:user_id])
    u
  end

  def session_admin
    Admin.find(session[:admin_id])
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
      request.headers["HTTP_X_FORWARDED_FOR"]
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
  
  def output_users(fs)
    users = []
    page = params[:page] || 1
    pcount = params[:pcount] || 20
    page = page.to_i
    pcount = pcount.to_i
    
    fs2 = fs[(page-1)*pcount,pcount]
    fs2.each {|f| users << f.safe_output_with_relation(params[:id]) } if fs2
    if params[:hash]
      ret = {:count => fs.size}
      ret.merge!( {:data => users})
    else
      ret = [{:count => fs.size}]
      ret << {:data => users}
    end
    render :json => ret.to_json
  end
  

end

