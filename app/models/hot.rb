class Hot
  include Mongoid::Document

	belongs_to :shop

  field :dead_line, type: Date
  field :date_array, type: Date
  field :shop_rank, type: Integer
	field :display_range
end
