// JavaScript Document
function GetObj(objName){
	if(document.getElementById){
		return eval('document.getElementById("'+objName+'")')
	}else{
		return eval('document.all.'+objName)
	}
}
function AutoPlay1(){ //自动滚动
	clearInterval(AutoPlayObj1);
	AutoPlayObj1 = setInterval('GoDown();StopDown();',5000);
}

function GoUp(){ //上翻开始
	if(MoveLock1) return;
	clearInterval(AutoPlayObj1);
	MoveLock1 = true;
	MoveTimeObj1 = setInterval('ScrUp();',Speed1);
}
function StopUp(){ //上翻停止
	clearInterval(MoveTimeObj1);
	if(GetObj('ISL_Cont1').scrollLeft % PageWidth1 - fill1 != 0){
		Comp1 = fill1 - (GetObj('ISL_Cont1').scrollLeft % PageWidth1);
		Comp1Scr();
	}else{
		MoveLock1 = false;
	}
}
function ScrUp(){ //上翻动作
	if(GetObj('ISL_Cont1').scrollLeft <= 0){
		GetObj('ISL_Cont1').scrollLeft = GetObj('ISL_Cont1').scrollLeft + GetObj('pic3').offsetWidth;
	}
	GetObj('ISL_Cont1').scrollLeft -= Space1 ;
}
function GoDown(){ //下翻
	clearInterval(MoveTimeObj1);
	if(MoveLock1) return;
	clearInterval(AutoPlayObj1);
	MoveLock1 = true;
	ScrDown();//执行下翻动作函数
	MoveTimeObj1 = setInterval('ScrDown()',Speed1);
}
function StopDown(){ //下翻停止
	clearInterval(MoveTimeObj1);
	if(GetObj('ISL_Cont1').scrollLeft % PageWidth1 - fill1 != 0 ){
		Comp1 = PageWidth1 - GetObj('ISL_Cont1').scrollLeft % PageWidth1 + fill1;
		Comp1Scr();
	}else{
		MoveLock1 = false;
	}
	}
function ScrDown(){ //下翻动作
	if(GetObj('ISL_Cont1').scrollLeft >= GetObj('pic3').scrollWidth){
		GetObj('ISL_Cont1').scrollLeft =GetObj('ISL_Cont1').scrollLeft - GetObj('pic3').scrollWidth;
	}
	GetObj('ISL_Cont1').scrollLeft += Space1 ;
}
function Comp1Scr(){
	var num1;
	if(Comp1 == 0){MoveLock1 = false;return;}
	if(Comp1 < 0){ //上翻
		if(Comp1 < -Space1){
		   Comp1 += Space1;
		   num1 = Space1;
		}else{
		  num1 = -Comp1;
		  Comp1 = 0;
		}
		GetObj('ISL_Cont1').scrollLeft -= num1;
		setTimeout('Comp1Scr()',Speed1);
	}else{ //下翻
		if(Comp1 > Space1){
		   Comp1 -= Space1;
		   num1 = Space1;
		}else{
		   num1 = Comp1;
		   Comp1 = 0;
	}
	GetObj('ISL_Cont1').scrollLeft += num1;
	setTimeout('Comp1Scr()',Speed1);
	}
}