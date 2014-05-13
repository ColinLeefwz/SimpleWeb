class Seat
  include Mongoid::Document

	field :sid
	field :num, type: Integer
	field :nob
	field :stat, type: Integer, default: 0
	field :printer_id, type: Integer
end
