course_modal = ->
  $(".section-title").on "click", (e)->
    $(this).closest(".section").find(".modal").modal('show')

  $(".close-icon").on "click", (e)->
    e.stopPropagation()
    modal = $(this).closest(".modal")

    modal.modal("hide")

  $(".modal").on "hidden", (e)->
    video = $(this).find("video")[0]
    player = sublime.player(video)
    player.stop() if player

$(document).ready(course_modal)
