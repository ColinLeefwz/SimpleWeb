
@user_name_uniqueness = ->
  $("[id$=_user_name]").blur ->
    $.get '/validate_user_name.js?user_name=' + $(this).val() 

