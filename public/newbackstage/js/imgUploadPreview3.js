var emObj, sidObj, documentHeight, windowHeight, docwidth,top1;
$(document).ready(function(){
    emObj=$("#EM").html()
    sidObj=$("#SmallImgDiv2").html();
    $("a.btn4").click(function(){
        documentHeight=$(document).height();
        windowHeight=$(window).height();
        if($(window).width()>1024){
            docwidth=$(window).width();
        }else{
            docwidth=1024;
        }
        if(documentHeight<=windowHeight){
            $("#BG").css({
                "width":docwidth+"px",
                "height":windowHeight+"px",
                "display":"block"
            });
        }else{
            $("#BG").css({
                "width":docwidth+"px",
                "height":documentHeight+"px",
                "display":"block"
            });
        }
		$("#UpImg").css("display","block");
		top1=$(document).scrollTop()+(windowHeight-$("#UpImg").height())/2;
		if(top1<0){top1=0;}
		$("#UpImg").css({"top":top1+"px","display":"none"});
		$("#UpImg").slideDown(600);
    });
	
});
function ImageUpload(target){//优惠券
		
    var obj , pic , sid;
    if(target=="UpImgFile"){
        obj=document.getElementById(target);
    }else{
        obj=target;
    }

    pic=document.getElementById("UploadPic");
    sid=document.getElementById("SmallImgDiv2");
    obj.click();//打开上传对话框
    obj.onchange=function(){
        $("#Btn19").removeClass("none");
        $("#UploadForm").ajaxSubmit({
            url: "/crop_photo/upload",
            type: 'POST',
            success: function(data){
                $("#EM").html("<img id='UploadPic' src='"+ data +"' />");
                pic.src= data;
                sid.innerHTML="<img src=\'"+$("#UploadPic").attr("src")+"\' />";
                    documentHeight=$(document).height();
                    windowHeight=$(window).height();
                    if(documentHeight<=windowHeight){
                        $("#BG").css({
                            "height":windowHeight+"px",
                            "display":"block"
                        });
                    }else{
                        $("#BG").css({
                            "height":documentHeight+"px",
                            "display":"block"
                        });
                    }
					$(".filebox6, .filebox7, .filebox8, .filebox9, .filebox10, .filebox11").css("display","none");
                    var cut = new ImgCut({
                        viewClass: 'cnm',  //初始化 大中小图片预览区域及个数，DOM结构决定
                        imgId: 'UploadPic',
                        bgColor: 'black',           //初始化 背景颜色
                        bgFade: true,              //初始化 背景渐变效果
                        shade: false,              //初始化 选区是否显示黑白效果
                        bgOpacity: 0.3 ,            //初始化 背景透明度
                        addClass: 'jcrop-light'    //初始化 选区边界凸效果
                    },

                    function (cutObj) {
                        cutObj.getApi().animateTo([100, 0, 100, 500]);
                        cutObj.getApi().ui.selection.addClass('jcrop-selection');
                    }
                    );

                    $("#Btn2").click(function () {
                        var result = cut.getResult() ;

                        var pdata = {
                            path: data
                        }

                        for (obj in result) {
                            if(obj=='x' || obj =="y" || obj=='w' || obj=='h')
                            {
                                pdata[obj] = result[obj]
                            }
                        //                                $("#UploadForm").append("<input type='hidden' name='"+ obj +"' value='" + result[obj]  +"'/>")
                        }
                        // -----------ajax 提交图片 控制器端剪裁------------------------------------------------
                        $.post("/crop_photo/crop", pdata , function(data){
                            $("#UpImg,#BG").css("display","none");
                            $("#CropedImg").attr("src", data["url"]+"?t="+ (new Date()) )
                            $("#Forms").append("<input type='hidden' name='coupon[img2]' value='" + data["url"]  +"'/>");
                        })

                    // --------------------------------------------------

                    });
            }
        });

    }
}


function NoCut(){
    $("#UpImg").animate({
        "top":"-722px"
    },750,function(){
        $("#UpImg, #BG").css("display","none");
    });
    $("#UpImgFile").val("");
    $("#EM").html(emObj).removeAttr("style");
    $("#SmallImgDiv2").html(sidObj);
    if(/msie/i.test(ua)){
        $(".filebox6, .filebox7, .filebox8, .filebox9, .filebox10, .filebox11").css("display","block");
    }
    var path=$("#EM img").attr("src");
    if(path="images/btn9.jpg"){
        $("#Btn19").addClass("none");
        $(".filebox14, .filebox15").addClass("none");
    }
}

function ImgCut(options, callback) {
    var
    _class  = ImgCut ,
    _ops    = options
    ;

    if (!$.isPlainObject(options)) {
        return false ;
    }

    this.bounds = [] ;
    this.result = {} ;
    this.api    = {} ;
    this.$img   = $('#' + _ops.imgId) ;//$('#UploadPic')
    this.$view  = $('.' + _ops.viewClass).size() ? $('.' + _ops.viewClass) : false ;//$('.cmn')

    if (typeof _class._initialized === 'undefined') {
        var methods = {
            //初始化
            init : function () {
                this.setResult() ;
                this.jCrop() ;
            },

            //创建jCrop对象
            jCrop : function () {
                var that = this ;
                var options = {
                    onChange: function (c) {
                        $.extend(that.result, c) ;
                        if (parseInt(c.w) > 0 && that.$view) {
                            function view($div, width, height) {
                                var rx = width / c.w ,
                                ry = height / c.h ;
                                $div.find('img').css({
                                    width      : Math.round(rx * that.bounds[0]) + 'px' ,
                                    height     : Math.round(ry * that.bounds[1]) + 'px' ,
                                    marginLeft : '-' + Math.round(rx * c.x) + 'px' ,
                                    marginTop  : '-' + Math.round(ry * c.y) + 'px'
                                }) ;
                            }
                            that.$view.show().each(function () {
                                view($(this), $(this).width(), $(this).height()) ;
                            }) ;
                        }
                    } ,
                    onSelect: this.onChange ,
                    aspectRatio: 1
                }

                $.extend(options, _ops) ;

                return this.$img.Jcrop(options,
                    //loader后this被创建
                    function () {
                        this.focus() ;
                        that.api = this ;
                        that.bounds = this.getBounds() ;
                        //释放本类实例对象
                        $.isFunction(callback) && callback(that) ;
                    }) ;
            },

            //修改图片时且同步缩略图预览时调用
            //已包装jcrop.setImage(url, callback)，有缩略图预览时必须掉此方法
            setViewImg : function (url, callback) {
                var
                that = this ,
                url = url + '?ver=' + (new Date()).getTime() ,
                minSize = that.api.getOptions().minSize ,
                img = new Image();
				
                img.onload = function () {
                    if (this.width >= minSize[0] && this.height >= minSize[1]) {
                        that.api.setImage(url, callback) ;
                        that.result.url = url ;
                        that.bounds[0] = this.width ;
                        that.bounds[1] = this.height ;
                        that.$img.attr('src', url) ;
                        that.$view && that.$view.find('img').attr('src', url) ;
                    } else {
                        alert('错误：被处理图片尺寸小于选区最小要求！') ;
                        return false ;
                    }
                }

                img.onerror = function () {
                    alert('错误：图片加载失败，请重试！') ;
                    return false ;
                }

                img.src = url ;
            },

            //装载与后端传递的数据
            setResult : function () {
                var that = this ;
                this.result.url = this.$img.attr('src') ;
                this.$view && this.$view.each(function (i) {
                    that.result['avatar_' + (i + 1)] = [] ;
                    that.result['avatar_' + (i + 1)][0] = $(this).width() ;
                    that.result['avatar_' + (i + 1)][1] = $(this).height() ;
                }) ;
            },

            //获取Jcrop对象
            getApi : function () {
                return this.api ;
            },

            //获取返回值：坐标、宽度、高度、大中小图尺寸、图片路径
            getResult : function () {
                return this.result ;
            }
        }

        $.extend(_class.prototype, methods) ;
  
        _class._initialized = true ;
    }
    this.init() ;
}