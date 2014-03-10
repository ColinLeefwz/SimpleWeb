@load_isotope = ->
  $.Isotope.prototype._getCenteredMasonryColumns = ->
    @width = @element.width()
    parentWidth = @element.parent().width()
    colW = (@options.masonry && @options.masonry.columnWidth) || @$filteredAtoms.outerWidth(true) || parentWidth

    cols = Math.floor(parentWidth/colW)
    cols = Math.max(cols, 1)

    @masonry.cols = cols
    @masonry.columnWidth = colW

  $.Isotope.prototype._masonryReset = ->
    @masonry = {}
    @_getCenteredMasonryColumns()
    i = @masonry.cols
    @masonry.colYs = []
    @masonry.colYs.push(0) while i--


  $.Isotope.prototype._masonryResizeChanged = ->
    prevColCount = @masonry.cols
    @_getCenteredMasonryColumns()
    return (@masonry.cols isnt prevColCount)

  $.Isotope.prototype._masonryGetContainerSize = ->
    unusedCols = 0
    i = @masonry.cols
    while --i
      break if @masonry.colYs[i] isnt 0
      unusedCols++
    height = Math.max.apply(Math, @masonry.colYs)
    width = (@masonry.cols - unusedCols)*(@masonry.columnWidth)
    return{ height, width }

  container = $('#content')
  container.imagesLoaded ->
    container.isotope {
      layoutMode: 'masonry'
    }

  $container = $('#content')
  $('li .filters').on 'click', ->
    selector = $(this).data('filter') + ', .always_show'
    $container.isotope {
      filter: selector
    }

  $('select#collapsed_navbar').on 'change', ->
    option = $(this).find(":selected")
    selector = option.data('filter') + ', .always_show'
    if selector != '.format'
      $container.isotope {
        filter: selector
      }

      

load_sublime = ->
  sublime.load()
  for video in $("video")
    sublime.ready( ->
      sublime.prepare(video, (player) ->
        player.pause()
      )
    )


update_profile_message = ->
  $("input[type='submit']").on 'click', ->
    $("input[type='file']").css("width", "95px")

    

$(document).ready ->
  load_sublime()

