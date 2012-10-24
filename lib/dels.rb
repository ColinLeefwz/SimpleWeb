# To change this template, choose Tools | Templates
# and open the template in the editor.

module Dels
  
  def del
    begin
      Del.create!(:name => self.collection_name.to_s, :data => self.attributes)
      self.delete
    rescue
      nil
    end
  end
  
end
