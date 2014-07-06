# encoding: utf-8
class CouponDayStat
  include Mongoid::Document
  field :sid, type: Integer
  field :day  
  field :dcount, type: Integer #总下载次数
  field :ucount, type: Integer #总使用次数
  field :data, type:Hash #[{'cid' =>[ "下载次数","使用次数"]}]

  def  shop
    Shop.find_by_id(sid)
  end
end
