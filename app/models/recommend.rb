class Recommend
  include Mongoid::Document

	field :sid
	field :product_id, type: Integer
	field :order_number, type: Integer
end
