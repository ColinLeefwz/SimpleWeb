# encoding: utf-8
require 'rest_client'

class PhotosController < ApplicationController
  before_filter :user_login_filter

  def create
    p = Photo.new(params[:photo])
    p.user_id = session[:user_id]
    p.save!
    p.add_to_checkin
    render :json => p.output_hash.to_json
  end
  
  def show
    if params[:id] =~ /^faq/
      photo = ShopFaq.find(params[:id].sub('faq',''))
    else
      photo = Photo.find(params[:id])
    end
    
    if params[:size].to_i==0
      redirect_to photo.img.url
    else
      redirect_to photo.img.url(:t2)
    end
  end
  
  def delete
    photo = Photo.find(params[:id])
    if photo.user_id != session[:user_id]
      render :json => {:error => "photo's owner #{photo.user_id} != session user #{session[:user_id]}"}.to_json
      return
    end
    if photo.destory
      render :json => {ok:photo.id}.to_json
    else
      render :json => {"error" => "delete #{photo.id} failed."}.to_json
    end
  end

  def like
    photo = Photo.find(params[:id])
    if photo.like && photo.like.find{|x| x["id"]==session[:user_id]}
      render :json => {"error" => "already liked photo #{photo.id}"}.to_json
      return
    end
    ret = photo.push(:like, {id:session[:user_id], name: session_user.name, t:Time.now})
    #TODO: ver判断，大于1.4.1的才发送xmpp提醒
    if session[:ver].to_f > 1.4
      Resque.enqueue(XmppMsg, 'sphoto',photo.user_id,
      "#{session_user.name}赞了你在#{photo.shop.name}分享的照片。")
    end
    render :json => ret.to_json
  end
  
  def dislike
    photo = Photo.find(params[:id])
    like = photo.like
    photo.like = like.delete_if{|x| x["id"]==session[:user_id]}
    photo.save!
    #TODO: 删除操作不更新最后updated_at
    render :json => {ok:photo.id}.to_json
  end  
  
  def comment
    photo = Photo.find(params[:id])
    ret = photo.push(:com, {id:session[:user_id], name: session_user.name, txt:params[:text] , t:Time.now})
    if session[:ver].to_f > 1.4
      Resque.enqueue(XmppMsg, 'sphoto',photo.user_id,
      "#{session_user.name}评论了你在#{photo.shop.name}分享的照片。")
    end
    render :json => ret.to_json
  end

  def recomment
    photo = Photo.find(params[:id])
    ru = User.find_by_id(params[:rid])
    ret = photo.push(:com, {id:session[:user_id], name: session_user.name, txt:params[:text] , t:Time.now, rid:ru.id, rname:ru.name})
    render :json => ret.to_json
  end
    
  def delcomment
    photo = Photo.find(params[:id])
    com = photo.com
    photo.com = com.delete_if{|x| x["id"]==session[:user_id] && x["txt"]==params[:text]}
    photo.save!
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
    render :json => {ok:photo.id}.to_json
  end
  
  def users
    page = params[:page].to_i
    pcount = params[:pcount].to_i
    page = 1 if page==0
    pcount = 20 if pcount==0
    skip = (page-1)*pcount
    photos = Photo.where({user_id: session[:user_id]}).sort({updated_at: -1}).skip(skip).limit(pcount)
    render :json => photos.map {|p| p.output_hash }.to_json
  end
  

end