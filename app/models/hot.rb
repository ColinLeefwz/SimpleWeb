class Hot
  include Mongoid::Document

  field :sid, type: Integer
  field :dead_line, type: Date
  field :od, type: Float #排序值 
	field :city # "0571", ""

	def show_shop_name
		if self.shop
      self.shop.name
		else
			"商家名称未找到"
		end
	end


	def show_city
		if self.city == "全城"
      range = self.city + "(" + self.shop.city + ")"
		else
			range = self.city
		end

		range
	end

  def shop
    Shop.find_by_id(sid)
  end
end
