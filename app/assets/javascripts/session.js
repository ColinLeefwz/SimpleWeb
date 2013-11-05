$(document).ready(function(){

  $(".timezone-toggle").on("click",function(){
    $(".timezone-confirmation").slideToggle();
    $(".content-type, .price").fadeToggle();
  });


  $(".timezone-confirmation").on("change", "select", function(){
    $(".simple_form").submit();
    $(".timezone-confirmation").slideUp();
    $(".content-type, .price").fadeIn();
  });
});
