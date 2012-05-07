$(document).ready(function(){
	$("#DH a img").css("display","none");
	$("#DH a img").eq(0).css("display","block");
	(function(){
		var curr = 0,j=0,num;
	    num=$("#DH img").length;	
		
		$("#DHNum .def").each(function(i){
			$(this).click(function(){
				curr = i;
				$("#DH a img").css("z-index","0");
				if(i==1){$("#DH a img").css("display","none");$("#DH a img").eq(0).css("display","block");}
				$("#DH").find("img").eq(i).hide();
				$("#DH").find("img").eq(i).fadeIn(2500).css("z-index","1");
				$(this).siblings(".def").removeClass("selected").end().addClass("selected");
				return false;
			});
		});
		
		var pg = function(flag){
			if (flag) {
				if (curr == 0) {
					todo = num-1;
				} else {
					todo = (curr - 1) % num;
				}
				
			} else {
				todo = (curr + 1) % num;
				
			}
			$("#DHNum .def").eq(todo).click();
		};
		
		//单击左箭头
		$("#Prev").click(function(){
			pg(true);
			return false;
		});
		
		//单击右箭头
		$("#Next").click(function(){
			pg(false);
			return false;
		});
		
		//Զ
		var timer = setInterval(function(){
			todo = (curr+1) % num;
			$("#DHNum .def").eq(todo).click();
		},4000);
		
		
		$("#DHNum a").mouseover(function(){
				clearInterval(timer);
			}
		);
		$("#DHNum a").mouseout(
			function(){
				timer = setInterval(function(){
					todo = (curr+1) % num;
					$("#DHNum .def").eq(todo).click();
				},4000);
			}
		);
	})();
});


var Speed_1 = 16; //速度(毫秒)
var Space_1 = 18; //每次移动(px)
var PageWidth_1 = 300 ; //翻页宽度
var interval_1 = 5000; //翻页间隔时间（单位毫秒）
var fill_1 = 0; //整体移位
var MoveLock_1 = false;
var MoveTimeObj;
var Comp_1 = 0,ax;
var AutoPlayObj=null;
 
 
/*此段程序滚动方向从右往左*/
function GetObj(objName){
	if(document.getElementById){//用if……else是为了兼容IE和火狐
		return eval('document.getElementById("'+objName+'")');
	}else{
		return eval('document.all.'+objName);
	}
}
function AutoPlay(){ //自动滚动
	clearInterval(AutoPlayObj);
	AutoPlayObj = setInterval('Ani_GoDown();Ani_StopDown();',interval_1); /*setInterval()调用Ani_GoDown();Ani_StopDown()的作用是向下运行、暂停。*/
}
function Ani_GoUp(){ //上翻开始
    if(ax==0){
		return;
	}else{
		if(MoveLock_1) return;
		clearInterval(AutoPlayObj);
		MoveLock_1 = true;
		MoveTimeObj = setInterval('Ani_ScrUp();',Speed_1);
	}
	
}
function Ani_StopUp(){ //上翻停止
	clearInterval(MoveTimeObj);
	if(GetObj('Cont1').scrollLeft % PageWidth_1 - fill_1 != 0){
		Comp_1 = fill_1 - (GetObj('Cont1').scrollLeft % PageWidth_1);
		Comp_1Scr();
	}else{
		MoveLock_1 = false;
	}
	AutoPlay();/*自动翻页，若不要自动则此处要删除*/
}
function Ani_ScrUp(){ //上翻动作
	if(GetObj('Cont1').scrollLeft <= 0){
		GetObj('Cont1').scrollLeft = GetObj('Cont1').scrollLeft + GetObj('List1_1').offsetWidth;
	}
	GetObj('Cont1').scrollLeft -= Space_1 ;
}
function Ani_GoDown(){ //下翻

	if(ax==0){
		return;
	}else{
		clearInterval(MoveTimeObj);
		if(MoveLock_1) return;
		clearInterval(AutoPlayObj);
		MoveLock_1 = true;
		Ani_ScrDown();//执行下翻动作函数
		MoveTimeObj = setInterval('Ani_ScrDown()',Speed_1);
	}
}
function Ani_StopDown(){ //下翻停止
	clearInterval(MoveTimeObj);
	if(GetObj('Cont1').scrollLeft % PageWidth_1 - fill_1 != 0 ){
		Comp_1 = PageWidth_1 - GetObj('Cont1').scrollLeft % PageWidth_1 + fill_1;
		Comp_1Scr();
	}else{
		MoveLock_1 = false;
	}
	AutoPlay();/*自动翻页，若不要自动则此处要删除*/
}
function Ani_ScrDown(){ //下翻动作
	if(GetObj('Cont1').scrollLeft >= GetObj('List1_1').scrollWidth){
	
		GetObj('Cont1').scrollLeft =GetObj('Cont1').scrollLeft - GetObj('List1_1').scrollWidth;
	}
	GetObj('Cont1').scrollLeft += Space_1 ;
}
function Comp_1Scr(){
	var num;
	if(Comp_1 == 0){MoveLock_1 = false;return;}
	if(Comp_1 < 0){ //上翻
		if(Comp_1 < -Space_1){
		   Comp_1 += Space_1;
		   num = Space_1;
		}else{
		  num = -Comp_1;
		  Comp_1 = 0;
		}
		GetObj('Cont1').scrollLeft -= num;
		setTimeout('Comp_1Scr()',Speed_1);
	}else{ //下翻
		if(Comp_1 > Space_1){
		   Comp_1 -= Space_1;
		   num = Space_1;
		}else{
		   num = Comp_1;
		   Comp_1 = 0;
	}
	
	GetObj('Cont1').scrollLeft += num;
	setTimeout('Comp_1Scr()',Speed_1);
	}
}
 
function photoalbum(){//photoalbum函数只在页面刚载入的时候调用
	var names=document.getElementsByName("xf");
	if(names.length<=3){
		document.getElementById("List2_1").style.display="none";
		ax=0;
	}else{
		ax=1;
		document.getElementById("List2_1").style.display="block";
		GetObj("List2_1").innerHTML=GetObj("List1_1").innerHTML;
		GetObj('Cont1').scrollLeft=fill_1>=0?fill_1:GetObj('List1_1').scrollWidth-Math.abs(fill_1);
		GetObj("Cont1").onmouseover=function(){ clearInterval(AutoPlayObj); }
		GetObj("Cont1").onmouseout=function(){AutoPlay();}
		AutoPlay();
	}
}