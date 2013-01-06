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

end

