change_star_class = ->
  favorite_imgs = $("img.favorite-icon")
  for img_icon in favorite_imgs
    if $(img_icon).hasClass("solid-star-icon")
      $(img_icon).attr("src", "/assets/star_purple.png")
    else
      $(img_icon).attr("src", "/assets/star_hollow.png")
    
favorite_click = ->
  $("img.favorite-icon").unbind "click"
  $("img.favorite-icon").on "click", ->
    if $(this).hasClass("solid-star-icon")
      $(this).removeClass("solid-star-icon").addClass("hollow-star-icon")
    else
      $(this).removeClass("hollow-star-icon").addClass("solid-star-icon")
    if $(this).data("type") == "content"
      if $(this).attr("data-original-title") == "remove from Favorites"
        $(this).attr("data-original-title", "add to Favorites")
      else
        $(this).attr("data-original-title", "remove from Favorites")
    else if $(this).data("type") == "user"
      if $(this).attr("data-original-title") == "unfollow this expert"
        $(this).attr("data-original-title", "follow this expert")
      else
        $(this).attr("data-original-title", "unfollow this expert")



    if $("#follower-count").length
      follower_num = +$("#follower-count").html()
      $("#follower-count").html($("#follow .solid-star-icon").length ? follower_num - 1 : follower_num + 1 )

$(document).ready ->
  favorite_click()
  change_star_class()
$(document).on 'page:load', ->
  favorite_click()
  change_star_class()
$(document).on 'ajax:success', ->
  favorite_click()
  change_star_class()
