$(document).ready(function(){
	$("input.inputs6").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
		if($(this).val()==""){
			$(this).val("3-12个字,如:获取wifi密码");
		}else if($(this).val().length<3){
			$(this).addClass("onfocs2");
			$("#Mes1").html("少于3个字").animate({"left":"290px"},500);
		}
	}).keydown(function(){
		if($(this).val()=="3-12个字,如:获取wifi密码"||$(this).val()=="必填"){
			$(this).val("");
		}
	}).keyup(function(){
		var len=$(this).val().length;
		if(len>12){
			$(this).removeClass("onfocs").addClass("onfocs2");
			$("#Mes1").html("超出12个文字").animate({"left":"290px"},500);
		}else{
			$(this).removeClass("onfocs2").addClass("onfocs");
			$("#Mes1").css({"left":"0px"});
		}
	});
	$("textarea").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
		if($(this).val()==""){
			$(this).val("例如：本店wifi密码：321123");
		}else if($(this).val().length<3){
			$(this).addClass("onfocs2");
			$("#Mes2").html("少于3个字").animate({"left":"400px"},500);
		}else{
			$("#Mes2").css({"left":"0px"});
		}
	}).keydown(function(){
		if($(this).val()=="例如：本店wifi密码：321123"||$(this).val()=="必填"){
			$(this).val("");
		}
	}).keyup(function(){
		$(this).removeClass("onfocs2").addClass("onfocs");
		$("#Mes2").css({"left":"0px"});
	});
	
	$("#cform").submit(function(){
		var n=$("input.inputs6").val();
		var t2=$("textarea.textarea4").val();
		if(n.length==""||n=="3-12个字,如:获取wifi密码"){
			$("input.inputs6").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n=="文字少于3个字符"||n=="必填"){
			$("input.inputs6").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n.length<3){
			$("input.inputs6").addClass("onfocs2").focus();
			$("#Mes1").html("少于3个字").animate({"left":"290px"},500);
			return false;
		}else if(n.length>12){
			$("input.inputs6").addClass("onfocs2").focus();
			$("#Mes1").html("超出12个文字").animate({"left":"290px"},500);
			return false;
		}
		if(t2.length==""||t2=="必填"||t2=="例如：本店wifi密码：321123"){
			$("textarea.textarea4").addClass("onfocs").val("必填").focus();
			return false;
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
		$("#link2").attr("disabled",true);
		$("#link2").removeAttr("abled",true);
		$("#link1").attr("abled",true);
		$("#link1").removeAttr("disabled",true);
		$('#link3').attr("abled",true);
		$("#link3").removeAttr("disabled",true);
	}else if(ro == "1"){
		$("#link1").attr("disabled",true);
		$("#link1").removeAttr("abled",true);
		$("#link2").attr("abled",true);
		$("#link2").removeAttr("disabled",true);
		$('#link3').attr("disabled",true);
		$("#link3").removeAttr("abled",true);
    }
}