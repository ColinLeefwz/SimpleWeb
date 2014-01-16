module FavoriteHelper
	def favorite_class(method, object, extra="")
		if current_user.try(method, object)
			"favorite#{extra} solid-star#{extra}"
		else
			"favorite#{extra} hollow-star#{extra}"
		end
	end
end
