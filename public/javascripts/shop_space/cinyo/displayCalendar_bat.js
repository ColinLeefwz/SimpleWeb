// JavaScript Document
function ajax_change(yearID,monthID,dayID,shopID,e){
	document.getElementById("DetailsList").style.display="block";
	var e=e?e:event;
	var X, Y;
	if(document.body.scrollLeft!=0){
		X=e.clientX-parseInt(document.getElementById("SelectDate").style.marginLeft)+document.body.scrollLeft+5;
	}else{
		X=e.clientX-parseInt(document.getElementById("SelectDate").style.marginLeft)+document.documentElement.scrollLeft+5;
	}

	if(document.body.scrollTop!=0){
		Y=e.clientY-parseInt(document.getElementById("SelectDate").style.marginTop)+document.body.scrollTop+5;
	}else{
		Y=e.clientY-parseInt(document.getElementById("SelectDate").style.marginTop)+document.documentElement.scrollTop+5;
	}

	document.getElementById("DetailsList").style.display="block";
	document.getElementById("DetailsList").style.left=X+"px";
	document.getElementById("DetailsList").style.top=Y+"px";

	jQuery.ajax({
		url: "/cinyo/plan",
		data: ({yearID: yearID,monthID: monthID+1, dayID: dayID, shopID: shopID}),
		success: function(data){document.getElementById("DetailsList").innerHTML = data}
	})
}
function CloseDetailsList(){
	document.getElementById("DetailsList").style.display="none";
}
function ShowDetailsList(){
	document.getElementById("DetailsList").style.display="block";
}

function displayCalendar(pYear,pMonth,pDay,shopID,change){
	var day=new Date(pYear,pMonth,pDay);
	var year=day.getFullYear();
	var month=day.getMonth();
	var theday=day.getDate();
	var dayWeek=day.getDay();

	if(month==11&&change=="next"){
		month=0;
		year=year+1;
	}else if(month==0&&change=="pre"){
		month=11;
		year=year-1;
	}else if(change=="next"){
		month++;
	}else if(change=="pre"){
		month--;
	}
	var firstDay=new Date(year,month,1);
	var firstDayWeek=firstDay.getDay();

	var contentHTML;
	contentHTML='<span class="change_date"><img src="/img/shop_space/cinyo/last-month.gif" onclick="displayCalendar('+year+','+(month)+','+theday+','+shopID+',\'pre\');"/> '+ year +'年'+(month+1)+'月 <img src="/img/shop_space/cinyo/next-month.gif" onclick="displayCalendar('+year+','+month+','+theday+','+shopID+',\'next\');"/></span>';

	contentHTML=contentHTML+'<table border="0" cellspacing="0" cellpadding="0" class="week">';
	contentHTML=contentHTML+'<tr>';
	contentHTML=contentHTML+'<td>周日</td>';
	contentHTML=contentHTML+'<td>周一</td>';
	contentHTML=contentHTML+'<td>周二</td>';
	contentHTML=contentHTML+'<td>周三</td>';
	contentHTML=contentHTML+'<td>周四</td>';
	contentHTML=contentHTML+'<td>周五</td>';
	contentHTML=contentHTML+'<td>周六</td>';
	contentHTML=contentHTML+'</tr>';
	contentHTML=contentHTML+'</table>';

	contentHTML=contentHTML+'<table border="0" cellspacing="0" cellpadding="0" class="days">';

	var monthForDays=JudgeMonth(year,month+1);

	for(var i = 0; i<42; i++){
		if(i%7==0){contentHTML=contentHTML+'<tr>';}
		var j=i-firstDayWeek+1;

		if(i<firstDayWeek){
			contentHTML=contentHTML+'<td>&nbsp;</td>';
		}else if(j<=monthForDays){
			if (j == theday){
				contentHTML=contentHTML+'<td class="thisday" onMouseOut="CloseDetailsList()" onMouseOver="ajax_change('+year+','+month+','+j+','+shopID+',event);">'+j+'</td>';
			}else{
				contentHTML=contentHTML+'<td onMouseOut="CloseDetailsList()" onMouseOver="ajax_change('+year+','+month+','+j+','+shopID+',event);">'+j+'</td>';
			}
		}else{
			contentHTML=contentHTML+'<td>&nbsp;</td>';
		}
		if((i+1)%7==0){contentHTML=contentHTML+'</tr>';}
	}

	contentHTML=contentHTML+'</table>';
	document.getElementById("Date").innerHTML=contentHTML;
}


function JudgeMonth(year,month){/**判断月份**/
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

