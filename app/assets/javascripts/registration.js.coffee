@check_terms_approved = ->
  $("#terms").on "change", ->
    if $("#terms").is(':checked')
      $("input[type='submit']").attr("disabled", false)
    else
      $("input[type='submit']").attr("disabled", true)
$ ->
  $("[data-validate]").blur ->
    $.ajax
      type: 'POST'
      url:  '/users/validate_user_name'
      data:
        user_name: $(this).val()
      success: (data) ->
        $("#User-Name-Info").empty()
        if data.status == 'true'
          $("#User-Name-Info").css "color", "green"
          $("#User-Name-Info").append "" + "Name: #{data.name} still can be used as your user name"
        else
          $("#User-Name-Info").css "color", "red"
          $("#User-Name-Info").append "" + "Sorry, name: #{data.name} has ever been registered by other users"
    return


