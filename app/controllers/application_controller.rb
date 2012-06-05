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
      err.backtrace[0,10].each {|x| logger.error x}
      err_str = err.to_s
      err_str = "抱歉,此页面不存在!" if err.class.name == "ActiveRecord::RecordNotFound"
      render(:file => "500.html.erb", :use_full_path => true, :locals => {:error_msg => err_str})
    end
  end

  around_filter :access_log if ENV["RAILS_ENV"] == "production"

  def user_agent_log(alog)
    begin
      if request.env['HTTP_USER_AGENT']
        agent              = Agent.new(request.env['HTTP_USER_AGENT'])
        alog.agent_name    = agent.name.to_s
        alog.agent_version = agent.version.to_s
        alog.agent_engine  = agent.engine.to_s
        alog.agent_os      = agent.os.to_s
        alog.agent = request.env['HTTP_USER_AGENT'] #if alog.agent_name.downcase=="unknown" || alog.agent_os.nil? || alog.agent_os.downcase=="unknown"
        alog.parse_unknown_agent if alog.agent_name.downcase=="unknown"
      end
    rescue Exception => err
      puts err
    end
  end

  def access_log
    alog = AccessLog.new
    alog.admin_id = session[:admin_id]
    alog.shop_id = session[:shop_id]
    alog.user_id = session[:user_id]
    alog.session_id = session[:session_id]
    alog.session_id = cookies["1dooo"] if session[:session_id].nil?
    time1 = Time.now.to_f
    rss_before = `ps -o rss= -p #{$$}`.to_i  if ENV["RAILS_ENV"] == "production"
    yield
    if ENV["RAILS_ENV"] == "production"
      rss_after        = `ps -o rss= -p #{$$}`.to_i
      alog.mem_consume = rss_after -rss_before
      alog.mem_now     = rss_after
    end
    alog.pid            = $$.to_i
    alog.url            = request.url[0,255]
    url = url[0,url.length-1] if !url.nil? && url[url.length-1,1]=='/'
    alog.ip             = real_ip
    alog.referer        = request.referer
    alog.time           = ((Time.now.to_f-time1)*1000).to_i
    user_agent_log(alog)
    alog.save
  end

  def memo_original_url
    session[:o_uri] = request.request_uri unless request.request_uri =~ /\/login/
  end

  def admin_authorize
    unless Admin.find_by_id(session[:admin_id])
      flash[:notice] = "请登录"
      memo_original_url()
      redirect_to( :controller => "admin_login" , :action => "login")
    else
      redirect_to "/noright.htm" unless right_check
    end
  end

  def right_check
    model=self.controller_name
    flag = Right.check(session_admin,model,self.action_name)
    #save_operation_log(session_admin.id,model,self.action_name,flag)
    flag
  end

  def save_operation_log(admin_id,model,action,flag)
    log=OperationLog.new
    log.admin_id=admin_id
    log.model=model
    log.action=action
    log.object_id=params[:id]
    log.allow=flag
    log.save
  end


  def user_authorize
    if session_user.nil?
      flash[:notice] = "请登录"
      memo_original_url()
      redirect_to( :controller => "user_login" , :action => "login")
    end
  end


  def user_login_redirect(user)
    session[:user_id] = user.id
    uri = session[:o_uri]
    session[:o_uri] = nil
    redirect_to( uri || {:controller => "user_login", :action => "index"} )
  end

  def session_user
    u=User.find_by_id(session[:user_id])
    u
  end

  def session_admin
    Admin.find_by_id(session[:admin_id])
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
      request.headers["X-Forwarded-For"]
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

end

