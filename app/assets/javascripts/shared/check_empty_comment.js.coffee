@check_empty_comment = ->
  $(".comment-btn").on "click", ->
    comment_content = $("#comment_content").val()

    if comment_content
      $("#new_comment").submit()
    else
      alert "comments can not be blank"

