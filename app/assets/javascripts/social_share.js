var social_popup = function(){
  $('a[data-popup]').on('click', function(e){
     window.open( $(this).attr('href'), "Popup", "height=600, width=600");
     e.preventDefault();
  });
}

$(document).ready(social_popup);
$(document).on('page:load', social_popup);

