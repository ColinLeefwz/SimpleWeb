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
				$("#DH").find("img").eq(i).fadeIn(2000).css("z-index","1");
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


$(window).scroll(function(){
		
		var h,old_h,new_h,change,s,top_h=380;/**top_h用于存放Contact元素距离窗口顶端的高度**/	
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
				old_h+=old_h*0.10;
				$("#Contact").css("top",old_h);
				if(old_h>new_h){
					old_h=new_h;
					$("#Contact").css("top",new_h);
					clearInterval(s);
				}
			}else if(change==false){
				old_h-=old_h*0.10;
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