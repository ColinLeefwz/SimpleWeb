module FollowHelper
  include NullableUser

  def follow_star(target)
    user = nullable(current_user)
    Following.follow?(user, target) ? "star_purple.png" : "star_hollow.png"
  end

  def follow_tooltip(target)
    user = nullable(current_user)
    Following.follow?(user, target) ? "unfollow this expert" : "follow this expert"
  end
end

