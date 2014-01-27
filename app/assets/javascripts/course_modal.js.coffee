course_modal = ->
  $(".section").on "click", (e)->
    $(this).find(".modal").modal({
      backdrop: "static"
    })

  $(".close-icon").on "click", (e)->
    e.stopPropagation()
    $(".modal").modal("hide")

$(document).ready(course_modal)
$(document).on "page:load", course_modal
