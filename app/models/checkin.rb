class Checkin < ActiveRecord::Base
  include Mongoid::Document
  field :mshop_id, type: Integer
  field :user_id, type: Integer
  field :loc, type:Array
  field :ip
  field :shop_name
  field :cat, type:DateTime
  field :accuracy, type:Float
  
  def mshop
    if mshop_id
      Mshop.find_by_id(mshop_id)
    else
      nil
    end
  end
end
