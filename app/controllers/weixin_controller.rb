class WeixinController < ApplicationController
  def index
    return render :text => params['echostr']  if params[:xml].blank?
    case params[:xml][:MsgType]
    when "text"
      @text = params[:xml][:Content]
      return render "text", :formats => :xml
    when "location"
      lo = [params[:xml][:Location_X].to_f,params[:xml][:Location_Y].to_f]
      @text = Shop.where({lo:{"$near" =>lo}}).limit(5).only(:name).map{|m| m.name}.join("\n")
      return render "text", :formats => :xml
    when 'image'
      @picurls = []
      photo = Photo.last
      @picurls << {"title" => "#{photo.user.name}发布" , "description" => photo.desc, "picurl" => photo.img.url(:t2), "url" => photo.img.url }
      return  render "picurl", :formats => :xml
    when "link"
      @text = "脸脸官网: http://dface.cn"
      render "text", :formats => :xml
    end
  end
end
