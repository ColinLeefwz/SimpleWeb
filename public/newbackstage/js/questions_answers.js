$(document).ready(function(){
	$("input.inputs").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
		if($(this).val()==""){
			$(this).val("3-12个字,如:获取wifi密码");
		}
	}).keydown(function(){
		if($(this).val()=="3-12个字,如:获取wifi密码"||$(this).val()=="必填"){
			$(this).val("");
		}
	});
	$("textarea").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
		if($(this).val()==""){
			$(this).val("3-140个字,例如：本店wifi密码：321123");
		}
	}).keydown(function(){
		if($(this).val()=="3-140个字,例如：本店wifi密码：321123"||$(this).val()=="必填"){
			$(this).val("");
		}
	});
	
	$("#cform").submit(function(){
		var n=$("input.inputs").val();
		var t2=$("textarea.textarea2").val();
		if(n.length==""||n=="3-12个字,如:获取wifi密码"){
			$("input.inputs").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n=="文字少于3个字符"||n=="必填"){
			$("input.inputs").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n.length<3){
			$("input.inputs").addClass("onfocs").val("文字少于3个字符").focus();
			return false;
		}
		if(t2.length==""||t2=="必填"||t2=="3-140个字,例如：本店wifi密码：321123"){
			$("textarea.textarea2").addClass("onfocs").val("必填").focus();
			return false;
		}
	});
});