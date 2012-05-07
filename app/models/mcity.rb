class Mcity < ActiveRecord::Base
  validates_presence_of :name, :eng_name
  validates_length_of :name, :in => 2..50
  validates_length_of :eng_name, :in => 0..32, :allow_blank => true
  validates_length_of :kb_id, :in => 0..32, :allow_blank => true
  validates_numericality_of :dp_id, :only_integer => true

  has_many :mcity_mcategories
  has_many :mcategories, :through => :mcity_mcategories
  has_many :mcity_mdistricts
  has_many :mdistricts, :through => :mcity_mdistricts

end
