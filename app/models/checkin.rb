class Checkin < ActiveRecord::Base
  belongs_to :mshop
  belongs_to :user

  validates_length_of :id, :maximum => 64
  validates_length_of :shop_name, :maximum => 64
end
