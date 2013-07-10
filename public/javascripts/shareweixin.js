/**脸脸分享到微信**/
var d = document,inputTimer,list,texts = {},
_sHost = 'https://open.weixin.qq.com',
_s = null

function _loadJs(_asUrl) {
    try{
        var x=document.createElement('SCRIPT');
        x.type='text/javascript';
        x.src=_asUrl;
        x.charset='utf-8';
        document.getElementsByTagName('head')[0].appendChild(x);
        return x;
    }catch(e){}
}
function _popup(rel) {
    if(document.getElementById('weixin_w')){
        _oDlgEl = document.getElementById('weixin_w');
    }else{
        var _oDlgEl  =  document.createElement("div");
        isIe6 =  /msie|MSIE 6/.test(navigator.userAgent);
        if(!isIe6){
            _oDlgEl.style.zIndex="101120000000";
        }
        _oDlgEl.style.position="absolute";
        if(isIe6){
            _oDlgEl.style.left = '550px';
            _oDlgEl.style.top = parseInt(document.documentElement.scrollTop)+200+'px';
            _oDlgEl.style.zIndex="1000000";
        }
        _oDlgEl.id = 'weixin_w';
    }
    _oDlgEl.innerHTML = '<div class="erweimaMask" id="__weixin_share_mask_cancel_" style="z-index:10000; "></div>\
		<div class="containerPanel" style="z-index:10020; width:220px;_width:251px;height:248px;position:fixed;left: 59%;margin-left:-100px;top:30%;-moz-border-radius:5px;-webkit-border-radius:5px;border-radius:5px;border-top:1px solid #868686;border-bottom:1px solid #212121;box-shadow:0px 1px 3px #313131;background-color:#4F5051;">\
		<div class="contentTitle" style="font-size:14px;height:27px;background-color:#6B6B6B;border-style:solid;border-width:1px;border-color:#6E6E6E #727272 #313233 #757575;box-shadow:0px 1px 0px #454647;-webkit-border-top-left-radius:5px;-webkit-border-top-right-radius:5px;-moz-border-radius-topleft:5px;-moz-border-radius-topright:5px;border-top-left-radius:5px;border-top-right-radius:5px;"><div class="left" style="float:left; margin-left:30px;_margin-left:15px;margin-top:2px;_margin-top:4px;color:#fff; font-weight:bold;">分享到微信朋友圈</div><span class="right closeIcon" style="margin-top:2px;margin-right:10px;float:right;"><a style="display:block;width:24px;height:24px;background:url(/images/share_close.png) no-repeat center;" href="javascript:_cancel()" id="_weixin_share_mask_"></a></span><div class="clr" style="clear:both;overflow: hidden;"></div></div>\
		<div class="content" id="content" style="width:180px;_width:211px;height:180px; margin:0;padding:20px;background:none;text-align:center;background:none;"><img style="width:178px; height:178px;" src="'+rel+'" id="_weixin_share_img_" /></div></div>';
		
    document.body.appendChild(_oDlgEl);
	
    _oMaskEl = document.getElementById("_weixin_share_mask_");
    _oErweimaMaskEl = document.getElementById("__weixin_share_mask_cancel_");
}
function _cancel() {
    _oDlgEl = document.getElementById('weixin_w');
    document.body.removeChild(_oDlgEl);
    _oDlgEl = _oDivEl = _oMaskEl = _oErweimaMaskEl = null;
}
function sharetowx(title,url,imgsrc,appid) {
    _popup('');
    _s = _loadJs(_sHost + '/qr/set/?a=1&title=' + title + '&url=' + url + '&img=' + imgsrc + '&appid=' + (appid || '') + "&r=" + Math.random());
    return false;
}
function showWxBox(_uid) {
    document.getElementById("_weixin_share_img_").setAttribute("src", ''+_sHost+'/qr/get/'+_uid + '\/');
}
