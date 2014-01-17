change_star_class = ->
  favorite_imgs = $("img.favorite-icon")
  for img_icon in favorite_imgs
    if $(img_icon).hasClass("solid-star-icon")
      $(img_icon).attr("src", "/assets/favorite.png")
    else
      $(img_icon).attr("src", "/assets/favorite_unselected.png")
    
favorite_click = ->
  $("img.favorite-icon").unbind "click"
  $("img.favorite-icon").on "click", ->
    # $(this).on "ajax:success", ->
    if $(this).hasClass("solid-star-icon")
      $(this).removeClass("solid-star-icon").addClass("hollow-star-icon")
    else
      $(this).removeClass("hollow-star-icon").addClass("solid-star-icon")

$(document).ready ->
  favorite_click()
  change_star_class()
$(document).on 'page:load', ->
  favorite_click()
  change_star_class()
$(document).on 'ajax:success', ->
  favorite_click()
  change_star_class()
