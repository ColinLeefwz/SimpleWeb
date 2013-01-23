$(document).ready(function(){
	
	$("#DHImg a").not(":first").css("display","none");

	(function(){
		var curr = 0,j=0,num;
	    num=$("#DHImg a").length;
		
		$("#DHNum .def").each(function(i){/** each()方法为每个匹配元素规定的函数 **/
			$(this).click(function(){
				curr = i;
				$("#DHImg a").filter("a").css("display","none").end().eq(j).css({"z-index":"1","display":"block"});

				$("#DHImg a").eq(i).css({"z-index":"2","display":"none"}).fadeIn(1800);
				$(this).siblings(".def").removeClass("selected").end().addClass("selected");
				/**siblings()获得匹配集合中每个元素的同胞元素，通过选择器进行筛选是可选的**/
				j=i;
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
	     /**todo的值即为$("#DHNum .def").each(function(i){……}中i的值，从而改变全局变量curr的值**/
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
		

		var timer = setInterval(function(){
			todo = (curr+1) % num;
			$("#DHNum .def").eq(todo).click();
		},4000);
		
		
		$("#DHImg, #DHNum a").mouseover(function(){/**当鼠标移到图片层或导航栏标签<a>元素上时清除动画**/
			clearInterval(timer);
		});
		
		$("#DHImg, #DHNum a").mouseout(function(){/**当鼠标离开图片层或导航栏标签<a>元素时执行动画**/
			timer = setInterval(function(){
				todo = (curr+1) % num;
				$("#DHNum .def").eq(todo).click();
			},4000);
		});
	})();
});