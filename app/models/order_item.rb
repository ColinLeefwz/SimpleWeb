class OrderItem
  include Mongoid::Document

	field :order_id, type: Integer
	field :product_name
	field :product_price, type: Integer
	field :product_id, type: Integer
	field :quantity, type: Integer
	field :product_unit
	field :category_name
end
