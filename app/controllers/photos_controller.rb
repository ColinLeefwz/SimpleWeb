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
    photo = Photo.find(params[:id])
    if params[:size].to_i==0
      redirect_to photo.img.url
    else
      redirect_to photo.img.url(:t2)
    end
  end

  def like
    photo = Photo.find(params[:id])
    if photo.like && photo.like.find{|x| x["id"]==session[:user_id]}
      render :json => {"error" => "already liked photo #{photo.id}"}.to_json
      return
    end
    ret = photo.push(:like, {id:session[:user_id], t:Time.now})
    render :json => ret.to_json
  end
  
  def dislike
    photo = Photo.find(params[:id])
    like = photo.like
    uk = like.find{|x| x["id"]==session[:user_id]}
    uk["del"] = true
    photo.like=like
    photo.save!
    render :json => {ok:photo.id}.to_json
  end  
  

end