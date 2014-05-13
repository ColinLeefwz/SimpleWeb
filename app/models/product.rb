class Product
  include Mongoid::Document

	field :sid, type: String
	field :name, type: String
	field :price, type: Integer
	field :unit, type: String,  default: '份'
	field :serial_number, type: String
	field :intro
	field :tag
	field :photo, type: String
	field :trait, type: Integer
	field :category_id
end
