# coding: utf-8

class Termini
  include Mongoid::Document
  field :uid,  type: Moped::BSON::ObjectId
  field :city, type:Array
  field :gender,type: Integer

  def save
  	return if Termini.where({uid: self.uid, city: self.city}).first 
  	super
  end

end