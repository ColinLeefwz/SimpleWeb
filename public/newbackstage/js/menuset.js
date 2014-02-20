function relist_menu(){
    var html = ''
    $(menujson.menu.button).each(function(index, val){
        html += '<dl class="inner_menu jsMenu ui-sortable ui-sortable-disabled">'
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
         html += "</dl>"
    })
    $('dl').remove()
    $('#menuList').append(html)
};

$(document).ready(function(){ 
	var inter1 = null;
// 增加菜单
	$(document).delegate('#addBt, .jsAddBt','click', function(event){
		$('#menu_val').val('')
		$('#popupForm_ .fail').css('display', 'none')
		if($(this).attr('id')=='addBt'){
			var index = null
			var leg = 8
			if(menujson.menu.button.length >=3 ){
				$('#wxTipserr').css('display',"inline-block").css('opacity',"1")
				$('#wxTipserr .inner').css('background-color', '#EAA000' ).html('一级菜单最多只能三个')
				set_interval()
				return 
			}
		}else{
			var index = get_menu_map($(this).parent().parent().attr('id'))[0]
			var leg = 16
			if(menujson.menu.button[index].sub_button.length >=5 ){
				$('#wxTipserr').css('display',"inline-block").css('opacity',"1")
				$('#wxTipserr .inner').css('background-color', '#EAA000' ).html('二级菜单最多只能五个')
				set_interval()
				return 
			}
		}
		$("#dialog_display").css("display", "block")
		$('#dialog_display .frm_label').html('菜单名称名字不多于'+ leg/2 +'个汉字或'+ leg +'个字母')
		$("#jsbtn0").unbind().click(function(){
			name = $('#menu_val').val();
			name = name.replace(/^[ ]*|[ ]*$/g,'')
			if(!checkMenuNameInput(name, index)){
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
			if(!checkMenuNameInput(name, index)){
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

	//预览
	$(document).delegate("#viewBt", 'click',function(){
		$('#mobile_review').css('display', 'block')
		mobile_review_list()

		$('.jsViewLi').unbind().click(function(){
			$('.jsSubViewDiv').css('display', 'none')
			var subdiv = $(this).children('.jsSubViewDiv')[0]
			var index = get_menu_map(this.id)
			var menu = get_menu_button(index)
			if(menu.sub_button.length == 0 ){
				review_action(menu)
			}else{
				$(subdiv).css('display', 'block')
				$(subdiv).children('ul').children('li').unbind().click(function(event){
					var index = get_menu_map(this.id)
					var menu = get_menu_button(index)
					review_action(menu)
					$(subdiv).css('display', 'none')
					event.stopPropagation();
				})
			}
		})

		$('#viewClose').unbind().click(function(){
			$('#mobile_review').css('display', 'none')
			$('#viewShow li.show_item').remove();
		})
	})

	// 发布
	$('#pubBt').click(function(){
		$('#menu_pub').css('display', 'block');
		$('#pub_add').unbind().click(function(){
			$('#menu_pub').css('display', 'none');
			$.post("/shop3_menu/pub", function(data){
				$('#wxTipserr').css('display',"inline-block").css('opacity',"1")
				$('#wxTipserr .inner').css('background-color', '#56A447' ).html('发布成功')
				set_interval()
			})
		})
		$('#pub_closed, #pub_cancel').unbind().click(function(){
			$('#menu_pub').css('display', 'none');
		})
	})

	//选中菜单
	$(document).delegate(".inner_menu_item", 'click',function(){
		if(!trigger_click){
			return false;
		}
		$(".inner_menu_item").removeClass('selected')
		$(this).addClass('selected')
		set_action_content(this.id)
		var index = get_menu_map(this.id)
		$('#changeBt').unbind().click(function(){
			var menu = get_menu_button(index)
			if(menu.type=='view'){
				$("#goPage").click()
			}else if(menu.type == 'click'){
				if(menu.dt=='text'){
					var html =  menu.data
					$('.tab_text').click()
					// $('.tab_img').click()
					// $('#menu_image_dialog').css('display','none')
					// var html = '<img class="wxmImg Zoomin" src="'+  +'">'
					$('.js_editorArea').html(menu.data)
				}else if(menu.dt=='photo'){
					var html =  '<img class="wxmImg Zoomin" src="'+ menu.data +'">'
					$('.tab_img').click()
					$('#menu_img_cancel').click()
					$('li.tab_nav').removeClass("selected")
					$('.tab_img').addClass("selected")
				}else if(menu.dt=='faq'){
					var html =  menu.data
					$('.tab_appmsg').click()
					$('#menu_faq_cancel').click()
					$('li.tab_nav').removeClass("selected")
					$('.tab_appmsg').addClass("selected")
				}
				$('.js_editorArea').html(html)
			}else{
				$(this).css('display', 'none')
			}

		})
	})

	$('#editBack').click(function(){
		var m = $('.selected')[0]
		set_action_content(m.id)
		$('.jsMain').css('display', 'none')
		$("#index").css('display', 'block')
	})

	// 选择‘文字’
	$('#sendMsg, .tab_text').click(function(){
		$('.jsMain').css('display', 'none')
		$('#edit').css('display', 'block') 
		var html = ''
		var m = $('.selected')[0]
		var indexs = get_menu_map(m.id)
		var menu = get_menu_button(indexs)
		if(menu.dt == 'text'){
			var html = menu.data
		}
		$('.js_editorArea').html(html)
		$('li.tab_nav').removeClass("selected")
		$('.tab_text').addClass("selected")
		$('#editSave').unbind().click(function(){
			$(this).unbind()
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
		var m = $('.selected')[0]
		var indexs = get_menu_map(m.id)
		var menu = get_menu_button(indexs)
		$('#menu_img_add').unbind().click(function(){
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
		$('#menu_img_cancel,#menu_image_dialog .pop_closed').unbind().click(function(){
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
		var m = $('.selected')[0]
		var indexs = get_menu_map(m.id)
		var menu = get_menu_button(indexs)
		$('#menu_faq_add').unbind().click(function(){
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

		$('#menu_faq_cancel,#menu_faq_dialog .pop_closed').unbind().click(function(){
			$('#menu_faq_dialog').css('display','none')
			$('.tab_text').click()
		})
	})

    // 选择增加view动作
	$("#goPage").click(function(){
		$('.jsMain').css('display', 'none')
		$('#url').css('display', 'block')
		$('#urlFail').css('display', 'none')
		var m = $('.selected')[0]
		var indexs = get_menu_map(m.id)
		var menu = get_menu_button(indexs)
		$('#urlText').val(menu.url)
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
		if(!((/(^http\:\/\/)|(^https\:\/\/)/).test(url))){
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

	function mobile_review_list(){
		var html = '<ul id="viewList" class="pre_menu_list">'
		$(menujson.menu.button).each(function(index, val){
			html += '<li id="menu_'+ index +'_review" class="pre_menu_item with3 jsViewLi">'
			html += '<a class="jsView" href="javascript:void(0);">' + val.name + '</a>'
			html += '<div style="display:none" class="sub_pre_menu_box jsSubViewDiv"><ul class="sub_pre_menu_list">'
			$(val.sub_button).each(function(sub_index, sub_val){
				html += '<li id="subMenu_menu_'+ index + '_'+ sub_index +'_review">'
				html += '<a class="jsSubView" href="javascript:void(0);">'+ sub_val.name +'</a></li>'
			})
			html += ' </ul><i class="arrow arrow_out"></i><i class="arrow arrow_in"></i></div></li>'
		})
		html += '</ul>'
		$("#viewList").replaceWith(html)
	}

	function checkMenuNameInput(name, index){
		var length = 0 
		for(var i=0; i< name.length; i++){
			length += (name[i].charCodeAt() <= 127 ? 1 : 2)
		}
		var leg = index ? 16 : 8
		if(length > leg){
			$('#popupForm_ .fail').css('display', 'block')
			$('#popupForm_ .fail span').html('菜单名称名字不多于'+ leg/2 +'个汉字或'+ leg +'个字母')
			return false
		}
		if(length==0){
			$('#popupForm_ .fail').css('display', 'block')
			$('#popupForm_ .fail span').html('输入框内容不能为空')
			return false
		}

		return true
	}

	// 预览 内容
	function review_action(men){
		logo = $('#mobile_logo').val()
		if(men.type == 'view'){
			window.open (men.url, men.name)
		}else if(men.type == 'click'){
			var html = '<li class="show_item">'
			html += '<img class="avatar" src="'+ logo +'">'
			if(men.dt == 'text'){
				html += '<div class="show_content">'+ men.data +'</div>'
			}else if(men.dt == 'photo'){
				html += '<img class="wxmImg Zoomin" src="' + men.data + '">'
			}else if(men.dt == 'faq'){
				html += '<div class="show_content">'+ men.data +'</div>'
			}
			html += '</li>'
			$('#viewShow').append(html)
		}
	}

	function show_action_content(type, menu){
		if(type=='view'){
			$('#view').css('display', 'block')
			$("#view p").html('订阅者点击该子菜单会跳到以下链接')
			$("#view div").html(menu.url)
			$('#changeBt').css('display', 'inline-block')
		}else if(type=='click'){
			$('#view').css('display', 'block')
			$("#view p").html('订阅者点击该子菜单会发送以下消息')
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
