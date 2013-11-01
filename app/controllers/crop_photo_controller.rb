# coding: utf-8
class CropPhotoController < ApplicationController

  def upload
    path = "/uploads/tmp/#{Time.now.strftime("%y%m%d%H%M%S")}coupon#{rand(99)}.jpg"
    FileUtils.mv(params[:photo].tempfile.path, "public"+ path)
    render :text =>  path
  end

  def crop
    path =  params[:path]
    img = MiniMagick::Image.open("public" + path)
    sc = img['width'].to_f/400
    img.crop "#{(params[:w].to_i*sc).to_i}x#{(params[:h].to_i*sc).to_i}+#{(params[:x].to_i*sc).to_i}+#{(params[:y].to_i*sc).to_i}"
    img.write("public" + path)
    render :json => {url: path+"?time=#{Time.now}"}
  end
    
end
