$(document).ready(function()
    {
    $("#uploadPhotoDialog").dialog( {
show : 'blind',
hide : 'blind',
autoOpen : false,
width : 560,
height : 300,
modal : true,
title : '',
closeText : '关闭'
});

    $("#eidtMenuDialog").dialog( {
show : 'blind',
hide : 'blind',
autoOpen : false,
width : 360,
height : 50,
modal : true,
title : '',
closeText : '关闭'
});
});

function isBrowser()
{
  var version='';
  var isIE = !!window.ActiveXObject;
  var isIE6 = isIE && !window.XMLHttpRequest;
  var isIE8 = isIE && !!document.documentMode;
  var isIE7 = isIE && !isIE6 && !isIE8;
  if (isIE) {
    if (isIE6) {
      version = 'IE6';
    } else if (isIE8) {
      version = 'IE8';
    } else if (isIE7) {
      version = 'IE7';
    }
  }
  else
  {
    version = 'FF';
  }
  return version;
}

var photoDialog={};

photoDialog.closeDialog=function()
{
  swf=null;
  $('#uploadPhotoDialog').dialog('close');
  $("#swfupload_div").html("<span id=\"spanButtonPlaceHolder\"></span><input id=\"btnCancel\" type=\"button\" value=\"取消上传\" onclick=\"swfu.cancelQueue();\" disabled=\"disabled\" style=\"margin-left: 2px; font-size: 8pt; height: 29px;\"/>  ");
};

photoDialog.showUpdatePhotoDialog=function(type,photo_id)
{
  if(type=="chuchuang")
    $("#title").html("更新橱窗图片！");
  else if(type=="advertisement")
    $("#title").html("更新广告图片！");
  $("#url_p").css("display", "none");
  swf=null;
  photoDialog.initSwfu({
      "ope":"update",
      "photo_id":photo_id,
      "name":$("#shop_name").val(),
      "pass":$("#password").val()
      },"/shop_space_index/upload");
  $("#uploadPhotoDialog").dialog("open");
};

photoDialog.showDialog=function(ope,batch,menu_id,menu_name)
{
  $("#ope").val(ope);
  if(ope=="banner")
  {
    $("#title").html("上传店标！(建议大小：1186px × 104px)");
    $("#url_p").css("display", "none");
    swf=null;
    photoDialog.initSwfu({
        "ope":"banner",
        "name":$("#shop_name").val(),
        "pass":$("#password").val()
        },"/shop_space_index/upload");
  }else if(ope=="chuchuang")
  {
    $("#title").html("上传橱窗图片！");
    if(batch==true)
    {
      swf=null;
      $("#url_p").css("display", "none");

    }
    else
      $("#url_p").css("display", "none");
    photoDialog.initSwfu({
        "ope":$("#ope").val(),
        "url":$("#upload_url").val(),
        "name":$("#shop_name").val(),
        "pass":$("#password").val()
        },"/shop_space_index/upload");
    //$("#fsUploadProgress").css("display", "none");
    //$("#swfupload_div").css("display", "none");
    //photoDialog.initSwfu({});
    swf=null;
  }else if(ope=="advertisement")
  {
    $("#title").html("上传广告图片！");
    if(batch==true)
    {
      $("#url_p").css("display", "none");
      swf=null;
    }
    else if(batch=="false")
      $("#url_p").css("display", "block");
    $("#url_p").css("display", "none");
    photoDialog.initSwfu({
        "ope":$("#ope").val(),
        "url":$("#upload_url").val(),
        "name":$("#shop_name").val(),
        "pass":$("#password").val()
        },"/shop_space_index/upload");

  }else if(ope=="image_menu")
  {
    menu_name=$("#image_menu_id option:selected").text();
    menu_id=$("#menu_id").val();
    $("#title").html("上传"+menu_name+"图片！");
    if(batch==true)
    {
      $("#url_p").css("display", "none");
      swf=null;
      $("#url_p").css("display", "none");
    }
    else if(batch=="false")
      $("#url_p").css("display", "none");
    else
      $("#url_p").css("display", "none");
    photoDialog.initSwfu({
        "ope":$("#ope").val(),
        "url":$("#upload_url").val(),
        "name":$("#shop_name").val(),
        "pass":$("#password").val(),
        "menu_id":menu_id
        },"/shop_space_index/upload");
  }
  $("#uploadPhotoDialog").dialog("open");
};

photoDialog.showResult=function(ope,result)
{
  $("#upload_url").val("");
  if(ope=="banner")
  {
    $("#banner").attr({
src:result
});
}else if(ope=="chuchuang")
{
  photoDialog.order_chuchuang_photos(result);
  photoDialog.show_chuchuang_photos();
  location.href="/shop_space_index";
}else if(ope=="advertisement")
{
  photoDialog.order_advertisement_photos(result);
  photoDialog.show_advertisement_photos();
  location.href="/shop_space_index";
}else if(ope=="image_menu")
{
  //photoDialog.show_image_menu_photos($("#menu_id").val(),result);
  photoDialog.change_image_menu($("#menu_id").val());
}
photoDialog.closeDialog();
};

photoDialog.changeUrl=function()
{
  if($("#upload_url").val()=="")
    $("#upload_url_error").text("请输入图片链接地址！");
  else if(photoDialog.isURL($("#upload_url").val())==true)
  {
    $("#upload_url_error").text("");
    photoDialog.initSwfu({
        "ope":$("#ope").val(),
        "url":$("#upload_url").val()
        },"/shop_space_index/upload");
  }
  else
    $("#upload_url_error").text("图片链接地址不正确！");
};

photoDialog.initSwfu=function(params,upload_url){
  swf=null;
  var settings = {
flash_url : "/flash/swfupload.swf",
            upload_url: upload_url,
            post_params: params,
            file_size_limit : "1024",
            file_types : "*.*",
            file_types_description : "All Files",
            file_upload_limit : 10,
            file_queue_limit : 0,
            custom_settings : {
progressTarget : "fsUploadProgress",
                 cancelButtonId : "btnCancel"
            },
debug: false,
       // Button settings
       button_image_url: "/images/FullyTransparent_65x29.png",
       button_width: "65",
       button_height: "29",
       button_placeholder_id: "spanButtonPlaceHolder",
       button_text: '<span>文件上传</span>',
       button_text_style: ".theFont { font-size: 16; }",
       button_text_left_padding: 12,
       button_text_top_padding: 3,
       // The event handler functions are defined in handlers.js
       file_queued_handler : fileQueued,
       file_queue_error_handler : fileQueueError,
       file_dialog_complete_handler : fileDialogComplete,
       upload_start_handler : uploadStart,
       upload_progress_handler : uploadProgress,
       upload_error_handler : uploadError,
       upload_success_handler : uploadSuccess,
       upload_complete_handler : uploadComplete,
       queue_complete_handler : myCustomQueueComplete	// Queue plugin event
  };
  swfu = new SWFUpload(settings);
};

photoDialog.isURL=function(url)
{
  var regExp = /(http[s]?|ftp):\/\/[^\/\.]+?\..+\w$/i;
  if(url.match(regExp))
    return true;
  else
    return false;
};

photoDialog.chuchuang_photo=function(pos)
{
  if(chuchuang_array.length<pos+1)
    $("#chuchuang_photo").attr({
src:"/images/top-banner.png"
});
else
$("#chuchuang_photo").attr({
src:chuchuang_array[pos]
});
};

photoDialog.order_chuchuang_photos=function(src)
{

  for(i=chuchuang_array.length;i>0;i--)
  {
    chuchuang_array[i]=chuchuang_array[i-1];
  }
  chuchuang_array[0]=src;
};

photoDialog.show_chuchuang_photos=function()
{
  for(var i=0;i<chuchuang_array.length;i++)
  {
    var id="#chuchuang_photo_"+i;
    var url=chuchuang_array[i];
    $(id).attr({
src:url
});
}
};

photoDialog.order_advertisement_photos=function(src)
{
  for(i=advertisement_array.length;i>0;i--)
  {
    advertisement_array[i]=advertisement_array[i-1];
  }
  advertisement_array[0]=src;
};

photoDialog.show_advertisement_photos=function()
{
  for(var i=0;i<advertisement_array.length;i++)
  {
    var id="#advertisement_photo_"+i;
    var url=advertisement_array[i];
    $(id).attr({
src:url
});
}
};

photoDialog.change_image_menu=function(menu_id)
{
  var menu_name=$("#image_menu_id option:selected").text();
  //var menu_name=$("#image_menu_id[value='"+menu_id+"']").text();
  $("#image_menu_name").text(menu_name);
  var url="/shop_space_index/image_menu/"+menu_id;
  $("#image_menu_iframe").attr({
src:url
});
$("#menu_id").val(menu_id);
// photoDialog.closeDialog();
document.getElementById("image_menu_iframe").location.reload();
};

photoDialog.change_active_menu=function(menu_id, tag)
{
  var url="/shop_space_index/active_article/"+menu_id;
  var menu_name='';
  if (tag == '1') {
    menu_name=$("#active_menu1_id option:selected").text();
    $("#active_menu1_name").text(menu_name);
    url="/shop_space_index/active_article/"+menu_id + "?ind=0";
    $("#article_menu1_iframe").attr({
src:url
});
$("#menu_id").val(menu_id);
document.getElementById("article_menu1_iframe").location.reload();
} else if (tag == '2') {
  menu_name=$("#active_menu2_id option:selected").text();
  $("#active_menu2_name").text(menu_name);
  url="/shop_space_index/active_article/"+menu_id + "?ind=2";
  $("#article_menu2_iframe").attr({
src:url
});
$("#menu_id").val(menu_id);
document.getElementById("article_menu2_iframe").location.reload();
}
};

photoDialog.showEditMenuDialog=function(type)
{
  var menu_name='';
  var menu_id=null;
  if(type=='article')
  {
    menu_name=$("#active_menu_id option:selected").text();
    menu_id=$("#active_menu_id option:selected").val();
    $("#menu_id").val(menu_id);
  }else if(type=='image')
  {
    menu_name=$("#image_menu_id option:selected").text();
    menu_id=$("#image_menu_id option:selected").val();
    $("#menu_id").val(menu_id);
  }
  $("#menu_name").val(menu_name);
  $("#eidtMenuDialog").dialog("open");
};

photoDialog.editMenuName=function()
{
  var menu_id=$("#menu_id").val();
  var menu_name=$("#menu_name").val();
  $.ajax({
url:'/shop_menus/update_menu/'+menu_id+"?"+'menu_name='+encodeURIComponent(menu_name),
data:'',
type:'post',
dataType:'text',
success:function(tt)
{
location.href="/shop_space_index";
//          $("#image_menu_id option:selected").text(menu_name);
//          $("#eidtMenuDialog").dialog("close");
//          $("#image_menu_name").text(menu_name);
}
});
};
