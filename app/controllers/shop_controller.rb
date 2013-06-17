# coding: utf-8

class ShopController < ApplicationController

  layout nil
  caches_action :info, cache_path: ->(c) {"SI#{c.params[:id]}"}
  
  def nearby
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    lo = [params[:lat].to_f , params[:lng].to_f]
    city = Shop.get_city(lo)
    hash = {city: city}
    if params[:name]
      hash.merge!( {name: /#{params[:name]}/ }  )  
    else
      hash.merge!( { del:{"$exists"=>false} }  )  
    end
    if params[:type]
      t = params[:type].to_i*2-1
      hash.merge!( {t: { "$in" => [ t-1, t ] } }  ) 
    end
    shops = Shop.where(hash).sort({utotal:-1}).skip(skip).limit(pcount)
    if city=="0571"
      shops = shops.to_a
      shops=shops[1..-1] << shops[0]  if shops[0]["_id"]==20325453
    end
    render :json =>  shops.map {|s| s.safe_output_with_users}.to_json
  end
  
  #签到时输入地点名称查找地点
  #少于三个字时，只查询附近的可以进入的现场
  #当大于三个字时
  #   名称完全匹配时，可以进入虚拟的活动地点
  #   名称部分匹配时，可以围观
  def add_search
    if params[:sname].nil?
      render :json => [].to_json
      return
    end
    lo = [params[:lat].to_f, params[:lng].to_f]
    if params[:sname].length<3
      radis = 0.001 + params[:sname].length*0.0005
      shops = Shop.where({lo:{"$within" => {"$center" => [lo,radis]}}, name:/#{params[:sname]}/}).limit(10)
      #TODO: 增加缓存，key为经纬度加查询关键字
      render :json =>  shops.map {|s| {id:s.id,name:s.name, visit:0}.merge!(s.group_hash(session[:user_id])) }.to_json
    else
      ret = []
      shop = Shop.where({t:0, name:params[:sname]}).first #虚拟的活动地点名称完全匹配时可以进入
      if shop
        hash = {id:shop.id,name:shop.name, visit:0}.merge!(shop.group_hash(session[:user_id])) 
        ret << hash
      end
      shop1s = Shop.where({lo:{"$within" => {"$center" => [lo,0.0025]}}, name:/#{params[:sname]}/}).limit(10)
      shop1s.each do |s| 
        hash = {id:s.id,name:s.name, visit:0}.merge!(s.group_hash(session[:user_id]))
        ret << hash
      end
      if ret.length<1
        #city = Shop.get_city(lo)
        shops = Shop.where({lo:{"$within" => {"$center" => [lo,0.03]}}, name:/#{params[:sname]}/}).limit(10)
        shops.each do |s| 
          hash = {id:s.id,name:s.name, visit:1}.merge!(s.group_hash(session[:user_id]))
          ret << hash
        end
      end
      render :json =>  ret.to_json
    end

  end
  
  def auth
    shop = Shop.find_by_id(params[:shop_id])
    flag = shop.group.auth(session[:user_id], params[:txt])
    if flag
      render :json => {ret:1}.to_json
    else
      render :json => {ret:0}.to_json      
    end
  end

  
  def users
    shop = Shop.find_by_id(params[:id])
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    users = shop.view_users(session[:user_id],(page-1)*pcount,pcount)
    render :json => users.to_json
  end
  
  def info
    shop = Shop.find_by_id(params[:id])
    render :json => shop.safe_output_with_staffs.to_json
  end
  
  def history
    shop = Shop.find_by_id(params[:id])
    skip = params[:skip].to_i
    pcount = params[:pcount].to_i
    pcount = 10 if pcount==0
    render :json => shop.history(skip,pcount).to_json
  end
  
  def photos
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 5 if pcount==0
    skip = (page-1)*pcount
    photos = shop_photo_cache(params[:id], skip, pcount)
    render :json => photos.map {|p| p.output_hash_with_username }.to_json
  end
  
  def shop_photo_cache_key(sid,skip,pcount)
    "SP#{sid}-#{pcount}"
  end
  
  def shop_photo_cache(sid,skip,pcount)
    if skip>0
      return shop_photo_no_cache(sid,skip,pcount)
    end
    Rails.cache.fetch(shop_photo_cache_key(sid,skip,pcount)) do
      shop_photo_no_cache(sid,skip,pcount)
    end
  end
  
  def shop_photo_no_cache(sid,skip,pcount)
    Photo.where({room:sid}).sort({updated_at: -1}).skip(skip).limit(pcount).to_a
  end


end
