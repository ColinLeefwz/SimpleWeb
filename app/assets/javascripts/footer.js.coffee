$(document).ready ->
#  $('.dropdown-toggle').dropdown()
  $("#footer-select").bind "change", ->
    document.location.href = $(this).val()
#    if ($(this).selected)
#      alert "test"
#    $("#about-us").selected = true
