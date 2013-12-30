get_cookie = (name) ->
	parts = document.cookie.split(name + "=")
	if parts.length == 2
		return parts.pop().split(";").shift()

detect_login = ->
	signed_in = get_cookie("signed_in")
	if signed_in == "1"
		return true
	else
		alert "not logged in"
		return false

favorite_icon_img = ->
	favorite_imgs = $("img.favorite-icon")
	for img_icon in favorite_imgs
		if $(img_icon).hasClass("solid-star")
		  $(img_icon).attr("src", "/assets/favorite.png")
		else
			$(img_icon).attr("src", "/assets/favorite_unselected.png")

favorite_click = ->
	$("img.favorite-icon").unbind "click"
	$("img.favorite-icon").on "click", ->
		if $(this).hasClass("solid-star")
			$(this).removeClass("solid-star").addClass("hollow-star")
		else
			$(this).removeClass("hollow-star").addClass("solid-star")
	favorite_icon_img()

$(document).ready ->
	favorite_click()
	favorite_icon_img()

$(document).on 'page:load', ->
	favorite_click()
	favorite_icon_img()

$(document).on 'ajax:success', ->
	favorite_click()
