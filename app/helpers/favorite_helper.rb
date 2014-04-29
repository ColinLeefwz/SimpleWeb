module FavoriteHelper
  include NullableUser

  def favorite_star(target)
    user = nullable(current_user)
    Subscription.favorited?(user, target) ? "star_purple.png" : "star_hollow.png"
  end

  def favorite_tooltip(target)
    user = nullable(current_user)
    Subscription.favorited?(user, target) ? "remove from favorites" : "add to favorites"
  end

end
