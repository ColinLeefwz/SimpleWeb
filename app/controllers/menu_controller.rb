class MenuController < ApplicationController
  before_filter :user_login_filter, :only => [:click]
  
  def get
    if params[:id]=="21835409"
      return render :json => {
    "menu"=> {
        "button"=> [
            {
                "type"=> "click",
                "name"=> "今日歌曲",
                "key"=> "V1001_TODAY_MUSIC",
                "sub_button"=> []
            },
            {
                "type"=> "click",
                "name"=> "歌手简介",
                "key"=> "V1001_TODAY_SINGER",
                "sub_button"=> []
            },
            {
                "name"=> "菜单",
                "sub_button"=> [
                    {
                        "type"=> "view",
                        "name"=> "搜索",
                        "url"=> "http=>//www.soso.com/",
                        "sub_button"=> []
                    },
                    {
                        "type"=> "view",
                        "name"=> "视频",
                        "url"=> "http=>//v.qq.com/",
                        "sub_button"=> []
                    },
                    {
                        "type"=> "click",
                        "name"=> "赞一下我们",
                        "key"=> "V1001_GOOD",
                        "sub_button"=> []
                    }
                ]
            }
        ]
    }
}.to_json
    end
    menu = Menu.find_by_id(params[:id])
    return render [].to_json if menu.nil?
    render menu.to_json
  end
  
  def click
    Xmpp.send_gchat2($gfuid,param[:sid],session[:user_id],"收到key：#{params[key]}")
  end
  
  def create
    menu = Menu.new
    menu._id = params[:id].to_i 
    menu.button = JSON.parse(params[:button])
    menu.save
  end
  
  def delete
  end
  
  
end
