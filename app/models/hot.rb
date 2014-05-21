class Hot
  include Mongoid::Document

	has_one :shop

  field :_id, type: Integer
  field :shop_id, type: Integer
  field :dead_line, type: Date
  field :date_array, type: Date
  field :shop_rank, type: Integer
	field :display_range
	field :day
	field :month
	field :year
end
