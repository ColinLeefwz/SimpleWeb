course_modal = ->
  $(".section").on "click", (e)->
    $(this).find(".modal").modal({
      keyboard: true
    })

  $(".close-icon").on "click", (e)->
    e.stopPropagation()
    modal = $(this).closest(".modal")

    modal.modal("hide")
    player = sublime.player(modal.find("video")[0])
    player.stop() if player

$(document).ready(course_modal)
$(document).on "page:load", course_modal
