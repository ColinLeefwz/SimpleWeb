# coding: utf-8

class UserLoginController < ApplicationController
  before_filter :user_authorize, :except => ['login','logout','bokee','shop', 'has_login', 'loginjs', 'send_password']
  in_place_edit_for :user, :nickname

  def index
    redirect_to user_user_logos_path(:user_id => session[:user_id])
  end

  def binduser
    if request.post?
      user = User.auth(params[:bindname], params[:bindpass])
      if user and (user.id != session_user.id)
        User.merge_user(user.id, session_user.id)
        user_login_redirect user
      else
        flash[:notice] = "用户名或者密码错误！"
        redirect_to :action => "index"
      end
    else
      redirect_to :action => "index"
    end
  end

  def login
    session[:o_uri] = params[:url] if params[:url]
    session[:user_id] = nil
    if request.post?
      # 保存用户登录信息 2010-05-07 13:38:00 修改
      user_login_log = UserLoginLog.new
      user_login_log.login_time = Time.zone.now
      user_login_log.ip = request.remote_ip
      user_login_log.name = params[:name]
      user_login_log.password = params[:password]

      user = User.auth(params[:name], params[:password])
      if user
        # 用户的登录名/手机号是可以修改的，所以保存 user_id
        user_login_log.user_id = user.id
        user_login_log.login_suc = true
        user_login_log.save
        session[:user_id] = user.id
        user_login_redirect user
      else
        user_login_log.save
        flash.now[:notice] = "用户名或者密码错误！"
      end
    else
      unless params[:nl].nil?
        render(:layout => false)
      end
    end
  end

  def loginjs
    user = nil
    if request.post?
      # 保存用户登录信息 2010-05-07 13:38:00 修改
      user_login_log = UserLoginLog.new
      user_login_log.login_time = Time.zone.now
      user_login_log.ip = request.remote_ip
      user_login_log.name = params[:name]
      user_login_log.password = params[:password]
      if !params[:name].blank?
        if PhoneCompare.form(params[:name])
          user = User.auth_by_phone(PhoneCompare.normalize(params[:name]), params[:password])
        else
          user = User.auth(params[:name], params[:password])
        end
      elsif !params[:phone].blank?
        if params[:shop_name] == 'qiandaohu'
          user = User.auth_by_qdh_phone(PhoneCompare.normalize(params[:phone]), params[:password])
        else
          user = User.auth_by_phone(PhoneCompare.normalize(params[:phone]), params[:password])
        end
      end
      if user
        # 用户的登录名/手机号是可以修改的，所以保存 user_id
        user_login_log.user_id = user.id
        user_login_log.login_suc = true
        user_login_log.save
        if user.shop_id.nil?
          session[:user_id] = user.id
          session[:shop_id] = user.my_shop.id unless user.my_shop.nil?
        else
          session[:user_id] = user.id
          session[:shop_id] = user.shop_id
        end
      else
        user_login_log.save
      end
    end
    render :text => user ? "1" : "0"
  end

  def has_login
    render :json => { :result => (session[:user_id].blank? ? 0 : 1)}.to_json
  end

  def upgrade_to_shop
    s = session_user.upgrade_to_shop
    render :text => "ok"
  end

  def shop
    if session[:shop_id].nil?
      return user_authorize if session_user.nil?
    end
    render :layout => false
  end

  def send_password
    @phone = params[:phone]
    @send_confirm = 0
    @phone_confirm = 0
    @send_form = 0
    @user = nil
    # 验证手机号格式
    if PhoneCompare.form(@phone)
      @phone_confirm = 1
      if params[:shop_name] == 'qiandaohu'
        @user = User.find(:first, :conditions => ["(phone = ? or other_phones like ?) and (shop_key = 'qiandaohu' or shop_key = 'qiandaohu_1dooo')", @phone, "%#{@phone}"])
      else
        @user = User.find_by_phone(@phone)
      end
      if @user
        if params[:shop_name] == 'qiandaohu'
          SmsOut.send_sms_by_qxt("您在加布里埃尔啤酒俱乐部网站的登录密码是:#{@user.password}。如有疑问请拔打400-007-1819", @phone)
        else
          SmsOut.send_sms("您在一渡网的登录密码是:#{@user.password}", @phone)
        end
        @send_confirm = 1
      end
    end
    render :json => {"result" => {"send_form" => @send_form, "send_confirm" => @send_confirm, "phone_confirm" => @phone_confirm }}.to_json
  end

  def logout
    # 用户退出时要清空这个session中的user_id，这个session的保留不再有意义，故清空这个session
    reset_session
    # session[:user_id] = nil
    flash.now[:notice] = "退出系统！"
    redirect_to request[:redirect_url].blank? ? "/" : request[:redirect_url]
  end

  def bokee
    hash=params[:hash]
    today= Time.now.strftime "%Y-%m-%d"
    tohash="#{params[:name]}#{today}bokee"
    if hash == Digest::SHA1.hexdigest(tohash)[0,16]
      user = User.find_by_name(params[:name])
      session[:o_uri] = params[:url] unless params[:url].nil?
      user_login_redirect user
    else
      render "用户名或者密码错误！"
    end
  end

end
