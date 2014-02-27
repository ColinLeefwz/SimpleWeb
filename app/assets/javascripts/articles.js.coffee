$(document).on "click", ".comment-btn", ->

  comment_content = $("#comment_content").val()
  alert "comments can not be blank" if !comment_content
