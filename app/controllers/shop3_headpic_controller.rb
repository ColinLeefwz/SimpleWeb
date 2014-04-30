# coding: utf-8

class Shop3HeadpicController < ApplicationController
  layout "shop3"

  def index
    @headpics = Headpic.where(sid: session[:shop_id])
  end 


  def create
    @headpic = Headpic.new(sid: session[:shop_id], img: params[:img])
    path =  params[:path]
    crop(path)
    @headpic.img = File.open("public" + path)
    if @headpic.save
      render :json => {url: @headpic.img_url}
    else
      render :json => 0
    end
  end

  def update
    @headpic = Headpic.find_by_id(params[:id])
    path =  params[:path]
    crop(path)
    @headpic.img = File.open("public" + path)
    if @headpic.save
      render :json => {url: @headpic.img_url}
    else
      render :json => 0
    end
  end

  def delete
    @headpic = Headpic.find_by_id(params[:id])
    @headpic.delete 
    render :json => 1
  end 


  private
  def crop(path)
    img = MiniMagick::Image.open("public" + path)
    sc = img['width'].to_f/400
    img.crop "#{(params[:w].to_i*sc).to_i}x#{(params[:h].to_i*sc).to_i}+#{(params[:x].to_i*sc).to_i}+#{(params[:y].to_i*sc).to_i}"
    img.write("public" + path)
  end


end
