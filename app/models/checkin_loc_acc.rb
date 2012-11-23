class CheckinLocAcc
  include Mongoid::Document
  field :_id, type: String
  field :max, type: Integer #最大误差
  field :min, type: Integer #最小误差
  field :avg, type: Float  #误差平均值
  field :fc,  type: Float #方差

end

