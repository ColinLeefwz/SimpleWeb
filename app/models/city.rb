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
    if code =~ /^x/
      o = Oversea.where({country_code: code}).limit(1).first
      return '海外' if o.nil?
      return o.country
    end
    
    city = City.where({code:code}).first
    return '海外' if city.nil?
    city.name
  end
  
  def City.fullname(city)
    city = City.where({code:city}).limit(1).first
    return "" if city.nil?
    city.s.to_s + city.name.to_s
  end
  

end

