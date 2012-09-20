class CheckinShopStat
  include Mongoid::Document
  field :_id, type: Integer
  field :users, type:Array
  field :ips, type:Array
end

