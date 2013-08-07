$(document).ready(function(){
	$("input.inputs2").click(function(){
		$(this).addClass("onfocs").val("");
	}).keyup(function(){
		var len=$(this).val().length;
		if(len>13){
			$("#Box6Message").html("标题超出13个文字");
			$(this).removeClass("onfocs").addClass("onfocs2");
			$("#Box6Message").animate({"top":"-40px"});
		}else{
			$(this).removeClass("onfocs2").addClass("onfocs");
			$("#Box6Message").animate({"top":"0px"});
		}
	}).blur(function(){
		var len=$(this).val().length;
		if(len<=13){
			$(this).removeClass("onfocs");
			$("#Box6Message").animate({"top":"0px"});
		}
	});
	$("textarea").click(function(){
		$(this).addClass("onfocs").val("");
	}).keyup(function(){
		var len=$(this).val().length;
		if(len>90){
			$("#Box6Message").html("内容超出90个文字");
			$(this).removeClass("onfocs").addClass("onfocs2");
			$("#Box6Message").animate({"top":"-40px"});
		}else{
			$(this).removeClass("onfocs2").addClass("onfocs");
			$("#Box6Message").animate({"top":"0px"});
		}
	}).blur(function(){
		$(this).removeClass("onfocs");
	});
	
	$("#Forms").submit(function(){
		var n=$("input.inputs2").val();
		var t1=$("textarea.textarea3").val();
		if(n.length==""||n=="优惠券主题 不得超过13个文字"||n=="必填"){
			$("input.inputs2").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n.length>13){
			$("#Box6Message").html("标题超出13个文字");
			$("input.inputs2").removeClass("onfocs").addClass("onfocs2");
			$("#Box6Message").animate({"top":"-40px"});
			return false;
		}
		if(t1.length==""||t1=="必填"||t1=="优惠额度，使用规则、期限等（限90个文字，一行限16个字符）"){
			$("textarea.textarea3").addClass("onfocs").val("必填").focus();
			return false;
		}else if(t1.length>90){
			$("#Box6Message").html("内容超出90个文字");
			$("textarea.textarea3").removeClass("onfocs").addClass("onfocs2");
			$("#Box6Message").animate({"top":"-40px"});
			return false;
		}			
	});						   
});