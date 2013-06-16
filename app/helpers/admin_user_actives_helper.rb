# encoding: utf-8
module AdminUserActivesHelper

  def show_aut(time)
    year,month, week = time.split("-").map{|m| m.to_i}
    str = "#{year}年"
    str += "#{month}月" if month
    str += "第#{week}周" if week
    str 
  end
end
