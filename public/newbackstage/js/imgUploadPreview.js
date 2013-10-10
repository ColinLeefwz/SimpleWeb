var uploadimgtimer, uliObj, sidObj;
$(document).ready(function(){
	uliObj=$("#UpLoadImg").html()
	sidObj=$("#SmallImgDiv").html();
	$("#CutBtn").click(function(){
		  cropzoom.send('cai_jian_tu_pian_hou_tai_chu_li_cheng_xu.php', 'POST', {}, function(imgRet) {
			   $("#SmallImgDiv img").attr("src", imgRet);
		  }); 
	 });
});
function ImageUpload(target){//优惠券
	var obj , sid;
	if(target=="UpImgFile"){
		obj=document.getElementById(target);
	}else{
		obj=target;
	}

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
				$("#UpLoadImg").html("<img src='"+path+"' style='filter:progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod='scale',src='"+ path + "')' />");
				uploadimgtimer=setTimeout(function(){
					var w=$("#UpLoadImg img").width();
					var h=$("#UpLoadImg img").height();
					Cut(w,h,path);
				},1000);
			}catch(e){}
		}else{//火狐、谷歌、Opera、需要通过生成FileReader()来专门实现图片显示
			var reader = new FileReader();
			reader.readAsDataURL(obj.files[0]);
			reader.onload = function(e){
				$("#UpLoadImg").html("<img src='"+this.result+"' />");
				$("#UpLoadImg img").load(function(){
					var w=$(this).width();
					var h=$(this).height();
					var src=$(this).attr("src");
					Cut(w,h,src);							  
				});
			}	
		}
	}
}
function Cut(imgwidth,imgheight,imgsrc){
	var boxheight;
	if(imgheight>252){
		boxheight=imgheight;
	}else{
		boxheight=252;	
	}
	if(imgwidth<=28&&imgheight<=30){
		imgwidth=400;imgheight=400;	
	}
	var cropzoom = $('#UpLoadImg').cropzoom({
		  width: 400,
		  height: boxheight,
		  bgColor: '#f8f8f8',
          enableRotation: true,
          enableZoom: true,
          selector: {
			   w:252,
			   h:252,
			   showPositionsOnDrag:true,
			   showDimetionsOnDrag:false,
               centered: false,
			   bgInfoLayer:'#fff',
               borderColor: '#fff',
			   animated: true,
               borderColorHover: '#fff'
           },
           image: {
			   width: imgwidth,
			   height: imgheight,
               source: imgsrc,
               minZoom: 10,
               maxZoom: 150
            }
      });
	if(/ipad/i.test(ua)){
		var cutdiv_left, cutdiv_top, mouse_left, mouse_top, cutarea_w, cutarea_h, hraf_w;
		cutdiv_left=$("#UpLoadImg").offset().left;
		cutdiv_top=$("#UpLoadImg").offset().top;
		cutarea_w=parseInt($("#selector").css("width"));
		cutarea_h=parseInt($("#selector").css("height"));
		hraf_w=cutarea_w/2, hraf_h=cutarea_h/2;
		$("#l, #t").css({"width":"0px","height":"0px","left":"0px","top":"0px"});
		$("#r").css({"width":imgwidth-cutarea_w+3+"px","height":imgheight+"px","top":"0px","left":cutarea_w+3+"px"});
		$("#b").css({"width":cutarea_w+3+"px","top":cutarea_h+3+"px","height":imgheight-cutarea_h-3+"px","left":"0px"});
		$("#selector").unbind("mouseover").unbind("mouseout").unbind("mousemove");
		$("body").bind("touchmove",function(e){e.stopPropagation();return false;});
		$("#selector").bind("touchmove",function(e){
			cutdiv_left=$("#UpLoadImg").offset().left;
			cutdiv_top=$("#UpLoadImg").offset().top;
			mouse_left=e.pageX;
			mouse_top=e.pageY;//alert(cutdiv_left+"  "+cutdiv_top+"   "+mouse_left+"   "+mouse_top);
			cutarea_w=parseInt($("#selector").css("width"));
			cutarea_h=parseInt($("#selector").css("height"));
			hraf_w=cutarea_w/2, hraf_h=cutarea_h/2;
			$("#l, #t, #r ,#b").css("display","block");
			$("#selector").css({"left":mouse_left-cutdiv_left-hraf_w+"px","top":mouse_top-cutdiv_top-hraf_h+"px"});
			//alert($("#selector").css("left"));
			$("#l").css({"width":mouse_left-cutdiv_left-hraf_w+"px","height":cutarea_h+mouse_top-cutdiv_top-hraf_h+3+"px","left":"0px","top":"0px"});
			$("#t").css({"width":cutarea_w+3+"px","height":mouse_top-cutdiv_top-hraf_h+"px","left":mouse_left-cutdiv_left-hraf_w+"px","top":"0px"});
			$("#r").css({"left":cutarea_w+mouse_left-cutdiv_left-hraf_w+3+"px","width":imgwidth-(cutarea_w+mouse_left-cutdiv_left-hraf_w)+3+"px","height":imgheight+"px","top":"0px"});
			$("#b").css({"width":cutarea_w+mouse_left-cutdiv_left-hraf_w+3+"px","top":cutarea_h+mouse_top-cutdiv_top-hraf_h+3+"px","height":imgheight-(cutarea_h+mouse_top-cutdiv_top-hraf_h)-3+"px","left":"0px"});
			if(parseInt($("#selector").css("left"))>=imgwidth-cutarea_w){
				$("#selector").css("left",imgwidth-cutarea_w+"px");
				$("#l").css("width",imgwidth-cutarea_w+"px");
				$("#t").css("left",imgwidth-cutarea_w+"px");
				$("#b").css("width",imgwidth+"px");
			}
			if(parseInt($("#selector").css("top"))>=imgheight-cutarea_h){
				$("#selector").css("top",imgheight-cutarea_h+"px");
				$("#l").css("height",imgheight+"px");
				$("#t").css("height",imgheight-cutarea_h+"px");
				$("#r").css("height",imgheight+"px");
			}
			if(parseInt($("#selector").css("left"))<=0){
				$("#selector").css("left","0px");
				$("#r").css({"width":imgwidth-cutarea_w+3+"px","left":cutarea_w+3+"px"});
				$("#t").css("left","0px");
				$("#b").css("width",cutarea_w+3+"px");
			}
			if(parseInt($("#selector").css("top"))<=0){
				$("#selector").css("top","0px");
				$("#l").css("height",cutarea_h+"px");
				$("#b").css("top",cutarea_h+"px");
			}
		});	
	}
}
function NoCut(){
	$('#UpImg').fadeOut(500);
	$("#UpLoadImg").removeAttr("style").html(uliObj);
	$("#SmallImgDiv").html(sidObj);
	if(/ipad/i.test(ua)){
		$("body").unbind("touchmove");
	}
	if(/msie/i.test(ua)){
		$(".filebox6, .filebox7, .filebox8, .filebox9, .filebox10, .filebox11").css({"display":"block"});
	}
}