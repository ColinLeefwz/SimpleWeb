# coding: utf-8

class Oversea
  include Mongoid::Document
  field :_id, type: Integer
  field :city
  field :country
  field :lo, type: Array
  field :country_code
  field :city_code


  #自行编码海外城市的编码
  def self.ccode
    countries={}
    ci = 0
    Oversea.all.each do |oversea|
      if oversea.country
        if co_code=countries[oversea.country]
          oversea.country_code=co_code
        else
          oversea.country_code=countries[oversea.country] ="x#{countries.length+1}"
        end
      end
      oversea.city_code = "c#{ci +=1}"
      oversea.save
    end
  end
end

