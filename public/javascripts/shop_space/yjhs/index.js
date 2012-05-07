$(function(){
     var len  = $("#DHImage a img").length;/**获取图片数量**/
	 var index = 0;
	 var timer;
	 $("#DHImage ul").css("width",$("#DHImage ul li").width()*len);
	 $("#DHNum .def").click(function(){
		index = $("#DHNum .def").index(this);/** 获取$("#DHNum .def")数组中关于本元素的索引 **/
		showImg(index);
	 });
	 
	 $("#DH").hover(function(){
			$("#Next, #Prve").css("display","block");
			 clearInterval(timer);
		 },function(){
			 $("#Next, #Prve").css("display","none");
			 timer = setInterval(function(){
				index++;
				if(index==len){index=0;}
			    showImg(index);
			  } , 3000);
	 }).trigger("mouseleave");
	 /** trigger()触发被选元素的指定类型事件 **/
	 
	 $("#Prev").click(function(){/** 左箭头 **/
		index--;
		if(index<0){index=len-1;}
		showImg(index);
	 });
	 
	 $("#Next").click(function(){/** 右箭头 **/
		index++;
		if(index==len){index=0;}
		showImg(index);
	 });
	function showImg(index){
        var w = $("#DHImage li").width();
		$("#DHImage ul").stop().animate({"margin-left" : -w*index},500,"swing");
		$("#DHNum .def").removeClass("selected").eq(index).addClass("selected");
	}

});