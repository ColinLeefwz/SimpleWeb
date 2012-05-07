$(function(){
	(function(){
		var curr = 0;
		var obj = document.getElementById("stage").getElementsByTagName("img");
		$("#DHNum .off").each(function(i){
			$(this).click(function(){
				curr = i;
				$("#stage img").eq(i).fadeIn(1000).siblings("#stage img").hide();
				$("#stage .frame").eq(i).fadeIn(1000).siblings("#stage .frame").hide();
				$(this).addClass("selected");
				$(this).siblings(".off").removeClass("selected");
				
			});
		});
		
		var pg = function(flag){
			if (flag) {
				if (curr == 0) {
					todo = obj.length-1;
				} else {
					todo = (curr - 1) % obj.length;
				}
			} else {
				todo = (curr + 1) % obj.length;
			}
			$("#DHNum .off").eq(todo).click();
		};
		
		//ǰ
		$("#Prev").click(function(){
			pg(true);
			return false;
		});
		
		//
		$("#Next").click(function(){
			pg(false);
			return false;
		});
		
		//Զ
		var timer = setInterval(function(){
			todo = (curr + 1) % obj.length;
			$("#DHNum .off").eq(todo).click();
		},4000);
		
		//ͣڴʱֹͣԶ
		$("#DHNum a").hover(function(){
				clearInterval(timer);
			},
			function(){
				timer = setInterval(function(){
					todo = (curr + 1)% obj.length;
					$("#DHNum .off").eq(todo).click();
				},4000);			
			}
		);
	})();
});

