# coding: utf-8

class CheckinsController < ApplicationController
  before_filter :user_login_filter

  def create
    raise "user != session user" if params[:user_id].to_s != session[:user_id].to_s
    do_checkin
    render :json => {ok:1}.to_json
  end
  
  def new_shop
    if params[:sname].length<4
      render :json => {error: "地点名称不能少于四个字"}.to_json
      return
    end
    if params[:sname][0,3]=="@@@"
      render :json => {error: "没权限创建：params[:sname]"}.to_json
      return
    end
    if !is_kx_user?(session[:user_id])
      if Rails.cache.read("ADDSHOP#{session[:user_id]}")
        render :json => {error: "一个用户一天只能创建一个地点"}.to_json
        return
      end
    end
    shop = gen_new_shop
    if is_session_user_kx
      score = 75
    else
      score = 68
    end
    ss = Shop.similar_shops(shop,score)
    if ss.length>0
      shop = ss[0]
    else
      shop.save!
      Rails.cache.write("ADDSHOP#{session[:user_id]}", 1, :expires_in => 24.hours)
    end
    params[:shop_id] = shop.id
    do_checkin(shop,false,true)
    render :json => shop.safe_output.to_json
  end
  
  
  def delete
    begin
      cin = Checkin.find(params[:id])
    rescue
      error_log "\nTry to delete non-exist checkin:#{params[:id]}, #{Time.now}"
      render :json => {:deleted => params[:id]}.to_json
      return
    end

    if cin.uid != session[:user_id]
      render :json => {:error => "checkin's owner #{cin.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    if cin.update_attribute(:del,true)
      render :json => {:deleted => params[:id]}.to_json
    else
      render :json => {:error => "cin #{params[:id]} delete failed"}.to_json
    end
  end



  private
  
  def gen_new_shop
    shop = Shop.new
    shop._id = Shop.next_id
    shop.name = params[:sname]
    shop.lo = [params[:lat].to_f, params[:lng].to_f]
    shop.lo = Shop.lob_to_lo(shop.lo) if params[:baidu]
    shop.city = shop.get_city
    #shop.d = 10
    shop.creator = session[:user_id]
    shop.utype = params[:type] if params[:type]
    shop
  end
  
  def do_checkin(shop=nil,fake=false, new_shop=false)
    shop = Shop.find_by_id(params[:shop_id]) if shop.nil?
    checkin = Checkin.new
    checkin.loc = [params[:lat].to_f, params[:lng].to_f]
    checkin.acc = params[:accuracy]
    checkin.uid = session[:user_id]
    checkin.sex = session_user.gender
    checkin.sid = shop.id
    checkin.city = shop.city if shop
    checkin.od = params[:od]
    checkin.bd = params[:baidu] if params[:baidu]
    checkin.bssid = params[:bssid] if params[:bssid] && !fake
    if params[:altitude]
      checkin.alt = params[:altitude].to_f
      checkin.altacc = params[:altacc]
    end
    if params[:speed]
      speed = params[:speed].to_f 
      checkin.speed = speed if speed>0.1
    end
    checkin.del = true if fake
    checkin.del = true if checkin.acc==5 && checkin.alt==0
    checkin.ip = real_ip
    new_user_nofity(checkin)
    if Rails.env != "test"
      Resque.enqueue(CheckinNotice, checkin, new_shop, params[:ssid] )
    else
      CheckinNotice.perform(checkin, new_shop, params[:ssid])
    end
    checkin
  end

  def new_user_nofity(checkin)
    if session[:new_user_flag]
      session[:new_user_flag] = nil
      session_user.update_attribute(:city, checkin.city)
      return  if ENV["RAILS_ENV"] != "production"
      Resque.enqueue(NewUser, checkin.uid,checkin.sid,checkin.od)
    end
  end

end
