class UserDay
  include Mongoid::Document
  field :_id, type: String #日期
  field :umtotal, type: Integer #男性用户总数
  field :uftotal, type: Integer #女性用户总数

  

end

