$(document).ready(function(){
	var menuindex = null;
	var menujson = null 
	$.get('/shop3_menu.json', function(data){
		menujson = data
	})


	$('#addBt').click(function(){
		$("#dialog_display").css("display", "block")
	})

	$('#jsbtn0').click(function(){
		var data = {name: $("#menu_val").val()};
		if(menuindex){
			data.index = menuindex   
		}
		$.post("/shop3_menu/set", data, function(data){
			menuindex = null
			$("#dialog_display").css("display", "none")
		})		
	})

	$('.jsAddBt').click(function(){
		menuindex = $(this).attr('rel');
		$("#dialog_display").css("display", "block")
	})

	$(".del_gray").click(function(){
		$.post("/shop3_menu/del", {index: $(this).attr('rel')}, function(){
		})	
	})

	$("#goPage").click(function(){
		$('.jsMain').css('display', 'none')
		$('#url').css('display', 'block')
	})

	$('#urlBack').click(function(){
		$('.jsMain').css('display', 'none')
		$("#index").css('display', 'block')
	});

	$("#urlSave").click(function(){
		
		var m = $('.selected')[0]
		var indexs = get_menu_map(m.id)
		var url = $('#urlText').val()
		$.post('/shop3_menu/set_action',{index: indexs, url: url})

	})

	$(".inner_menu_item").click(function(){
		$(".inner_menu_item").removeClass('selected')
		$(this).addClass('selected')
		set_action_content(this.id)
	})

	$('#jsbtn1').click(function(){
		menuindex = null
		$("#dialog_display").css("display", "none")
	})

	function get_menu_map(tagid){
		var menus = tagid.split('_')
		if(menus[0]=='menu'){
			menu_map = [menus[1]]
		}else{
			menu_map = [menus[2], menus[3]]
		}
		return menu_map
	}


	function set_action_content(tagid){
		var indexs = get_menu_map(tagid);
		$('.jsMain').css('display', 'none')
		if(indexs.length==1){
			menu = menujson.menu.button[indexs[0]]
			if(menu.sub_button.length == 0 ){
				$("#index").css('display', 'block')
			}else{
				$('#none').css('display', 'block')
				$("#none p").html('已有子菜单，无法设置动作')
			}
		}else{
			menu = menujson.menu.button[indexs[0]].sub_button[indexs[1]]
			if(menu.type=='view'){
				$('view').css('display', 'block')
				$("#view p").html('订阅者点击该子菜单会跳到以下链接')
				$("#view div").html(menu.url)
			}else if(menu.type=='click'){
				$('view').css('display', 'block')
				$("#view p").html('订阅者点击该子菜单会执行以下操作')
				$("#view div").html(menu.name)
			}else{
				$("#index").css('display', 'block')
			}
		}
	}
})
