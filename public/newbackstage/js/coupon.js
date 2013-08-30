$(document).ready(function(){
	if($("#Box6Message").html()!=""){
		$("#Box6Message").animate({"top":"-40px"},300);
	}
	$("input.inputs2").click(function(){
		$(this).addClass("onfocs");
	}).keyup(function(){
		var len=$(this).val().length;
		if(len>13){
			$("#Box6Message").html("标题超出13个文字");
			$("#Box6Message").animate({"top":"-40px"},300);
			$(this).removeClass("onfocs").addClass("onfocs2");
		}else{
			$(this).removeClass("onfocs2").addClass("onfocs");
			$("#Box6Message").animate({"top":"0px"});
		}
	}).keydown(function(){
		if($(this).val()=="优惠券主题 不得超过13个文字"||$(this).val()=="必填"){
			$(this).val("");
		}
	}).blur(function(){
		var len=$(this).val().length;
		if($(this).val()==""){
			$(this).val("优惠券主题 不得超过13个文字");
		}else if(len<=13){
			$(this).removeClass("onfocs");
			$("#Box6Message").animate({"top":"0px"});
		}
	});
	$("textarea").click(function(){
		$(this).addClass("onfocs");
	}).keyup(function(){
		var len=$(this).val().length;
		if(len>90){
			$("#Box6Message").html("内容超出90个文字");
			$(this).removeClass("onfocs").addClass("onfocs2");
			$("#Box6Message").animate({"top":"-40px"},300);
		}else{
			$(this).removeClass("onfocs2").addClass("onfocs");
			$("#Box6Message").animate({"top":"0px"});
		}
	}).keydown(function(){
		if($(this).val()=="优惠额度，使用规则、期限等，不超过90字"||$(this).val()=="必填"){
			$(this).val("");
		}
	}).blur(function(){
		if($(this).val()==""){
			$(this).val("优惠额度，使用规则、期限等，不超过90字");
		}
		$(this).removeClass("onfocs");
	});
	
	$("#coupon_rulev").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		if($(this).val()==""){
			$(this).removeClass("onfocs").addClass("onfocs2");
			$("#rulev span").css("display","inline").text("不得为空");
		}else if(isNaN($("#coupon_rulev").val())){
			$(this).removeClass("onfocs").addClass("onfocs2");
			$("#rulev span").css("display","inline").text("必须为数字");
		}else{
			$(this).removeClass("onfocs");
			$(this).removeClass("onfocs2");
			$("#rulev span").css("display","none").text("");
		}
	});
	
	$("#Forms").submit(function(){
		var n=$("input.inputs2").val();
		var t1=$("textarea.textarea3").val();
		var imgsrc=$("#uploadPreview img").attr("src");
		if(n.length==""||n=="优惠券主题 不得超过13个文字"||n=="必填"){
			$("input.inputs2").addClass("onfocs").val("必填").focus();
			return false;
		}else if(n.length>13){
			$("#Box6Message").html("标题超出13个文字");
			$("input.inputs2").removeClass("onfocs").addClass("onfocs2");
			$("#Box6Message").animate({"top":"-40px"},300);
			return false;
		}
		if(t1.length==""||t1=="必填"||t1=="优惠额度，使用规则、期限等，不超过90字"){
			$("textarea.textarea3").addClass("onfocs").val("必填").focus();
			return false;
		}else if(t1.length>90){
			$("#Box6Message").html("内容超出90个文字");
			$("textarea.textarea3").removeClass("onfocs").addClass("onfocs2");
			$("#Box6Message").animate({"top":"-40px"},300);
			return false;
		}
                
                if($("#uploadPreview").attr("rel")!="share"){
                    if(imgsrc=="/newbackstage/images/pic6.jpg"||imgsrc==""){
                            $("#Box6Message").html("请上传一张优惠券图片");
                            $("#Box6Message").animate({"top":"-40px"},300);
                            return false;
                    }
                }
		if($("#rulev").css("display")=="block"){
			if($("#coupon_rulev").val()==""){
				$("#coupon_rulev").addClass("onfocus2");
				$("#rulev span").css("display","inline").text("不得为空");
				return false;
			}else if(isNaN($("#coupon_rulev").val())){
				$("#rulev span").css("display","inline").text("必须为数字");
				return false;
			}
		}
	});
});
function show_rulev(rv){
	if(rv =="1"){ 
		$("#rulev").css("display","block");
		$("#rulev label").text("前几名");
	}else if(rv=="3"){
		$("#rulev").css("display","block");
		$("#rulev label").text("累计次数");
	}else{
		$('#rulev').css("display","none");
	}
}

function show_hint(rv){
	if(rv =="1"){
		$("#hint1").show()
	}else{
		$("#hint1").hide()
	}
}