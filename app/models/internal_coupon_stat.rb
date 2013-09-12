# coding: utf-8

#内部地点优惠券每日统计
class InternalCouponStat
  include Mongoid::Document
  field :day
  field :sid, type: Integer #大地点id或总店
  field :data, type: Hash #{内部地点id => {'优惠券id' => [下载次数， 使用次数]} }
  field :cdown, type: Integer
  field :udown, type: Integer








end
