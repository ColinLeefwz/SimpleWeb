@bind_sign_in_modal = (target)->
  if not signed_in()
    target.on "click", (event)->
      $("#sign-in-modal").modal()
      event.preventDefault()

