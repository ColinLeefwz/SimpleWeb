$(".main-menu").html("<%=j render partial: 'dashboard/refer_user'%>")

$(document).ready ->
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
