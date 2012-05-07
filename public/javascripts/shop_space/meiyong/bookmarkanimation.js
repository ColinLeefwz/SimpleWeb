// JavaScript Document

var bre=247,w=bre,w1=0,i=1,k=0;
var s1,s2,sum;
function $ba(ij){
	return document.getElementById(ij);
}


function Star(){
	$ba("N1").style.display="none";
	$ba("Picimgs1").style.display="block";
	sum = $ba("Pic").getElementsByTagName("img").length/2;//获取图片数量
}

function Run(i){//顺序显示图片
	w-=40;
	w1+=40;
	
	if(w<0||w1>bre){
		w=0;
		w1=bre;
	}
	for(j=1;j<=i;j++){
		$ba("N"+j).style.display="block";
		$ba("Picimgs"+j).style.display="none";
	}
	$ba("N"+i).style.display="none";
	$ba("Picimgs"+(i-1)).style.width=w+"px";
	$ba("Picimgs"+(i-1)).style.display="block";
	$ba("Picimgs"+i).style.display="block";
	$ba("N"+(i-1)).style.display="block";
	
	$ba("Picimgs"+i).style.width=w1+"px";
	
	if(w<=0){
		w=bre;
		w1=0;
		clearInterval(s1);
	}
}

function Run2(i){//倒序显示图片
	w-=35;
	w1+=35;
	
	if(w<0||w1>bre){
		w=0;
		w1=bre;
	}
	for(j=1;j<=sum;j++){
		$ba("N"+j).style.display="block";
		$ba("Picimgs"+j).style.display="none";
	}
	
	$ba("N"+i).style.display="none";
	$ba("Picimgs"+i).style.width=w1+"px";
	$ba("Picimgs"+i).style.display="block";
	
	$ba("N"+(i+1)).style.display="block";
	$ba("Picimgs"+(i+1)).style.width=w+"px";
	$ba("Picimgs"+(i+1)).style.display="block";
	
	if(w<=0){
		w=bre;
		w1=0;
		clearInterval(s2);
	}
}


function Open(i){
	if(k<i){
		k=i;
		clearInterval(s1);
		clearInterval(s2);
		s1=setInterval("Run("+i+")",100);
		return;
	}else if(k>i){
		k=i;
		clearInterval(s1);
		clearInterval(s2);
		s2=setInterval("Run2("+i+")",100);
	}
	
}
Star();
