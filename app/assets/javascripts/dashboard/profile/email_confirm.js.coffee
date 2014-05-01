
@email_confirm = ->
  originate_email = $("#email").val()
  $("#update").on "click", ->
    current_newsletter = $("#subscription_newsletter").val()
    if current_newsletter == "create" and originate_email != $("#email").val()
      confirm "Your newsletter email address also will change, are sure to change your email address?"
