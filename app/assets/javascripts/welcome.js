
$(document).ready(function(){
  docReady(function() {
    var container = document.querySelector('#container');
    var msnry = new Masonry( container, {
    // options
      columnWidth: 300,
      itemSelector: '.item',
      gutter: 3
    });
  });

  $(window).scroll(function()
  {

  });
});
