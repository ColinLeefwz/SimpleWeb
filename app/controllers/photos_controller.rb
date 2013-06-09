# encoding: utf-8
require 'rest_client'

class PhotosController < ApplicationController
  before_filter :user_login_filter, :except => [:show, :detail ]

  def create
    p = Photo.new(params[:photo])
    p.user_id = session[:user_id]
    p.save!
    p.add_to_checkin
    if p.weibo && params[:wbtoken] && $redis.get("wbtoken#{session[:user_id]}").nil?
      $redis.set("wbtoken#{session[:user_id]}", params[:wbtoken])
    end
    if p.qq && params[:qqtoken] && $redis.get("qqtoken#{session[:user_id]}").nil?
      $redis.set("qqtoken#{session[:user_id]}", params[:qqtoken])
    end    
    expire_cache_shop(p.room)
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
  
  def detail
    render :json => Photo.find_by_id(params[:id]).output_hash_with_username.to_json
  end
  
  def delete
    begin
      photo = Photo.find(params[:id])
    rescue
      error_log "\nTry to delete non-exist photo:#{params[:id]}, #{Time.now}"
      render :json => {:deleted => params[:id]}.to_json
      return
    end
    if photo.user_id != session[:user_id]
      render :json => {:error => "photo's owner #{photo.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    sid = photo.room
    if photo.destroy
      expire_cache_shop(sid)
      Rails.cache.delete("UP#{photo.user_id}-5")
      render :json => {ok:photo.id}.to_json
    else
      render :json => {"error" => "delete #{photo.id} failed."}.to_json
    end
  end

  def like
    photo = Photo.find(params[:id])
    $redis.zadd("Like#{photo.id}", Time.now.to_i, session[:user_id])
    if session[:ver].to_f > 1.4
      Resque.enqueue(XmppMsg, 'sphoto',photo.user_id,
        "#{session_user.name} '赞'了你在 #{photo.shop.name} 分享的照片。")
    end
    expire_cache_shop(photo.room)
    render :json => [].to_json
  end
  
  def dislike
    photo = Photo.find(params[:id])
    $redis.zrem("Like#{photo.id}", session[:user_id])
    expire_cache_shop(photo.room)
    #TODO: 删除操作不更新最后updated_at
    render :json => {ok:photo.id}.to_json
  end  
  
  def comment
    photo = Photo.find(params[:id])
    com = {id:session[:user_id], name: session_user.name, txt:params[:text] , t:Time.now}
    ret = photo.push(:com, com)
    if session[:ver].to_f > 1.4
      Resque.enqueue(XmppMsg, 'sphoto',photo.user_id,
        "#{session_user.name}评论了你在#{photo.shop.name}分享的照片。")
    end
    expire_cache_shop(photo.room)
    render :json => com.to_json
  end

  def recomment
    photo = Photo.find(params[:id])
    ru = User.find_by_id(params[:rid])
    com = {id:session[:user_id], name: session_user.name, txt:params[:text] , t:Time.now, rid:ru.id, rname:ru.name}
    ret = photo.push(:com, com)
    expire_cache_shop(photo.room)
    render :json => com.to_json
  end
    
  def delcomment
    photo = Photo.find(params[:id])
    com = photo.com
    photo.com = com.delete_if{|x| x["id"]==session[:user_id] && x["txt"]==params[:text]}
    photo.save!
    expire_cache_shop(photo.room)
    render :json => {ok:photo.id}.to_json
  end
  
  def hidecomment
    photo = Photo.find(params[:id])
    if photo.user_id!=session[:user_id]
      render :json => {"error" => "user #{session[:user_id]} isn't photo's owner."}.to_json
      return
    end
    com = photo.com
    comment = com.find{|x| x["id"].to_s==params[:uid] && x["txt"]==params[:text]}
    if comment.nil?
      render :json => {"error" => "comment #{params[:text]} not found."}.to_json
      return
    end
    comment["hide"] = true
    photo.com = com
    photo.save!
    expire_cache_shop(photo.room)
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
    Photo.where({user_id: uid, "$or" => [ { weibo: true } , { qq: true } ]}).
      sort({updated_at: -1}).skip(skip).limit(pcount).to_a
  end

  
  private 
  def expire_cache_shop(sid)
    Rails.cache.delete("views/SI#{sid}.json")
    Rails.cache.delete("SP#{sid}-5")
  end
  

end