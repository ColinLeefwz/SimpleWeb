/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 * add by hyw 2010/0618
 */
function checkpwd(){
 var p1=document.getElementById("user_password").value;  //document.new_user.user_password.value; //获取密码框的值
 var p2=document.getElementById("user_password_confirmation").value;  //document.new_user.user_password_confirmation.value; //获取重新输入的密码值
 if(p1==""){
  document.getElementById("msg").innerHTML="请输入密码！"; //在div提示密码输入信息
  //document.new_user.user_password.focus(); //焦点放到密码框
  document.getElementById("user_password").focus();
  return false; //退出检测函数
 }//如果允许空密码，可取消这个条件

 if(p1!=p2){ //判断两次输入的值是否一致，不一致则显示错误信息
  document.getElementById("msg").innerHTML="两次输入密码不一致，请重新输入!"; //在div显示错误信息
  return false;
 }else{
  //密码一致，可以继续下一步操作
  document.getElementById("msg").innerHTML=""; //在div刷新信息
  return true;
 }
}


