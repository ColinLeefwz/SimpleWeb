// JavaScript Document
var n=1;
function Door(i){
	var obj=document.getElementById("ConTitle").getElementsByTagName("li");
		
		if(i==0){
			document.getElementById("Title").style.display="block";
			document.getElementById("Word").style.display="block";
			obj[i+1].className="t4";
			obj[i].className="t1";
		}else if(i==1){
			document.getElementById("Title").style.display="none";
			document.getElementById("Word").style.display="none";
			obj[i-1].className="t2";
			obj[i].className="t3";
		}
}
function BQpic(){
	if(n==1){
		document.getElementById("BQS").style.display="block";
		document.getElementById("BQ").innerHTML="关闭";
		n=0;
	}else if(n==0){
		document.getElementById("BQS").style.display="none";
		document.getElementById("BQ").innerHTML="表情";
		n=1;
	}
	
}
