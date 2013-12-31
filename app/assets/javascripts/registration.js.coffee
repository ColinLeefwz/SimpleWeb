
check_terms_approved = -> 
  $("#terms").on "change", ->
    if $("#terms").is(':checked')
      $("input[type='submit']").attr("disabled", false)
    else
      $("input[type='submit']").attr("disabled", true)

$(document).ready(check_terms_approved)
$(document).on "page:load", check_terms_approved
    
