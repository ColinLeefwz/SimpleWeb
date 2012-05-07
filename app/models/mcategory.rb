class Mcategory < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :in =>2..255
  validates_numericality_of :nest_id, :only_integer => true, :greater_than_or_equal_to => 0, :default => 0

  has_many :mshop_mcategories
  has_many :mshops, :through => :mshop_mcategories

  has_many :mcity_mcategories
  has_many :mcitys, :through => :mcity_mcategories

  def has_sub()
    return !Mcategory.find_by_nest_id(self.id).nil?
  end

  def sub_categories()
    return Mcategory.find_all_by_nest_id(self.id)
  end

  def mcity_mcategory(mcity_id)
    return McityMcategory.find_by_mcity_id_and_mcategory_id(mcity_id, self.id)
  end
end
