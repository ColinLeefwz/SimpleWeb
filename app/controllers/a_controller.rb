class AController < ApplicationController
  
  def index
    c = Channel.new
    c.ip = real_ip
    c.v = params[:v] #1微博来自脸脸，2首次发微博分享, 3照片链接， 4二维码
    c.time = Time.now
    c.agent = request.env["HTTP_USER_AGENT"]
    c.save
    render :file => "~/lianlian/public/mini.html", :use_full_path => true 
  end
  
end
