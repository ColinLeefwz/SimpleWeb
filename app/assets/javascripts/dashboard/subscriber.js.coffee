
@subscriber = ->
  create_spinner()

  $("#subscription_newsletter").on "change", ->
    $(this).closest("form").submit()
    $(".newsletter .spinner").css({"display": "inline"})


create_spinner = ->
  opts = 
    lines: 7,
    length: 0,
    width: 5,
    radius: 6

  spinner = new Spinner(opts).spin().el
  $(".newsletter .spinner-wrapper").append $(spinner)

