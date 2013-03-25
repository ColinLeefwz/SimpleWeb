// JavaScript Document
$(function(){
 
  //获取头像高度
  var headH = $(".headImg").height()+14;
  
  //获取消息框高度
  var msgH = $(".msg");
  
  //遍历每一个消息框的高度，判断是否<头像高，成立则给把头像高度赋给父元素li作为其最小高度，防止头像在视觉上溢出父元素（头像绝对定位不占位置，会‘溢出’）；
  msgH.each(function(){
	  if($(this).height()<headH){
		 $(this).parents("li").height(headH);  
	  }  
	  
  });
 
})