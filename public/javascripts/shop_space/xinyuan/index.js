jQuery(function(){
     var len  = jQuery("#DHImage a img").length;/**获取图片数量**/
	 var n = 0;
	 var timer;
	 jQuery("#DHImage ul").css("width",jQuery("#DHImage li").width()*len);
	 jQuery("#DHNum .def").click(function(){
		n = jQuery("#DHNum .def").index(this);/** 获取jQuery("#DHNum .def")数组中关于本元素的索引 **/
		showImg(n);
	 });
	 
	 jQuery("#DH").hover(function(){
			 clearInterval(timer);
		 },function(){
			 timer = setInterval(function(){
				n++;
				if(n==len){n=0;}
			    showImg(n);
			  } , 4000);
	 }).trigger("mouseleave");
	 /** trigger()触发被选元素的指定类型事件 **/
	 
	 /** hover(over , out)当鼠标移动到一个匹配元素上面时会触发指定的第一个函数，当鼠标移出这个元素时会触发指定的第二个函数。而且，会伴随着对鼠标是否仍然处在特定元素中的检测。**/
	 
	 jQuery("#Prev").click(function(){/** 左箭头 **/
		n--;
		if(n<0){n=len-1;}
		showImg(n);
	 });
	 
	 jQuery("#Next").click(function(){/** 右箭头 **/
		n++;
		if(n==len){n=0;}
		showImg(n);
	 });
});

function showImg(n){
        var w = jQuery("#DHImage li").width();
		jQuery("#DHImage ul").stop().animate({"margin-left" : -w*n},2000,"bounceout");
		jQuery("#DHNum .def").removeClass("selected").eq(n).addClass("selected");
}