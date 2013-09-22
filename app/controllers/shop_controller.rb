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
    if params[:sname][0,3]=="@@@" #测试人员输入商家id模拟签到
      shop = Shop.find_by_id(params[:sname][3..-1])  
      if shop && (session[:user_id].to_s == shop.seller_id.to_s || is_kx_user?(session[:user_id]) || User.is_fake_user?(session[:user_id]) )
         render :json => [shop].map {|s| {id:s.id,name:s.name, visit:0}.merge!(s.group_hash(session[:user_id])) }.to_json
        return
      end
    end
    if params[:sname]=="听说" || params[:sname]=="听" || (params[:sname][0]=="听" && params[:sname][-1]=="说")
      render :json => [Shop.find_by_id(21832930)].map {|s| {id:s.id,name:s.name, visit:0}.merge!(s.group_hash(session[:user_id])) }.to_json
      return
    end    
    lo = [params[:lat].to_f, params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    if params[:sname].length==1
      shops = Shop.where2({lo:{"$within" => {"$center" => [lo,0.01]}}, name:/#{params[:sname]}/, del:{"$exists" => false}}, {limit:10})
      render :json =>  shops.map {|s| {id:s.id,name:s.name, visit:0}.merge!(s.group_hash(session[:user_id])) }.to_json
    else
      ret = []
      shop1s = Shop.where2({lo:{"$within" => {"$center" => [lo,0.1]}}, name:/#{params[:sname]}/, del:{"$exists" => false}},{limit:10})        
      shop1s.each do |s| 
        hash = {id:s.id,name:s.name, visit:0}.merge!(s.group_hash(session[:user_id]))
        ret << hash
      end

      #商家查询个数小于10， 按群组的相似度查询群组
      if ret.size < 10
        ids = $redis.zrange("GSN", 0, -1, withscores: true).select{|gs|  Shop.str_similar(params[:sname], gs[0]) >= (0.5+ret.size*0.05)}.map{|m| m[1]}
        unless ids.blank?
          Shop.where2({_id: {"$in" => ids}}).each do |shop|
             hash = {id:shop.id,name:shop.name, visit:0}.merge!(shop.group_hash(session[:user_id]))
             ret << hash
          end
        end
      end

      ret.uniq!
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
    if sid.to_i == 21834120
      Photo.where({room:sid, hide: nil, user_id: "s21834120"}).sort({od: -1, updated_at: -1}).skip(skip).limit(pcount).to_a
    else
    Photo.where({room:sid, hide: nil}).sort({od: -1, updated_at: -1}).skip(skip).limit(pcount).to_a
    end
  end


end
