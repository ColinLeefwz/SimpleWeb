$(function(){
     var len  = $("#DHImage a img").length;/**获取图片数量**/
	 var index = 0;
	 var timer;
	 $("#DHImage ul").css("width",$("#DHImage li").width()*len);
	 $("#DHNum .def").click(function(){
		index = $("#DHNum .def").index(this);/** 获取$("#DHNum .def")数组中关于本元素的索引 **/
		showImg(index);
	 });
	 
	 $("#DH").hover(function(){
			$("#Next, #Prev").css("display","block");
			 clearInterval(timer);
		 },function(){
			 $("#Next, #Prev").css("display","none");
			 timer = setInterval(function(){
				index++;
				if(index==len){index=0;}
			    showImg(index);
			  } , 4000);
	 }).trigger("mouseleave");
	 /** trigger()触发被选元素的指定类型事件 **/
	 
	 /** hover(over , out)当鼠标移动到一个匹配元素上面时会触发指定的第一个函数，当鼠标移出这个元素时会触发指定的第二个函数。而且，会伴随着对鼠标是否仍然处在特定元素中的检测。**/
	 
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
});


function showImg(index){
        var w = $("#DHImage li").width();
		$("#DHImage ul").stop().animate({"margin-left" : -w*index},800);
		$("#DHNum .def").removeClass("selected").eq(index).addClass("selected");
}