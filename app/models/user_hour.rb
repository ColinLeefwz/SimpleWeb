# encoding: utf-8

class UserHour
  include Mongoid::Document
  field :_id, type: String #日期
  field :umtotal, type: Integer #男性用户总数
  field :uftotal, type: Integer #女性用户总数
  field :wb, type: Integer
  field :qq, type: Integer
  
end