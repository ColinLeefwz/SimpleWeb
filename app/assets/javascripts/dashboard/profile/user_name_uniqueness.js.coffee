
@user_name_uniqueness = ->
  current_username = $("[id$=_user_name]").val()
  $("[id$=_user_name]").blur ->
    if current_username != $(this).val()
      $.get '/validate_user_name.js?user_name=' + $(this).val()

