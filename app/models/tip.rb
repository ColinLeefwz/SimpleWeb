class Tip
  include Mongoid::Document

	field :sid
	field :t, type: Integer
	field :name
	field :price, type: Integer
end
