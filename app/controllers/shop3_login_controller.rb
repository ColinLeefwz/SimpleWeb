# coding: utf-8

class Shop3LoginController < ApplicationController
  before_filter :shop_authorize, :except => [:login, :find_shop, :login2]
  include Paginate

  def index
    @shop_faqs = session_shop.faqs.limit(5)
    hash = {:room => session[:shop_id].to_i.to_s, :user_id => {"$ne" => "s#{session[:shop_id]}" }}
    hash.merge!({user_id: params[:uid]}) unless params[:uid].blank?
    sort = {:od => -1, :updated_at =>  -1}
    @photos = paginate("Photo", params[:page], hash, sort,4)
    @shop_notice = session_shop.notice
    @shop_coupons = session_shop.coupons
    render :layout => "shop3"
  end

  def tojson
    hash = {sid: session[:shop_id]}
    unless params[:name].blank?
      uids = User.where(:name => /#{params[:name]}/).only(:_id).map { |m| m._id }
      hash.merge!({uid: {'$in' => uids}})
    end
    hash.merge!({uid: params[:uid]}) unless params[:uid].blank?
    
    sort = {_id: -1}
    @checkins = paginate2("Checkin", params[:page], hash, sort, 1000)
    respond_to do |format|
      format.json
    end
  end

  def login
    #   Rails.cache.delete("LE#{real_ip}")
    return redirect_to :action  => 'index' if session[:shop_id]
    if request.post?
      shop =  Shop.find_by_id_or_id2(params[:id])
      return flash.now[:notice] = 'id没有找到.' if shop.nil?
      ip = real_ip
      err_cache = cache_err_num(ip)
      return  flash.now[:notice] = "您的ip已经被锁定一小时，请稍后再试!" if !err_cache.nil? && err_cache[0] == err_cache[1]
      if shop.password.blank? || shop.password != Digest::SHA1.hexdigest(params[:password])[0,16]
        error_num, allow_err_num = err_cache ? [err_cache[0] +1, err_cache[1]] :  city_err_num(shop.city, ip)
        Rails.cache.write("LE#{ip}" ,"#{error_num};#{allow_err_num}", :expires_in => 1.hour)
        LoginFail.create(:name => params[:id], :password => params[:password], :login_at => Time.now, :ip => ip, :agent => request.env['HTTP_USER_AGENT'] )
        return flash.now[:notice] = (allow_err_num== error_num ? '您的ip已经被锁定一小时，请稍后再试!' :  "密码输入错误，您还有#{allow_err_num - error_num}次机会")
      end
      LoginSuccess.create(:name => params[:id], :login_at => Time.now, :ip => ip, :agent => request.env['HTTP_USER_AGENT']  )
      Rails.cache.delete("LE#{ip}")
      session[:shop_id] = shop.id
      cookies[:id], cookies[:password] =params[:id],params[:password] if params[:remember]=='1'
      o_uri_path, session[:o_uri_path] = session[:o_uri_path]||'/shop3_login/index' , nil
      o_uri_path = mweb_url if session_shop.mweb
      return redirect_to o_uri_path
    end
    render :layout => false
  end

  def mweb_url
    url = "#{Host::Mweb}/login/"
    url += session_shop.mobile_space ? 'index2' : "index"
    url += "?sid=#{session[:shop_id]}&hash=#{Digest::SHA256.hexdigest(session[:shop_id].to_s + "12191008")[0,32]}"
  end

  def login2
    reset_session
    if Digest::SHA256.hexdigest(params[:id] + "mweb")[0,32] == params[:hash]
      session[:shop_id] = params[:id]
      redirect_to '/shop3_login/index'
    end
  end

  def logout
    if session_shop.mweb && session[:admin_sid].nil?
      reset_session
      redirect_to "#{Host::Mweb}/login/logout"
    else
      admin_sid = session[:admin_sid]
      reset_session
      session[:shop_id] = admin_sid
      redirect_to :action => :login
    end
  end

  def find_shop
    shop = Shop.find_by_id_or_id2(params[:id])
    render :json => {:text => shop ? shop.name : '错误id.'}
  end


  def branch_login
    shop= Shop.find_by_id(params[:id])
    if shop.psid.to_i == session[:shop_id].to_i
      session[:admin_sid] = session[:shop_id]
      session[:shop_id] = shop.id
      redirect_to :controller => :shop3_login,:action => "index"
    else
      render :text => "不能登录"
    end
  end

  def gchat
    @chats = paginate_arr(session_shop.gchat, params[:page], 10)
    render :layout => "shop3"
  end

  private

  def cache_err_num(ip)
    err_cache = Rails.cache.read("LE#{ip}")
    return if err_cache.nil?
    err_cache.split(';').map{|m| m.to_i }
  end

  def city_err_num(city_code, ip)
    cityname, citycode = RequestApi::TaoBaoIP.fetch_city(ip), nil
    unless cityname.blank?
      cityname = cityname.sub(/[市]/, '')
      citycode= City.where(name: /#{cityname}/).limit(1).to_a.first.try(:code)
    end
    [1, (citycode && citycode != city_code) ? 50 : 100]
  end


end

