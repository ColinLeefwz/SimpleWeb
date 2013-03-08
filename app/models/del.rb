class Del
  include Mongoid::Document
  field :name
  field :data, type:Array

  def self.insert(obj)
    begin
      Del.create!(:name => obj.collection_name.to_s, :data => obj.attributes)
      obj.destroy
    rescue
      nil
    end
  end
end
