var w1, h1, imgarr, i=0, timer, oldpointX,  newpointX, menuheight;
w1=$(window).width()-10;
ua=navigator.userAgent.toLowerCase();
$(document).bind('pageinit',function(){
	menuheight=$("#Menu").height();
	$("#Menu").css("top",-menuheight+"px");
	$("#OpenMenu").click(function(){
		$(this).animate({"top":-35+"px"},300,function(){
			$("#Menu").animate({"top":"0px"},400);
		});
	});
	$("#CloseMenu").click(function(){
		$("#Menu").animate({"top":-menuheight+"px"},300,function(){
			$("#OpenMenu").animate({"top":"0px"},400);
		});
	})
	$("#Menu .men li:last").addClass("nonebg");
	$("#GoBack").click(function(){
		history.go(-1);
	});
	$("#Btn4").click(function(){
		$("#Shadow").slideToggle(250);
	});
	$("#Shadow").click(function(){
		$(this).slideToggle(250);
	});
	if($(window).width()<=265){
		$(".btn1, .btn2, .btn3, .btn4").css({"margin":"0px 1px","padding-right":"2px"});
		$(".footer").css({"margin-left":"0px","margin-right":"0px"});
		if(/msie 7.0/i.test(ua)){
			$(".btn1, .btn2, .btn3, .btn4").css({"margin":"0px","padding-right":"2px"});
		}
	}
});

$(window).load(function(){
	imgarr=$("#DH img").length;
	h1=0;
	for(i=0;i<imgarr;i++){
		if($("#DH img").eq(i).height()>h1){h1=$("#DH img").eq(i).height();}
		$("#DH img").eq(i).css("width",w1+"px");
	}
	$("#DH").css("width",w1+"px");
	$("#DH .imgdiv").css({"width":w1*imgarr+"px","height":h1+"px"});

	DH_animate("run");
	i=0;

	$("#DHNum a").click(function(){
		clearTimeout(timer);
		var num=$(this).html();
		$("#DH .imgdiv").stop(true,true).animate({"margin-left":-w1*(num-1)+"px"},800,function(){
			$("#DH .imgdiv").append($("#DH .imgdiv a:first"));
			$("#DH .imgdiv").css("margin-left","0px");
			$("#DHNum a").removeClass("selected");
			i=num-1;
			$("#DHNum a").eq(i).addClass("selected");
			timer=setTimeout(function(){DH_animate("run");},3000);
		});
	});
	$("#DH img").swipeleft(function(e){
		var num;
		clearTimeout(timer);
		if($("#DHNum a.selected").html()==1){
			num=$("#DH img").length-1;
		}else{
			num=$("#DHNum a.selected").prev().html()-1;
		}
		$("#DH .imgdiv").prepend($("#DH .imgdiv a:last"));
		$("#DH .imgdiv").css("margin-left",-w1+"px");
		$("#DHNum a").removeClass("selected");
		$("#DHNum a").eq(num).addClass("selected");
		$("#DH .imgdiv").stop(true,true).animate({"margin-left":"0px"},800,function(){
			timer=setTimeout(function(){DH_animate("run");},3000);
		});
		e.stopPropagation();
		return false;
	});

	$("#DH img").swiperight(function(e){
		var num;
		clearTimeout(timer);
		if($("#DHNum a.selected").html()==$("#DH img").length){
			num=1;
		}else{
			num=$("#DHNum a.selected").next().html()-1;
		}
		$("#DHNum a").removeClass("selected");
		$("#DHNum a").eq(num).addClass("selected");
		$("#DH .imgdiv").stop(true,true).animate({"margin-left":-w1+"px"},800,function(){
			$("#DH .imgdiv").append($("#DH .imgdiv a:first"));
			$("#DH .imgdiv").css("margin-left","0px");
			timer=setTimeout(function(){DH_animate("run");},3000);
		});
		e.stopPropagation();
		return false;
	});
});
function DH_animate(n){
	clearTimeout(timer);
	if(n=="run"){
	timer=setTimeout(function(){
	$("#DH .imgdiv").stop(true,true).animate({"margin-left":-w1+"px"},800,function(){
			$("#DH .imgdiv").append($("#DH .imgdiv a:first"));
			$("#DH .imgdiv").css("margin-left","0px");
			$("#DHNum a").removeClass("selected");
			if(i<imgarr-1){
				i++;
			}else{
				i=0;
			}
			$("#DHNum a").eq(i).addClass("selected");
			DH_animate("run");
		});
	},3000);
		
	}else if(n=="norun"){
		$("#DH .imgdiv").stop(true,true);
	}
}

//в╙фа
$(window).orientationchange(function(e){
	setTimeout(function(){
		w1=$(window).width()-10;
		h1=0;
		for(i=0;i<imgarr;i++){
			$("#DH img").eq(i).css("width",w1+"px");
			if($("#DH img").eq(i).height()>h1){h1=$("#DH img").eq(i).height();}
		}
		$("#DH").css("width",w1+"px");
		$("#DH .imgdiv").css({"width":w1*imgarr+"px","height":h1+"px"});
		i=0;
	},250);
	
});