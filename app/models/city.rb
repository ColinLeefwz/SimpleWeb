# coding: utf-8

class City
  include Mongoid::Document
  field :name
  field :code
  field :ename
  field :s


  def self.gname(code)
    City.where({:code => code}).first.try(:name) || code
  end
  
  def self.city_name(code)
    city = City.where({code:code}).first
    return "海外" if city.nil?
    city.name
  end
  

end

