require 'offset'

class Mshop < ActiveRecord::Base
  validates_presence_of :name
  validates_length_of :name, :in => 1..50
  validates_length_of :fullname, :in => 0..255
  validates_length_of :address, :in => 2..255, :allow_blank => true
  validates_length_of :phone, :in => 6..25, :allow_blank => true
  validates_length_of :linkman, :in => 2..50, :allow_blank => true
  validates_length_of :kb_id, :in => 0..32, :allow_blank => true
  validates_numericality_of :dp_id, :only_integer => true

  has_many :mshop_mcategories
  has_many :mcategories, :through => :mshop_mcategories
  has_many :mshop_mdistricts
  has_many :mdistricts, :through => :mshop_mdistricts
  belongs_to :mcity

  def kb_url
    kb_id.blank? ? "" : "http://detail.koubei.com/store/detail-storeId-%s" % kb_id
  end

  def dp_url
    dp_id.blank? ? "" : "http://www.dianping.com/shop/%d" % dp_id
  end
  
  def o_lat
    Offset.pixel2lat(Offset.lat2pixel(lat, 18) - (2 * 256 - 72 / 3), 18)
  end

  def o_lng
    Offset.pixel2lng(Offset.lng2pixel(lng, 18) - (4 * 256 - 2 * 72), 18)
  end

end
