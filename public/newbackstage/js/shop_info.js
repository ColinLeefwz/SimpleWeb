$(document).ready(function(){
	$("input.inputs2").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
	});
	
	$("#edit_shop_1").submit(function(){//修改密码
		$(".err").html("");
		var op=$("#oldpass");
		var sp=$("#shop_password");
		var spc=$("#shop_password_confirmation");
		if(op.val()==""){
			op.next().css("display","inline").html("原始密码不能是空");
		}else if(sp.val()==""){
			sp.next().css("display","inline").html("新密码不能是空");
		}else if(sp.val().length<6){
			sp.next().css("display","inline").html("新密码长度小于6位");
		}else if(spc.val()==""){
			spc.next().css("display","inline").html("确认密码不能是空");
		}else{
			spc.next().css("display","inline").html("新密码和确认密码不一致");
		}
	});
});