@sign_in_confirm = ->
  if get_cookie("signed_in") then true else false



get_cookie = (name) ->
  parts = document.cookie.split(name + "=")
  if (parts.length == 2)
    return parts.pop().split(";").shift()
