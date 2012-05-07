// JavaScript Document
function Focus(){
	var bp=document.getElementById("BigPic").getAttribute("src");
	var array=bp.split("/");
	var imgs=array[array.length-1].split(".");
	var sp,sps,sps1;
	
	for(var i=0;i<num;i++){
		piclist.getElementsByTagName("li")[i].setAttribute("id","picli_"+i);
		piclist.getElementsByTagName("li")[i].getElementsByTagName("span")[0].getElementsByTagName("a")[0].setAttribute("href","javascript:Changes("+i+")");
		piclist.getElementsByTagName("li")[i].getElementsByTagName("span")[0].getElementsByTagName("a")[0].getElementsByTagName("img")[0].setAttribute("id","picli_img"+i);
	}
	for(var i=0;i<num;i++){
		sp=piclist.getElementsByTagName("li")[i].getElementsByTagName("a")[0].getElementsByTagName("img")[0].getAttribute("src");
		sps=sp.split("/");
		sps1=sps[sps.length-1].split(".");
		spsrc=sps1[0].substring(0,sps1[0].lastIndexOf("_"));
		if(imgs[0]==spsrc){
			funs=funs2=oldn=i;
			ImgList(i);
			return;
		}
	}
}

function ImgList(n, isajax){
	piclist.getElementsByTagName("li")[n].className="hover";
    OpenPic(n,isajax);
    if(parseInt(picplaneinner.offsetWidth)>(parseInt(piclist.getElementsByTagName("li")[0].offsetWidth)*n)){
		piclist.style.left=0+"px";
		document.getElementById("LA").className="la nla";
		document.getElementById("RA").className="ra";
	}else if(funs>5&&funs<(num-5)){
	    piclist.style.left=-(piclist.getElementsByTagName("li")[0].offsetWidth)*Math.floor(funs/5)*5+"px";
		document.getElementById("LA").className="la";
		document.getElementById("RA").className="ra";
	}else if((num-funs)<5){/**用于判断否是是图片序列末端的图片**/
		piclist.style.left=-parseInt(piclist.getElementsByTagName("li")[0].offsetWidth)*Math.floor(funs/5)*5+"px";
		document.getElementById("RA").className="ra nra";
	}
	
	
	if(parseInt(piclist.style.width)<=picplaneinner.offsetWidth){
		document.getElementById("LA").className="la nla";
		document.getElementById("RA").className="ra nra";
	}	
}

function Changes(n){
	if(n>oldn){
		funs=funs2=n-1;
		ArrowDown();
	}else if(n<oldn){
		funs=funs2=n+1;;
		ArrowUp();
	}
	oldn=n;
}

function OpenPic(n,isajax){
	for(var i=0;i<num;i++){
		piclist.getElementsByTagName("li")[i].className="";
	}
	piclist.getElementsByTagName("li")[n].className="hover";
	var img_src=document.getElementById("picli_img"+n).getAttribute("src");
	
	/**获取图片名**/
	var array=img_src.split("/");

	var imgs=array[array.length-1].split(".");
	var imgs1=imgs[0].substring(0,imgs[0].lastIndexOf("_"));
	if(isajax)
	$.getJSON("/shop_space/load_photo/"+array[array.length-2], function(data){
			document.getElementById("BigPic").setAttribute("src","/shop_photos/0000/"+array[array.length-2]+"/"+imgs1+"."+imgs[imgs.length-1]);
		if(data["name"]==null){
			$("#photo_name h2").replaceWith("<h2></h2>");
		}else{
			$("#photo_name h2").replaceWith("<h2>"+data["name"]+"</h2>");
		}

		if(data["content"]==null){
			$("#photo_content p").replaceWith("<p></p>");
		}else{
			$("#photo_content p").replaceWith("<p>"+data["content"]+"</p>");
		}
	})
	funs=funs2=n;
}

function PageUp(){
   if(parseInt(piclist.style.left)==0||piclist.style.left==""){
		return;
	}else{
		document.getElementById("RA").className="ra";
	}
	clearInterval(run);
	run=setInterval("Run(false)",90);
}

function PageDown(){
 	var w = parseInt(piclist.style.width) - Math.abs(parseInt(piclist.offsetLeft));
	if(w<=picplaneinner.offsetWidth){
		return;
	}else{
		document.getElementById("LA").className="la";
	}
	clearInterval(run);
	run=setInterval("Run(true)",90);
}

function Run(n){
	var len=parseInt(piclist.offsetLeft);
	var len1=parseInt(piclist.style.width)/num;
	var w=parseInt(piclist.style.width) - Math.abs(parseInt(piclist.offsetLeft));
	if(i<=po&&n==true){
		piclist.style.left=(len-len1)+"px";i++;
	}else if(i<=po&&n==false){
		piclist.style.left=(len+len1)+"px";i++;
	}else{
		i=1;clearInterval(run);
		
		if(w<=picplaneinner.offsetWidth){
			document.getElementById("RA").className="ra nra";
			document.getElementById("LA").className="la";
		}else if(parseInt(piclist.style.left)==0||piclist.style.left==""){
			document.getElementById("RA").className="ra";
			document.getElementById("LA").className="la nla";
		}else if(w>picplaneinner.offsetWidth){
			document.getElementById("LA").className="la";
			document.getElementById("RA").className="ra";
		}
	}
}


function ArrowUp(){
	if(funs2<=0){funs=funs2=num-1;ImgList(funs, true);document.getElementById("LA").className="la";return;}
	piclist.getElementsByTagName("li")[funs2].className="";
	funs2--;
	piclist.getElementsByTagName("li")[funs2].className="hover";
	
	OpenPic(funs2,true)
	
	if(funs2>=5&&(funs2%5==0)){
		if(funs2>Math.floor(num/5)*5)return;/**指针位于图片列表末尾几张图片时取消循环**/
		clearInterval(run);run=setInterval("Run(false)",90);
	}else if(funs2==5){clearInterval(run);run=setInterval("Run(false)",90);}
	if(funs2==0){document.getElementById("LA").className="la nla";}
	
}
function ArrowDown(){
	if(funs2>=(num-1)){funs=funs2=0;ImgList(funs, true);return;}
	piclist.getElementsByTagName("li")[funs2].className="";
	funs2++;
	piclist.getElementsByTagName("li")[funs2].className="hover";
	OpenPic(funs2, true);
	if(funs2>=5&&(funs2%5==0)){clearInterval(run);run=setInterval("Run(true)",90);}
	if(funs2==num){document.getElementById("RA").className="ra nra";}
}
