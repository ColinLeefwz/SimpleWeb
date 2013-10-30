$(document).ready(function(){
  $(".item-text > a").click(function() {
    $(".item").find(".item-icon").css("display", "inline-block");
    $(this).parents(".item").find(".item-icon").css("display", "none");
    $(".item").find(".item-icon-selected").css("display", "none");
    $(this).parents(".item").find(".item-icon-selected").css("display", "inline-block");
    $(".item").find(".item-text > a").css("color", "");
    $(this).parents(".item").find(".item-text > a").css("color", "#880848");
  });

});


