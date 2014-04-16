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

  def get_favorite_type(object)
    if object.is_a? User
      "user"
    else
      "content"
    end
  end

end
