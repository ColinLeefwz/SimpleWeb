class Blacklist < ActiveRecord::Base
  belongs_to :user
  
  validates_uniqueness_of :block_id, :scope => :user_id
  

end
