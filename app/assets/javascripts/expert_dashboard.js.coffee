@side_bar = ->
  $(".item-text > a").on 'click', ->
    $(".item").find(".item-icon").css("display", "inline-block")
    $(this).parents(".item").find(".item-icon").css("display", "none")
    $(".item").find(".item-icon-selected").css("display", "none")
    $(this).parents(".item").find(".item-icon-selected").css("display", "inline-block")
    $(".item").find(".item-text > a").css("color", "")
    $(this).parents(".item").find(".item-text > a").css("color", "#880848")

@pjax_dashboard = ->
  $(".item-pjax").on "click", ->
    history.pushState(null, "", $(this).attr('href'))
  $(window).bind "popstate", ->
    $.getScript(location.href)


@validate_refer_message = ->
  $(".validation-message").hide()
  send = $("input[value='Send']")
  send.attr('disabled', 'disabled')

  to = $("input#refer_email_form_to")
  enable_send = false
  to.on 'blur', ->
    to_value = to.val()
    get_path = "/email/validate_invite_email"
    $.get(get_path, {to_address: to_value}, (data)=>
      enable_send = data.status
      if enable_send
        send.removeAttr("disabled")
        $(".validation-message").hide()
      else
        send.attr('disabled', 'disabled')
        $(".validation-message").show()
        $(".validation-message").text data.error_message
    )

