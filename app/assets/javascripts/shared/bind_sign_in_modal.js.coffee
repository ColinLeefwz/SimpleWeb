@bind_sign_in_modal = (target)->
  if not signed_in()
    target.on "click", ->
      $("#sign-in-modal").modal()
