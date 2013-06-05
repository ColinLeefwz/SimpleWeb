# coding: utf-8
# 旅行线路，以后也可以用作火车线路等
class Line
  include Mongoid::Document
  field :name #线路名称
  field :admin_sid, type:Integer #所属旅行社
  field :arr, type:Array #线路 [ { time:相对时间，lo:经纬度, sid:地点id } ]
  
end

