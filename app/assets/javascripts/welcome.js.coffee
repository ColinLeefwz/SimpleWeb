$ ->
  container = $('#content')
  container.imagesLoaded ->
    container.masonry
      itemSelector: '.item',
      isFitWidth: true
