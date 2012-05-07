
$(function(){
     var len  = $(".dh .dhnum .nums > a").length;
	 var n=0;
	 var index = 0;
	 var adTimer;
	 $(".dh .dhnum .tit").html($(".dh .dhs img").eq(0).attr("title"));
	 $(".dh .dhnum .nums a").mouseover(function(){
		index  =   $(".dh .dhnum .nums a").index(this);
		if(n!=0){
			for(var i=0;i<len;i++){
					$(".dhs a").eq(i).css({"left":"0","z-index":"0"});
			}
			showImg(index);
		}
		n=1;
	 }).eq(0).mouseover();
	 $('.dh').hover(function(){
			 clearInterval(adTimer);
		 },function(){
			 adTimer = setInterval(function(){
			    showImg(index);
				index++;
				if(index==len){
				for(var i=0;i<len;i++){
					$(".dhs a").eq(i).css({"z-index":"0"});
				}
				index=0;
				
				}
			  } , 2000);//间隔时间2秒
	 }).trigger("mouseleave");
});

// 通过控制left ，来显示不同的幻灯片
function showImg(index){
	    for(var i=0;i<index;i++){
				$(".dhs a").eq(i).css({"z-index":"1"});
		}
		$(".dh .dhnum .tit").html($(".dh .dhs img").eq(index).attr("title"));
		$(".dhs a").eq(index).css({"left":"233px","z-index":"2","dislay":"block"});
		$(".dhs a").eq(index).stop().animate({left : 0},700);//变换时间
		$(".dhnum a").removeClass("selected").eq(index).addClass("selected");
}
