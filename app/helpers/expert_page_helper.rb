module ExpertPageHelper
	def favorite_class(expert, extra="")
		if current_user.try(:follow?, expert)
			"favorite-#{extra} solid-star "
		else
			"favorite-#{extra} hollow-star"
		end
	end

end
