class MshopMdistrict < ActiveRecord::Base
  validates_numericality_of :mshop_id, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :mdistrict_id, :only_integer => true, :greater_than_or_equal_to => 0

  belongs_to :mshop
  belongs_to :mdistrict
end
