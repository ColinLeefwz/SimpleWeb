class ShopSinaUser
  include Mongoid::Document
  field :_id, type: Integer
  field :users, type:Array  

  def self.find_by_id(id)
    begin
      self.find(id)
    rescue
      nil
    end
  end

end