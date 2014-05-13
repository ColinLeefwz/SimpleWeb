class Order
  include Mongoid::Document

	field :uid
	field :sid
	field :price, type: Integer
	field :eprice, type: Integer
	field :stat, type: Integer
	field :remark
	field :seat_id, type: Integer
	field :num, type: Integer
	field :serial_number
	field :father, type: Integer
	field :order_items_count, type: Integer
end
