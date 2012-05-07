
/** 首页滚动图片动画 **/
$(document).ready(function(){
			
	$("#LeftArrow").click(function(){
		for(i=1;i<=3;i++){
			var block=$("#B"+i).parent().css("display");
			if(block=="block"){
				Run(i,"left");
			}
		}
	});
	
	$("#RightArrow").click(function(){
		for(i=1;i<=3;i++){
			var block=$("#B"+i).parent().css("display");
			if(block=="block"){
				Run(i,"right");
			}
		}
	});
	
	function Run(obj,dir){
		var len,w;
		w=parseInt($("#B"+obj+" li").css("width"))+parseInt($("#B"+obj+" li").css("marginRight"))+parseInt($("#B"+obj+" li").css("marginLeft"))+parseInt($("#B"+obj+" li").css("paddingLeft"))+parseInt($("#B"+obj+" li").css("paddingRight"));
		if(dir=="left"){
			len=parseInt($("#B"+obj).css("left"))-w;
			$("#B"+obj).animate({"left":len+"px"},function(){
				$("#B"+obj).find(":first").remove().appendTo($("#B"+obj));
				$("#B"+obj).css({"left":"0px"});
			});
		}

		if(dir=="right"){
			len=parseInt($("#B"+obj).css("left"))-w;
			$("#B"+obj).find("li:last").prependTo($("#B"+obj)).parent().css({"left":len+"px"});
			$("#B"+obj).animate({"left":0+"px"});
		}
	}	
				
});
function Focus(x){
		$(".title2right a").removeClass("hover");
		$("#A"+x).addClass("hover");
		$(".box").css("display","none");
		$("#B"+x).parent().css("display","block");
}