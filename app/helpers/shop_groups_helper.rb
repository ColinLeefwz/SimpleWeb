# coding: utf-8
module ShopGroupsHelper
  def group_show_users(users, link=true)
    str =""
    users.each do|u|
      str += "#{u['name']},#{u['phone']},#{u['sfz']}"
      if link
        str += ",<a href='/shop_checkins/user?uid=#{u['id']}' style='color: #0B99D7'>#{u['id']}</a>" if u['id']
        str += "<br/>"
      else
        str += ",#{u['id']}"  if u['id']
        str += "\r\n"
      end
    end
    str
  end
end
