# coding: utf-8

class ShopLoginController < ApplicationController
  before_filter :shop_authorize, :except => [:login, :find_shop]
  include Paginate

  def index
    render :layout => "shop"
  end


  def login
    #     Rails.cache.delete("LE#{real_ip}")
    return redirect_to :action  => 'index' if session[:shop_id]
    if request.post?
      shop =  Shop.find_by_id(params[:id])
      return flash.now[:notice] = 'id没有找到.' if shop.nil?
      if shop.password.blank? || shop.password != params[:password]
        ip = real_ip
        error_num, allow_err_num=  err_num(shop.city, ip)
        return  render(:text => "您的ip已经被锁定一小时，请稍后再试!")    if allow_err_num == error_num
        Rails.cache.write("LE#{ip}" ,"#{error_num};#{allow_err_num}", :expires_in => 1.hour)
        LoginFail.create(:name => params[:id], :password => params[:password], :login_at => Time.now, :ip => ip, :agent => request.env['HTTP_USER_AGENT'] )
        return flash.now[:notice] = "密码输入错误，您还有#{allow_err_num - error_num}次机会"
      end
      LoginSuccess.create(:name => params[:id], :login_at => Time.now, :ip => ip, :agent => request.env['HTTP_USER_AGENT']  )
      session[:shop_id] = shop.id
      cookies[:id], cookies[:password] =params[:id],params[:password] if params[:remember]=='1'
      o_uri_path, session[:o_uri_path] = session[:o_uri_path]||'/shop_login/index' , nil
      redirect_to o_uri_path
    end
  end

  def logout
    session[:shop_id] = nil
    redirect_to :action => :login
  end

  def find_shop
    shop = Shop.find_by_id(params[:id])
    render :json => {:text => shop ? shop.name : '错误id.'}
  end

  def gchat
    @chats = paginate_arr(session_shop.gchat, params[:page], 15)
    render :layout => "shop"
  end

  private

  def err_num(city_code, ip)
    
    err_cache = Rails.cache.read("LE#{ip}")
    if err_cache.nil?
      cityname, citycode = RequestApi::TaoBaoIP.fetch_city(ip), nil
      unless cityname.blank?
        cityname = cityname.sub(/[市]/, '')
        citycode= City.where(name: /#{cityname}/).limit(1).to_a.first.try(:code)
      end
      [1, (citycode && citycode != city_code) ? 3 : 5]
    else
      data = err_cache.split(';').map{|m| m.to_i }
      data[0] += 1
      data
    end
  end


end

