class McityMcategory < ActiveRecord::Base
  validates_numericality_of :mcity_id, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :mcategory_id, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :mshop_count, :only_integer => true, :greater_than_or_equal_to => 0, :default => 0
  
  belongs_to :mcity
  belongs_to :mcategory


end
