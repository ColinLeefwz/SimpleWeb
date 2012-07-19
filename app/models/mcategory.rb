# coding: utf-8

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

  def self.unfold(type_id)
    categories = []
    case type_id
    when 1
      categories =  self.where(["name = ? or name = ?", "酒吧", "活动"])
    when 2
      categories =  self.where(["name = ? or name = ?", "咖啡厅", "茶馆"])
    when 3
      categories =  self.where(["name = ? or name = ?", "美食", "酒店"])
    when 4
      categories =  self.where(["name = ? or name = ?", "运动健身", "休闲娱乐"])
    when 5
      categories =  self.where(["name = ? or name = ?", "购物", "广场"])
    end
    
    categories.inject([]) { |f, s| f + s.leafs.map(&:id) }

  end

  #所有的节点
  def leafs(s=[])
    sub = sub_categories
    unless sub.blank?
      s << self
      sub.each{|sb| sb.leafs(s)}
      s
    else
      s << self
    end
  end

  def parent
    self.class.find_by_id(self.nest_id)
  end

  #根节点
  def root
    pa = parent
    if pa.nil?
      return self
    else
      pa.root
    end
  end

  # 尖端节点
  def sleaf(s=[])
    sub= sub_categories
    unless sub.blank?
      sub.each{|sb| sb.sleaf(s)}
      s
    else
      s << self
    end
  end

end
