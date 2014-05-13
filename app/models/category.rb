class Category
  include Mongoid::Document

	field :sid
	field :name
	field :is_show, type: Integer
	field :order_number, type: Integer
end
