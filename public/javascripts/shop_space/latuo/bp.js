//大图浏览器
function Obj(id){
	return document.getElementById(id);
}
function ChangeDiv(){/**取消不透明度，同时隐藏元素**/
	try{
		Obj("BigPicBox").style.opacity=1;
		Obj("MovePicBox").style.opacity=0.7;
		Obj("BigPicBox").style.filter = "alpha(opacity=100)";
		Obj("MovePicBox").style.filter = "alpha(opacity=70)";
	}catch(e){}
	Obj("BigPicBox").style.display="none";
	Obj("MovePicBox").style.display="none";
}
function GetPoint(obj){/**返回的应该是obj类的初始的left和top坐标**/
	if (obj == null){return;}
	var x = obj.offsetLeft, y = obj.offsetTop;

	while(obj=obj.offsetParent){/**obj.offsetParent是一个类**/
	/**offsetParent：返回对最近的动态定位的包含元素的引用，所有的偏移量都根据该元素来决定。如果元素的style.display设置为none，则该属性返回null。这是非标准的但却得到很好支持的属性。**/
		x += obj.offsetLeft; y += obj.offsetTop;
	}
	return {"x": x, "y": y};
}
function slidebp(ev){
	var e= ev ? ev:event;
	var w=0,t=0;
	if(document.documentElement.scrollLeft!=0){
		w=document.documentElement.scrollLeft;
	}else{
		w=document.body.scrollLeft;
	}
	if(document.documentElement.scrollTop!=0){
		t=document.documentElement.scrollTop;
	}else{
		t=document.body.scrollTop;
	}
	var x = e.clientX - spb_poi.x + w;/**e.clientX 和 spb_poi.x 和 w都为数字型**/
	var y = e.clientY - spb_poi.y + t;/**e.clientY 和 spb_poi.y 和 t也都为数字型**/
/** e.clientX是指鼠标到页面左侧边距的距离，spb_poi.x是指#SmallPicBox容器到页面左侧边距的距离，document.documentElement.scrollLeft/document.body.scrollLeft滚动条距离页面左侧的距离。 **/
/**
单单x = event.clientX - spb_poi.x + document.documentElement.scrollLeft ; y = event.clientY - spb_poi.y + document.documentElement.scrollTop;其中的
event.clientX和event.clientY不能被火狐使用。虽然火狐支持event事件类，但火狐不支持直接使用event.clientX和event.clientY这两种写法。
**/
/**var x  和  var y  所获得的是鼠标相对于#SmallPicBox容器左上角的坐标**/
	MoveBigPic(x, y);
	MoveDiv(x, y);

	var sp = Obj("SmallPic");
	var bpb = Obj("BigPicBox");
	var mpb = Obj("MovePicBox");

	if (sp == null || bpb == null || mpb == null){return;}
	
	bpb.style.display = "block";
	mpb.style.display = "block";
}

function ClosePic(){

	var sp = Obj("SmallPic");
	var bpb = Obj("BigPicBox");
	var mpb = Obj("MovePicBox");
	if (sp == null || bpb == null || mpb == null){return;}
	try{
		sp.style.filter = "alpha(opacity=100)";
		sp.style.opacity=1
	}catch(e){}

	bpb.style.display = "none";
	mpb.style.display = "none";
}

function MoveBigPic(x, y){
 
  var bpbi = Obj("BigPicBoxInner");
  if (bpbi == null){return;}
  var xx = 0;
  var yy = 0;
  if (x < mpb_mbw){
	  xx = 0;
  }else if (x > (spb_w - mpb_mbw)){
    xx = bpb_w - bp_w;
  }else{
    xx = (mpb_mbw - x) * (bp_w - bpb_w) / (spb_w - mpb_w);
  }

  if (y < mpb_mbh){
    yy = 0;
  }else if (y > (spb_h - mpb_mbh)){
    yy = bpb_h - bp_h;
  }else{
    yy = (mpb_mbh - y) * (bp_h - bpb_h) / (spb_h - mpb_h);
  }
  bpbi.style.left = xx + "px";
  bpbi.style.top = yy + "px";
}

function MoveDiv(x, y){/**x  和   y  是鼠标相对于#SmallPicBox容器左上角的坐标**/
  var mpb = Obj("MovePicBox");
  if (mpb == null){return;}

  var xx = 0;
  var yy = 0;
  if (x < mpb_mbw){
    xx = 0;/**离#SmallPicBox左边距的距离设为0**/
  }else if (x > (spb_w - mpb_mbw)){
    xx = spb_w - mpb_w;/**离#SmallPicBox左边距的距离设为spb_w-mpb_w**/
  }else{
    xx = x - mpb_mbw;/**鼠标到#SmallPicBox的距离-鼠标到#MovePicBox的距离=#vpd到#SmallPicBox的距离**/
  }
  
  if (y < mpb_mbh){
    yy = 0;
  }else if (y > (spb_h - mpb_mbh)){
    yy = spb_h - mpb_h;
  }else{
    yy = y - mpb_mbh;
  }
  mpb.style.left = xx  + "px";
  mpb.style.top = yy   + "px";
/**因为#SmallPicBox、#BigPicBox、#MovePicBox是兄弟关系而非父子关系，又因为#MovePicBox脱离了文档流，所以要使得#MovePicBox在#SmallPicBox的上面就必须加上#SmallPicBox的上边距和左边距**/
  MoveSmallPicBox(xx, yy);
}

function MoveSmallPicBox(x, y){/** x 和 y 是#MovePicBox容器左上角原点相对于#SmallPicBox容器左上角原点的距离**/
  var mpbi = Obj("MovePicBoxInner");
  if (mpbi == null){return;}

  var xx = 0 - x;
  var yy = 0 - y;

  mpbi.style.left = xx + "px";
  mpbi.style.top = yy + "px";
}