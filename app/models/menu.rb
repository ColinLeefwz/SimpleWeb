# coding: utf-8

=begin
{
    "menu": {
        "button": [
            {
                "type": "click",
                "name": "今日歌曲",
                "key": "V1001_TODAY_MUSIC",
                "sub_button": []
            },
            {
                "type": "click",
                "name": "歌手简介",
                "key": "V1001_TODAY_SINGER",
                "sub_button": []
            },
            {
                "name": "菜单",
                "sub_button": [
                    {
                        "type": "view",
                        "name": "搜索",
                        "url": "http://www.soso.com/",
                        "sub_button": []
                    },
                    {
                        "type": "view",
                        "name": "视频",
                        "url": "http://v.qq.com/",
                        "sub_button": []
                    },
                    {
                        "type": "click",
                        "name": "赞一下我们",
                        "key": "V1001_GOOD",
                        "sub_button": []
                    }
                ]
            }
        ]
    }
}
=end

class Menu
  include Mongoid::Document
  field :_id, type: Integer #商家ID
  field :button, type: Array #一级菜单，最多三个，包含name/type/url/key/sub_button等字段
  field :halt, type:Boolean #是否停用
  
  def to_json
    {menu:{button: self.button}}.to_json
  end
  
  
end
