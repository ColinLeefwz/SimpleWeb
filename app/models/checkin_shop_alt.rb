class CheckinShopAlt
  include Mongoid::Document
  field :_id, type: String
  field :datas, type: Hash #{_id => 商家id,max => [alt最大值,alt最大值时的altacc],min => [alt最小值,alt最小时的altacc],avgalt => alt平均值,avgaltacc => altacc平均值, fcalt => alt方差 ,fcaltacc => altacc方差}

end

