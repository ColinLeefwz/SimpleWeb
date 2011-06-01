// JavaScript Document
$(document).ready(function(){
	SC();
	ConHeight();
	$(window).resize(function(){
		SC();
		ConHeight();
	});
	
	function SC(){
		$("#SC a").each(function(){$(this).css({"width":$(window).width()+"px"});});
	}
	
	function ConHeight(){//获取con层的高度
		var conheight=$(window).height()-$("#header").height()-$("#foot, #ch_foot").height();
		$("#con").css("height",conheight+"px");		
	}

	
	$("#shake").click(function(){
		$("#BG, #BGImg").css("display","block");
		var left=($(window).width()-$("#BGImg").width())/2;
		var top=($(window).height()-$("#BGImg").height())/2;
		$("#BGImg").css({"left":left+"px", "top":top+"px"});
		for(var i=5; i>0; i--){
			for(var j=i; j>0; j--){
				$("#BGImg").animate({"left":left+"px","top":top+5+"px"},30);
				$("#BGImg").animate({"left":left+5+"px","top":top+"px"},30);
				$("#BGImg").animate({"left":left+"px","top":top-5+"px"},30);
				$("#BGImg").animate({"left":left-5+"px","top":top+"px"},30);
			}	
		}
	});
	
	$("#BGImg").click(function(){
		$("#BG, #BGImg").css("display","none");
	});
});

								 
	