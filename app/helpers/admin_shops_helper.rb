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
      return text if Photo.find_by_id(mat[1]).nil?
      text = text.sub(mat[1],"<a href=#{Photo.find(mat[1]).img} target='_blank'>#{mat[1]}</a><img src='#{Photo.find(mat[1]).img.url(:t2)}' />" )
    end
    text
  end

  def gchat_img2(text)
    if mat = text.match(/(\[img:(.*)\])/)
      return text if Photo.find_by_id(mat[2]).nil?
      text = text.sub(mat[1],"<a href=#{Photo.find(mat[2]).img} target='_blank'><img src='#{Photo.find(mat[2]).img.url(:t2)}' /></a>" )
    end
    text
  end

  def type_or_user(shop)
    if shop.creator
      user = User.find_by_id(shop.creator)
      if user.nil?
        shop.type
      else
        link_to(user.name, "/admin_users/show?id=#{user.id}")
      end
    else
      shop.type
    end
  end

  def edit_lo(loc)
    return ""  if loc.nil?

    if loc.first.is_a?(Array)
      loc.inject("") do |f, lo|
        f + %Q(<input type="checkbox" value="#{lo.join(',')}" name="shop[lo][]" checked="checked">#{lo.join(',')}<br/>)
      end
    else
      %Q(<input type="checkbox" value="#{loc.join(',')}" name="shop[lo][]" checked="checked">#{loc.join(',')}<br/>)
    end
  end

  def thand(shop)
    return "标记删除" if shop.del
    return "审核通过" if shop.t
    return "忽略" if shop.i
  end

end
