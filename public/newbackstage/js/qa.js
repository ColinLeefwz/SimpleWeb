//本JS只针对问答系统的新增和编辑
$(document).ready(function(){
	$("#link1").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
		if($(this).val()==""){
			$(this).val("http://");
		}
	}).keydown(function(){
		if($(this).val()=="http://"){
			$(this).val("");
		}
	});
	$("#link2").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
		if($(this).val()==""){
			$(this).val("标题");
		}
	}).keydown(function(){
		if($(this).val()=="标题"){
			$(this).val("");
		}
	});
	
	$("#Inputs3").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		var inputs3_val=$(this).val();
		if(inputs3_val==""||inputs3_val=="请输入数字"){
			$(this).val("请输入数字");
			$(this).addClass("onfocs2");
			return false;
		}else if(/\D{1,}/i.test(inputs3_val)){
			$("#Mes3").html("必须填数字").slideDown(500);
			$(this).addClass("onfocs2");
			return false;
		}
		for(var i=0;i<$("#B4L").length;i++){
			var n_i=$("#B4L a").eq(i).attr('rel');
			var inputs3_val=inputs3_val.toString();
			if(inputs3_val==n_i){
				$("#Mes3").html("此数字已被使用").slideDown(500);
				$(this).addClass("onfocs2");
				return false;
			}
		}
		$(this).removeClass("onfocs");
	}).keydown(function(){
		if($(this).val()=="请输入数字"||$(this).val()=="必填"){
			$(this).val("");
		}
	}).keyup(function(){
		var inputs3_val=$(this).val();
		$("#NewNum").html(inputs3_val+"&nbsp;=&gt;&nbsp;");
		if(/\D{1,}/i.test(inputs3_val)){
			$("#Mes3").html("必须填数字").slideDown(500);
			$(this).addClass("onfocs2");	
		}else if(/^\d*$/i.test(inputs3_val)){
			$("#Mes3").html("").slideUp(500);
			$(this).removeClass("onfocs2").addClass(onfocs);
		}
	});
	
	$("#Inputs1").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
		if($(this).val()==""){
			$(this).val("3-12个字,如:获取wifi密码");
		}else if($(this).val().length<3){
			$(this).addClass("onfocs2");
			$("#Mes1").html("少于3个字").slideDown(500);
		}
	}).keydown(function(){
		if($(this).val()=="3-12个字,如:获取wifi密码"||$(this).val()=="必填"){
			$(this).val("");
		}
	}).keyup(function(){
		var len=$(this).val().length;
		var inputs1_val=$("#Inputs1").val();
		
		if(inputs1_val=="3-12个字,如:获取wifi密码"){inputs1_val="";}
		
		$("#NewTitle").html(inputs1_val);
		
		if(len>12){
			$(this).removeClass("onfocs").addClass("onfocs2");
			$("#Mes1").html("超出12个文字").slideDown(500);
		}else{
			$(this).removeClass("onfocs2").addClass("onfocs");
			$("#Mes1").slideUp(500);
		}
	});
	$("#Inputs2").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
		if($(this).val()==""){
			$(this).val("例如：本店wifi密码：321123");
		}else if($(this).val().length>1000){
			$(this).addClass("onfocs2");
			$("#Mes2").html("超过1000个字").slideDown(500);
		}else{
			$("#Mes2").slideUp(500);
		}
	}).keydown(function(){
		if($(this).val()=="例如：本店wifi密码：321123"||$(this).val()=="必填"){
			$(this).val("");
		}
	}).keyup(function(){
		$(this).removeClass("onfocs2").addClass("onfocs");
		$("#Mes2").slideUp(500);
	});
	
	$("#cform").submit(function(){
		var n=$("#Inputs1").val();
		var n2=$("#Inputs3").val();
		var t2=$("#Inputs2").val();
		alert(n);
		
		if(n2==""||n2=="请输入数字"){
			$("#Inputs3").val("请输入数字");
			$("#Inputs3").addClass("onfocs").focus();
			return false;
		}else if(/\D{1,}/i.test(n2)){
			$("#Mes3").html("必须填数字").slideDown(500);
			$("#Inputs3").addClass("onfocs2").focus();
			return false;
		}
		for(var i=0;i<$("#B4L").length;i++){
			var n_i=$("#B4L a").eq(i).attr('rel');
			var n2=n2.toString();
			if(n2==n_i){
				$("#Mes3").html("此数字已被使用").slideDown(500);
				$("#Inputs3").addClass("onfocs2").focus();
				return false;
			}
		}
		
		if(n.length==""||n=="3-12个字,如:获取wifi密码"){
			$("#Inputs1").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n=="文字少于3个字符"||n=="必填"){
			$("#Inputs1").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n.length<3){
			$("#Inputs1").addClass("onfocs2").focus();
			$("#Mes1").html("少于3个字").slideDown(500);
			return false;
		}else if(n.length>12){
			$("#Inputs1").addClass("onfocs2").focus();
			$("#Mes1").html("超出12个文字").slideDown(500);
			return false;
		}

		if(t2.length==""||t2=="必填"||t2=="例如：本店wifi密码：321123"){
			$("#Inputs2").addClass("onfocs").val("必填").focus();
			return false;
		}else if(t2.length>1000){
			$("#Inputs2").addClass("onfocs2").focus();
			$("#Mes2").html("超过1000个字").slideDown(500);
			return false;
		}
	});
	
	$("#Preview").click(function(){
		$("#LinkDiv").animate({"margin-left":"-330px"});
    	var od = $('#shop_faq_od').val();
    	var title = $('#Inputs1').val();
    	var text = $('#Inputs1').val();
    	var head = $('#link2').val();
    	var content = $('#baidu_editor_0').contents().find('body').html()

  		$.post("/shop3_faqs/ajax_preview",{od:od, title:title, text:text, head:head, content:content},function(data){
  			var pid = data['id'];
  			$('#previewIframe').attr("src",'/shop3_faqs/preview?id='+pid);  
  		})
	});
	$("#Edit").click(function(){
		$("#LinkDiv").animate({"margin-left":"0px"});
	});
});

$(window).load(function(){
	$(window).unbind("resize");
	if(windowWidth<=1024){
		$("div.main").css({"width":"1150px","padding-left":"50px"});
	}
	$(window).resize(function(){
		windowWidth=$(window).width();
		documentHeight=$(document).height();
		windowHeight=$(window).height();
		if(windowWidth<=1024){
			$("div.main").css("width","1150px");
			if(parseInt($("#Nav").css("left"))==0){
				$("div.main").stop(true).animate({"width":"1150px","padding-left":"50px"});
			}
		}else{
			$("div.main").css({"width":"100%","padding-left":"0px"});
		}
		if(documentHeight<=windowHeight){
			$("#Nav").css("height",windowHeight+"px");
			$("#Navcon").css("height",(windowHeight-50)+"px");
		}else{
			$("#Nav").css("height",documentHeight+"px");
			$("#Navcon").css("height",(documentHeight-50)+"px");
		}
	});
});
function show_link_rulev(rv){
	if(rv =="0"){ 
		$("#editor_none_block").css("display","none");
		$("#rulev").css("display","block");
		// $("#rulev label").text("外部链接");
	}else if(rv=="1"){
		$("#rulev").css("display","none");
		$("#editor_none_block").css("display","block");
	}
}

function select_radio(ro){
	if(ro == "0"){
		$("#LinkDiv").animate({"margin-left":"400px"},500,function(){
			$("#LinkDiv").css("display","none");
			$("#link1").css({"display":"block","background-color":"#ffffff"});
			$("#link1").removeAttr("disabled").animate({"margin-left":"8px"});
		});
	}else if(ro == "1"){
		$("#link1").animate({"margin-left":"400px"},500,function(){
			$("#link1").css("display","none");
			$("#LinkDiv").css("display","block");
			$("#LinkDiv").animate({"margin-left":"0px"},500);
		});
    }
}