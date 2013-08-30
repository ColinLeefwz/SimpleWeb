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
			}if(/ipad/i.test(ua)){
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
			}if(/ipad/i.test(ua)){
				 var file = $(this).get(0).files[0];
				 var reader = new FileReader();
					reader.readAsDataURL(file);
					reader.onload = function(e){
						$("#"+divid).html("<img id='image_view' class='imgstyle2'  src='"+this.result+"'/><img id='image_view2' class='imgstyle3 ml15 mb75' src='"+this.result+"' />");
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