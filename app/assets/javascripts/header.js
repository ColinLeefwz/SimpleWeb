
$(document).ready(function(){
  var nav = $("nav");

  nav.find("li").each(function(){
    if ( $(this).find("ul").length > 0) {
      $(this).mouseenter(function(){
        $(this).find("ul").stop(true, true).slideDown();
      });

      $(this).mouseleave(function(){
        $(this).find("ul").stop(true, true).slideUp("fast");
      });

    }
  });
});



/* $(document).ready(function(){

  $("#nav_bar").on("click", ".category", function(event){
    $(".subcategory").slideUp();
    $(this).children(".subcategory").slideDown();
  });

  $(".subcategory").on("click", func", tion(event){
    event.preventDefault();
  });

});    */


/*
$(document).ready(function(){
  $(".category").hover(function(){
    $(".subcategory", this).stop(true, true).slideDown();
  },
  function(){
    $(".subcategory", this).stop(true, true).slideUp();
  } 
  );
});       */
