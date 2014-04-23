
@email_confirm = ->
  originate_email = $("#email").val()
  $("#update").on "click", ->
    if originate_email != $("#email").val()
      confirm "Are sure to change your email address?"
