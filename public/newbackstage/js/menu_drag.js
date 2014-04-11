$(document).ready(function(){ 
	
	//取消
	$('#cancelBt').click(function(){
		Relist_Menu()
		back_up()
	});

	//完成
	$('#finishBt').click(function(){
		Relist_Menu();
		back_up();
		var index = order_index();
		$.post('/shop3_menu/sort_menu', {index: index}, function(data){
			menujson = data;
			sort="sort";
		})
	})

	function back_up(){
		trigger_click = true;
		$("#MenuList dl,#MenuList dd").unbind('mousedown')
		$(document).unbind("mouseup")
	   	$(".add_gray,.edit_gray, .del_gray").css('display', '');
		$("#finishBt, #cancelBt").css('display', 'none');
		$("#addBt, #orderBt").css('display', 'block');
	    $("dd, dt").removeClass('selected').attr('style', '')
	    $('dl').addClass('ui-sortable-disabled')
	}

	$("#orderBt").click(function(){
		sort="nosort";
		$("#index, #url, #view, #edit, #none").css("display", 'none')
		trigger_click = false;
		$("dd, dt").addClass('selected').css('background-color', '#FFFFFF');
	    $(".add_gray,.edit_gray, .del_gray").css('display', 'none');
		$("#MenuList a.sort_gray").css('display', '');
		$("#finishBt, #cancelBt").css('display', 'block');
		$("#addBt, #orderBt").css('display', 'none');
	    $('dl').removeClass('ui-sortable-disabled');

	    //一级菜单拖拽
		$('#MenuList dl').mousedown(function(downe){
			var x = parseInt(downe.pageX);
			var y = parseInt(downe.pageY);
			var obj= $(this);
			var posi = obj.position();
			var objx = parseInt(posi.left);
	        var objy = parseInt(posi.top);
	        var objheight = parseInt(obj.height());
	        objheight = objheight > 100 ? objheight : 100
	        obj.after("<dl class='drag_placeholder'></dl>");
	        obj.addClass('dragging').addClass('ui_sortable_helper');
	        obj.attr('style', "width:180px; height: "+objheight+"px; z-index:9999;position:absolute;background-color:#ffffff");
	        obj.css('left', objx+'px').css('top', objy+'px');
	        var last_ny = y;
	        $(document).mousemove(function(move_ent){
	        	var nx = parseInt(move_ent.pageX); //移动后的鼠标位置
				var ny = parseInt(move_ent.pageY);
				var movedx = nx - x; //移动距离
				var movedy = ny - y;
				obj.css('left', (objx + movedx)+'px').css('top', (objy + movedy)+'px');
				if((ny-last_ny) > objheight || (ny-last_ny) < -objheight){
					var chobj = $('.drag_placeholder').first();
					if(last_ny < ny){
						var chddobj = chobj.next();
						if(chddobj.hasClass('ui_sortable_helper')){
							chddobj = chddobj.next();
						}
						if(chddobj.get(0).tagName =='DL'){
							chddobj.after("<dd class='drag_placeholder'></dl>")
							chobj.remove()
							last_ny = ny;
						}
					}else{
						var chddobj = chobj.prev();
						if(chddobj.hasClass('ui_sortable_helper')){
							chddobj = chddobj.prev();
						}
						if(chddobj.get(0).tagName =='DL'){
							chddobj.before("<dd class='drag_placeholder'></dl>")
							chobj.remove()
							last_ny = ny;
						}
					}
				}
	        });

	        obj.unbind('mouseup').mouseup(function(){
				$(document).unbind('mousemove')
				obj.removeAttr('style')
				obj.removeClass('dragging').removeClass('ui_sortable_helper')
				$('.drag_placeholder').replaceWith(obj);
				$("dd, dt").addClass('selected').css('background-color', '#FFFFFF');
				return false;
			});

			$(document).unbind('mouseup').mouseup(function(){
				$(document).unbind('mousemove')
				obj.removeAttr('style')
				obj.removeClass('dragging').removeClass('ui_sortable_helper')
				$('.drag_placeholder').remove();
				$("dd, dt").addClass('selected').css('background-color', '#FFFFFF');
			});

	        return false;
		});

		//二级菜单拖拽
		// $(document).delegate('#MenuList dd','mousedown', function(downe){
		$('#MenuList dd').mousedown(function(downe){
			var x = parseInt(downe.pageX);
			var y = parseInt(downe.pageY);
			var objdd = $(this);
	        var posi = objdd.position();
	        var objx = parseInt(posi.left);
	        var objy = parseInt(posi.top);
	        objdd.after("<dd class='sub_drag_placeholder'></dd>");
	        objdd.addClass('dragging').addClass('ui_sortable_helper');
	        objdd.attr('style', "width:180px; height: 32px; z-index:9999;position:absolute;");
	        // objdd.css('background-color', '#f00');
	        objdd.css('left', objx+'px').css('top', objy+'px');
	        var last_ny = y;
	        // 鼠标移动
			$(document).mousemove(function(move_ent){
				var nx = parseInt(move_ent.pageX); //移动后的鼠标位置
				var ny = parseInt(move_ent.pageY);
				var movedx = nx - x; //移动距离
				var movedy = ny - y;
				objdd.css('left', (objx + movedx)+'px').css('top', (objy + movedy)+'px');
				if((ny-last_ny) > 32 || (ny-last_ny) < -32){
					var chobj = $('.sub_drag_placeholder').first();
					if(last_ny < ny){
						var chddobj = chobj.next();
						if(chddobj.attr('id') == objdd.attr('id')){
							chddobj = chddobj.next();
						}
						if(chddobj.get(0).tagName =='DD'){
							chobj.remove();
							chddobj.after("<dd class='sub_drag_placeholder'>")
							last_ny = ny;
						}
					}else{
						var chddobj = chobj.prev();
						if(chddobj.attr('id') == objdd.attr('id')){
							chddobj = chddobj.prev();
						}
						if(chddobj.get(0).tagName =='DD'){
							chobj.remove()
							chddobj.before("<dd class='sub_drag_placeholder'></dd>")
							last_ny = ny;
						}
					}
					
				}
			});
			// 鼠标松开
			objdd.unbind('mouseup').mouseup(function(up_e){
				$(document).unbind('mousemove')
				objdd.removeAttr('style')
				objdd.removeClass('dragging').removeClass('ui_sortable_helper')
				$('.sub_drag_placeholder').replaceWith(objdd);
				$("dd, dt").addClass('selected').css('background-color', '#FFFFFF');
				return false;
			});

			// 当objdd.mouseup没有执行后执行鼠标松开 
			$(document).unbind('mouseup').mouseup(function(){
				$(document).unbind('mousemove')
				objdd.removeAttr('style')
				objdd.removeClass('dragging').removeClass('ui_sortable_helper')
				$('.sub_drag_placeholder').remove();
				$("dd, dt").addClass('selected').css('background-color', '#FFFFFF');
			})
			return false
		});
	});

	function last_index(str_id){
		return str_id.split('_').pop()
	}

	function order_index(){
		var index = {}
		$("#MenuList dl").each(function(){
			var dd_arr = []
			var dt_obj = $(this).find('dt').first()
			var dt_index = last_index(dt_obj.attr('id'))
			$(this).find('dd').each(function(){
				var dd_index = last_index($(this).attr('id'))
				dd_arr.push(parseInt(dd_index))
			});
			index[dt_index] = dd_arr.length > 0 ? dd_arr : null
		});
		return index;
	};
});