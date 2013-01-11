# encoding: utf-8
module AdminShopsHelper
  def import_type
    types = []
    File.open('db/mongo/baidu-mapabc-merge/type.txt', 'r') do |f|
      f.each_line{|l| types << l.scan(/[\u4e00-\u9fa5;\/a-zA-Z]+/)}
    end
    types = (types-[[]]).reject{|r| r[0] =~ /^(金融|医疗)/}.unshift(['',''])
  end

  def import_t
    [["活动",0],["酒吧",1],["咖啡",2],["茶馆",3],["餐饮",4],["酒店",5],["休闲娱乐",6],["运动",7],["购物",8],["广场",9],["写字楼",10],["住宅",11],["学校",12],["交通",13]]
  end

  def gchat_img(text)
    if mat = text.match(/\[img:(.*)\]/)
      text = text.sub(mat[1],"<a href=#{Photo.find(mat[1]).img} target='_blank'>#{mat[1]}</a>" )
    end
    text
  end
end
