// JavaScript Document
var ie7=false;
function setDivPosition(pfield){
d=document.getElementById("showMovieList");
if(d){
	d.style.left=totalOffsetLeft(pfield)+"px";
	d.style.top=totalOffsetTop(pfield)+pfield.offsetHeight-1+"px";
	d.style.width="350px";
	d.style.display="block";
	d.style.zIndex="9999";
	d.style.paddingRight="10";
	d.style.paddingLeft="10";
	d.style.paddingTop="10";
	d.style.paddingBottom="10";
	d.style.position="absolute";
	d.style.backgroundColor="white";
}}

function setDivPosition_ie6(){
d=document.getElementById("showMovieList");
if(d){
	x=window.event.x+10;
	y=window.event.y+10;
	d.style.left=x+"px";
	d.style.top=y+"px";
	d.style.width="350px";
	d.style.display="block";
	d.style.zIndex="9999";
	d.style.paddingRight="10";
	d.style.paddingLeft="10";
	d.style.paddingTop="10";
	d.style.paddingBottom="10";
	d.style.position="absolute";
	d.style.backgroundColor="white";
	if(ie7){
		d.style.left=window.event.x+3+"px";
		d.style.top=window.event.y+3+"px";
	}
}}

function isIE6(){
if(navigator&&navigator.userAgent.toLowerCase().indexOf("msie")!=-1&&navigator.userAgent.toLowerCase().indexOf("6.0")!=-1){ return true;}
else if(navigator&&navigator.userAgent.toLowerCase().indexOf("msie")!=-1&&navigator.userAgent.toLowerCase().indexOf("7.0")!=-1){ ie7=true;return true;}
return false;
}
function myOffsetWidth(pfield){if(navigator&&navigator.userAgent.toLowerCase().indexOf("msie")==-1){return pfield.offsetWidth-ea*2;
}else{return pfield.offsetWidth;
}}

function totalOffsetLeft(s){return kb(s,"offsetLeft");
}

function totalOffsetTop(s){return kb(s,"offsetTop");
}

function kb(s,na){var wb=0;
while(s){wb+=s[na];
s=s.offsetParent;
}return wb;
}

function ajax_change(yearID,monthID,dayID,calendarID,shopID){

	var pars="yearID="+yearID+"&monthID="+monthID+"&dayID="+dayID+"&shopId="+shopID;
	var myajax=new Ajax.Updater(
	'showMovieList',
	'../../movielist/reply_updater.php',
	{method: 'get',
	parameters: pars
	}
	);
	if(isIE6()){
		setDivPosition_ie6();
	}else{
		setDivPosition(document.getElementById(calendarID));
	}
}

function hiddenMore(){
	document.getElementById("showMovieList").style.display="none";
}
function showMore(){
	document.getElementById("showMovieList").style.display="block";
}


function get_X(obj){
	var ParentObj=obj;
	var left=obj.offsetLeft;
	while(ParentObj=ParentObj.offsetParent){
		left+=ParentObj.offsetLeft;
	}
	return left;
}


function get_Y(obj){
	var ParentObj=obj;
	var top=obj.offsetTop;
	while(ParentObj=ParentObj.offsetParent){
		top+=ParentObj.offsetTop;
	}
	return top;
}

function displayCalendar(pYear,pMonth,pDay,shopID){

	var today=new Date(pYear,pMonth,pDay);
	var year=today.getFullYear();
	var month=today.getMonth();
	var day=today.getDate();
	var dayWeek=today.getDay();

	var firstDay=new Date(year,month,1);
	var firstDayWeek=firstDay.getDay();

	var nYear=pYear;
	var nMonth=pMonth;
	var nDay=pDay;
	if(nMonth==12){
		nMonth=1;
		nYear=nYear+1;
	}else{
		nMonth++;
	}

	var contentHTML;
	contentHTML='<table width="225" border="0" cellspacing="0" cellpadding="0" style="margin-left:30px;">';
	contentHTML=contentHTML+'<tr>' ;
	contentHTML=contentHTML+'   <td class="film-ranking-month"><img src="images/last-month.gif" style="cursor:pointer;" onclick="displayCalendar_minus('+nYear+','+nMonth+','+nDay+');"/> '+ nYear +'年'+nMonth+'月 <img src="images/next-month.gif" style="cursor:pointer;" onclick="displayCalendar('+nYear+','+nMonth+','+nDay+');"/></td>';

	contentHTML=contentHTML+'</tr>';
	contentHTML=contentHTML+'</table>';

	contentHTML=contentHTML+'<table width="295" border="0" cellspacing="0" cellpadding="0" style="margin-left:3px;">';
	contentHTML=contentHTML+'<thead>';
	contentHTML=contentHTML+'<tr class="film-ranking">';
	contentHTML=contentHTML+'<td align="center">&nbsp;&nbsp;周日</td>';
	contentHTML=contentHTML+'<td align="center">周一</td>';
	contentHTML=contentHTML+'<td align="center">周二</td>';
	contentHTML=contentHTML+'<td align="center">周三</td>';
	contentHTML=contentHTML+'<td align="center">周四</td>';
	contentHTML=contentHTML+'<td align="center">周五</td>';
	contentHTML=contentHTML+'<td align="center">周六&nbsp;&nbsp;</td>';
	contentHTML=contentHTML+'</tr>';
	contentHTML=contentHTML+'</thead>';
	contentHTML=contentHTML+'</table>';

	contentHTML=contentHTML+'<table width="275" border="0" cellspacing="0" cellpadding="0">';

	contentHTML=contentHTML+'<tr class="number">';
	for(var i = 0;i<firstDayWeek;i++){
		contentHTML=contentHTML+'<td align="center">&nbsp;</td>';
	}
	var totalI;
	var tempDay;
	for(var i = 0;i<getDaysForMonth(year,month+1);i++){
		if (i+1 == day)
			contentHTML=contentHTML+'<td align="center"><div id="calendar'+i+'" onMouseOver="ajax_change('+year+','+(month+1)+','+(i+1)+',\'calendar'+i+'\',shopID);"><a style="color:#FF0000;font-size:14px;font-weight: bold">'+(i+1)+'</a></div></td>';
		else
			contentHTML=contentHTML+'<td align="center"><div id="calendar'+i+'" class=calendar onMouseOver="ajax_change('+year+','+(month+1)+','+(i+1)+',\'calendar'+i+'\',shopID);">'+(i+1)+'</div></td>';

		totalI = firstDayWeek + i + 1;
		if((totalI) % 7 == 0) contentHTML=contentHTML+'</tr>';
	}

	contentHTML=contentHTML+'</tr>';
	contentHTML=contentHTML+'</table>';
	$("calendar-content").innerHTML=contentHTML;
}

function displayCalendar_minus(pYear,pMonth,pDay){

	var today=new Date(pYear,pMonth,pDay);
	var year=today.getFullYear();
	var month=today.getMonth();
	var day=today.getDate();
	var dayWeek=today.getDay();

	var firstDay=new Date(year,month,1);
	var firstDayWeek=firstDay.getDay();

	var nYear=pYear;
	var nMonth=pMonth;
	var nDay=pDay;
	if(nMonth==1){
		nMonth=12;
		nYear=nYear-1;
	}else{
		nMonth--;
	}

	var contentHTML;
	contentHTML='<table width="225" border="0" cellspacing="0" cellpadding="0" style="margin-left:30px;">';
	contentHTML=contentHTML+'<tr>' ;
	contentHTML=contentHTML+'   <td class="film-ranking-month"><img src="images/last-month.gif" style="cursor:pointer;" onclick="displayCalendar_minus('+nYear+','+nMonth+','+nDay+');"/> '+ nYear +'年'+nMonth+'月 <img src="images/next-month.gif" style="cursor:pointer;" onclick="displayCalendar('+nYear+','+nMonth+','+nDay+');"/></td>';

	contentHTML=contentHTML+'</tr>';
	contentHTML=contentHTML+'</table>';

	contentHTML=contentHTML+'<table width="295" border="0" cellspacing="0" cellpadding="0" style="margin-left:3px;">';
	contentHTML=contentHTML+'<thead>';
	contentHTML=contentHTML+'<tr class="film-ranking">';

	contentHTML=contentHTML+'<td align="center">&nbsp;&nbsp;周一</td>';
	contentHTML=contentHTML+'<td align="center">周二</td>';
	contentHTML=contentHTML+'<td align="center">周三</td>';
	contentHTML=contentHTML+'<td align="center">周四</td>';
	contentHTML=contentHTML+'<td align="center">周五</td>';
	contentHTML=contentHTML+'<td align="center">周六</td>';
	contentHTML=contentHTML+'<td align="center">周日&nbsp;&nbsp;</td>';
	contentHTML=contentHTML+'</tr>';
	contentHTML=contentHTML+'</thead>';
	contentHTML=contentHTML+'</table>';

	contentHTML=contentHTML+'<table width="275" border="0" cellspacing="0" cellpadding="0">';

	contentHTML=contentHTML+'<tr class="number">';
	for(var i = 0;i<firstDayWeek;i++){
		contentHTML=contentHTML+'<td align="center">&nbsp;</td>';
	}
	var totalI;
	for(var i = 0;i<getDaysForMonth(year,month+1);i++){
		if (i+1 == day)
			contentHTML=contentHTML+'<td align="center"><div id="calendar'+i+'" onMouseOver="ajax_change('+year+','+(month+1)+','+(i+1)+',\'calendar'+i+'\');"><a color="red">'+(i+1)+'</a></div></td>';
		else
			contentHTML=contentHTML+'<td align="center"><div id="calendar'+i+'" class=calendar onMouseOver="ajax_change('+year+','+(month+1)+','+(i+1)+',\'calendar'+i+'\');">'+(i+1)+'</div></td>';
		totalI = firstDayWeek + i + 1;
		if((totalI) % 7 == 0) contentHTML=contentHTML+'</tr>';
	}

	contentHTML=contentHTML+'</tr>';
	contentHTML=contentHTML+'</table>';
	$("calendar-content").innerHTML=contentHTML;
}


function getDaysForMonth(year,month){
	if(month==1 ||month==3 ||month==5 ||month==7 ||month==8 ||month==10 ||month==12){
		return 31;
	}else if(month==4 ||month==6 ||month==9 ||month==11){
		return 30;
	}else{
		if((year % 4 == 0 && year % 100 != 0) || year % 400 == 0){
			return 29;
		}
		else{
			return 28;
		}
	}
}

