// JavaScript Document

function Plane(){
	var wh=$(window).height();
	var mh=$("#Main").height();
	var m_rh=$(".mainright").height();
	if(wh>mh){
		$("#Main").css("marginTop",(wh-mh)/2+"px");	
	}
	if(m_rh<mh){
		$(".mainright").css("padding-top",(mh*0.1)+"px");	
	}
}

window.onload=Plane;
window.onresize=Plane;

$(window).load(function(){
	var mw=$("#Main").width();
	var mh=$("#Main").height();
	var bl=1;
	var bw=$("#BigPic").width();
	var bh=$("#BigPic").height();
	$("#BigPic").css("display","none");
	
	$("#BG1").css({"display":"none","height":mh+"px"});
	//if($("#SmallPic").width()<$("#MainLeft").width()){$("#MainLeft").css("paddingTop","15px");} 
	$("#SmallPic").click(function(){
		$("#BG1").css("display","block");
		$("#BigPic").css({"width":"1px","height":"1px","display":"block","top":"0px","left":"0px","bottom":"auto","right":"auto"});
		if(bw>=mw||bh>=mh){
			if(bw>bh){
				bl=mw/bw;
			}else{
				bl=mh/bh;
			}
		}
		$("#BigPic").animate({"width":bw*bl+"px","height":bh*bl+"px"},550,function(){
			$(this).animate({"top":(mh-bh*bl)/2+"px","left":(mw-bw*bl)/2+"px"},550);
		});
	});
	
	$("#BigPic").click(function(){
		$("#BigPic").css({"top":"auto","left":"auto","bottom":(mh-bh*bl)/2+"px","right":(mw-bw*bl)/2+"px"});
		$("#BigPic").animate({"right":"0px","bottom":"0px"},550,function(){
			$(this).animate({"width":"1px","height":"1px"},550,function(){
				$("#BigPic, #BG1").css("display","none");
			});
		});	
	});
});