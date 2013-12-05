# coding: utf-8
class WeixinController < ApplicationController
  def index
    return render :text => params['echostr']  if params[:xml].blank?
    case params[:xml][:MsgType]
    when "text"
      @text = params[:xml][:Content]
      @picurls = []

      sid = params["sid"]
      shop = Shop.find_by_id(sid)
      text_weixin = shop.weixin_answer_text(@text)

      if text_weixin
        if text_weixin.class == MobileArticle
          @picurls << {"title" => "#{text_weixin.title}" , "description" => text_weixin.text, "picurl" => text_weixin.img.url(:t2), "url" => "http://shop.dface.cn/mobile_articles/show?id=#{text_weixin.id}&sid=#{text_weixin.sid}" }
        end
        return render "picurl", :formats => :xml
      else
        # return render "text", :formats => :xml
      end

      # if @text =~ /音乐/
      #   return render "music", :formats => :xml
      # else
      #   return render "picurl", :formats => :xml
      # end
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
