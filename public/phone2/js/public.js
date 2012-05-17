// JavaScript Document
$(document).ready(function(){
	Foot();
	SC();
	$(window).scroll(function(){
		Foot();
	});
	function Foot(){
		var h=$(window).height()+$(window).scrollTop()-$("#ch_foot, #foot").height();
		
		if(h>=($("#main").height()+$("#foot").height())){
			h=($("#main").height()+$("#ch_foot, #foot").height());
		}
		
		if(h<$(window).height()-$("#ch_foot, #foot").height()){
			h=$(window).height()-$("#ch_foot, #foot").height();	
		}
		
		$("#ch_foot, #foot").css("top",h+"px");	
	}
	$(window).resize(function(){
		SC();
		Foot();
	});
	
	function SC(){
		$("#SC a").each(function(){$(this).css({"width":$(window).width()+"px"});});
	}
});


								 
	