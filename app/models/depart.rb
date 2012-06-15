class Depart < ActiveRecord::Base
  has_many :admins
  
  validates_presence_of :name
  validates_uniqueness_of :name

  validates_length_of :name, :maximum => 32
  
end
