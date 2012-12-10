class SinaUser
  include Mongoid::Document
  store_in session: "dooo"

  field :_id, type: Integer

  def self.find_by_id(id)
    begin
      self.find(id)
    rescue
      nil
    end
  end
end
