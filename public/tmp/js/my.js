// JavaScript Document
$(function(){
  //获取头像高度
  var headH = $(".headImg").height();
  
  //获取消息框高度
  var msgH = $(".msg");
  
  //遍历所有消息框，根据消息框的高度和头像的高度比较来判断；
  msgH.each(function(){
	 var thisH = $(this).height();
	  
	  //若消息框高度<头像高度；则对消息框设置padding-top，使其与头像底部对齐
	  if(thisH < headH){
		var mT1 = headH - thisH;		
		$(this).css("padding-top",mT1); 
		 
	  //若消息框高度>=头像高度；则对头像设置padding-top，使其与消息框底部对齐
	  }else{
		 var mT2 = thisH - headH;	
		 $(this).siblings(".headImg").css("padding-top",mT2);  
	  }
  });
 
})