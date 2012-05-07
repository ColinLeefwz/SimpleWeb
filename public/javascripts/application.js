
	function getSelectionId(text, li) {
		var target  = text.previousSibling;
		if(target.class=="fieldWithErrors") target=target.firstChild;
	    target.value=li.id;
	}
function SetDefaultTarget(target,i){
	try{
		document.getElementById(target+i).className="ha";
		document.getElementById(target+i).getElementsByTagName("span")[0].className="hb";
		document.getElementById(target+i).getElementsByTagName("a")[0].className="hc";
	}catch(e){}
}
function SetDefault(i){
	SetDefaultTarget('tag',i);
}
function SetDefault2(i){
	SetDefaultTarget('tagg',i);
}

var speed=20;var m;function Marquee(c){var b=document.getElementById("t_"+c);var a=document.getElementById("n_"+c);if(a.offsetWidth-b.scrollLeft<=0){b.scrollLeft-=a.offsetWidth}b.scrollLeft++}function sT(a){m=setInterval("Marquee('"+a+"')",speed)}function cT(a){clearInterval(m);a.scrollLeft=0}function iText(TextId,TextWidth){try{eval(TextId)}catch(e){return false}if(TextWidth==0){return}for(var i=0;i<eval(TextId).length;i++){var LayId=TextId+i;var DivId="t_"+TextId+i;var NobId="n_"+TextId+i;var marDiv=document.getElementById(DivId);var marNobr=document.getElementById(NobId);eval(TextId)[i].innerHTML="<div id='"+DivId+"' style=\"width: "+TextWidth+"px;overflow: hidden;\" onMouseover=sT('"+LayId+"') onMouseout=cT(this)><NOBR id=\"n_"+LayId+'">'+eval(TextId)[i].innerHTML+"</NOBR></div>"}}

var $ = function (id) {
      return "string" == typeof id ? document.getElementById(id) : id;
};

var Class = {
create: function() {
          return function() {
            this.initialize.apply(this, arguments);
          }
        }
}

Object.extend = function(destination, source) {
  for (var property in source) {
    destination[property] = source[property];
  }
  return destination;
}

var TransformView = Class.create();
TransformView.prototype = {
  //容器对象,滑动对象,切换参数,切换数量
initialize: function(container, slider, parameter, count, options) {
              if(parameter <= 0 || count <= 0) return;
              var oContainer = $(container), oSlider = $(slider), oThis = this;

              this.Index = 0;//当前索引

              this._timer = null;//定时器
              this._slider = oSlider;//滑动对象
              this._parameter = parameter;//切换参数
              this._count = count || 0;//切换数量
              this._target = 0;//目标参数

              this.SetOptions(options);

              this.Up = !!this.options.Up;
              this.Step = Math.abs(this.options.Step);
              this.Time = Math.abs(this.options.Time);
              this.Auto = !!this.options.Auto;
              this.Pause = Math.abs(this.options.Pause);
              this.onStart = this.options.onStart;
              this.onFinish = this.options.onFinish;

              oContainer.style.overflow = "hidden";
              oContainer.style.position = "relative";

              oSlider.style.position = "absolute";
              oSlider.style.top = oSlider.style.left = 0;
            },
            //设置默认属性
SetOptions: function(options) {
              this.options = {//默认值
Up:			true,//是否向上(否则向左)
        Step:		35,//滑动变化率
        Time:		10,//滑动延时
        Auto:		true,//是否自动转换
        Pause:		3000,//停顿时间(Auto为true时有效)
        onStart:	function(){},//开始转换时执行
        onFinish:	function(){}//完成转换时执行
              };
              Object.extend(this.options, options || {});
            },
            //开始切换设置
Start: function() {
         if(this.Index < 0){
           this.Index = this._count - 1;
         } else if (this.Index >= this._count){ this.Index = 0; }

         this._target = -1 * this._parameter * this.Index;
         this.onStart();
         this.Move();
       },
       //移动
Move: function() {
        clearTimeout(this._timer);
        var oThis = this, style = this.Up ? "top" : "left", iNow = parseInt(this._slider.style[style]) || 0, iStep = this.GetStep(this._target, iNow);

        if (iStep != 0) {
          this._slider.style[style] = (iNow + iStep) + "px";
          this._timer = setTimeout(function(){ oThis.Move(); }, this.Time);
        } else {
          this._slider.style[style] = this._target + "px";
          this.onFinish();
          if (this.Auto) {
            if (this.Index == 0) {
              this._timer = setTimeout(function(){ oThis.Index++; oThis.Start(); }, this.Pause + 10000);
            } else {
              this._timer = setTimeout(function(){ oThis.Index++; oThis.Start(); }, this.Pause);
            }
          }
        }
      },
      //获取步长
GetStep: function(iTarget, iNow) {
           var iStep = (iTarget - iNow) / this.Step;
           if (iStep == 0) return 0;
           if (Math.abs(iStep) < 1) return (iStep > 0 ? 1 : -1);
           return iStep;
         },
         //停止
Stop: function(iTarget, iNow) {
        clearTimeout(this._timer);
        this._slider.style[this.Up ? "top" : "left"] = this._target + "px";
      }
};

window.onload=function(){
  function Each(list, fun){
    for (var i = 0, len = list.length; i < len; i++) {
      fun(list[i], i); }
  };

  var objs2 = $("idNum2").getElementsByTagName("li");

  var tv2 = new TransformView("idTransformView2", "idSlider2", 518, 5, {
onStart: function(){
Each(objs2, function(o, i){ o.className = tv2.Index == i ? "on" : ""; }) },//按钮样式
Up: false
});

new Marquee(
    "index-scroll",  //容器ID<br />
    1,  //向上滚动(0向上 1向下 2向左 3向右)<br />
    2,  //滚动的步长<br />
    800,  //容器可视宽度<br />
    34,  //容器可视高度<br />
    20,  //定时器 数值越小，滚动的速度越快(1000=1秒,建议不小于20)<br />
    4000,  //间歇停顿时间(0为不停顿,1000=1秒)<br />
    1000,  //开始时的等待时间(0为不等待,1000=1秒)<br />
    35  //间歇滚动间距(可选)<br />
    );

tv2.Start();

Each(objs2, function(o, i){
    o.onmouseover = function(){
    o.className = "on";
    tv2.Auto = false;
    tv2.Index = i;
    tv2.Start();
    }
    o.onmouseout = function(){
    o.className = "";
    tv2.Auto = true;
    tv2.Start();
    }
    })

$("idStop").onclick = function(){ tv2.Auto = false; tv2.Stop(); }
$("idStart").onclick = function(){ tv2.Auto = true; tv2.Start(); }
$("idNext").onclick = function(){ tv2.Index++; tv2.Start(); }
$("idPre").onclick = function(){ tv2.Index--;tv2.Start(); }
//	$("idFast").onclick = function(){ if(--tv2.Step <= 0){tv2.Step = 1;} }
//	$("idSlow").onclick = function(){ if(++tv2.Step >= 10){tv2.Step = 10;} }
//	$("idReduce").onclick = function(){ tv2.Pause-=1000; if(tv2.Pause <= 0){tv2.Pause = 0;} }
//	$("idAdd").onclick = function(){ tv2.Pause+=1000; if(tv2.Pause >= 5000){tv2.Pause = 5000;} }

//	$("idReset").onclick = function(){
//		tv2.Step = Math.abs(tv2.options.Step);
//		tv2.Time = Math.abs(tv2.options.Time);
//		tv2.Auto = !!tv2.options.Auto;
//		tv2.Pause = Math.abs(tv2.options.Pause);
//	}
}

// Download by http://www.codefans.net
function Marquee(){
  this.ID=document.getElementById(arguments[0]);
  this.Direction=arguments[1];
  this.Step=arguments[2];
  this.Width=arguments[3];
  this.Height=arguments[4];
  this.Timer=arguments[5];
  this.WaitTime=arguments[6];
  this.StopTime=arguments[7];
  if(arguments[8]){this.ScrollStep=arguments[8];}else{this.ScrollStep=this.Direction>1?this.Width:this.Height;}
  this.CTL=this.StartID=this.Stop=this.MouseOver=0;
  this.ID.style.overflowX=this.ID.style.overflowY="hidden";
  this.ID.noWrap=true;
  this.ID.style.width=this.Width;
  this.ID.style.height=this.Height;
  this.ClientScroll=this.Direction>1?this.ID.scrollWidth:this.ID.scrollHeight;
  this.ID.innerHTML+=this.ID.innerHTML;
  this.Start(this,this.Timer,this.WaitTime,this.StopTime);
  }
Marquee.prototype.Start=function(msobj,timer,waittime,stoptime){
  msobj.StartID=function(){msobj.Scroll();}
  msobj.Continue=function(){
    if(msobj.MouseOver==1){setTimeout(msobj.Continue,waittime);}
    else{clearInterval(msobj.TimerID); msobj.CTL=msobj.Stop=0; msobj.TimerID=setInterval(msobj.StartID,timer);}
    }
  msobj.Pause=function(){msobj.Stop=1; clearInterval(msobj.TimerID); setTimeout(msobj.Continue,waittime);}
  msobj.Begin=function(){
    msobj.TimerID=setInterval(msobj.StartID,timer);
    msobj.ID.onmouseover=function(){msobj.MouseOver=1; clearInterval(msobj.TimerID);}
    msobj.ID.onmouseout=function(){msobj.MouseOver=0; if(msobj.Stop==0){clearInterval(msobj.TimerID); msobj.TimerID=setInterval(msobj.StartID,timer);}}
    }
  setTimeout(msobj.Begin,stoptime);
  }
Marquee.prototype.Scroll=function(){
  switch(this.Direction){
    case 0:
      this.CTL+=this.Step;
      if(this.CTL>=this.ScrollStep&&this.WaitTime>0){this.ID.scrollTop+=this.ScrollStep+this.Step-this.CTL; this.Pause(); return;}
      else{if(this.ID.scrollTop>=this.ClientScroll) this.ID.scrollTop-=this.ClientScroll; this.ID.scrollTop+=this.Step;}
      break;
    case 1:
      this.CTL+=this.Step;
      if(this.CTL>=this.ScrollStep&&this.WaitTime>0){this.ID.scrollTop-=this.ScrollStep+this.Step-this.CTL; this.Pause(); return;}
      else{if(this.ID.scrollTop<=0) this.ID.scrollTop+=this.ClientScroll; this.ID.scrollTop-=this.Step;}
      break;
    case 2:
      this.CTL+=this.Step;
      if(this.CTL>=this.ScrollStep&&this.WaitTime>0){this.ID.scrollLeft+=this.ScrollStep+this.Step-this.CTL; this.Pause(); return;}
      else{if(this.ID.scrollLeft>=this.ClientScroll) this.ID.scrollLeft-=this.ClientScroll; this.ID.scrollLeft+=this.Step;}
      break;
    case 3:
      this.CTL+=this.Step;
      if(this.CTL>=this.ScrollStep&&this.WaitTime>0){this.ID.scrollLeft-=this.ScrollStep+this.Step-this.CTL; this.Pause(); return;}
      else{if(this.ID.scrollLeft<=0) this.ID.scrollLeft+=this.ClientScroll; this.ID.scrollLeft-=this.Step;}
      break;
    }
  }
