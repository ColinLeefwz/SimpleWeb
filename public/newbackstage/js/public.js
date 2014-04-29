// JavaScript Document
var windowWidth,documentHeight,windowHeight,messageHeight,LinkBoxTimer,ua,MessageDivTimer,CouponPlaneTimer,x0=0,x1=0;
ua=navigator.userAgent.toLowerCase();
$(window).load(function(){
	windowWidth=$(window).width();
	documentHeight=$(document).height();
	windowHeight=$(window).height();
	messageHeight=$("#Message").height();
	//ua="ipad";
	if(windowWidth<=1024){
		$("div.main").css("width","1024px");
		if(parseInt($("#Nav").css("left"))==0){
			$("div.main").stop(true).animate({"width":"830px","padding-left":"160px"});	
		}
	}
	if(/MSIE/i.test(ua)&&documentHeight<=window.screen.height){//针对IE
		$("#Nav").css("height",documentHeight+"px");
		$("#Navcon").css("height",(documentHeight-50)+"px");
	}
	if(documentHeight<=windowHeight){
		$("#Nav").css("height",windowHeight+"px");
		$("#Navcon").css("height",(windowHeight-50)+"px");
	}else{
		$("#Nav").css("height",documentHeight+"px");
		$("#Navcon").css("height",(documentHeight-50)+"px");
	}
	
	$(window).resize(function(){
		windowWidth=$(window).width();
		documentHeight=$(document).height();
		windowHeight=$(window).height();
		if(windowWidth<=1024){
			$("div.main").css("width","1024px");
			if(parseInt($("#Nav").css("left"))==0){
				$("div.main").stop(true).animate({"width":"830px","padding-left":"160px"});	
			}
		}else{
			$("div.main").css({"width":"100%","padding-left":"0px"});
		}
		if(documentHeight<=windowHeight){
			$("#Nav").css("height",windowHeight+"px");
			$("#Navcon").css("height",(windowHeight-50)+"px");
		}else{
			$("#Nav").css("height",documentHeight+"px");
			$("#Navcon").css("height",(documentHeight-50)+"px");
		}
	});
	
	$("#CB1").click(function(){//取消动画
		if($("#CB1").attr("class")=="checkboxs1"){
			$("#CB1").removeClass("checkboxs1").addClass("checkboxs2");
			runing="checkboxs2";
			NavDiv();
			CouponPlane();
			MessageDiv();
		}else if($("#CB1").attr("class")=="checkboxs2"){
			$("#CB1").removeClass("checkboxs2").addClass("checkboxs1");
			runing="checkboxs1";
			NavDiv();
			CouponPlane();
			MessageDiv();
			Photo();
		}
	});
	
	$("#NowPage").click(function(){
		clearTimeout(LinkBoxTimer);
		$("#PageNum").stop().fadeIn(200);
	});
	$("#PageNum").mouseover(function(){
		$("#PageNum").css("display","block");
	}).mouseout(function(){
		$("#PageNum").css("display","none");
	});
	
/*	$("#OpenLinkBox").click(function(){ //右侧脸脸图标，打开弹出菜单
		clearTimeout(LinkBoxTimer);
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
	*/
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
	/*$(".header").css("overflow","visible");
	$("#Message").css("display","none");
	if(runing=="checkboxs1"){
		$("#Message").css("top",-messageHeight+"px");
		$(".header").css("overflow","visible");
		$("#Message").animate({"top":"50px"},1000,function(){
			MessageDivTimer=setTimeout(function(){$("#Message").fadeOut(500,function(){
				$("#Message").css({"top":-messageHeight+"px", "display":"block"});
			});},8000);
		});
		$("#Message").mouseover(function(){
			MessageDivTimer=setTimeout(function(){$("#Message").fadeOut(500,function(){
				$("#Message").css({"top":-messageHeight+"px", "display":"block"});
			});},2000);
		});
	}else if(runing=="checkboxs2"){
		clearTimeout(MessageDivTimer);
		$("#Message").unbind();
		$(".header").css("overflow","visible");
		$("#Message").css({"top":"50px","display":"block"});
	}*/
}

function NavDiv(){//菜单
	windowWidth=$(window).width();
	if(navmove=="on"){
		$("#Nav").css({"left":"-160px"});
		if(windowWidth<=1024){
			$("div.main").stop(true).css({"width":"1024px","padding-left":"0px"});
		}
	}else{
		$("#Btn").addClass("dis").html("<img src='/newbackstage/images/sign1.png' align='absmiddle'/> 取消固定导航");
		$("#Nav").stop(true).animate({"left":"0px"},250);
		if(windowWidth<=1024){
			$("div.main").stop(true).animate({"width":"830px","padding-left":"160px"});
		}else{
			$("div.main").css("width","100%");
		}
	}
	if(runing=="checkboxs1"){
		if(/ipad/i.test(ua)){
			$("#OpenNav").click(function(e){
				if(navmove=="on"){
					if($("#Nav").css("left")=="160px") return false;
					$("#Nav").stop(true).animate({"left":"0px"},250);
					windowWidth=$(window).width();
					if(windowWidth<=1024){
						$("div.main").stop(true).animate({"width":"830px","padding-left":"160px"});
					}else{
						$("div.main").css("width","100%");
					}
				}
			});
			$("#CloseNav").click(function(){
				if(navmove=="on"){
					$("#Nav").stop(true,true).animate({"left":"-160px"},250);
					windowWidth=$(window).width();
					if(windowWidth<=1024){
						$("div.main").stop(true).animate({"width":"1024px","padding-left":"0px"});
					}else{
						$("div.main").css("width","100%");
					}
				}
				e.stopPropagation();
			});			
		}else{
			$("#Nav").mouseout(function(e){
				if(navmove=="on"){
					$("#Nav").stop(true,true).animate({"left":"-160px"},250);
					windowWidth=$(window).width();
					if(windowWidth<=1024){
						$("div.main").stop(true).animate({"width":"1024px","padding-left":"0px"});
					}else{
						$("div.main").css("width","100%");
					}
				}
			});
			
			$(document).mousemove(function(e){
				if(navmove=="on"){
					if(parseInt(e.pageX)<=160){
						$("#Nav").stop(true).animate({"left":"0px"},250);
						windowWidth=$(window).width();
						if(windowWidth<=1024){
							$("div.main").stop(true).animate({"width":"830px","padding-left":"160px"});
						}else{
							$("div.main").css("width","100%");
						}
					}	
				}
			});
		}


		$("#Btn").click(function(){
			   if($.cookie( 'navmove' ) =="on"){
				navmove="off";
				// window.localStorage.navmove = "off";
				removecookie();
				$.cookie( 'navmove', 'off', { path: '/' } );
				


				$("#Btn").addClass("dis").html("<img src='/newbackstage/images/sign1.png' align='absmiddle'/> 取消固定导航");;

				$("#Nav").unbind();
				$(document).unbind("mouseout");
				$(document).unbind("mouseover");
				$("#OpenNav").unbind();
				$("#CloseNav").unbind();
				$("#Nav").stop(true,true).css({"left":"0px"});
				if(windowWidth<=1024){
					$("div.main").stop(true).animate({"width":"830px","padding-left":"160px"});
				}

			  }else if($.cookie( 'navmove' ) =="off"){
				navmove="on";
				// window.localStorage.navmove = "on";
				removecookie();
				$.cookie( 'navmove', 'on', { path: '/' } );


				$("#Nav").unbind();
				$(document).unbind("mouseout");
				$(document).unbind("mouseover");
				$("#OpenNav").unbind();
				$("#CloseNav").unbind();

				$("#Btn").removeClass("dis").html("<img src='/newbackstage/images/sign1.png' align='absmiddle'/> 固定左侧导航");

				NavDiv();
			}
		});
		$("#Btn").mouseover(function(){
			$("Nav").stop(true,true).animate({"top":"0px"});				 
		});
	}else if(runing=="checkboxs2"){
		$(document).unbind();
		$("#Nav").unbind();
		$("#Btn").unbind();
		$("#OpenNav").unbind();
		$("#CloseNav").unbind();
		$("#Nav").stop(true,true).css("left","0px");	
	}
	
}

function removecookie(){//清除每次生成的多余路径
	$.removeCookie('navmove', { path: '/shop3_coupons/' });
	$.removeCookie('navmove', { path: '/shop3_content/' });
	$.removeCookie('navmove', { path: '/shop3_checkins/' });
	$.removeCookie('navmove', { path: '/shop3_staffs/' });
	// $.removeCookie('navmove', { path: '/*' });
}

function Menus(){//首页：手机头
	$("a.menu1, a.menu2, a.menu3, a.menu4, a.menu5, a.menu6").css("height","0px");
	$("span.box1line1, span.box1line2, span.box1line3").css({"width":"0px","left":"320px"});
	$("span.box1line4,span.box1line5, span.box1line6").css({"width":"0px"});
	$("span.box1line1, span.box1line2, span.box1line3").animate({"width":"138px","left":"173px"},1400);
	$("span.box1line4").animate({"width":"179px"},1400);
	$("span.box1line5, span.box1line6").animate({"width":"138px"},1400,function(){
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
function CouponPlane(){
	if(runing=="checkboxs1"){
		$("div.box3plane1").css("top","0px");
		$("div.box3plane2").css("left","-186px");
		$("div.box3plane3").css("right","-210px");
	
		if(/ipad/i.test(ua)){
			$("div.box3inner").click(function(){
				var obj=$(this);
				obj.siblings().find("div.box3plane1").stop(true,true).animate({"top":"0px"},1100,"expoout");
				obj.siblings().find("div.box3plane2").css({"left":"-186px"});
				obj.siblings().find("div.box3plane3").css({"right":"-210px"});
				obj.find("div.box3plane1").stop(true,true).animate({"top":"-156px"},1100,"expoout");
				obj.find("div.box3plane2").stop(true,true).animate({"left":"0px"},600);
				obj.find("div.box3plane3").stop(true,true).animate({"right":"0px"},600);
				
				CouponPlaneTimer=setTimeout(function(){
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
	}else if(runing=="checkboxs2"){
		clearTimeout(CouponPlaneTimer);
		$("div.box3inner").unbind();
		$("div.box3plane1").stop(true,true).css("top","-186px");
		$("div.box3plane2").css("left","0px");
		$("div.box3plane3").css("right","0px");
	}
}

/*function Del(id){//问答系统管理：删除
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
}*/

function ShowDiv(){//问答系统管理：显示
	var num=parseInt($("div.box4plane2:last").attr("rel")) ? parseInt($("div.box4plane2:last").attr("rel")): 0;
	var opacity=1,n,i=0,x=0,z=0;
	var arr=new Array(num);
	
	$("#Waterfall .box4plane1, #Waterfall .box4plane2").css("display","none");
	for(;x<=num;x++){
		arr[x]="flighting";
	}
	while(opacity){
		n=parseInt(Math.random()*（num＋1）);
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
	$("#Dn2_b0,#Dn2_b2").css("height","0px");
	$("#Dn2_b1").css({"height":"0px","top":"380px"});
	//$("div.box2left1").css("width","0px");

	$("#Dn2_b0,#Dn2_b2").animate({"height":"380px"},1600,"backout");
	$("#Dn2_b1").animate({"height":"380px","top":"0px"},1300,"backinout");
	//$("div.box2left1").animate({"width":"620px"},1000,"backin");
	//$("div.box2right1").animate({"height":"380px"},1000,"backin");
}
function AllNoDH(){//取消动画
	$(".header").css("overflow","visible");
		$("#Nav").animate({"left":"0px"},250);
	if(windowWidth<=1024){
		$("div.main").stop(true).animate({"width":"830px","padding-left":"160px"});
	}else{
		$("div.main").css("width","100%");
	}
}
function Photo(){//照片墙动画
	var arr=new Array($("div.box9plane").length);
	var ns, box9planeTimer;
	if(runing=="checkboxs1"&&noing=="run"){
		for(ns=0;ns<$("div.box9plane").length;ns++){
			arr[ns]=parseInt($("div.box9plane").eq(ns).css("top"));
			$("div.box9plane").eq(ns).css("top","666px"); 
		}
		ns=0;
		box9planeTimer=setInterval(function(){
			$("div.box9plane").eq(ns).animate({"top":arr[ns]+"px"},500);
			ns++;
			if(ns==$("div.box9plane").length){clearInterval(box9planeTimer);}
		},250);	
	}else if(runing=="checkboxs2"){
		clearInterval(box9planeTimer);
		if($("div.box9plane").eq(ns).html()!=""){
			$('#Waterfall').BlocksIt({
				numOfCol: 5,
				offsetX: 10,
				offsetY: 8,
				blockElement: 'div'
			});	
		}
	}
}