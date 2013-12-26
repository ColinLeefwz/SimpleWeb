// JavaScript Document
$(document).ready(function(){
	var high=window.screen.height,
		scrollheight=0;
	/** high 存放屏幕高度， scrollTop 存放页面滚动高度。**/
	
	$(parent.window).scroll(function(){//页面滚动时执行此函数
		if(scrollheight<$(parent.window).scrollTop()){
			scrollheight=$(parent.window).scrollTop();
			ADDItems();
		}		
		// 另一种情况 若 scrollheight > $(parent.window).scrollTop() 表示页面向上滚动。那么页面的整体高度就不会再增加。
	});

	ADDItems();
	
	function ADDItems(){//增加框架函数
		var row=1;  //表示行数，例如此例表示的显示3行
		while($(".box").height()<(high+scrollheight)&&row<4){
			row++;
			for(var i=0;i<3;i++){
				var itemplane="<div class=\"plane\"><img src=\"images/pic1.jpg\" class=\"imgs\">"
								+"<div class=\"content\">"
									+"<h2>"
										+"<a href=\"#\">杭州名人名家</a>"
											+"<img src=\"images/sign3.gif\">"
									+"</h2>："
									+"<a href=\"#\" class=\"mlr5\">#浙江科技产业大厦#</a>"
									+"你要按你所想的去生活，否则，你迟早会按你所生活的去想。"
								+"</div>"
								+"<div class=\"operation\">"
									+"<a href=\"#\" class=\"mr5\">收藏</a>"
									+"<a href=\"#\">转发(2)</a>"
									+"<div class=\"bgs\">"
										+"<input type=\"text\" value=\"我来说说\" class=\"inputs\">"
											+"<input type=\"submit\" value=\"提交\" class=\"btn1 r\" title=\"提交\">"
									+"</div>"
								+"</div>"
							+"</div>";
				$("#Waterfall").append(itemplane);
			}
		}
		
		$("input.inputs").live({ // 重新绑定输入框的事件。
			mouseover:function(){$(this).select();},// $(this).select();表示输入框被选中
			mouseout:function(){if($(this).val()==""){$(this).val("我来说说");}},
			click:function(){if($(this).val()=="我来说说"){$(this).val("");}}
		});
		
		$("#Waterfall img:last").load(function(){//添加$("#Waterfall img:last").load()在这里是为了防止火狐浏览器第一次加载页面时显示不正常。
			$('#Waterfall').BlocksIt({
				numOfCol: 3,
				offsetX: 10,
				offsetY: 8,
				blockElement:"div"
			});
		});	
		/*if($.browser.webkit){
			$("#Waterfall img").load(function(){
				$('#Waterfall').BlocksIt({
					numOfCol: 3,
					offsetX: 10,
					offsetY: 8,
					blockElement:"div"
				});
			});
		}else{
			$("#Waterfall img:last").load(function(){//添加$("#Waterfall img:last").load()在这里是为了防止火狐浏览器第一次加载页面时显示不正常。
				$('#Waterfall').BlocksIt({
					numOfCol: 3,
					offsetX: 10,
					offsetY: 8,
					blockElement:"div"
				});
			});	
		}*/
		/** numOfCol: 设置每一行有几个框架， offsetX: 设置每个框架互相比邻的左边距。 offsetY: 设置每个框架互相比邻的上边距。 blockElement: 设定哪种标签按瀑布流的形式显示。 **/	
	}
});