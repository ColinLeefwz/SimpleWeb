$(document).ready ->
  $("#footer-select").bind "change", ->
    document.location.href = $(this).val()
