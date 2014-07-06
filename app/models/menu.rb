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
                        "type2": 'url',
                        "sub_button": []
                    },
                    {
                        "type": "view",
                        "name": "视频",
                        "type2": 'mweb',
                        "url": "http://v.qq.com/",
                        "sub_button": []
                    },
                    {
                        "type": "click",
                        "name": "赞一下我们",
                        "type2": 'app',
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
  

  def view_json
    data = self.reload.button
    data.each do |d|
        if d['type']=='click'
            mk = MenuKey.find_by_id(d['key'])
            d['dt'] = mk.type
            d['data'] = mk.content
        end
        d['sub_button'].each do |subd|
            if subd['type']=='click'
                smk = MenuKey.find_by_id(subd['key'])
                subd['dt'] = smk.type
                subd['data'] = smk.content
            end
        end
    end
    {menu:{button: data}}.to_json
  end

  def shop 
    Shop.find_by_id(self.id)
  end 


  
end
