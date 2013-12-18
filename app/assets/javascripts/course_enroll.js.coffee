

sign_up_and_confirm = ->
  $(".confirm-button").on "click", ->
    $("#sign_up_confirm_form").submit()


$(document).ready(sign_up_and_confirm)
$(document).on "page:load", sign_up_and_confirm
