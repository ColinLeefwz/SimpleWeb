$(document).ready(function(){
  var container = $('#content');
  container.imagesLoaded(function(){
    container.masonry({
      itemSelector: '.item',
      isFitWidth: true,
    });
  });
});
