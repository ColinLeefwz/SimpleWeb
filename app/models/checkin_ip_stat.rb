class CheckinIpStat
  include Mongoid::Document
  field :_id, type: String
  field :shops, type:Array
  field :stotal, type: Integer
  field :ctotal, type: Integer
  field :data, type: Array
  
end

