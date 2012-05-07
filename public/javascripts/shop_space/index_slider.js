// JavaScript Document
$(document).ready(function(){
	var conleft_w=$("#ConLeft").width();
	var conright_w=$("#ConRight").width();
	
	$(".slider").click(function(){
		$("#ConLeft").animate({width:0},550,function(){
			$("#ConLeft").css("display","none");
			$("#ConRight").css("width","99%");
			var h;
			if(document.body.scrollTop!=0){
				h=document.body;
			}else{
				h=document.documentElement;
			}
			$("#OpenConLeft").css({"display":"block","top":(h.scrollTop+200)});
		});
	});
	
	$("#OpenConLeft").click(function(){
		$("#ConLeft").css("display","block");
		$("#ConRight").css("width",conright_w);
		$("#ConLeft").animate({width:conleft_w},550,function(){$("#OpenConLeft").css("display","none");});
	});
	
	$(window).scroll(function(){
		if($("#OpenConLeft").css("display")=="none") return false;
		
		var h,old_h,new_h,change,s,top_h=200;
		old_h=parseInt($("#OpenConLeft").css("top"));
		
		if(document.body.scrollTop!=0){
			h=document.body;
		}else{
			h=document.documentElement;
		}
		
		new_h=h.scrollTop+top_h;
		
		if(old_h<new_h){
			clearInterval(s);
			change=true;
		}else if(old_h>new_h){
			clearInterval(s);
			change=false;
		};

		s=setInterval(function(){
			if(change==true){
				old_h+=old_h*0.08;
				$("#OpenConLeft").css("top",old_h);
				if(old_h>new_h){
					old_h=new_h;
					$("#OpenConLeft").css("top",new_h);
					clearInterval(s);
				}
			}else if(change==false){
				old_h-=old_h*0.08;
				$("#OpenConLeft").css("top",old_h);
				if(old_h<new_h){
					old_h=new_h;
					$("#OpenConLeft").css("top",new_h);
					clearInterval(s);
				}
			}
		},70);	
	});
	
	$(".nav .navinner .navtitle").children("li").click(function(){
		$(this).find("ul").slideToggle(300,function(){
			if($(this).css("display")=="block"){
				$(this).prev("span").addClass("picbg");
			}else{
				$(this).prev("span").removeClass("picbg");
			}											
		});
	});
});
