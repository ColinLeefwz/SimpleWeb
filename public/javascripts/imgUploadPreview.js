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
            if(navigator.userAgent.indexOf("MSIE") > -1&& (navigator.userAgent.indexOf("MSIE 7.0") > -1 || navigator.userAgent.indexOf("MSIE 8.0") > -1)  ){
                this.select();
                path = document.selection.createRange().text;
                divObj.innerHTML = "<img id='preview_size_fake" + "' src='"+
                "' style='display:none; filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=image);visibility:hidden;position: absolute;'/>";
                divObj.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale);";
                divObj.filters.item("DXImageTransform.Microsoft.AlphaImageLoader").src = path;
            }
            else if(navigator.userAgent.indexOf("MSIE") > -1&& navigator.userAgent.indexOf("MSIE 6.0") > -1 ){
                divObj.innerHTML = "<img id='image_view' style='height: 197px; width: 194px' />";
                var imageView = document.getElementById("image_view");
                imageView.src = $(this).val();
            }
            else{
                divObj.innerHTML = "<img id='image_view' style='height: 197px; width: 194px' />";
                imageView = document.getElementById("image_view");
                imageView.src = window.URL.createObjectURL(this.files[0]);
            }

        }catch (e) {
            alert("游览器不支持预览图片")
        }
    });
}