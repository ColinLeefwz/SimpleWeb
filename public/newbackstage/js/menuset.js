$(document).ready(function(){
	var menujson = null 
	var inter1 = null;

	$.get('/shop3_menu.json', function(data){
		menujson = data
	})

	// 增加菜单
	$(document).delegate('#addBt, .jsAddBt','click', function(event){
		$('#menu_val').val('')
		$('#popupForm_ .fail').css('display', 'none')
		if($(this).attr('id')=='addBt'){
			var index = null
			if(menujson.menu.button.length >=3 ){
				$('#wxTipserr').css('display',"inline-block").css('opacity',"1")
				$('#wxTipserr .inner').html('一级菜单最多只能三个')
				set_interval()
				return 
			}
		}else{
			var index = get_menu_map($(this).parent().parent().attr('id'))[0]
			if(menujson.menu.button[index].sub_button.length >=5 ){
				$('#wxTipserr').css('display',"inline-block").css('opacity',"1")
				$('#wxTipserr .inner').html('二级菜单最多只能五个')
				set_interval()
				return 
			}
		}
		$("#dialog_display").css("display", "block")
		$("#jsbtn0").unbind().click(function(){
			name = $('#menu_val').val();
			name = name.replace(/^[ ]*|[ ]*$/g,'')
			if(!checkMenuNameInput(name)){
				return 
			}
			$(this).unbind()
			$.post("/shop3_menu/add_menu", {index: index, name: name }, function(data){
				menujson = data;
				relist_menu();
				$("#dialog_display").css("display", "none");
			})	
		})
		$('#jsbtn1, #dialog_display .pop_closed').click(function(){
			$("#dialog_display").css("display", "none")
		})
		event.stopPropagation();
	})

	//编辑菜单
	$(document).delegate(".edit_gray", 'click', function(event){
		$('#popupForm_ .fail').css('display', 'none')
		var index = get_menu_map($(this).parent().parent().attr('id'))
		$('#menu_val').val(get_menu_button(index).name)
		$("#dialog_display").css("display", "block")
		$("#jsbtn0").unbind().click(function(){
			
			name = $('#menu_val').val()
			if(!checkMenuNameInput(name)){
				return 
			}
			$(this).unbind()
			$.post("/shop3_menu/edit_menu", {index: index, name: name }, function(data){
				menujson = data;
				relist_menu();
				$("#dialog_display").css("display", "none");
			})	
		})

		$('#jsbtn1, #dialog_display .pop_closed').click(function(){
			$("#dialog_display").css("display", "none")
		})
		event.stopPropagation();
	})

	//删除菜单
	$(document).delegate(".del_gray", 'click',function(event){
		$('#tmpwxDialog_2').css('display', 'block')
		var index = get_menu_map($(this).parent().parent().attr('id'))
		$('#tmpwxDialog_2 .btn_primary').click(function(){
			$.post("/shop3_menu/del", {index: index}, function(data){
				menujson = data
				relist_menu();
				$('#tmpwxDialog_2').css('display', 'none')
			})	
		})
		
		$('#tmpwxDialog_2 .btn_default, #tmpwxDialog_2 .pop_closed').click(function(){
			$('#tmpwxDialog_2').css('display', 'none')
		})
		event.stopPropagation();
	})

	//选中菜单
	$(document).delegate(".inner_menu_item", 'click',function(){
		$(".inner_menu_item").removeClass('selected')
		$(this).addClass('selected')
		set_action_content(this.id)
		var index = get_menu_map(this.id)
		$('#changeBt').click(function(){

		})
	})

	$('#editBack').click(function(){
		var m = $('.selected')[0]
		set_action_content(m.id)
	})

	// 选择‘文字’
	$('#sendMsg, .tab_text').click(function(){
		$('.jsMain').css('display', 'none')
		$('#edit').css('display', 'block') 
		$('.js_editorArea').html('')
		$('li.tab_nav').removeClass("selected")
		$('.tab_text').addClass("selected")
		$('#editSave').unbind().click(function(){
			$(this).unbind()
			var m = $('.selected')[0]
			var indexs = get_menu_map(m.id)
			text = $('.js_editorArea').html()
			$.post('/shop3_menu/set_click_action',{index: indexs, menu_key: {type: 'text', tv: text}}, function(data){
				menujson = data
				set_action_content(m.id)
				relist_menu()
				$("#"+m.id).addClass('selected')
			})
		})
	})

	// 选择‘图片’
	$('.tab_img').click(function(){
		$('#menu_image_dialog').css('display','block')
		$('li.tab_nav').removeClass("selected")
		$(this).addClass("selected")
		$("#menu_image_dialog input").attr("checked",false)
		$('#menu_img_add').click(function(){
			var m = $('.selected')[0]
			var indexs = get_menu_map(m.id)
			var objor = $("#menu_image_dialog input:checked")[0]
			if(!objor){
				return false;
			}
			var menu_photo_id = $(objor).val()
			var src = $(objor).parent().parent().children('a').children('img')[0].src
			$('#menu_image_dialog').css('display','none')
			$('.js_editorArea').html('<img class="wxmImg Zoomin" src="'+ src +'">')
			$('#editSave').unbind().click(function(){
				$(this).unbind()
				$.post("/shop3_menu/set_click_action", {index: indexs, menu_key: {type: 'photo', tv: menu_photo_id} }, function(data){
					menujson = data
					set_action_content(m.id)
					relist_menu()
					$("#"+m.id).addClass('selected')
				})
			})
		});
		$('#menu_img_cancel,#menu_image_dialog .pop_closed').click(function(){
			$('#menu_image_dialog').css('display','none')
			$('.tab_text').click()
		})
	})

	// 选择‘问答’
	$('.tab_appmsg').click(function(){
		$('#menu_faq_dialog').css('display','block')
		$("#menu_faq_dialog input").attr("checked",false)
		$('li.tab_nav').removeClass("selected")
		$(this).addClass("selected")
		$('#menu_faq_add').click(function(){
			var m = $('.selected')[0]
			var indexs = get_menu_map(m.id)
			var objor = $("#menu_faq_dialog input:checked")[0]
			if(!objor){
				return false;
			}
			var menu_faq_id = $(objor).val()
			var objp = $(objor).parent().parent().children('p')[0]
			var title = $(objp).html()
			$('#menu_faq_dialog').css('display','none')
			$('.js_editorArea').html('问答:' + title)
				$('#editSave').unbind().click(function(){
					$(this).unbind()
					$.post('/shop3_menu/set_click_action', {index: indexs, menu_key: {type: 'faq', tv: menu_faq_id } }, function(data){
						menujson = data
						set_action_content(m.id)
						relist_menu()
						$("#"+m.id).addClass('selected')
					})
				})
		});

		$('#menu_faq_cancel,#menu_faq_dialog .pop_closed').click(function(){
			$('#menu_faq_dialog').css('display','none')
			$('.tab_text').click()
		})
	})

    // 选择增加view动作
	$("#goPage").click(function(){
		$('.jsMain').css('display', 'none')
		$('#url').css('display', 'block')
		$('#urlFail').css('display', 'none')
		$('#urlText').val('')
	})

	//取消增加view动作
	$('#urlBack').click(function(){
		$('.jsMain').css('display', 'none')
		$("#index").css('display', 'block')
	});

	//提交view动作
	$("#urlSave").click(function(){
		var m = $('.selected')[0]
		var indexs = get_menu_map(m.id)
		var url = $('#urlText').val()
		if(!((/^http\:\/\//).test(url))){
			$('#urlFail').css('display', 'block')
			return
		}
		$.post('/shop3_menu/set_view_action',{index: indexs, button: {url: url, type:'view'}}, function(data){
			menujson = data
			set_action_content(m.id)
			relist_menu()
			$("#"+m.id).addClass('selected')
		})
	})

	function set_interval(){
		inter1 = setInterval(function(){
			objd= $('#wxTipserr')
			objd.css('opacity',objd.css('opacity') -0.005)
			if(objd.css('opacity') <= 0.5 ){
				$('#wxTipserr').css('display', 'none')
				clearInterval(inter1)
			}
		}, 60) 
	}

	function get_menu_button(indexs){
		if(indexs.length==2){
			return  menujson.menu.button[indexs[0]].sub_button[indexs[1]]
		}else{
			return  menujson.menu.button[indexs[0]]
		}
	}

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
			var menu = menujson.menu.button[indexs[0]]
			if(menu.sub_button.length == 0 ){
				show_action_content(menu.type, menu)
			}else{
				$('#none').css('display', 'block')
				$("#none p").html('已有子菜单，无法设置动作')
				$('#changeBt').css('display', 'none')
			}
		}else{
			var menu = menujson.menu.button[indexs[0]].sub_button[indexs[1]]
			show_action_content(menu.type, menu)
		}
	}

	function relist_menu(){
		var html = '<dl class="inner_menu jsMenu ui-sortable ui-sortable-disabled">'
		$(menujson.menu.button).each(function(index, val){
            html += '<dt id="menu_' + index +'" class="inner_menu_item jslevel1">'
            html += '<i class="icon_inner_menu_switch"></i>'
            html += '<a class="inner_menu_link" href="javascript:void(0);">'
            html += '<strong>' + val.name + '</strong></a><span class="menu_opr">'  
            if(!val.type){
            	html += '<a class="icon14_common add_gray jsAddBt" href="javascript:void(0);" rel="' + index + '">添加</a>'
            }  
            html += '<a class="icon14_common  edit_gray jsEditBt" href="javascript:void(0);" rel="' + index + '">编辑</a>'
            html += '<a class="icon14_common del_gray jsDelBt" href="javascript:void(0);" rel="' + index + '">删除</a>'
            html += '<a style="display:none" class="icon14_common sort_gray jsOrderBt" href="javascript:void(0);">排序</a>'
            html += '</span></dt>'
            $(val.sub_button).each(function(sub_index, sub_val){
				html += '<dd id="subMenu_menu_'+ index + '_'+ sub_index +'" class="inner_menu_item jslevel2">'
				html += '<i class="icon_dot">●</i>'
				html += '<a class="inner_menu_link" href="javascript:void(0);"><strong>'+ sub_val.name +'</strong></a>'
				html += '<span class="menu_opr">'
				html += '<a class="icon14_common edit_gray jsSubEditBt" href="javascript:void(0);" rel="'+ index + ',' + sub_index + '">编辑</a>'
				html += '<a class="icon14_common del_gray jsSubDelBt" href="javascript:void(0);" rel="'+ index + ',' + sub_index + '">删除</a>'
				html += '<a style="display:none" class="icon14_common sort_gray jsOrderBt" href="javascript:void(0);">排序</a></span></dd>'
            })
   		})
   		html += "</dl>"
   		$('dl').remove()
   		$('#menuList').append(html)
	}

	function checkMenuNameInput(name){
		var length = 0 
		for(var i=0; i< name.length; i++){
			length += (name[i].charCodeAt() <= 127 ? 1 : 2)
		}
		if(length > 8){
			$('#popupForm_ .fail').css('display', 'block')
			$('#popupForm_ .fail span').html('菜单名称名字不多于4个汉字或8个字母')
			return false
		}
		if(length==0){
			$('#popupForm_ .fail').css('display', 'block')
			$('#popupForm_ .fail span').html('输入框内容不能为空')
			return false
		}
		return true
	}

	function show_action_content(type, menu){
		if(type=='view'){
			$('#view').css('display', 'block')
			$("#view p").html('订阅者点击该子菜单会跳到以下链接')
			$("#view div").html(menu.url)
			$('#changeBt').css('display', 'inline-block')
		}else if(type=='click'){
			$('#view').css('display', 'block')
			$("#view p").html('订阅者点击该子菜单会执行以下操作')
			if(menu.dt=='photo'){
				var html = '<img class="wxmImg Zoomin" src="'+ menu.data +'">'
			}else{
				var html = menu.data
			}
			$("#view div").html(html)
			$('#changeBt').css('display', 'inline-block')
		}else{
			$("#index").css('display', 'block')
			$('#changeBt').css('display', 'none')
		}
	}
})
