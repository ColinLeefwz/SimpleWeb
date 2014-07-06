class Hot
  include Mongoid::Document

  field :sid, type: Integer # 商家id
  field :dead_line, type: Date # 截止日期 "yyyy-mm-dd"
  field :od, type: Float #排序值 
	field :city # "0571", "all", "0571, ..."

	def show_shop_name
		if self.shop
      self.shop.name
		else
			"商家名称未找到"
		end
	end


	def show_city
		if self.city == "()"
      range = "(" + self.shop.city + ")"
		else
			range = "全国"
		end

		range
	end

  def shop
    Shop.find_by_id(sid)
  end
end
