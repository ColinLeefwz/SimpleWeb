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
            }else if(/ipad/i.test(ua)){
				 var file = $(this).get(0).files[0];
				 var reader = new FileReader();
					reader.readAsDataURL(file);
					reader.onload = function(e){
						$("#"+divid).html("<img style='height: 100%; width: 100%;' id='image_view'  src='"+this.result+"'/>");
					}
			}else{ 
                divObj.innerHTML = "<img id='image_view' style='height: 100%; width: 100%;' />";
                imageView = document.getElementById("image_view");
                imageView.src = window.URL.createObjectURL(this.files[0]);
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
            }else if(/ipad/i.test(ua)){
				 var file = $(this).get(0).files[0];
				 var reader = new FileReader();
					reader.readAsDataURL(file);
					reader.onload = function(e){
						$("#"+divid).html("<img style='height: 100%; width: 100%;' id='image_view'  src='"+this.result+"'/>");
					}
			}else{
                divObj.innerHTML = "<img id='image_view' style='height: 100%; width: 100%;' />";
                imageView = document.getElementById("image_view");
                imageView.src = window.URL.createObjectURL(this.files[0]);
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
            }else if(/ipad/i.test(ua)){
				 var file = $(this).get(0).files[0];
				 var reader = new FileReader();
					reader.readAsDataURL(file);
					reader.onload = function(e){
						$("#"+divid).html("<img style='height: 100%; width: 100%;' id='image_view'  src='"+this.result+"'/>");
					}
			}else{
                divObj.innerHTML = "<img id='image_view' class='imgstyle2'/><img id='image_view2' class='imgstyle3 ml15 mb75'/>";
                imageView = document.getElementById("image_view");
				imageView2 = document.getElementById("image_view2");
                imageView.src = window.URL.createObjectURL(this.files[0]);
				imageView2.src = window.URL.createObjectURL(this.files[0]);
            }

        }catch (e) {}
    });
}

var uploadimgtimer;
function ImageUpload(target){//优惠券
	clearTimeout(uploadimgtimer);
	$('#UploadPic').imgAreaSelect({ onSelectChange: nimabi });
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
					sid.innerHTML="<img style='filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale,src="+path+"); width='"+w+"'px;' src='"+path+"'/>";
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
					//document.getElementById("EM").style.height=pic.height+"px";
					sid.innerHTML="<img style='width:"+w+"px;' src=\'"+pic.src+"\' />";
				}
				Cut();
			}
		}
	}	
}

var cutXY;
function Cut(){
	cutXY=0;
	if(/msie/i.test(ua)){ $("div.cutbox").remove(); }
	$('#UploadPic').load(function(){
		$('#UploadPic').imgAreaSelect({ x1: 0, y1: 0, x2: 252, y2: 252,minWidth:252, minHeight:252, maxWidth:252, maxHeight:252,resize:"se", onSelectChange:preview});
	});	
}

function preview(img, selection) {
	$("div.cutbox").eq(0).mousemove(function(){
		if(cutXY==0){
			$('#SmallImgDiv > img').css({ 
				marginLeft: '0px', 
				marginTop: '0px' 
			});
		}else if(cutXY==1){
			$('#SmallImgDiv > img').css({ 
				marginLeft: '-' + selection.x1 + 'px', 
				marginTop: '-' + selection.y1 + 'px' 
			});	
		}
		cutXY=1;
	});

	$('#x1').val(selection.x1);
	$('#y1').val(selection.y1);
	$('#x2').val(selection.x2);
	$('#y2').val(selection.y2);
	$('#w').val(selection.width);
	$('#h').val(selection.height);

	$(".imgareaselect-outer").unbind("mousedown").unbind("mousemove").unbind("mouseup");
	$(".imgareaselect-outer").click(function(){
		if(/msie/i.test(ua)){ 
			$("div.cutbox").remove();
		}else{
			$("div.cutbox").css("display","none");
			$("div.cutbox").children().css("display","inline");
			selection.x1=0;
			selection.x2=0;
			selection.y1=0;
			selection.y2=0;
		}	
	});
} 
function nimabi(){}