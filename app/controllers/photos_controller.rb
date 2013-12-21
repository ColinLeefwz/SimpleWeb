# encoding: utf-8
require 'rest_client'

class PhotosController < ApplicationController
  before_filter :user_login_filter, :except => [:show, :detail ]

  def create
    p = Photo.new(params[:photo])
    p.user_id = session[:user_id]
    ft1 = params[:filter1].to_i
    p.ft1 = ft1 if ft1 != 0
    ft2 = params[:filter2].to_i
    p.ft2 = ft2 if ft2 != 0
    p.save!
    p.add_to_checkin
    if p.weibo && params[:wbtoken] && $redis.get("wbtoken#{session[:user_id]}").nil?
      $redis.set("wbtoken#{session[:user_id]}", params[:wbtoken])
    end
    if p.qq && params[:qqtoken] && $redis.get("qqtoken#{session[:user_id]}").nil?
      $redis.set("qqtoken#{session[:user_id]}", params[:qqtoken])
    end
    expire_cache_shop(p.room, p.user_id)
    render :json => p.output_hash_with_username.to_json
  end
  
  def show
    if params[:id] =~ /^faq/
      id = params[:id].sub('faq','')
      if params[:size].to_i==0
        redirect_to ShopFaq.img_url(id)
      else
        redirect_to ShopFaq.img_url(id,:t2)
      end      
    else
      if params[:size].to_i==0
        redirect_to Photo.img_url(params[:id])
      else
        redirect_to Photo.img_url(params[:id],:t2)
      end
    end
  end
  
  def re_share
    share = PhotoShare.new
    share.pid = params[:photo_id]
    share.uid = params[:user_id]
    share.weibo = true if params[:weibo]=='1'
    share.qq = true if params[:qq]=='1'
    share.wx = params[:wx] unless params[:wx].blank?
    share.save!
    render :json => {ok:1}.to_json
  end
  
  def detail
    render :json => Photo.find_by_id(params[:id]).output_hash_with_username.to_json
  end
  
  def delete
    begin
      photo = Photo.find(params[:id])
    rescue
      Xmpp.error_notify("#{session_user.name}:试图删除不存在的照片墙图片:#{params[:id]}")
      render :json => {:deleted => params[:id]}.to_json
      return
    end
    if photo.user_id != session[:user_id]
      render :json => {:error => "photo's owner #{photo.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    sid = photo.room
    if photo.destroy
      expire_cache_shop(sid, photo.user_id)
      render :json => {ok:photo.id}.to_json
    else
      render :json => {"error" => "delete #{photo.id} failed."}.to_json
    end
  end

  def like
    photo = Photo.find(params[:id])
    flag = $redis.zadd("Like#{photo.id}", Time.now.to_i, session[:user_id])
    if flag && UserDevice.user_ver_redis(photo.user_id).to_f>=2.3
      Rails.cache.fetch("Like#{photo.id}#{session[:user_id]}") do
        Resque.enqueue(XmppMsg,  session[:user_id], photo.user_id,
          "'赞'了你的照片",
          "COMMENT#{photo.id},#{Time.now.to_i}", " NOLOG='1' NOPUSH='1' ")
      end
    end
    #expire_cache_shop(photo.room, photo.user_id)
    render :json => {id:session[:user_id], name: session_user.name, t:Time.now}.to_json
  end
  
  def dislike
    photo = Photo.find(params[:id])
    $redis.zrem("Like#{photo.id}", session[:user_id])
    #expire_cache_shop(photo.room)
    render :json => {ok:photo.id}.to_json
  end  
  
  def comment
    photo = Photo.find(params[:id])
    com = {id:session[:user_id], name: session_user.name, txt:params[:text] , t:Time.now}
    ret = photo.push(:com, com)
    photo.set(:updated_at, Time.now)
    if UserDevice.user_ver_redis(photo.user_id).to_f>=2.3 && session[:user_id] != photo.user_id
      Resque.enqueue(XmppMsg,  session[:user_id], photo.user_id,
        params[:text],
        "COMMENT#{photo.id},#{Time.now.to_i}", " NOLOG='1' NOPUSH='1' ")
    end
    comment_send_to_room(photo,com)
    expire_cache_shop(photo.room, photo.user_id)
    render :json => com.to_json
  end

  def recomment
    photo = Photo.find(params[:id])
    ru = User.find_by_id(params[:rid])
    com = {id:session[:user_id], name: session_user.name, txt:params[:text] , t:Time.now, rid:ru.id, rname:ru.name}
    ret = photo.push(:com, com)
    photo.set(:updated_at, Time.now)
    if UserDevice.user_ver_redis(ru.id).to_f>=2.3 && session[:user_id] != ru.id
      Resque.enqueue(XmppMsg,  session[:user_id], ru.id,
        params[:text],
        "COMMENT#{photo.id},#{Time.now.to_i}", " NOLOG='1' NOPUSH='1' ")
    end
    comment_send_to_room(photo,com)
    expire_cache_shop(photo.room, photo.user_id)
    render :json => com.to_json
  end
    
  def delcomment
    photo = Photo.find(params[:id])
    com = photo.com.delete_if{|x| x["id"]==session[:user_id] && x["txt"]==params[:text]}
    photo.set(:com, com)
    expire_cache_shop(photo.room, photo.user_id)
    render :json => {ok:photo.id}.to_json
  end
  
  def hidecomment
    photo = Photo.find(params[:id])
    if photo.user_id!=session[:user_id]
      render :json => {"error" => "user #{session[:user_id]} isn't photo's owner."}.to_json
      return
    end
    res = photo.hidecom(params[:uid], params[:text])
    return render :json => {"error" => res}.to_json if res
    expire_cache_shop(photo.room, photo.user_id)
    render :json => {ok:photo.id}.to_json
  end
  
  def me
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 5 if pcount==0
    skip = (page-1)*pcount
    photos = Photo.where({user_id: session[:user_id]}).sort({updated_at: -1}).skip(skip).limit(pcount)
    render :json => photos.map {|p| p.output_hash_with_shopname }.to_json
  end
  
  def my_comments
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 5 if pcount==0
    skip = (page-1)*pcount
    photos = Photo.where({"com.id" => session[:user_id]}).sort({updated_at: -1}).skip(skip).limit(pcount)
    render :json => photos.map {|p| p.output_hash_with_shopname }.to_json
  end
  
  def users
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 5 if pcount==0
    skip = (page-1)*pcount
    photos = user_photo_cache(params[:uid], skip, pcount)
    render :json => photos.map {|p| p.output_hash_with_shopname }.to_json
  end
  
  def user_photo_cache_key(uid,skip,pcount)
    "UP#{uid}-#{pcount}"
  end
  
  def user_photo_cache(uid,skip,pcount)
    if skip>0
      return user_photo_no_cache(uid,skip,pcount)
    end
    Rails.cache.fetch(user_photo_cache_key(uid,skip,pcount)) do
      user_photo_no_cache(uid,skip,pcount)
    end
  end
  
  def user_photo_no_cache(uid,skip,pcount)
    arr = $redis.smembers("UnBroadcast")
    Photo.where({user_id: uid, "$or" => [ { weibo: true } , { qq: true } ], room:{"$nin" => arr} }).
      sort({updated_at: -1}).skip(skip).limit(pcount).to_a
  end

  
  private 
  def expire_cache_shop(sid,uid=nil)
    Rails.cache.delete("views/SI#{sid}.json")
    Rails.cache.delete("SP#{sid}-5")
    Rails.cache.delete("UP#{uid}-5") if uid 
  end
  
  def comment_send_to_room(photo,com)
    if params[:sid] && params[:sid]==photo.room
      Resque.enqueue(XmppRoomMsg2, params[:sid], session[:user_id], "[img:#{photo.id}]#{photo.com.size}:#{com[:txt]}", "COMMENT#{com[:id]}#{Time.now.to_i}", 1)
    end
  end
  

end