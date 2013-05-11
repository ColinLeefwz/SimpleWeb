# coding: utf-8

class ShopLoginController < ApplicationController
  before_filter :shop_authorize, :except => [:login, :find_shop]
  include Paginate

  def index
    render :layout => "shop"
  end


  def login
    return redirect_to :action  => 'index' if session[:shop_id]
    ip = real_ip
    error_num, aen = Rails.cache.read("LE#{ip}").to_s.split(';')
    return  render(:text => "密码错误#{error_num}次，请一个小时后再试") if error_num.to_i == 5
    if request.post?
      shop =  Shop.find_by_id(params[:id])
      return flash.now[:notice] = 'id没有找到.' if shop.nil?
      if shop.password.blank? || shop.password != params[:password]
        error_num = error_num.to_i+ 1
        if aen.nil?
          cityname, citycode = RequestApi::TaoBaoIP.fetch_city(ip), nil
          unless cityname.blank?
            cityname = cityname.sub(/[市]/, '')
            citycode= City.where(name: /#{cityname}/).limit(1).to_a.first.try(:code)
          end
          aen =  (citycode && citycode != shop.city) ? 3 : 5
        end
        aen = aen.to_i
        Rails.cache.write("LE#{ip}" ,"#{error_num};#{aen}", :expires_in => 1.hour)
        return redirect_to :action => 'login'  if aen - error_num ==0
        LoginFail.create(:name => params[:id], :password => params[:password], :login_at => Time.now, :ip => ip )
        return flash.now[:notice] = "密码输入错误，您还有#{aen.to_i-error_num}次机会"
      end
      LoginSuccess.create(:name => params[:id], :login_at => Time.now, :ip => ip  )
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

  def asyn_city
    
  end

  def write_cache(ip)
    
  end

end

