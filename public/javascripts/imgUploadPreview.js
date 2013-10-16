/***
 *  图片上传预览， select文件选择框， divid： 图片要预览的id
 **/

function imgUploadPreview2(select, divid){//问答系统
    $(select).change(function(){
        var picPath =  this.value
        var type = picPath.substring(picPath.lastIndexOf(".") + 1, picPath.length).toLowerCase();
        if (type != "jpg" && type != "png") {
            $(this).val('')
            alert("请上传jpg/png格式图片");
            return false;
        }

        try{
            var divObj = document.getElementById(divid);
            if(navigator.userAgent.indexOf("MSIE") > -1&& (navigator.userAgent.indexOf("MSIE 7.0") > -1|| navigator.userAgent.indexOf("MSIE 9.0") > -1 || navigator.userAgent.indexOf("MSIE 8.0") > -1)  ){
				this.select();
                this.blur();
                var path = document.selection.createRange().text;
                document.selection.empty();
                path = "file:///" + path.replace("\\",'/');
                document.getElementById("image_view").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+ path + "')";
				document.getElementById("image_view").src ="http://shop.dface.cn/images/clear.gif";
				//divObj.innerHTML="<img id='image_view1' style='background:url(file:///"+$(select).val()+") center center no-repeat;height: 100%; width: 100%;'/>";
			}else if(navigator.userAgent.indexOf("MSIE") > -1&& navigator.userAgent.indexOf("MSIE 6.0") > -1 ){
				divObj.innerHTML = "<img id='image_view' style='height: 100%; width: 100%;' />";
                var imageView = document.getElementById("image_view");
                imageView.src = $(this).val();
            }else{
				 var file = $(this).get(0).files[0];
				 var reader = new FileReader();
					reader.readAsDataURL(file);
					reader.onload = function(e){
						$("#"+divid).html("<img style='height: 100%; width: 100%;' id='image_view'  src='"+this.result+"'/>");
					}
			}

        }catch (e) {
            //alert("游览器不支持预览图片")
        }
    });
}


function imgUploadPreview(select, divid){//优惠券
    $(select).change(function(){
        var picPath =  this.value
        var type = picPath.substring(picPath.lastIndexOf(".") + 1, picPath.length).toLowerCase();
        if (type != "jpg" && type != "png") {
            $(this).val('')
            alert("请上传jpg/png格式图片");
            return false;
        }
        
        try{
            var divObj = document.getElementById(divid)
            if(navigator.userAgent.indexOf("MSIE") > -1&& (navigator.userAgent.indexOf("MSIE 7.0") > -1|| navigator.userAgent.indexOf("MSIE 9.0") > -1 || navigator.userAgent.indexOf("MSIE 8.0") > -1)  ){
				this.select();
                this.blur();
                var path = document.selection.createRange().text;
                document.selection.empty();
                path = "file:///" + path.replace("\\",'/');
                document.getElementById("image_view").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+ path + "')";
				document.getElementById("image_view").src="http://shop.dface.cn/images/clear.gif";

				//divObj.innerHTML="<img id='image_view1' style='background:url(file:///"+$(select).val()+") center center no-repeat;height: 100%; width: 100%;'/>";
			}else if(navigator.userAgent.indexOf("MSIE") > -1&& navigator.userAgent.indexOf("MSIE 6.0") > -1 ){
				divObj.innerHTML = "<img id='image_view' style='height: 100%; width: 100%;' />";
                var imageView = document.getElementById("image_view");
                imageView.src = $(this).val();
            }else{
				 var file = $(this).get(0).files[0];
				 var reader = new FileReader();
					reader.readAsDataURL(file);
					reader.onload = function(e){
						$("#"+divid).html("<img style='height: 100%; width: 100%;' id='image_view'  src='"+this.result+"'/>");
					}
			}
        }catch(e){}
    });
}

function imgUploadPreview3(select, divid){//商家设置
    $(select).change(function(){
        var picPath =  this.value
        var type = picPath.substring(picPath.lastIndexOf(".") + 1, picPath.length).toLowerCase();
        if (type != "jpg" && type != "png") {
            $(this).val('')
            alert("请上传jpg/png格式图片");
            return false;
        }
        
        try{
            var divObj = document.getElementById(divid)
            if(navigator.userAgent.indexOf("MSIE") > -1&& (navigator.userAgent.indexOf("MSIE 7.0") > -1|| navigator.userAgent.indexOf("MSIE 9.0") > -1 || navigator.userAgent.indexOf("MSIE 8.0") > -1)  ){
				this.select();
                this.blur();
                var path = document.selection.createRange().text;
                document.selection.empty();
                path = "file:///" + path.replace("\\",'/');
                document.getElementById("image_view").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+ path + "')";
				document.getElementById("image_view").src ="http://shop.dface.cn/images/clear.gif";
				document.getElementById("image_view2").style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+ path + "')";
				document.getElementById("image_view2").src ="http://shop.dface.cn/images/clear.gif";
			}else if(navigator.userAgent.indexOf("MSIE") > -1&& navigator.userAgent.indexOf("MSIE 6.0") > -1 ){
                divObj.innerHTML = "<img id='image_view' class='imgstyle2'/><img id='image_view2' class='imgstyle3 ml15 mb75'/>";
                var imageView = document.getElementById("image_view");
				var imageView2 = document.getElementById("image_view2");
                imageView.src = $(this).val();
				imageView2.src = $(this).val();
            }else {
				 var file = $(this).get(0).files[0];
				 var reader = new FileReader();
					reader.readAsDataURL(file);
					reader.onload = function(e){
						$("#"+divid).html("<img style='height: 100%; width: 100%;' id='image_view'  src='"+this.result+"'/>");
					}
			}
        }catch (e) {}
    });
}

var uploadimgtimer, emObj, sidObj, swidth, sheight, ratio;
$(document).ready(function(){
	emObj=$("#EM").html()
	sidObj=$("#SmallImgDiv").html();
});
function ImageUpload(target){//优惠券
	ratio=1;
	var obj , pic , sid;
	if(target=="UpImgFile"){
		obj=document.getElementById(target);
	}else{
		obj=target;
	}
	pic=document.getElementById("UploadPic");
	sid=document.getElementById("SmallImgDiv");

	obj.click();//打开上传对话框
	obj.onchange=function(){
		if(/msie/i.test(ua)){//IE浏览器可以直接取值
			//pic.src=obj.value;//经测试IE用此种写法在服务器可能会有问题。
			//因此IE在服务器上运行时一般采用如下方法：
			this.select();
			this.blur();
			var path=document.selection.createRange().text;
			path = "file:///" + path.replace(":",'|');
			path = path.replace(/\\/g,'/');
			document.selection.empty();
			$(".filebox6, .filebox7, .filebox8, .filebox9, .filebox10, .filebox11").css({"display":"none"});
			try{
				pic.removeAttribute("style");
				pic.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+ path + "')";
				pic.src=path;

				uploadimgtimer=setTimeout(function(){
					var w=pic.width;
					var h=pic.height;
					//alert(w+"  "+h);
					document.getElementById("EM").innerHTML="";
					if(w>=400){
						w=400;
					}
					document.getElementById("EM").innerHTML="<img style='filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src="+path+");' id='UploadPic' src='"+path+"' onClick=\'ImageUpload(\"UpImgFile\")\' />";
					sid.innerHTML="<img style='filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src="+path+");' width='"+w+"px' height='"+h+"px' src='"+path+"'/>";
					swidth=w;
					sheight=h;
					Cut();
				},1000);
			}catch(e){}
		}else{//火狐、谷歌、Opera、需要通过生成FileReader()来专门实现图片显示
			var reader = new FileReader();
			reader.readAsDataURL(obj.files[0]);
			reader.onload = function(e){
				pic.src=this.result;
				pic.onload=function(){
					var w=pic.width;
					var h=pic.height;
					//document.getElementById("EM").style.height=pic.height+"px";
					sid.innerHTML="<div style='width:"+w+"px; height:"+h+"px'><img style='width:"+w+"px; height:"+h+"px' src=\'"+pic.src+"\' /></div>";
					swidth=w;
					sheight=h;
					Cut();
				}
			}
		}
	}	
}
function Cut(){
	var w=$("#UploadPic").width();
	var h=$("#UploadPic").height();
	$("#CutDiv").css("display","block");
	$("#EM").css({"width":w+"px","height":h+"px"});
	if(h/w<1&&h<252){ratio=h/w;}
	$("#UpImg div.upimgtab").removeAttr("style");
	if(h<252){
		$("#UpImg div.upimgplane").removeAttr("style");
		$("#UpImg div.upimgtab").css({"top":"50%","margin-top":-(h/2)+"px"});
	}else{
		$("#UpImg div.upimgplane").css("height",h+"px");
	}

	if(w<400){
		$("#CutDiv").css({"width":w+"px","height":h+"px","left":(400-w)/2+"px"});
	}else{
		$("#CutDiv").css({"width":w+"px","height":h+"px","left":"0px"});
		$("#CutArea").css({"left":"0px","top":"0px"});
	}

	$("#CutArea").css({"width":252*ratio+"px","height":252*ratio+"px","left":"0px","top":"0px"});
	$("#CutArea div#CAMove").css({"left":252*ratio-15+"px","top":252*ratio-15+"px"});

	$("#CutBG1,#CutBG2").css({"width":"0px","height":"0px"});
	$("#CutBG3").css({"width":w-252*ratio+"px","height":h+"px","left":252*ratio+"px"});
	$("#CutBG4").css({"width":252*ratio+"px","height":(h-252*ratio)+"px","top":252*ratio+"px","left":"0px"});

	if($("#CutArea").width()>252){
		ratio=252/$("#CutArea").width();
		$("#SmallImgDiv div, #SmallImgDiv img").css({"width":ratio*swidth+"px","height":ratio*sheight+"px"});
	}else if($("#CutArea").width()<252){
		ratio=252/$("#CutArea").width();
		$("#SmallImgDiv div, #SmallImgDiv img").css({"width":ratio*swidth+"px","height":ratio*sheight+"px"});
	}
	
	$("#CutBG1, #CutBG2, #CutBG3, #CutBG4").click(function(){
		$("#CutDiv").css("display","none");
		if(/msie/i.test(ua)){
			$(".filebox6, .filebox7, .filebox8, .filebox9, .filebox10, .filebox11").css({"display":"block","height":h+"px"});
		}
		if(/ipad/i.test(ua)){
			$("body").unbind("touchmove");
		}
	});

	if(/ipad/i.test(ua)){
		$("body").bind("touchmove",function(e){e.stopPropagation();return false;});
		$("#CutArea").bind("touchmove",function(e){
			var cutdiv_left=$("#CutDiv").offset().left;
			var cutdiv_top=$("#CutDiv").offset().top;
			var mouse_left=e.pageX;
			var mouse_top=e.pageY;
			var cutarea_w=parseFloat($("#CutArea").css("width"));
			var cutarea_h=parseFloat($("#CutArea").css("height"));
			var hraf_w=cutarea_w/2, hraf_h=cutarea_h/2;
			if(mouse_left-cutdiv_left-hraf_w<0){
				mouse_left=cutdiv_left+hraf_w;
			}
			if(mouse_top-cutdiv_top-hraf_h<0){
				mouse_top=cutdiv_top+hraf_h;
			}
			if(mouse_left-cutdiv_left-hraf_w>w-cutarea_w){
				mouse_left=w-cutarea_w+cutdiv_left+hraf_w;
			}
			if(mouse_top-cutdiv_top-hraf_h>h-cutarea_h){
				mouse_top=h-cutarea_h+cutdiv_top+hraf_h;
			}
			$("#CutArea").css({"left":mouse_left-cutdiv_left-hraf_w+"px","top":mouse_top-cutdiv_top-hraf_h+"px"});
			$("#CutBG1").css({"width":mouse_left-cutdiv_left-hraf_w+"px","height":cutarea_h+mouse_top-cutdiv_top-hraf_h+"px"});
			$("#CutBG2").css({"width":cutarea_w+"px","height":mouse_top-cutdiv_top-hraf_h+"px","left":mouse_left-cutdiv_left-hraf_w+"px"});
			$("#CutBG3").css({"left":cutarea_w+mouse_left-cutdiv_left-hraf_w+"px","width":w-(cutarea_w+mouse_left-cutdiv_left-hraf_w)+"px","height":h+"px"});
			$("#CutBG4").css({"width":cutarea_w+mouse_left-cutdiv_left-hraf_w+"px","top":cutarea_h+mouse_top-cutdiv_top-hraf_h+"px","height":h-(cutarea_h+mouse_top-cutdiv_top-hraf_h)+"px"});
			$("#SmallImgDiv img").css({"margin-left":-(mouse_left-cutdiv_left-hraf_w)+"px","margin-top":-(mouse_top-cutdiv_top-hraf_h)+"px"});
		});	
	}else{
		$("#CutArea").mousedown(function(){
			$("#CutArea").mousemove(function(e){
				var cutdiv_left=$("#CutDiv").offset().left;
				var cutdiv_top=$("#CutDiv").offset().top;
				var mouse_left=e.pageX;
				var mouse_top=e.pageY;
				var cutarea_w=parseFloat($("#CutArea").css("width"));
				var cutarea_h=parseFloat($("#CutArea").css("height"));
				
				var hraf_w=cutarea_w/2, hraf_h=cutarea_h/2;
				if(mouse_left-cutdiv_left-hraf_w<0){
					mouse_left=cutdiv_left+hraf_w;
				}
				if(mouse_top-cutdiv_top-hraf_h<0){
					mouse_top=cutdiv_top+hraf_h;
				}
				if(mouse_left-cutdiv_left-hraf_w>w-cutarea_w){
					mouse_left=w-cutarea_w+cutdiv_left+hraf_w;
				}
				if(mouse_top-cutdiv_top-hraf_h>h-cutarea_h){
					mouse_top=h-cutarea_h+cutdiv_top+hraf_h;
				}
				$("#CutArea").css({"left":mouse_left-cutdiv_left-hraf_w+"px","top":mouse_top-cutdiv_top-hraf_h+"px"});
				$("#CutBG1").css({"width":mouse_left-cutdiv_left-hraf_w+"px","height":cutarea_h+mouse_top-cutdiv_top-hraf_h+"px"});
				$("#CutBG2").css({"width":cutarea_w+"px","height":mouse_top-cutdiv_top-hraf_h+"px","left":mouse_left-cutdiv_left-hraf_w+"px"});
				$("#CutBG3").css({"left":cutarea_w+mouse_left-cutdiv_left-hraf_w+"px","width":w-(cutarea_w+mouse_left-cutdiv_left-hraf_w)+"px","height":h+"px"});
				$("#CutBG4").css({"width":cutarea_w+mouse_left-cutdiv_left-hraf_w+"px","top":cutarea_h+mouse_top-cutdiv_top-hraf_h+"px","height":h-(cutarea_h+mouse_top-cutdiv_top-hraf_h)+"px"});
				
				$("#SmallImgDiv img").css({"margin-left":-(mouse_left-cutdiv_left-hraf_w)*ratio+"px","margin-top":-(mouse_top-cutdiv_top-hraf_h)*ratio+"px"});
			});
			$("#CutArea").mouseup(function(){
				$(this).unbind("mousemove");
			});
		});
	}
	
	$("#CAMove").mousedown(function(e){
		var cutdiv_left=$("#CutDiv").offset().left;
		var cutdiv_top=$("#CutDiv").offset().top;
		var cutarea_w=parseFloat($("#CutArea").css("width"));
		
		$("#CAMove").mousemove(function(e){
			$("#CAMove").css({"left":e.pageX-cutdiv_left-parseFloat($("#CutArea").css("left"))-15+"px",
			"top":e.pageY-cutdiv_top-parseFloat($("#CutArea").css("top"))-15+"px","width":"30px","height":"30px"});
			$("#CutArea").css({"width":e.pageX-cutdiv_left-parseFloat($("#CutArea").css("left"))+"px","height":e.pageX-cutdiv_left-parseFloat($("#CutArea").css("left"))+"px"});
			var cutarea_w=$("#CutArea").width();
			
			var w=$("#UploadPic").width();
			var h=$("#UploadPic").height();
			if(w>h&&cutarea_w>h){
				cutarea_w=h;
			}else if(h>w&&cutarea_w>w){
				cutarea_w=w;
			}
			
			$("#CutBG1").css("height",parseFloat($("#CutArea").css("top"))+$("#CutArea").height()+"px");
			$("#CutBG2").css("width",$("#CutArea").width()+"px");
			$("#CutBG3").css({
				"left":cutarea_w+parseFloat($("#CutArea").css("left"))+"px",
				"width":$("#CutDiv").width()-cutarea_w-parseFloat($("#CutArea").css("left"))+"px"
			});
			$("#CutBG4").css({
				"top":$("#CutArea").height()+parseFloat($("#CutArea").css("top"))+"px",
				"height":$("#CutDiv").height()-($("#CutArea").height()+parseFloat($("#CutArea").css("top")))+"px",
				"width":parseFloat($("#CutArea").css("left"))+$("#CutArea").width()+"px"
			});
			
			if($("#CutArea").width()>252){
				ratio=252/$("#CutArea").width();
				$("#SmallImgDiv div, #SmallImgDiv img").css({"width":ratio*swidth+"px","height":ratio*sheight+"px"});
			}else if($("#CutArea").width()<252){
				ratio=252/$("#CutArea").width();
				$("#SmallImgDiv div, #SmallImgDiv img").css({"width":ratio*swidth+"px","height":ratio*sheight+"px"});
			}

			e.stopPropagation();
			return false;
		});
		$("#CAMove").mouseup(function(){
			$("#CAMove").unbind("mousemove").css({"left":parseFloat($("#CutArea").css("width"))-15+"px","top":parseFloat($("#CutArea").css("width"))-15+"px","width":"10px","height":"10px"});
		});
		/*$("#CAMove").mouseout(function(){
			$("#CAMove").unbind("mousemove").css({"left":parseFloat($("#CutArea").css("width"))-15+"px","top":parseFloat($("#CutArea").css("width"))-15+"px"});
		});*/
		e.stopPropagation();
		return false;
	});
}
function NoCut(){
	$('#UpImg').fadeOut(500);
	$("#EM").html(emObj).removeAttr("style");
	$("#SmallImgDiv").html(sidObj);
	$("#CutDiv").css("display","none");
	if(/ipad/i.test(ua)){
		$("body").unbind("touchmove");
	}
	if(/msie/i.test(ua)){
		$(".filebox6, .filebox7, .filebox8, .filebox9, .filebox10, .filebox11").css({"display":"block"});
	}
}