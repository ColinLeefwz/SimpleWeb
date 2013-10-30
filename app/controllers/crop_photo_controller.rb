# coding: utf-8
class CropPhotoController < ApplicationController

  def crop
    path = params[:photo].tempfile.path
    img = MiniMagick::Image.open(path)
    sc = img['width'].to_f/400
    img.crop "#{(params[:w].to_i*sc).to_i}x#{(params[:h].to_i*sc).to_i}+#{(params[:x].to_i*sc).to_i}+#{(params[:y].to_i*sc).to_i}"
    rpath = "/uploads/tmp/#{Time.now.strftime("%y%m%d%H%M%S")}coupon#{rand(99)}.jpg"
    img.write("public" + rpath)
    render :json => {url: rpath}
  end
    
end
