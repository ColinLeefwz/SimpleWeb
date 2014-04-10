check_terms_approved = ->
  $("#terms").on "change", ->
    if $("#terms").is(':checked')
      $("input[type='submit']").attr("disabled", false)
    else
      $("input[type='submit']").attr("disabled", true)

# $ ->
#   $("[data-validate]").blur ->
#     $this = $(this)
#     $.get($this.data("validate"),
#       user_name: $this.val()
#     ).success ->
#       $("#User_Name_Info").empty()
#       $("#User_Name_Info").append "" + "can"
#     .error ->
#       $("#User_Name_Info").empty()
#       $("#User_Name_Info").append "" + "exist"

# $ ->
#   $("[data-validate]").blur ->
#     $.get("/users/validate_user_name", {user_name: $(this).val()}, "script")

$ ->
  $("[data-validate]").blur ->
    $.ajax
      type: 'POST'
      url:  '/users/validate_user_name'
      data:
        user_name: $(this).val()
      success: (data) ->
        $("#User_Name_Info").empty()
        if data.status == 'true'
          $("#User_Name_Info").append "" + "Name: #{data.name} still can be used as your user name"
        else
          $("#User_Name_Info").append "" + "Sorry, name: #{data.name} has ever been registered by other users"
    return

$(document).ready(check_terms_approved)
$(document).on "page:load", check_terms_approved

