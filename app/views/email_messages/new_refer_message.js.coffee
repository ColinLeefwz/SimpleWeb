$(".main-menu").html("<%=j render partial: 'dashboard/refer_user'%>")

$(document).ready ->
  validate_refer_message()
