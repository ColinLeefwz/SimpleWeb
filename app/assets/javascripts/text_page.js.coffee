change_star_class = ->
  if $(".favorite-icon").hasClass("solid-star-icon")
    $(".favorite-icon").attr("src", "/assets/favorite.png")
  else
    $(".favorite-icon").attr("src", "/assets/favorite_unselected.png")

$(document).ready(change_star_class)
$(document).on 'page:load', change_star_class
$(document).on 'ajax:success', change_star_class
