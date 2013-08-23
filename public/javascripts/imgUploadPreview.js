/***
 *  图片上传预览， select文件选择框， divid： 图片要预览的id
 **/

function imgUploadPreview(select, divid){

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
			}
            else if(navigator.userAgent.indexOf("MSIE") > -1&& navigator.userAgent.indexOf("MSIE 6.0") > -1 ){
                divObj.innerHTML = "<img id='image_view' style='height: 100%; width: 100%;' />";
                var imageView = document.getElementById("image_view");
                imageView.src = $(this).val();
            }
            else{
                divObj.innerHTML = "<img id='image_view' style='height: 100%; width: 100%;' />";
                imageView = document.getElementById("image_view");
                imageView.src = window.URL.createObjectURL(this.files[0]);
            }

        }catch (e) {
            //alert("游览器不支持预览图片")
        }
    });
}