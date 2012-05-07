/** 首页滚动图片动画 **/
$(document).ready(function(){
	var lens=105,w,num;
	num=$("#B1 li").length;
	w=num*lens;
	$("#B1").css("width",w);
	$("#LeftArrow").click(function(){						   
		if(parseInt($("#B1").css("left"))==0){return false;}
		Runs("left");
		ShowBox("left");
	});

	$("#RightArrow").click(function(){
		if(parseInt($("#B1").css("width"))+parseInt($("#B1").css("left"))-5==parseInt($("#CM2Rinner").css("width"))){return false;}
		Runs("right");
		ShowBox("right");
	});
	
	function Runs(dir){
		lefts=parseInt($("#B1").css("left"));
		if(dir=="left"){
			$("#B1").animate({"left":(lefts+lens)},700);
		}
		if(dir=="right"){
			$("#B1").animate({"left":(lefts-lens)},700);
		}	
	 }
	function ShowBox(dir){
		var ws=$("#ConMiddle3").width()-$("#CM3Box").width();
		var ws2=$("#B1").width()-parseInt($("#CM2Rinner").css("width"));

		var ratio=ws/ws2;
		var lefts=parseInt($("#CM3Box").css("left"));
		if(dir=="left"){
			if(parseInt($("#B1").css("left"))==-lens){lefts=0;ratio=0;}
			$("#CM3Box").animate({"left":parseInt(lefts-lens*ratio)},1000);
		}
		if(dir=="right"){
			if(parseInt($("#B1").css("width"))+parseInt($("#B1").css("left"))-5==parseInt($("#CM2Rinner").css("width"))+lens){lefts=ws;ratio=0;}
			
			$("#CM3Box").animate({"left":parseInt(lefts+lens*ratio)},1000);	
		}
	}
	
	/*$("#CM3Box").mousemove(function(e){
		var w=parseInt($("#CM3Box").css("width"));
		var ws=$("#ConMiddle3").width()-$("#CM3Box").width();
		w=e.clientX-80;
		$("#CM3Box").css("left",(w)+"px");
		if(parseInt($("#CM3Box").css("left"))<=0){
			$("#CM3Box").css("left",0);
		}else if(parseInt($("#CM3Box").css("left"))>=ws){
			$("#CM3Box").css("left",ws);
		}
	});*/
});
