
$(document).ready(function(){
  docReady(function() {
    var container = document.querySelector('#container');
    var msnry = new Masonry( container, {
    // options
      columnWidth: 100,
      itemSelector: '.item',
      gutter: 50
    });
  });

  $(window).scroll(function()
  {

  });
});
