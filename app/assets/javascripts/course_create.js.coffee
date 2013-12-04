

remove_fields = (link) ->
  $(link).prev("input[type=hidden]").val("1")
  $(link).closest(".fields").slideUp()

add_fields = (link, associaton, content) ->
  new_id = new Date().getTime()
  regexp = new RegExp("new_" + associaton, "g")
  $(".expand_field").append(content.replace(regexp, new_id))


$(document).on "click", ".remove-fields", (e)->
  e.preventDefault()
  remove_fields(this)

$(document).on "click", ".add-fields", (e)->
  e.preventDefault()
  associaton = $(this).data("associaton")
  content = $(this).data("fields")
  add_fields(this, associaton, content)

# reference: turbolinks -> troubleshooting -> events firing twice or more


