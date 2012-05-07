// JavaScript Document
function GetObj(objName){
	if(document.getElementById){
		return eval('document.getElementById("'+objName+'")');
	}else{
		return eval('document.all.'+objName);
	}
}

function AutoPlay(){
	clearInterval(AutoPlayObj);
	AutoPlayObj=setInterval('GoDown();StopDown();',interval_1);
}

function GoUp(){
	if(ax==0){
		return;
	}else{
	if(MoveLock_1)return;
		clearInterval(AutoPlayObj);
		MoveLock_1=true;
		MoveWay_1="left";
		MoveTimeObj=setInterval('ISL_ScrUp_1();',Speed_1);
	}
}

function StopUp(){
	if(MoveWay_1 == "right"){return;}
	clearInterval(MoveTimeObj);
	if((GetObj('Cont1').scrollLeft-fill_1)%PageWidth_1!=0){	
		Comp_1=fill_1-(GetObj('Cont1').scrollLeft%PageWidth_1);
		CompScr()
	}else{
		MoveLock_1=false;
	}

}

function ISL_ScrUp_1(){
	if(GetObj('Cont1').scrollLeft<=0){
		GetObj('Cont1').scrollLeft=GetObj('Cont1').scrollLeft+GetObj('List1_1').offsetWidth;
	}
	GetObj('Cont1').scrollLeft-=Space_1;
}

function GoDown(){
	if(ax==0){
		return;
	}else{
	clearInterval(MoveTimeObj);
	if(MoveLock_1)return;
	clearInterval(AutoPlayObj);
	MoveLock_1=true;
	MoveWay_1="right";
	ScrDown();
	MoveTimeObj=setInterval('ScrDown()',Speed_1);}
}

function StopDown(){
	if(MoveWay_1 == "left"){return};
	clearInterval(MoveTimeObj);
	if(GetObj('Cont1').scrollLeft%PageWidth_1-(fill_1>=0?fill_1:fill_1+1)!=0){
		Comp_1=PageWidth_1-GetObj('Cont1').scrollLeft%PageWidth_1+fill_1;CompScr();
	}else{
		MoveLock_1=false;
	}
}

function ScrDown(){
	if(GetObj('Cont1').scrollLeft>=GetObj('List1_1').scrollWidth){
		GetObj('Cont1').scrollLeft=GetObj('Cont1').scrollLeft-GetObj('List1_1').scrollWidth;
	}
	GetObj('Cont1').scrollLeft+=Space_1;
}

function CompScr(){
	if(Comp_1==0){ MoveLock_1=false; return; }
	var num,TempSpeed=Speed_1,TempSpace=Space_1;
	if(Math.abs(Comp_1)<PageWidth_1/2){
		TempSpace=Math.round(Math.abs(Comp_1/Space_1));
		if(TempSpace<1){ TempSpace=1; }
	}
	if(Comp_1<0){
		if(Comp_1<-TempSpace){	
			Comp_1+=TempSpace;num=TempSpace;	
		}else{
			num=-Comp_1;
			Comp_1=0;
		}
	GetObj('Cont1').scrollLeft-=num;setTimeout('CompScr()',TempSpeed)
   }else{
	   if(Comp_1>TempSpace){   
		   Comp_1-=TempSpace;num=TempSpace; 
		}else{
			num=Comp_1;Comp_1=0;
		}
		GetObj('Cont1').scrollLeft+=num;setTimeout('CompScr()',TempSpeed);
	}
}

function photoalbum(){//photoalbum函数只在页面刚载入的时候调用
	var names=document.getElementsByName("xf");
	if(names.length<=10){
		document.getElementById("List2_1").style.display="none";
		ax=0;
	}else{
		ax=1;
		GetObj("List2_1").innerHTML=GetObj("List1_1").innerHTML;
		GetObj('Cont1').scrollLeft=fill_1>=0?fill_1:GetObj('List1_1').scrollWidth-Math.abs(fill_1);
		GetObj("Cont1").onmouseover=function(){ clearInterval(AutoPlayObj); }
		GetObj("Cont1").onmouseout=function(){ }
	}
}