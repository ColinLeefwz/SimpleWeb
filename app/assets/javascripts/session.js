var timezone_toggle = function(){
  $(".timezone-toggle").on("click",function(){
    $(".timezone-confirmation").slideToggle();
    $(".content-type, .price").fadeToggle();
  });


  $(".timezone-confirmation").on("change", "select", function(){
    $(".simple_form").submit();
    $(".timezone-confirmation").slideUp();
    $(".content-type, .price").fadeIn();
  });
}

$(document).ready(timezone_toggle);
$(document).on('page:load', timezone_toggle);
