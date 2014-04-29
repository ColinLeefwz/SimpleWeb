# coding: utf-8
class CropPhotoController < ApplicationController

  def upload
    path = tmp_path
    FileUtils.mv(params[:photo].tempfile.path, path)
    render :text =>  path.gsub(/^public/, '')
  end

  def crop
    path =  params[:path]
    img = MiniMagick::Image.open("public" + path)
    sc = img['width'].to_f/400
    img.crop "#{(params[:w].to_i*sc).to_i}x#{(params[:h].to_i*sc).to_i}+#{(params[:x].to_i*sc).to_i}+#{(params[:y].to_i*sc).to_i}"
    img.write("public" + path)
    render :json => {url: path}
  end
  
  private
  
  def tmp_path
  	path = URI.parse(request.referer).path
	dir = "public/uploads/tmp/"
	FileUtils.mkdir_p(dir)
	case path
	when "/shop3_headpic"
		dir + "#{Time.now.to_i}headpic#{rand(99)}.jpg"
	else
		dir + "#{Time.now.to_i}coupon#{rand(99)}.jpg"
	end
  end
    
end
