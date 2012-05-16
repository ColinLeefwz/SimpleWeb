class Depart < ActiveRecord::Base
  has_many :admins
  
  validates_presence_of :name
  validates_uniqueness_of :name
end
