@subscriber = ->
  $("#subscribe_newsletter").on "change", ->
    $.ajax "/subscription.js"
