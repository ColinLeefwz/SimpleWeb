// JavaScript Document
var documentHeight,windowHeight,messageHeight,LinkBoxTimer,ua;

$(document).ready(function(){
	documentHeight=$(document).height();
	windowHeight=$(window).height();
	messageHeight=$("#Message").height();
	
	ua=navigator.userAgent;
	//ua="ipad";
	
	if(documentHeight<=windowHeight){
		$("#Nav").css("height",windowHeight+"px");
		$("#Navcon").css("height",(windowHeight-50)+"px");
	}
	
	$("#OpenLinkBox").click(function(){
		$("#LinkBox").stop().fadeIn(200).animate({"top":"60px"},300);
	}).mouseout(function(){
		LinkBoxTimer=setTimeout(function(){
			$("#LinkBox").css({"display":"none","top":"80px"});				 
		},1000);
	});
	$("#LinkBox").mouseover(function(){
		clearTimeout(LinkBoxTimer);
		$(this).css({"display":"block","top":"60px"});
	});
	$("#LinkBox").mouseout(function(){
		$(this).css({"display":"none","top":"80px"});
	});
	
	$("#LinkBox a.links2").click(function(){
		window.location.href='http://shop.dface.cn';
	});
});

function Dn2_divplane(){//首页：最新数据动画
	var i,num,n;
	num=$("#Dn2 .box2plane").length;
	var arr=new Array(num);
	for(i=0;i<num;i++){
		$("#Dn2_b"+i).css("top","242px");
		arr[i]="number";
	}
	i=1;
	while(i==1){
		n=parseInt(Math.random()*10);
		if(n<num){
			if(arr[0]=="number"){
				arr[0]=n;continue;
			}else if(arr[0]==arr[1]||arr[1]=="number"){
				arr[1]=n;continue;
			}else if(arr[0]==arr[2]||arr[1]==arr[2]||arr[2]=="number"){
				arr[2]=n;continue;
			}else if((arr[0]==arr[3])||(arr[1]==arr[3])||(arr[2]==arr[3])||(arr[3]=="number")){
				arr[3]=n;continue;
			}else{
				i=0;
			}
		}
	}
	for(i=0;i<num;i++){
		$("#Dn2_b"+arr[i]).delay(500+80*i).animate({"top":"0px"},500);
	}
}
function MessageDiv(){//消息通知框
	$("#Message").css("top",-messageHeight+"px");
	$(".header").css("overflow","visible");
	$("#Message").animate({"top":"50px"},1000,function(){
		setTimeout(function(){$("#Message").fadeOut(500,function(){
			$("#Message").css({"top":-messageHeight+"px", "display":"block"});
		});},8000);
	});
	$("#Message").mouseover(function(){
		setTimeout(function(){$("#Message").fadeOut(500,function(){
			$("#Message").css({"top":-messageHeight+"px", "display":"block"});
		});},2000);
	});
}

function NavDiv(){//菜单
	var i=1;
	$("#Nav").animate({"left":"-160px"},800);
	$(document).mousemove(function(e){
		if(parseInt(e.pageX)<=160){
			$("#Nav").stop(true).animate({"left":"0px"},250);
		}
	});
	$("#Nav").mouseout(function(e){
		$("#Nav").stop(true,true).animate({"left":"-160px"},250);
	});
	
	$("#Btn").toggle(
		function(){
			$("#Btn").addClass("dis");
			$("#Nav").unbind("mouseout");
			$(document).unbind("mousemove");
		},
		function(){
			$("#Btn").removeClass("dis");
			$("#Nav").bind("mouseout",function(){$("#Nav").stop().animate({"left":"-160px"},250);});
			$(document).bind("mousemove",function(e){
				if(parseInt(e.pageX)<=160){
					$("#Nav").stop().animate({"left":"0px"},250);
				}
			});
		}
	);
}
function Menus(){//首页：手机头
	$("a.menu1, a.menu2, a.menu3, a.menu4, a.menu5, a.menu6").css("height","0px");
	$("span.box1line1, span.box1line2, span.box1line3").css({"width":"0px","left":"320px"});
	$("span.box1line4,span.box1line5, span.box1line6").css({"width":"0px"});
	$("span.box1line1, span.box1line2, span.box1line3").animate({"width":"138px","left":"173px"},2000);
	$("span.box1line4").animate({"width":"179px"},2000);
	$("span.box1line5, span.box1line6").animate({"width":"138px"},2000,function(){
		$("a.menu1, a.menu2, a.menu3, a.menu4, a.menu5, a.menu6").animate({"height":"55px"},500);
	});
}
function Tag(obj){//滑动门一
	$(obj).siblings().removeClass("hover").end().addClass("hover");
}
function SlideDoor(obj,id){//滑动门二
	$(obj).siblings().removeClass("hover").end().addClass("hover");
	$("#Door"+id).siblings("ul.list2").css("display","none").end().show(500);
}
function CouponPlane(){//优惠券管理
	$("div.box3plane1").css("top","0px");
	$("div.box3plane2").css("left","-186px");
	$("div.box3plane3").css("right","-210px");
	
	if(/pad/i.test(ua)){
		$("div.box3inner").click(function(){
			var obj=$(this);
			obj.siblings().find("div.box3plane1").stop(true,true).animate({"top":"0px"},1100,"expoout");
			obj.siblings().find("div.box3plane2").css({"left":"-186px"});
			obj.siblings().find("div.box3plane3").css({"right":"-210px"});
			obj.find("div.box3plane1").stop(true,true).animate({"top":"-156px"},1100,"expoout");
			obj.find("div.box3plane2").stop(true,true).animate({"left":"0px"},600);
			obj.find("div.box3plane3").stop(true,true).animate({"right":"0px"},600);
			
			setTimeout(function(){
				obj.find("div.box3plane2").css({"left":"-186px"});
				obj.find("div.box3plane3").css({"right":"-210px"});
				obj.find("div.box3plane1").stop(true,true).animate({"top":"0px"},1100,"expoout");
			},5000);
		});
		
	}else{
		$("div.box3inner").stop(true,true).hover(
		function(){
			$(this).find("div.box3plane1").stop(true,true).animate({"top":"-156px"},1100,"expoout");
			$(this).find("div.box3plane2").stop(true,true).animate({"left":"0px"},600);
			$(this).find("div.box3plane3").stop(true,true).animate({"right":"0px"},600);
		}
		
		,function(){
			$(this).find("div.box3plane2").css({"left":"-186px"});
			$(this).find("div.box3plane3").css({"right":"-210px"});
			$(this).find("div.box3plane1").stop(true,true).animate({"top":"0px"},1100,"expoout");
		});
	}
}

function Del(id){//问答系统管理：删除
	var div=$("#Div"+id);
	var height=div.height();
	var size;
	var rel=parseInt(div.attr("rel"));
	if(height>300){
		size=300;
	}else{
		size=height;
	}
	var i=5;
	div.append("<div class='shade' style='height:"+height+"px;line-height:"+height+"px;'><span style='opacity:0.5;font-size:"+size+"px;'>"+i+"</span></div>");
	
	$(".shade").click(function(){
		clearInterval(timer);
		$(this).remove();			
	});
	
	var timer=setInterval(function(){
		div.children("div.shade").find("span").animate({"font-size":(size/2)+"px","opacity":"1"},650,function(){
			if(i==1){
				clearInterval(timer);
				div.remove();
				var top=height+21;
				var left=parseInt(div.css("left"));
				var delay=1;
				div.animate({"height":"0px","padding-top":"0px"},500,function(){div.css("display","none");});
				
				for(rel=rel;rel<=num;rel++){
					if(parseInt($("#Div"+rel).css("left"))==left){
						$("#Div"+rel).animate({"top":parseInt($("div.box4plane2[rel="+rel+"]").css("top"))-top+"px"},700*delay);
						delay+=0.4;
					}
				}
				
			}else{
				div.children("div.shade").find("span").html(--i).css({"font-size":size+"px","opacity":"0.5"});
			}
		});
	},670);
}
function ShowDiv(){//问答系统管理：显示
	var num=parseInt($("div.box4plane2:last").attr("rel"));
	var opacity=1,n,i=0,x=0,z=0;
	var arr=new Array(num);
	
	$("#Waterfall .box4plane1, #Waterfall .box4plane2").css("display","none");
	for(;x<=num;x++){
		arr[x]="flighting";
	}
	while(opacity){
		n=parseInt(Math.random()*10);
		if(n<=num){
			for(x=0;x<=num;x++){
				if(arr[x]!=n){
					z++;
				}else{
					break;
				}
			}
			if(z==(num+1)){
				arr[i]=n;
				i++;
			}
			z=0;
			if(i==(num+1)){opacity=0;}
		}
	}
	x=0;
	//alert(arr[0]+"   "+arr[1]+"   "+arr[2]+"   "+arr[3]+"   "+arr[4]+"   "+arr[5]+"   "+arr[6]+"   "+arr[7]);
	var timer=setInterval(function(){
			$("#Div"+arr[x]).fadeIn(650);
			if(x!=num){
				x++;
			}else{
				clearInterval(timer);
			}
		},180);
}
function DH(){//数据统计动画
	$("#Dn2_b0,#Dn2_b2,div.box2right1").css("height","0px");
	$("#Dn2_b1,#Dn2_b3").css({"height":"0px","top":"380px"});
	$("div.box2left1").css("width","0px");

	$("#Dn2_b0,#Dn2_b2").animate({"height":"380px"},1300,"backout");
	$("#Dn2_b1,#Dn2_b3").animate({"height":"380px","top":"0px"},1000,"backinout");
	$("div.box2left1").animate({"width":"620px"},1000,"backin");
	$("div.box2right1").animate({"height":"380px"},1000,"backin");
}