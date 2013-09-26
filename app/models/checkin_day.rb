# encoding: utf-8
class CheckinDay
  include Mongoid::Document
  field :_id,  type: String
  field :num, type: Integer
  field :od1, type: Integer
  field :od2, type: Integer
  field :od3, type: Integer
  field :shops, type:Array

  def show_shops
    self.shops.map{|m| "#{Shop.find_by_id(m[0].to_i).try(:name)}: #{m[1]}"}.join(', ')
  end
end
