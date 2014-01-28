course_modal = ->
  $(".section").on "click", (e)->
    $(this).find(".modal").modal({
      backdrop: "static"
    })

  $(".close-icon").on "click", (e)->
    e.stopPropagation()
    modal = $(this).closest(".modal")

    player = sublime.player(modal.find("video")[0])
    player.stop()
    modal.modal("hide")

$(document).ready(course_modal)
$(document).on "page:load", course_modal
