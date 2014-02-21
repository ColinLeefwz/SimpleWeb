# encoding: utf-8
require 'rest_client'

class PhotosController < ApplicationController
  before_filter :user_login_filter, :except => [:show, :detail, :callback ]
  before_filter :forbid_user_filter, :except => [:show, :detail, :callback ]
  
  def forbid_user_filter
    if session_user.forbidden?
      clear_session_info
      render :json => {:error => "not login"}.to_json
    end
  end
  
  def uptoken
    token = Photo.uptoken(params[:user_id])
    render :json => {token:token }.to_json
  end
  
  def callback
    #{"from"=>"5198febcc90d8bd138000338", "room"=>"20314866", "id"=>"5198febcc90d8bd138000338/1392964949-2", "key"=>"Fnyr8lxbaqgkjyObS2-EdtaK8kT9", "size"=>"60866", "controller"=>"photos", "action"=>"callback"}
    if params[:id][0,25]==params[:from]+"/"
      user = User.find_by_id(params[:from])
      room = params[:room]
      time,total = params[:id][25..-1].split("-").map{|x| x.to_i}
      photo = Photo.where({user_id:user.id, room:room, time:time, total:total]}).first
      unless photo
        Xmpp.error_notify("多图上传，七牛先上传完成：#{user.name},#{Shop.find_by_id(room).name}")
      end
    else
      Xmpp.error_notify("图片上传七牛回调出错：#{request.params}")
    end
    if params[:size].to_i > 99999
      Xmpp.error_notify("图片上传七牛文件过大：#{request.params}")
    end
    render :json => request.params.to_json
  end

  def create
    p = Photo.new(params[:photo])
    p.user_id = session[:user_id]
    ft1 = params[:filter1].to_i
    p.ft1 = ft1 if ft1 != 0
    ft2 = params[:filter2].to_i
    p.ft2 = ft2 if ft2 != 0
    total = params[:total].to_i
    p.total = total if total > 1
    time = params[:time].to_i
    p.time = time if time != 0
    p.save!
    p.zwyd_pre_notice
    p.nyd_pre_notice
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
      
      if id =~ /^zwyd/
        id = id.sub('zwyd','')
        if params[:size].to_i==0
          return redirect_to Photo.img_url(id)
        else
          return redirect_to Photo.img_url(id,:t2)
        end
      elsif id =~ /^nyd/
        id = id.sub('nyd','')
        if params[:size].to_i==0
          return redirect_to Photo.img_url(id)
        else
          return redirect_to Photo.img_url(id,:t2)
        end
      elsif id =~ /^new_year/
        return redirect_to "http://oss.aliyuncs.com/dface/52be6bb220f318fdfe00001c/0.jpg"
      end
      
      if params[:size].to_i==0
        redirect_to ShopFaq.img_url(id)
      else
        redirect_to ShopFaq.img_url(id,:t2)
      end  
    elsif params[:id] =~ /^zwyd/
      id = params[:id].sub('zwyd','')
      if params[:size].to_i==0
        redirect_to Photo.img_url(id)
      else
        redirect_to Photo.img_url(id,:t2)
      end
    elsif params[:id] =~ /^nyd/
      id = params[:id].sub('nyd','')
      if params[:size].to_i==0
        redirect_to Photo.img_url(id)
      else
        redirect_to Photo.img_url(id,:t2)
      end
    elsif params[:id] =~ /^new_year/
      redirect_to "http://oss.aliyuncs.com/dface/52be6bb220f318fdfe00001c/0.jpg"
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
    if Photo.delete(photo)
      expire_cache_shop(sid, photo.user_id)
      render :json => {ok:photo.id}.to_json
    else
      render :json => {"error" => "delete #{photo.id} failed."}.to_json
    end
  end

  def like
    photo = Photo.find(params[:id])
    flag = $redis.zadd("Like#{photo.id}", Time.now.to_i, session[:user_id])
    if flag && session[:user_id] != photo.user_id
      Rails.cache.fetch("Like#{photo.id}#{session[:user_id]}") do
        Resque.enqueue(XmppMsg,  session[:user_id], photo.user_id,
          "#{photo.total_str}'赞'了你的照片",
          "COMMENT#{photo.id},#{Time.now.to_i}", " NOLOG='1' NOPUSH='1' ")
        Resque.enqueue(PushMsg, photo.user.tk, "",
             "#{session_user.name}赞了你的照片，快去看看吧",photo.user_id) if photo.user.tk
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
    if session[:user_id] != photo.user_id
      Resque.enqueue(XmppMsg,  session[:user_id], photo.user_id,
        "#{photo.total_str}#{params[:text]}",
        "COMMENT#{photo.id},#{Time.now.to_i}", " NOLOG='1' NOPUSH='1' ")
      Resque.enqueue(PushMsg, photo.user.tk, "",
         "#{session_user.name}评论了你的照片，快去看看吧",photo.user_id) if photo.user.tk
    end
    #comment_send_to_room(photo,com)
    expire_cache_shop(photo.room, photo.user_id)
    render :json => com.to_json
  end

  def recomment
    photo = Photo.find(params[:id])
    ru = User.find_by_id(params[:rid])
    com = {id:session[:user_id], name: session_user.name, txt:params[:text] , t:Time.now, rid:ru.id, rname:ru.name}
    ret = photo.push(:com, com)
    photo.set(:updated_at, Time.now)
    if session[:user_id] != ru.id
      Resque.enqueue(XmppMsg,  session[:user_id], ru.id,
        "#{photo.total_str}#{params[:text]}",
        "COMMENT#{photo.id},#{Time.now.to_i}", " NOLOG='1' NOPUSH='1' ")
      Resque.enqueue(PushMsg, ru.tk, "",
           "#{session_user.name}回复了你的照片评论，快去看看吧",ru.id) if ru.tk
    end
    #comment_send_to_room(photo,com)
    expire_cache_shop(photo.room, photo.user_id)
    render :json => com.to_json
  end
  
  #mnesia:transaction(fun() -> Rs = mnesia:wread({offline_msg, {"502e6303421aa918ba000001", "dface.cn"} }) end).

    
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
    u = User.find_by_id(params[:uid])
    stranger = u.stranger?(session[:user_id])
    if u.invisible==2 && stranger
      return render :json => [].to_json
    end
    if skip>6 && stranger
      return render :json => {:error => "非对方的朋友只显示最多5张照片"}.to_json
    end
    photos = PhotoCache.new.user_photo_cache(params[:uid], skip, pcount)
    render :json => photos.map {|p| p.output_hash_with_shopname }.to_json
  end

  
  private 
  def expire_cache_shop(sid,uid=nil)
    Rails.cache.delete("SP#{sid}-5")
    Rails.cache.delete("UP#{uid}-5") if uid 
  end
  
  def comment_send_to_room(photo,com)
    if params[:sid] && params[:sid]==photo.room && photo.total.nil?
      Resque.enqueue(XmppRoomMsg2, params[:sid], session[:user_id], "[img:#{photo.id}]#{photo.com.size}:#{com[:txt]}", "COMMENT#{com[:id]}#{Time.now.to_i}", 1)
    end
  end
  

end