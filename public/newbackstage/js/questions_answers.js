$(document).ready(function(){
	$("input.inputs").click(function(){
		$(this).addClass("onfocs").val("");
	}).blur(function(){
		$(this).removeClass("onfocs");
	});
	$("textarea").click(function(){
		$(this).addClass("onfocs").val("");
	}).blur(function(){
		$(this).removeClass("onfocs");
	});
	
	$("#Forms").submit(function(){
		var n=$("input.inputs").val();
		var t1=$("textarea.textarea1").val();
		var t2=$("textarea.textarea2").val();
		if(n.length==""||n=="如：获取本店wifi密码"){
			$("input.inputs").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n=="文字少于3个字符"||n=="必填"){
			$("input.inputs").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n.length<3){
			$("input.inputs").addClass("onfocs").val("文字少于3个字符").focus();
			return false;
		}
		if(t1.length==""||t1=="必填"||t1=="如：本店wifi密码：321123"){
			$("textarea.textarea1").addClass("onfocs").val("必填").focus();
			return false;
		}
		if(t2.length==""||t2=="必填"||t2=="详细内容"){
			$("textarea.textarea2").addClass("onfocs").val("必填").focus();
			return false;
		}
		
	});
});