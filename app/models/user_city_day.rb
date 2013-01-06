class UserCityDay
  include Mongoid::Document
  field :_id, type: String #日期
  field :datas, type:Hash

end

