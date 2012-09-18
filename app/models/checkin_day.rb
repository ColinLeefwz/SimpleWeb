class CheckinDay
  include Mongoid::Document
  field :_id,  type: String
  field :num, type: Integer
  field :od1, type: Integer
  field :od2, type: Integer
  field :od3, type: Integer
  field :shops, type:Array
end
