course_modal = ->
  $(".section").on "click", (e)->
    $(this).find(".modal").modal({
      keyboard: true
    })

  $(".close-icon").on "click", (e)->
    e.stopPropagation()
    modal = $(this).closest(".modal")

    modal.modal("hide")

  $(".modal").on "hidden", (e)->
    video = $(this).find("video")[0]
    player = sublime.player(video)
    player.stop() if player

$(document).ready(course_modal)
$(document).on "page:load", course_modal
