$(function(){
     var len  = $("#DHNum > a").length;
	 var index = 0;//用于控制选择指定的#DHNum li类
	 var adTimer;//用于控制循环setInterval
	 $(".dh .dhinner ul").css("width",len*$(".dh .dhinner").width());
	 
	 $("#DHNum a").mouseover(function(){
		index  =   $("#DHNum a").index(this);
		showImg(index);
	 }).eq(0).mouseover();
	 
	 //鼠标覆盖.ad类时停止动画，鼠标离开.ad类时开始动画.
	 $('#DHNum').hover(function(){
			 clearInterval(adTimer);
		 },function(){//此函数是.ad类触发mouseleave事件时执行的函数
			 adTimer = setInterval(function(){
			    showImg(index)
				index++;
				if(index==len){index=0;}
			  } , 4000);//间隔时间
	 }).trigger("mouseleave");
});

// 通过控制bottom ，来显示不同的幻灯片
function showImg(index){
        var adWidth = $(".dh .dhinner").width();
		$(".dh .dhinner ul").stop().animate({left : -adWidth*index},800);
		$("#DHNum a").removeClass("selected").eq(index).addClass("selected");
}