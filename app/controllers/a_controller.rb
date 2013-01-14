class AController < ApplicationController
  
  def index
    c = Channel.new
    c.ip = real_ip
    c.v = params[:v]
    c.time = Time.now
    c.agent = request.env["HTTP_USER_AGENT"]
    c.save
    if c.agent.match(/iphone|ipad/i)
      redirect_to "https://itunes.apple.com/cn/app/lian-lian-xian-chang-she-jiao/id577710538?mt=8"
    else
      redirect_to "/"
    end
  end
  
end
