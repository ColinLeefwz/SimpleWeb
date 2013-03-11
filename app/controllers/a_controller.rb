class AController < ApplicationController
  
  def index
    c = Channel.new
    c.ip = real_ip
    c.v = params[:v] #1微博来自脸脸，2首次发微博分享, 3照片链接， 4二维码
    c.time = Time.now
    c.agent = request.env["HTTP_USER_AGENT"]
    c.save
    if c.agent.match(/iphone|ipad/i)
      redirect_to "http://itunes.apple.com/app/id577710538?ls=1&mt=8"
    else
      redirect_to "/"
    end
  end
  
end
