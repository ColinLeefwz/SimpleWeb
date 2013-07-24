class ShopDayTotalStat
  include Mongoid::Document

  field :_id, type: String #日期
  field :cucount, type: Integer #签到券使用量
  field :cdcount, type: Integer #签到券下载量
  field :ctcount, type: Integer #签到优惠数
  field :sucount, type: Integer #分享券使用量
  field :sdcount, type: Integer #分享券下载量
  field :stcount, type: Integer #分享优惠数
  field :cnum, type: Integer #场所签到总人数
  field :cities, type: Array #按地区统计签到人数 例如：{"cities" : {"1558" : 5,"1833" : 1,"1852" : 2,"1853" : 1,...}

end