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
    pro_city_name(code).split(";")[-1]
  end
  
  def self.pro_city_name(code)
    return '海外' if code.nil? || code.size<1
    if code =~ /^x/
      o = $redis.get("CountryName#{code}")
      return '海外' if o.nil?
      return o
    end
    city = $redis.get("CityName#{code}")
    if city.nil?
      Xmpp.error_notify("城市代码#{code}不存在")
      return "未知"
    end
    city
  end
  
  def self.cascade_name(code)
    name = pro_city_name(code)
    if code =~ /^x/
      return name if '海外'==name
      return "海外;#{name}"
    end
    return "中国;#{name}"
  end
    
  def self.city_name_mongo(code)
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
    return pro_city_name(city)
  end
  
  def self.init_redis
    Oversea.all.each do |o|
      $redis.set("CountryName#{o.country_code}", o.country)
    end
    City.where({}).sort({_id:1}).each do |city|
      #next if $redis.get("CityName#{city.code}")
      $redis.set("CityName#{city.code}", "#{city.s};#{city.name}")
    end
  end
  

end

