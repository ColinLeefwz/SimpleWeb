class Waiter
  include Mongoid::Document

	field :sid
	field :uid
	field :seat_id, type: Integer
	field :name
end
