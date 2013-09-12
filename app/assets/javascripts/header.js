
$(document).ready(function(){
  var nav = $("nav");
  var subcategory = $(".subcategory");

  nav.find("li").each(function(){
    if ( $(this).find("ul").length > 0) {
      // $(this).mouseenter(function(){
      //   $(this).find("ul").stop(true, true).slideDown();
      // });

      // $(this).mouseleave(function(){
      //   $(this).find("ul").stop(true, true).slideUp("fast");
      // });

      $(this).click(function(){
        $(this).parents("nav").find("a").css("border-bottom", "0");
        $(this).find("a").css("border-bottom", "3px solid #8a2649");
        subcategory.slideUp();
        $(this).find("ul").stop(true, true).slideDown();
      });
    }
  });
});

