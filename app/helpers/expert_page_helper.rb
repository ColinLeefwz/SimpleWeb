module ExpertPageHelper
	def favorite_class(expert)
		if current_user.try(:follow?, expert)
			".favorite.solid-star "
		else
			".favorite.hollow-star"
		end
	end

	def follow_link(expert)
		if current_user.try(:follow?, expert)
			link_to image_tag("favorite.png", class: "favorite-icon solid-star"), relationship_path(expert), remote: true
		else
			link_to image_tag("favorite.png", class: "favorite-icon hollow-star"), relationship_path(expert), remote: true
		end


	end
	
end
