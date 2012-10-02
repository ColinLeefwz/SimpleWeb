# encoding: utf-8
require 'rest_client'

class PhotosController < ApplicationController
  before_filter :user_login_filter

  def create
    p = Photo.new(params[:photo])
    p.user_id = session[:user_id]
    p.save!
    if p.weibo
      Resque.enqueue(WeiboPhoto, session[:user_token], "在#{p.shop.name}分享：", p.img.url)
    end
    render :json => p.output_hash.to_json
  end
  
  def show
    photo = Photo.find(params[:id])
    if params[:size].to_i==0
      redirect_to photo.img.url
    elsif params[:size].to_i==2
      redirect_to photo.img.url(:t2)
    else
      redirect_to photo.img.url(:t1)
    end
  end

end