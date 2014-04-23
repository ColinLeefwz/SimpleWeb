
@email_confirm = ->
  originate_email = $("#email").val()
  $("#update").on "click", ->
    if originate_email != $("#email").val()
      confirm "Your newsletter email address also will change, are sure to change your email address?"
