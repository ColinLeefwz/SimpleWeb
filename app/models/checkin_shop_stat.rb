class CheckinShopStat
  include Mongoid::Document
  field :_id, type: Integer
  field :users, type:Array
  field :ips, type:Array

  def shop
    Shop.find_by_id(self.id)
  end

  def user(user_object_id)
    user_object_id =~ /"(.*?)"/
    User.find($1)
  end
end

