var comment={};
comment.submitComment=function()
{
 var shopId = $("#c_shop_id") != null ? $("#c_shop_id").val() : "";
 var articleId = $("#article_id") != null ? $("#article_id").val() : "";
 var discountId = $("#discount_id") != null ? $("#discount_id").val() : "";
 var shopPhotoId = $("#shop_photo_id") != null ? $("#shop_photo_id").val() : "";
 var user_logo = $("#user_logo_file_name") != null && $("#user_logo_file_name").val() != '' ? $("#user_logo_file_name").val() : "/user_logos/___small.jpg";
       var body=$("#body_id").val();
       var captcha=$("#captcha").val();
       var nic_name=$("#comment_nic_name").val();
       var token = ($("input[name='authenticity_token']") != null && $("input[name='authenticity_token']").length > 0) ? $("input[name='authenticity_token']")[0].value : $("#comment_form_authenticity_token").val();
       var params={'[comment][shop_id]':shopId,'[comment][article_id]':articleId,'[comment][discount_id]':discountId,'[comment][shop_photo_id]':shopPhotoId,'[comment][body]':body,captcha:captcha,nic_name:nic_name, authenticity_token:token};
       $.ajax({
            type:"POST", url:"/shop_space/comment/1", data:params, dataType:"text",
             success: function(data){
                    if(data!='验证码错误！'&&data!='请先登录后再点评！')
                    {
                         var html="<div onmouseover=\"this.className='d_over'\" onmouseout=\"this.className='d_out'\" id=\"comment_747\" class=\"d_out\">";
                         html+="<div id=\"t_pl_picyure\">";
                         html+="<img src=\"" + user_logo + "\" width=\"50px\" height=\"50px\" /><h2>" + nic_name + "</h2></div>";
                         html+="<div id=\"pl-content\"><p>";
                         html+=body.replace(/\/：(\d)+\*/g,  function (var1) {
                           return "<img src=\"/img/bq/" + var1.match(/\d+/)[0] + ".gif\" />"
                           })
                         html+="</p><p></p><span></span></div></div>";
                         $("#comments").prepend(html);
                    }else {
                        alert(data);
}
             },
             error:function(){
             }
        });
};

comment.submitHehunComment=function()
{
       var body=$("#comment_body").val();
       var captcha=$("#captcha").val();
       var nic_name=$("#comment_nic_name").val();
       var to_user=$("#comment_to_user").val();
       var params={'[comment][body]':body,captcha:captcha,nic_name:nic_name,to_user:to_user};
       $.ajax({
            type:"POST", url:"/shop_space/comment/1", data:params, dataType:"text",
             success: function(data){
                    if(data!='验证码错误！'&&data!='请输入昵称！')
                    {
                         alert(data);
                    }else
                    {
                        alert(data);
                        window.parent.closeIframe();
                     }
             },
             error:function(err){
                 alert(err);
             }
        });
};

comment.refreshComment=function(shopId)
{
       var params={'shop_id':shopId};
       $.ajax({
            type:"POST", url:"/shop_space/comments/1", data:params, dataType:"text",
             success: function(data){
                   $("#comments").html(data);
             },
             error:function(){

             }
        });
         $(function () {
            $('.comments a').click(function () {
            $.get(this.href, null, null, 'script');
                return false;
            });
        });
};



