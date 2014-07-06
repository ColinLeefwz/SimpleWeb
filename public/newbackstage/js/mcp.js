$(document).ready(function(){
	$("input.inputs6").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
	});

	$("textarea").click(function(){
		$(this).addClass("onfocs");
	}).blur(function(){
		$(this).removeClass("onfocs");
	});
	
	$("#cform").submit(function(){
		var num=$("input.inputs6").length;
		for(var i=0;i<num;i++){
			if($("input.inputs6").eq(i).val()==""){
				$("input.inputs6").eq(i).addClass("onfocs2");
				return false;
			}
		}
		if($("textarea.textarea4").val()==""){
			$("textarea.textarea4").addClass("onfocs2");
			return false;
		}
		
	});
});