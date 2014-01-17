module FavoriteHelper
	def favorite_class(method, object, extra="")
		if current_user.try(method, object)
			"favorite#{extra} solid-star#{extra}"
		else
			"favorite#{extra} hollow-star#{extra}"
		end
	end

  def decide_tip_title(method, object)
    if method == :has_subscribed?
      current_user.try(method, object) ? "remove from Favorites" : " add to Favorites"
    elsif method == :follow?
      current_user.try(method, object) ? "unfollow this expert" : "follow this expert"
    end
  end
	# def favorite_expert_class(expert, extra="")
	# 	if current_user.try(:follow?, expert)
	# 		"favorite#{extra} solid-star "
	# 	else
	# 		"favorite#{extra} hollow-star"
	# 	end
	# end

	# def favorite_content_class(content, extra="")
	# 	if current_user.try(:has_subscribed?, content)
	# 		"favorite#{extra} solid-star "
	# 	else
	# 		"favorite#{extra} hollow-star"
	# 	end
	# end

end
