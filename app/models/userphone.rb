class Userphone < ActiveRecord::Base
  self.table_name="users"
  validates_presence_of :name,:phone
  validates_length_of :phone, :in =>11..12
  validates_numericality_of :phone, :only_integer => true

end
