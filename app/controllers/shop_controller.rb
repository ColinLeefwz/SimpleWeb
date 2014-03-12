# coding: utf-8
require 'cgi'

class ShopController < ApplicationController
  before_filter :user_login_filter, :only => [:del_gchat]
  before_filter :user_is_session_user, :only => [:del_gchat]
  

  layout nil
  
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
      shops=shops[1..-1] << shops[0]  if shops[0]["_id"]==$zjkjcyds
    end
    render :json =>  shops.map {|s| s.safe_output_with_users}.to_json
  end
  
  #签到时输入地点名称查找地点
  def add_search
    if params[:sname].nil?
      render :json => [].to_json
      return
    end
    if params[:sname]=="即"
      ids = (21839801..21839814).to_a<<(21839911)
      shops = ids.map {|x| Shop.find_by_id(x)}.find_all{|x| x!=nil}
      render :json => shops.map {|s| {id:s.id,name:s.name, visit:0, distance: ''}.merge!(s.group_hash(session[:user_id])) }.to_json
      return
    end
    if params[:sname]=="素非餐厅" || params[:sname]=="素非"
      render :json => [Shop.find_by_id(21837941)].map {|s| {id:s.id,name:s.name, visit:0, distance: ''}.merge!(s.group_hash(session[:user_id])) }.to_json
      return
    end
    if params[:sname]=="铜梁安居" || params[:sname]=="铜梁安居古镇"
      render :json => [Shop.find_by_id(21838424)].map {|s| {id:s.id,name:s.name, visit:0, distance: ''}.merge!(s.group_hash(session[:user_id])) }.to_json
      return
    end
    if params[:sname][0,2]=="行酷" || params[:sname][-3..-1]=="车友会"
      render :json => [Shop.find_by_id(21838725)].map {|s| {id:s.id,name:s.name, visit:0, distance: ''}.merge!(s.group_hash(session[:user_id])) }.to_json
      return
    end
    if params[:sname]=="微+" || params[:sname]=="微＋" || params[:sname]=="微加"
      render :json => [Shop.find_by_id(21837950)].map {|s| {id:s.id,name:s.name, visit:0,distance: ''}.merge!(s.group_hash(session[:user_id])) }.to_json
      return
    end
    lo = [params[:lat].to_f, params[:lng].to_f]
    lo = Shop.lob_to_lo(lo) if params[:baidu].to_i==1
    gcj_offset = Shop.get_gcj_offset(lo)
    headers[:GCJOFFSET] = gcj_offset.join(",")
    def output(s,lo)
      distance = s.min_distance(s,lo)
      if distance>=1000
        dis = "%.1f公里" % (distance/1000.0)
      else
        dis = "%d0米" % (distance/10)
      end
      {id:s.id,name:s.name, visit:0, distance:dis, "lat"=>s.loc_first[0], "lng"=>s.loc_first[1] }
    end
    if params[:sname][0,3]=="@@@" #测试人员输入商家id模拟签到
      shop = Shop.find_by_id(params[:sname][3..-1])  
      if shop && (session[:user_id].to_s == shop.seller_id.to_s || is_kx_user?(session[:user_id]) || User.is_fake_user?(session[:user_id]) )
         render :json => [shop].map {|s| output(s,lo).merge!(s.group_hash(session[:user_id])) }.to_json
        return
      end
    end
    if params[:sname].length==1
      shops = Shop.where2({lo:{"$within" => {"$center" => [lo,0.01]}}, name:/#{params[:sname]}/, del:{"$exists" => false}}, {limit:10})
      render :json =>  shops.map {|s| output(s,lo).merge!(s.group_hash(session[:user_id])) }.to_json
    else
      ret = []
      # TODO: 默认搜索同城， 国外搜国家
      if params[:sname].length>=4
        city = Shop.get_city(lo)
        shop1s = Shop.where2({city: city, name:/#{params[:sname]}/, del:{"$exists" => false}},{limit:10})
      else
        shop1s = Shop.where2({lo:{"$within" => {"$center" => [lo,0.1]}}, name:/#{params[:sname]}/, del:{"$exists" => false}},{limit:10}) 
      end
      shop1s.each do |s| 
        hash = output(s,lo).merge!(s.group_hash(session[:user_id]))
        distance = s.min_distance(s,lo)
        if distance>3000 && !s.group_id && s.id != 21834120 && !is_kx_user?(session[:user_id]) && !is_co_user?(session[:user_id])
          hash.merge!( {visit:1} )
        else
          hash.merge!( {visit:0} )
        end
        ret << hash
      end
      #商家查询个数小于10， 按群组的相似度查询群组
      if ret.size < 10
        ids = $redis.zrange("GSN", 0, -1, withscores: true).select{|gs|  Shop.str_similar(params[:sname], gs[0]) >= (0.6+ret.size*0.04)}.map{|m| m[1]}
        ids.each do |id|
          shop = Shop.find_by_id(id)
          hash = output(shop,lo).merge!(shop.group_hash(session[:user_id]))
          ret << hash
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


  def save_gchat
    if params[:txt].nil? || params[:txt]=="0" || params[:txt][0,3]=="@@@" || params[:txt] =~ /^0\d$/
      render :text => '0'
      return
    end
    gchat = Gchat.new(sid: params[:sid], uid: params[:uid], mid: params[:mid], txt: params[:txt])
    if gchat.save
      render :text => '1'
    else
      render :text => '0'
    end
  end
  
  def del_gchat
    shop = Shop.find_by_id(params[:sid])
    unless shop.shop_or_staff?(params[:user_id])
      render :json => {:error => "无权限"}.to_json 
    end
    gchat = Gchat.where(mid:params[:id]).first
    if gchat.nil?
      Xmpp.error_notify("删除不存在的聊天室消息：#{shop.name} #{params[:sid]}")
      render :text => '1'
    end
    if gchat.sid.to_s != params[:sid] || gchat.uid.to_s != params[:user_id]
      render :json => {:error => "无法删除该记录"}.to_json
    end
    if gchat.delete
      render :text => '1'
    else
      render :text => '0'
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

  def user6s
    shop = Shop.find_by_id(params[:id])
    users = shop.view_user6s(session[:user_id])
    if params[:total].to_i==1
      hash = {total:shop.total_user, users:users}
      render :json => hash.to_json
    else
      render :json => users.to_json
    end
  end
  
  def basic
    shop = Shop.find_by_id(params[:id])
    data = shop.safe_output
    render :json => data.to_json
  end
    
  def info
    shop = Shop.find_by_id(params[:id])
    render :json => shop.safe_output_with_staffs.to_json
  end
  
  def history
    skip = params[:skip].to_i
    pcount = params[:pcount].to_i
    pcount = 10 if pcount==0
    arr = Gchat.history_skip(params[:id], skip, pcount)
    render :json => arr.map{|x| [x.uid,x.txt,x.cati,x.mid]}.to_json
  end

  
  def photos
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 5 if pcount==0
    skip = (page-1)*pcount
    photos = PhotoCache.new.shop_photo_cache(params[:id], skip, pcount)
    if page <=1
      shop = Shop.find_by_id(params[:id])
      photos = shop.preset_p(photos)
    end
    render :json => photos.map {|p| p.output_hash_with_username }.to_json
  end
  

end
