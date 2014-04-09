check_terms_approved = ->
  $("#terms").on "change", ->
    if $("#terms").is(':checked')
      $("input[type='submit']").attr("disabled", false)
    else
      $("input[type='submit']").attr("disabled", true)

$ ->
  $("[data-validate]").blur ->
    $this = $(this)
    $.get($this.data("validate"),
      user_name: $this.val()
    ).success( ->
      $("#User_Name_Info").empty()
      $("#User_Name_Info").append "" + "can"
      return
    ).error ->
      $("#User_Name_Info").empty()
      $("#User_Name_Info").append "" + "exist"
      return
  return
return

$(document).ready(check_terms_approved)
$(document).on "page:load", check_terms_approved

