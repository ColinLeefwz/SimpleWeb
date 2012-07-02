class Blacklist < ActiveRecord::Base
  belongs_to :user
  belongs_to :block, :class_name => User
  
  validates_uniqueness_of :block_id, :scope => :user_id
  

end
