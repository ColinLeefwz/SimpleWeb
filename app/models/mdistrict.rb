class Mdistrict < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :in =>2..255
  validates_numericality_of :nest_id, :only_integer => true, :greater_than_or_equal_to => 0, :default => 0

  has_many :mshop_mdistricts
  has_many :mshop, :through => :mshop_mdistricts
  has_many :mcity_mdistricts
  has_many :mcity, :through => :mcity_mdistricts

  def mcity_mdistrict(mcity_id)
    return McityMdistrict.find_by_mcity_id_and_mdistrict_id(mcity_id, self.id)
  end

  def sub_district
    return Mdistrict.find_all_by_nest_id(self.id)
  end

  
  # 所有尖端节点
  def sleaf(s=[])
    sub= sub_district
    unless sub.blank?
      sub.each{|sb| sb.sleaf(s)}
      s
    else
      s << self
    end
  end

end
