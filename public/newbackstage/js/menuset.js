//$(document)放置的是滚动导航栏效果
$(document).ready(function(){
	var zb=0,timer;	
	$("#RightArrow").mousedown(function(){
		clearInterval(timer);
		timer=setInterval(function(){
			if((558-ul_w)>0){clearInterval(timer);return false;}
			zb++;
			if(zb>(ul_w-558)){clearInterval(timer);return false;}
			$("#B17LC ul").css("margin-left",-zb+"px");
		},1);
	});
	$("#LeftArrow").mousedown(function(){
		clearInterval(timer);
		timer=setInterval(function(){
			if((558-ul_w)>0){clearInterval(timer);return false;}
			zb--;
			if(zb<0){zb=0;clearInterval(timer);return false;}
			$("#B17LC ul").css("margin-left",-zb+"px");
		},1);
	});
	$("#RightArrow,#LeftArrow").mouseup(function(){
		clearInterval(timer);
	});

	$("#B17LC ul li").click(function(){
		$("#B17LC ul li").removeClass("hover");
		$(this).addClass("hover");
		var rel=$(this).attr("rel");
		$(this).closest("div.box17con").find("div.box17coninner1").addClass("none");
		$("#B17C"+rel).removeClass("none");
	});
});

var sn="F",			//用于子菜单，添加子菜单时此值用subnum确定。
	str,			//用于存放新增/编辑
	delnum, 		//删除编号
	sort="sort";		//排序
function OpenBG(){
	var top;
    documentHeight=$(document).height();
    windowHeight=$(window).height();
    if(documentHeight<=windowHeight){
      $("#BG").css({"height":windowHeight+"px","display":"block"});
    }else{
      $("#BG").css({"height":documentHeight+"px","display":"block"});
    }
}
function MessageDelDiv(deldivmessage){
	$("#DelDiv center").html(deldivmessage);
	OpenBG();
    $("#DelDiv").fadeIn(600);
}
function Close(ID){
	$("#"+ID).animate({"top":"0px"},400,function(){
		$("#"+ID).removeAttr("style");
		$("#"+ID+",#BG").css("display","none");
		sn="F";
	});
}
function Close2(){
	$("#DelDiv").animate({"top":"0px"},400,function(){
		$("#BG").css({"display":"none"});
		$("#DelDiv").removeAttr("style");
	});
}
function Close3(){
	$("#Phone").removeClass("block");
	$("#BG").css({"display":"none"});
}
function InfoDiv(strs,subnum){
	if(strs==""){
		if(menujson.menu.button.length>=3&&subnum==""){
			MessageDelDiv("<br/>一级菜单最多只能三个");
			return false;
		}
		if(subnum!=""){
			if(menujson.menu.button[subnum].sub_button.length >=5 ){
				MessageDelDiv("<br/>二级菜单最多只能五个");
				return false;
			}
			sn=subnum;
		}
		str="news";
	}else{
		str="edit";
		if(subnum!=""){
			sn=(subnum.toString()).split(",");
			if((sn.length==1)&&(menujson.menu.button[subnum].sub_button.length!=0)){
				MessageDelDiv("<br/>已有子菜单，无法设置动作");
				return false;
			}
		}
	}
	OpenBG();
	$("#TS").addClass("none");
	$("#Inputs").val(strs);
    $("#Info").fadeIn(600);
}
function SubMits(){
	var name,index,len=0;
	$("#TS").addClass("none");
	if(sn=="F"){
		index=null;
	}else{
		index=sn;
	}
	name = $('#Inputs').val();
	name = name.replace(/^[ ]*|[ ]*$/g,'');
	
	for(var i=0; i< name.length; i++){
			len += (name[i].charCodeAt() <= 127 ? 1 : 2);
	}
	if(name.length==0){
		$("#TS").removeClass("none").html("输入框内容不能为空");
		return false;
	}else if(sn=="F"&&len>8){
		$("#TS").removeClass("none").html("菜单名称不能超过4个汉字或8个字母");
		return false;
	}else if(sn!="F"&&len>12){
		$("#TS").removeClass("none").html("子菜单名称不能超过6个汉字或12个字母");
		return false;
	}

	if(str=="news"){
		$.post("/shop3_menu/add_menu", {index: index, name: name }, function(data){
			menujson = data;
			Relist_Menu();
			$("#TS").addClass("none");
			$("#Info,#BG").css("display","none");
			sn="F";
		});
	}else if(str=="edit"){
		$.post("/shop3_menu/edit_menu", {index: index, name: name }, function(data){
			menujson = data;
			Relist_Menu();
			$("#TS").addClass("none");
			$("#Info,#BG").css("display","none");
			sn="F";
		});
	}
}
function MesSubMits(){
	OpenBG();
    $("#Message1").fadeIn(600);
}
function FormMits(){
	$("#Message1").css("display","none");
	var allow_pub = true
	menujson.menu.button.forEach(function(button){
		if(button.sub_button.length > 0){
			button.sub_button.forEach(function(sub_button){
				if(!sub_button.type){
					allow_pub = false;
				}
			});
		}else{
			if(!button.type){
				allow_pub = false;
			}
		}
	});
	if(allow_pub){
		$.post("/shop3_menu/pub", function(data){
			MessageDelDiv("<br/>发布成功");
		})
	}else{
		MessageDelDiv("存在还未设置响应动作的菜单,请检查。");
	}
}
function DelDiv(subnum){								//打开删除对话框
	delnum=(subnum.toString()).split(",");
	OpenBG();
    $("#Del").fadeIn(600);
}
function DelSubMits(){									//删除菜单项目
	$.post("/shop3_menu/del", {index: delnum}, function(data){
		menujson = data;
		Relist_Menu();
		$("#Del,#BG").css("display","none");
		delnum="";
	});
}
function Get_Menu_Map(tagid){
		var menus = tagid.split('_')
		if(menus[0]=='menu'){
			menu_map = [menus[1]]
		}else{
			menu_map = [menus[2], menus[3]]
		}
		return menu_map
	}
function Relist_Menu(){									//重新排版菜单
		var selected_id = $(".selected").attr('id')
    var html = ''
    $(menujson.menu.button).each(function(index, val){
        html += '<dl class="ui-sortable-disabled">';
        html += '<dt id="menu_' + index +'">';
        html += '<i class="downarrow"></i>';
        var tp = "'"+ val.type2 +"'," + "'" + val.url + "'"
        html += ('<a class="mlink" onClick="OpenPlane(this,\'parent\',sort,'+ tp +')">'+val.name+ '</a>');
        html +='<span class="menu_opr">';  
        if(!val.type){
            html += '<a class="add_gray" rel="'+ index +'" onClick="InfoDiv(\'\',\''+index+'\')">添加</a>';
        }  
        html += '<a class="edit_gray" rel="'+ index +'" onclick="InfoDiv(\'\',\''+ index+'\')" >编辑</a>'
        html += '<a class="del_gray"  rel="'+ index +'" onclick="DelDiv(\''+index+'\')" >删除</a>'
        html += '<a style="display:none" class="sort_gray">排序</a>'
        html += '</span></dt>'
        $(val.sub_button).each(function(sub_index, sub_val){
            html += '<dd id="subMenu_menu_'+ index + '_'+ sub_index +'">';
            html += '<i class="point">●</i>';
            var stp = "'"+ sub_val.type2 +"'," + "'" + sub_val.url + "'"
            html += '<a class="mlink" onClick="OpenPlane(this,\'sub\',sort,'+ stp +')">'+ sub_val.name +'</a>';
            html += '<span class="menu_opr">';
            html += '<a class="edit_gray" rel="'+ index +','+ sub_index +'" onclick="InfoDiv(\''+sub_val.name+'\',\''+index+','+sub_index+'\')" >编辑</a>';
            html += '<a class="del_gray" rel="'+ index +','+ sub_index +'" onclick="DelDiv(\''+index+','+sub_index+'\')">删除</a>';
            html += '<a style="display:none" class="sort_gray">排序</a></span></dd>';
        })
         html += "</dl>";
		 
    })
    $('dl').remove();
    $('#MenuList').append(html);
    if(selected_id){
    	$('#'+selected_id).addClass('selected')
    }
};
function OpenPlane(obj,str,sort,type2,url) {							//打开右侧面板

	if(sort=="nosort"){return false;}
	$(".mlink").parent().removeClass("selected");
	$(obj).parent().addClass("selected");
	$('.box18bg').removeClass('jshover').hide();
	var strs=$(obj).parent().next().text();

	$(".box17right").addClass("none");
	if(str=="parent"&&strs!=""){
		$("#Box17Con2").removeClass("none");
	}else{
		$("#Box17Con3").removeClass("none");
	}
	if(type2=="url"){
		HttPLink({url: url});
		$("#Box17Con4 .pl20").html(url);
		return false;
	}else if(type2=='mweb'){
		PhoneLink({no_action: true});
		var obj = $('.box18bg[rel="'+url+'"]').parent().clone().removeClass('box18change');
		obj.find(".box18bg").remove();
		return false
	}else if(type2=='app'){
		APPLink({no_action: true});
		var obj = $('.box18bg[rel="'+url+'"]')
		var src = obj.next().attr('src')
		var title = obj.siblings().last().html()
		var robj = $('#Box17Con7 .box18')
		robj.find('img').attr('src', src)
		robj.find('span').html(title)
		return false
	}else if(((/(^http\:\/\/)|(^https\:\/\/)/).test(url))){
		HttPLink({url: url});
		$("#Box17Con4 .pl20").html(url);
		return false;
	}
}
function HttPLink(option){										//打开链接编辑页
	option = option || {}
	$(".box17right").addClass("none");
	$("#Box17Con4").removeClass("none");
	if(option.url){
		$("#linkbtn").unbind('click').click(function(){
			EditLink(option.url)
		})
	}else{
		EditLink()
	}
}
function PhoneLink(option){										//打开手机编辑页
	option = option || {}
	$(".box17right").addClass("none");
	$("#Box17Con5").removeClass("none");
	if(option.no_action){
		return false;
	}else{
		$('#mwebbtn').click();
		$('#B17LC li').first().click();
	}
}
function APPLink(option){											//打开APP应用页
	option = option || {}
	$(".box17right").addClass("none");
	$("#Box17Con7").removeClass("none");
	if(option.no_action){
		return false;
	}else{
		$('#appbtn').click();
	}
}
function Res(){												//所有单元归零
	$(".box17right").addClass("none");
	$("#Box17Con3").removeClass("none");
	$(window).resize();
}
function EditLink(url){										//打开编辑页面
	$(".box17right").addClass("none");
	$("#Box17Con9").removeClass("none");
	$('#TextArea5').val(url||'')
}
function SaveLink(){
	var m = $('.selected')[0];
	var indexs = Get_Menu_Map(m.id);
	var url = $("#TextArea5").val();
	if(!((/(^http\:\/\/)|(^https\:\/\/)/).test(url))){
		$("#UrlFail").removeClass("none");
		return false;
	}
	$.post("/shop3_menu/set_view_action",{index: indexs, button: {url: url, type:"view", type2: 'url'}}, function(data){
		menujson = data;
		Relist_Menu();
		$("#"+m.id).addClass("selected");
		$("#UrlFail").addClass("none");
		$(".box17right").addClass("none");
		$("#Box17Con4").removeClass("none");
		$("#Box17Con4 .pl20").html(url);
		$(".selected a.mlink").click();
	});
	
}
function EditWeb(obj){									//选择跳转页面
	$(".box17right").addClass("none");
	$("#Box17Con6").removeClass("none");
}
function EditAPP(){										//跳转到应用页面
	$(".box17right").addClass("none");
	$(".box18bg").hide();
	$("#Box17Con8").removeClass("none");
}
function ChangePlane(obj){
	$(obj).siblings().find("div.box18bg").hide().removeClass('jshover');
	$(obj).find("div.box18bg").toggle().addClass('jshover');
}
function More(obj,n){
	$(obj).val("加载中...");
	var str="";
	for(var i=0;i<4;i++){
		str+='<div class="box18 box18change" onclick="ChangePlane(this)">'
				+'<div class="box18bg"><img src="/newbackstage/images/sign65.png"/></div>'
				+'<h2 class="tit">安居，一部厚重的书（序）</h2><span class="time">2014-03-22</span>'
				+'<img src="/newbackstage/images/pic36.jpg"/>'
				+'先看看安居历史之久远。差不多两亿年前，这里就有古生物活动。而在两万年前，就有人类居住了……'
			+'</div>';	
	}
	$("#B17C"+n).find("div.box17ci").append(str);
	$(obj).val("更 多");
	$(window).resize();
}
function SaveWeb(obj){
	var m = $('.selected')[0];
	var indexs = Get_Menu_Map(m.id);
	var url = $("#PW").contents().find("div.box17ci div.jshover").attr("rel");
	if(!url){
		MessageDelDiv('<br/>没有选择文章');
		return false;
	}
	$.post("/shop3_menu/set_view_action",{index: indexs, button: {url: url, type:"view", type2: 'mweb'}}, function(data){
		menujson = data;
		Relist_Menu();
		$(".box17right").addClass("none");
		$("#Box17Con5").removeClass("none");
		$(window).resize();
		$(".selected a.mlink").click();
	});
}

function SaveAPP(){
	var m = $('.selected')[0]
	var indexs = Get_Menu_Map(m.id);
	var url = $("#Box17Con8 div.jshover").attr('rel')
	if(!url){
		MessageDelDiv('<br/>没有选择应用')
		return false;
	}
	$.post("/shop3_menu/set_view_action",{index: indexs, button: {url: url, type:"view", type2: 'app'}}, function(data){
			menujson = data;
			Relist_Menu();
			$(".box17right").addClass("none");
			$("#Box17Con7").removeClass("none");
			$(window).resize();
			$(".selected a.mlink").click();
		})
}
function ResWeb(){
	$(".box17right").addClass("none");
	$("#Box17Con5").removeClass("none");
	$(window).resize();
}
function ResAPP(){
	$(".box17right").addClass("none");
	$("#Box17Con7").removeClass("none");
	$(window).resize();
}
function View(){									//模拟手机
	OpenBG();
	$("#Phone").addClass("block");
	var html = "<ul id='PhoneMenu'>";
	$(menujson.menu.button).each(function(index, val){
		html += "<li><a class='plink'>" + val.name + "</a>";
		html += "<div class='phonediv'>";
		$(val.sub_button).each(function(sub_index, sub_val){
			html += "<a href="+sub_val.url+" target='IFrame'>"+ sub_val.name +"</a>";
		})
		html += "<span class='al'></span><span class='ar'></span></div></li>"
	})
	html += '</ul>'
	$("#PhoneDS").replaceWith(html);
	$("#PhoneMenu a.plink").each(function(index){
		$(this).bind("click",function(){
			$(this).parent("li").siblings().find("div.phonediv").hide();
			$(this).next().toggle();
			var obj=$(this).next().find("a").eq(0).html();
			if(!obj){$(this).next().hide();}
		});
	});
}