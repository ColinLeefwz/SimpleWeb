class ApiAdminShopController < ApplicationController
	def ajax_dis
		lob1 = Shop.find(params[:shop_id]).lo_to_lob
		lob2 = params[:lob2].split(/[,，]/).map {|m| m.to_f }.reverse
		distance = Shop.new.get_distance(lob1, lob2)
		render :json => {:distance => distance}
	end
end
