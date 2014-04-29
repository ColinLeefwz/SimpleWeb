@side_bar = ->
  $(".item-text > a").on 'click', ->
    $(".item").find(".item-icon").css("display", "inline-block")
    $(this).parents(".item").find(".item-icon").css("display", "none")
    $(".item").find(".item-icon-selected").css("display", "none")
    $(this).parents(".item").find(".item-icon-selected").css("display", "inline-block")
    $(".item").find(".item-text > a").css("color", "")
    $(this).parents(".item").find(".item-text > a").css("color", "#880848")

@pjax_dashboard = ->
  $(".item-text a").on "click", ->
    history.pushState(null, "", $(this).attr('href'))
