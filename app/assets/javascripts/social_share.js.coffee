
social_popup = ->
  $('a[data-popup]').on('click', (e)->
    ratio = if $(this).parent().hasClass("facebook") then "height=560, width=1080" else "height=600, width=600" # if use click on facebook share, open a larger pop-up
    window.open( $(this).attr('href'), "Popup", ratio)
    e.preventDefault()
  )


$(document).ready(social_popup)

