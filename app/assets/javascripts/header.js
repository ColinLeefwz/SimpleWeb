$(function(){
  var pull = $('#pull');
      menu = $('#nav_bar');

  $(pull).on('click', function(e){
      e.preventDefault();
      menu.slideToggle(); 
  })
})
