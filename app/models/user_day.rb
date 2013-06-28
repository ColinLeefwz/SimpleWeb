# encoding: utf-8

class UserDay
  include Mongoid::Document
  field :_id, type: String #日期
  field :umtotal, type: Integer #男性用户总数
  field :uftotal, type: Integer #女性用户总数
  field :wb, type: Integer
  field :qq, type: Integer
  
  def qq_ratio
    return "" if qq.nil? || wb.nil? || qq==0 || wb==0
    "%.1f 倍" %  (qq*1.0/wb)
  end
  

end

