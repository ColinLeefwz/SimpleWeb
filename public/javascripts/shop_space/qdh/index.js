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
				if(i!=0||i==(num-1))$("#DH a img").eq(i-1).css("z-index","1");
				$("#DH").find("img").eq(i).hide();
				$("#DH").find("img").eq(i).fadeIn(1500).css("z-index","1");
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
/**
if(j==0){
					if(i!=0){$("#DH").find("img").eq(i-1).prevUntil().css("display","none");}
					if(i!=num){$("#DH").find("img").eq(i).nextUntil("#DHNum").css("display","none");}
					if(i==0){$("#DH img").eq(num-1).css("display","block");}
				}else if(j=1){
					if(i==0){
						$("#DH").find("img").eq(num-1).css("display","block");	
					}else if(i>0&&i<(num-1)){
					$("#DH").find("img").eq(i-1).prevUntil().css("display","none");
					$("#DH").find("img").eq(i+1).nextUntil().css("display","block");}
					
				}
**/
