class Hot
  include Mongoid::Document

	belongs_to :shop

  field :dead_line, type: Date
  field :date_array, type: Date
  field :shop_rank, type: Integer
	field :display_range

	def show_shop_name
		if self.shop
      self.shop.name
		else
			"商家名称未找到"
		end
	end


	def show_display_range
		if self.display_range == "全城"
      range = self.display_range + "(" + self.shop.city + ")"
		else
			range = self.display_range
		end

		range
	end
end
