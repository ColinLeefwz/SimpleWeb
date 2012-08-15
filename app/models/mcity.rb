# encoding: utf-8"
class Mcity < ActiveRecord::Base
  require "iconv"
  require 'open-uri'
  validates_presence_of :name, :eng_name
  validates_length_of :name, :in => 2..50
  validates_length_of :eng_name, :in => 0..32, :allow_blank => true
  validates_length_of :kb_id, :in => 0..32, :allow_blank => true
  validates_numericality_of :dp_id, :only_integer => true

  has_many :mcity_mcategories
  has_many :mcategories, :through => :mcity_mcategories
  has_many :mcity_mdistricts
  has_many :mdistricts, :through => :mcity_mdistricts

#  def to_url_gb16(name)
#    bgstr = Iconv.iconv("GB2312//IGNORE","UTF-8//IGNORE",name).first
#    str = bgstr.unpack("H#{bgstr.length*4}").first.upcase
#    s=[]
#    (str.length/2).times do |t|
#      s << "%"+str[t*2,2]
#    end
#    s.join('')
#  end


#  def get_code
#    url = "http://www.ip138.com/post/search.asp?area=#{to_url_gb16(name)}&action=area2zone"
#    doc = Nokogiri::HTML(open(url))
#    t = doc.search("td[@class='tdc2']")[1].text
#    t = doc.search("td[@class='tdc2']")[2].text if t.match(/台湾|香港|澳门/)
#    if t =~ /更详细/
#      puts "url = #{url}"
#    end
#    if t =~ /更详细/ && self.name.force_encoding('UTF-8') =~ /[州|市]/
#      puts "----------------------------"
#      puts "name : #{self.name}, t : #{t}"
#      puts "+++++++++++++++++++++++++++++"
#      name = self.name.force_encoding('UTF-8').sub(/[州|市]/,'')
#      url = "http://www.ip138.com/post/search.asp?area=#{to_url_gb16(name)}&action=area2zone"
#      doc = Nokogiri::HTML(open(url))
#      t = doc.search("td[@class='tdc2']")[1].text
#      t = doc.search("td[@class='tdc2']")[2].text if self.name.force_encoding('UTF-8') =~ /州/ && !(t =~ /州/)
#    end
#    code = t.force_encoding("UTF-8").split('区号：').last
#    self.update_attribute(:code, code)
#  end



end

