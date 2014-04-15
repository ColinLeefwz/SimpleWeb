@check_empty_comment = ->
  $(".comment-btn").on "click", ->
    comment_content = $("#comment_content").val()
    alert "comments can not be blank" if !comment_content

