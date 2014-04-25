$("#show-email-modal").html "<%= j render "shared/share_email_modal"%>"
$("#share-email-modal").modal "show"

$("#new_share_email_form input[type='submit']").on "click", (e)->
  e.preventDefault()
  if valid_form()
    $("form#new_share_email_form").submit()
  else
    $("#show-alert").html("<div class='alert alert-danger'>please input email</div>")

valid_form = ()->
  emailPattern = /// ^ #begin of line
   ([\w.-]+)         #one or more letters, numbers, _ . or -
   @                 #followed by an @ sign
   ([\w.-]+)         #then one or more letters, numbers, _ . or -
   \.                #followed by a period
   ([a-zA-Z.]{2,6})  #followed by 2 to 6 letters or periods
   $ ///i            #end of line and ignore case
  to_val = $("#share_email_form_to").val()
  to_val.match emailPattern
