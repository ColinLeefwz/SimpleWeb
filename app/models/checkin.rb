class Checkin < ActiveRecord::Base
  include Mongoid::Document
  field :mshop_id, type: Integer
  field :user_id, type: Integer
  field :loc, type:Array
  field :ip
  field :shop_name
  field :cat, type:DateTime
  field :accuracy, type:Float
end
