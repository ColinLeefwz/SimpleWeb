jQuery(document).ready(function($) {
  var container = $('#content');
  var containerWidth = container.width();

  // getContainerWidth();
  // changeColumns();
  // initEvents();
  initPlugins();

  function changeColumns() {
    var w_w = $(window).width();
    if( w_w <= 600 ) n = 1;
    else if( w_w <= 768 ) n = 2;
    else if( w_w > 768)  n = 3;
  }

  function getCOntainerWidth(){
    containerWidth = container.width();
  }

  function initEvents() {
    $(window).on( 'throttledresize', function( event ) {
      getContainerWidth();
      changeColumns();
      initPlugins();
    });
  }

  function initPlugins(){
    container.imagesLoaded( function(){
      container.masonry({
        itemSelector : '.item',
			  isFitWidth: true
       // isAnimated : true,
       // animationOptions: {
       //   duration: 400
       // }
      });
    });
  }
});
