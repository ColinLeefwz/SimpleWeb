// JavaScript Document
$(window).load(function(){
	var bodywidth=$("body").width();
	var bodyheight=$("body").height();
	var scrollLeft=$(document).scrollLeft();
	var scrollTop=$(document).scrollTop();
	var clientWidth=document.documentElement.clientWidth;
	var clientHeight=document.documentElement.clientHeight;
	var imgwidth,imgheight;
	if(bodywidth<window.screen.availWidth){
		bodyWidth=window.screen.availWidth;
	}
	if(bodyheight<window.screen.availHeight){
		bodyheight=window.screen.availHeight;
	}
	$("#BG").css({"width":bodywidth+"px","height":bodyheight+"px"});
	$("#BGimg").css({"top":bodywidth/2+"px","left":bodyheight/2+"px"});
	
	$("#PicList li a").click(function(){
		var src,src2;
		var src=$(this).find("img:first").attr("src");
		var src2=src.substring(src.lastIndexOf("/")+1);
		$("#BGimg").find("img:first").attr("src","images/"+src2);
		clientWidth=document.documentElement.clientWidth;
		clientHeight=document.documentElement.clientHeight;
		scrollLeft=$(document).scrollLeft();
		scrollTop=$(document).scrollTop();
		imgwidth=$(this).find("img:first").width();
		imgheight=$(this).find("img:first").height();		
		$("#BGimg").css({"width":imgwidth+"px","height":imgheight+"px","top":(clientHeight-imgheight)/2+scrollTop+"px","left":(clientWidth-imgwidth)/2+scrollLeft+"px"}).fadeIn(800);
		$("#BG").css("display","block");
		return false;
	});
	
	$("#CloseBg").click(function(){
		$("#CloseBg").css("display","none");
		$("#BGimg").animate({"height":"0px"},500,function(){$(this).css("display","none");$("#BG").css("display","none");$("#CloseBg").css("display","block");});
	});
	
	$(window).scroll(function(){
		if($("#BGimg").css("display")!="none"){
			bodywidth=$("body").width();
			bodyheight=$("body").height();
			clientWidth=document.documentElement.clientWidth;
			clientHeight=document.documentElement.clientHeight;
			scrollLeft=$(document).scrollLeft();
			scrollTop=$(document).scrollTop();
			$("#BG").css({"width":bodywidth+scrollLeft+"px","height":bodyheight+"px"});
			$("#BGimg").animate({"top":(clientHeight-imgheight)/2+scrollTop+"px","left":(clientWidth-imgwidth)/2+scrollLeft+"px"},1);
		}
	});
	
	$(window).resize(function(){
		if($("#BGimg").css("display")!="none"){
			bodywidth=$("body").width();
			bodyheight=$("body").height();
			clientWidth=document.documentElement.clientWidth;
			clientHeight=document.documentElement.clientHeight;
			scrollLeft=$(document).scrollLeft();
			scrollTop=$(document).scrollTop();
			$("#BG").css({"width":bodywidth+"px","height":bodyheight+"px"});
			$("#BGimg").animate({"top":(clientHeight-imgheight)/2+scrollTop+"px","left":(clientWidth-imgwidth)/2+scrollLeft+"px"},800);
		}
	});

});