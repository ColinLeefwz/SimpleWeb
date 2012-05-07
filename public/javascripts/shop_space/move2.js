// JavaScript Document
function GetObj(objName){
	if(document.getElementById){
		return eval('document.getElementById("'+objName+'")')
	}else{
		return eval('document.all.'+objName)
	}
}
function AutoPlay(){ //自动滚动
	clearInterval(AutoPlayObj);
	AutoPlayObj = setInterval('ISL_GoDown();ISL_StopDown();',5000); 
}

function ISL_GoUp(){ //上翻开始
	if(MoveLock) return;
	clearInterval(AutoPlayObj);
	MoveLock = true;
	MoveTimeObj = setInterval('ISL_ScrUp();',Speed);
}
function ISL_StopUp(){ //上翻停止
	clearInterval(MoveTimeObj);
	if(GetObj('ISL_Cont').scrollLeft % PageWidth - fill != 0){
		Comp = fill - (GetObj('ISL_Cont').scrollLeft % PageWidth);
		CompScr();
	}else{
		MoveLock = false;
	}
}
function ISL_ScrUp(){ //上翻动作
	if(GetObj('ISL_Cont').scrollLeft <= 0){
		GetObj('ISL_Cont').scrollLeft = GetObj('ISL_Cont').scrollLeft + GetObj('pic1').offsetWidth;
	}
	GetObj('ISL_Cont').scrollLeft -= Space ;
}
function ISL_GoDown(){ //下翻
	clearInterval(MoveTimeObj);
	if(MoveLock) return;
	clearInterval(AutoPlayObj);
	MoveLock = true;
	ISL_ScrDown();//执行下翻动作函数
	MoveTimeObj = setInterval('ISL_ScrDown()',Speed);
}
function ISL_StopDown(){ //下翻停止
	clearInterval(MoveTimeObj);
	if(GetObj('ISL_Cont').scrollLeft % PageWidth - fill != 0 ){
		Comp = PageWidth - GetObj('ISL_Cont').scrollLeft % PageWidth + fill;
		CompScr();
	}else{
		MoveLock = false;
	}
}
function ISL_ScrDown(){ //下翻动作
	if(GetObj('ISL_Cont').scrollLeft >= GetObj('pic1').scrollWidth){
		GetObj('ISL_Cont').scrollLeft =GetObj('ISL_Cont').scrollLeft - GetObj('pic1').scrollWidth;
	}
	GetObj('ISL_Cont').scrollLeft += Space ;
}
function CompScr(){
	var num;
	if(Comp == 0){MoveLock = false;return;}
	if(Comp < 0){ //上翻
		if(Comp < -Space){
		   Comp += Space;
		   num = Space;
		}else{
		  num = -Comp;
		  Comp = 0;
		}
		GetObj('ISL_Cont').scrollLeft -= num;
		setTimeout('CompScr()',Speed);
	}else{ //下翻
		if(Comp > Space){
		   Comp -= Space;
		   num = Space;
		}else{
		   num = Comp;
		   Comp = 0;
	}
	GetObj('ISL_Cont').scrollLeft += num;
	setTimeout('CompScr()',Speed);
	}
}