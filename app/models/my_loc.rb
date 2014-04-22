# encoding: utf-8

class MyLoc
  include Mongoid::Document
  field :_id, type: Moped::BSON::ObjectId
  field :sid1, type: Integer #我的家
  field :sid2, type: Integer #我的学校
  field :sid3, type: Integer  #我的公司
  
  def home
    Shop.find_by_id(sid1)
  end

  def school
    Shop.find_by_id(sid2)
  end
  
  def building
    Shop.find_by_id(sid3)
  end
  
  def shops
    [home, school, building]
  end
      
end