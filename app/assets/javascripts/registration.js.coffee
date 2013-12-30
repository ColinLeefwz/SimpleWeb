
check_terms_approved = -> 
  $("#terms").on "change", ->
    if $("#terms").is(':checked')
      $("button").attr("disabled", false)
    else
      $("button").attr("disabled", true)

$(document).ready(check_terms_approved)
$(document).on "page:load", check_terms_approved
    
