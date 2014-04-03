@form_validation = ->
  $("#publish").on "click", (e)->
    if ($("input[type=checkbox]:checked").length == 0)
      alert "You have to at least select one category"
      e.preventDefault()
    else
      confirm "Are you sure you want to publish this content and make it visible on the home page?"

  $("#save-draft").on "click", (e)->
    if ($("input[type=checkbox]:checked").length == 0)
      alert "You have to at least select one category"
      e.preventDefault()
    else
      confirm "Are you sure you want to save this content as a draft?"
