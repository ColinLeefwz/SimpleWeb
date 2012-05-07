$(window).scroll(function(){
		var h,old_h,new_h,change,s,top_h=132;/**top_h用于存放Contact元素距离窗口顶端的高度**/	
		old_h=parseInt($("#Contact").css("top"));
		
		if(document.body.scrollTop!=0){
			h=document.body;
		}else{
			h=document.documentElement;
		}
		new_h=h.scrollTop+top_h;
		
		if(old_h<new_h){
			clearInterval(s);
			change=true;
		}else if(old_h>new_h){
			clearInterval(s);
			change=false;
		};

		s=setInterval(function(){
			if(change==true){
				old_h+=old_h*0.15;
				$("#Contact").css("top",old_h);
				if(old_h>new_h){
					old_h=new_h;
					$("#Contact").css("top",new_h);
					clearInterval(s);
				}
			}else if(change==false){
				old_h-=old_h*0.15;
				$("#Contact").css("top",old_h);
				if(old_h<new_h){
					old_h=new_h;
					$("#Contact").css("top",new_h);
					clearInterval(s);
				}
			}
		},80);	
});

$("#Link").click(function(){
	var h;
	if(document.body.scrollTop!=0){
		h=document.body;
	}else{
		h=document.documentElement;
	}
	h.scrollTop=0;
});