﻿// -----------
dface_var={}

function dface_init(sid, uid){
    dface_var.sid = 21835409;
    dface_var.uid = "51910153c90d8b1e2000015e";
    dface_var.gid = 1;
}

function close(){
    try{
        window.location = "dface://close";
    }catch(e){
        alert(e)
    }
}


//---------------------- 



 var logh=20;
 extraleft=new Array();
 extraleft[1]=6;
 extraleft[2]=4;
 extraleft[3]=5;
 extraleft[4]=5;
 extraright=10;
 var saw=308;
 var sah=247; 
 var stdir;
 var stwidth=new Array();
 var stmargin=new Array();
 var sttype=new Array();
 var ststart=new Array();
 var stscore=0;
 sts=0;
 stwidth[0]=260; //a ronk maga!
 ststart[0]=(stwidth[0]-270)*Math.random();
 stmargin[0]=(saw-stwidth[0])/2; //ronk margoja!
 sttype[0]=Math.floor(Math.random()*4)+1;
 var stinterval;
 var paddingtarget=0,paddingnow=0;
 var gameisover=1;
 var dnd=0;

 function firstinit() {
  document.body.addEventListener("touchmove", function(e) {
          e.preventDefault();
  }, false);

  gamesplayed=getCookie('stack_gamesplayed');
  if(gamesplayed == '') {gamesplayed=0;}
  document.getElementById('gamesplayed').innerHTML=gamesplayed;

  theirbest=getCookie('stack_bestscore');
  if(theirbest == '') {theirbest=0;}
  document.getElementById('yourbest').innerHTML=theirbest;

  imgpreload(new Array('/stack/i/dropshadow.png','/stack/i/wood/11.png','/stack/i/wood/12.png','/stack/i/wood/13.png','/stack/i/wood/21.png','/stack/i/wood/22.png','/stack/i/wood/23.png','/stack/i/wood/31.png','/stack/i/wood/32.png','/stack/i/wood/33.png','/stack/i/wood/41.png','/stack/i/wood/42.png','/stack/i/wood/43.png'));
  document.body.addEventListener("touchmove", function(e) {
          e.preventDefault();
  }, false);
 }

 function init() {
  tmp=document.createElement('div');
  tmp.style.position='absolute';
  tmp.style.cursor='pointer';
  if(typeof(tmp.ontouchstart) !== 'undefined') {
	  tmp.ontouchstart=handleclick;
  } else {
  	tmp.onmousedown=handleclick;
  	tmp.onclick = function() {return false;}
  }
  tmp.style.backgroundImage='url(/stack/i/stackthelog.png)';
tmp.style.backgroundPosition='center center';
tmp.style.backgroundRepeat='no-repeat';
  tmp.style.width='298px';
  tmp.style.height='55px';
tmp.style.padding='17px 11px 0 11px';
  tmp.style.zIndex='30';
  tmp.style.margin='243px 0 0 0';
  $st('st_outerarea').appendChild(tmp);

  tmp=document.createElement('div')
  tmp.id='st_scrollarea';
  tmp.style.backgroundImage='url(/stack/i/bg1250.png)';
  tmp.style.backgroundPosition='bottom center';
  tmp.style.width='320px';
  tmp.style.height='315px';
  tmp.style.position='absolute';
  $st('st_outerarea').appendChild(tmp);
  
  tmp=document.createElement('div');
  tmp.style.backgroundImage='url(/stack/i/fuhatul.png)';
  tmp.style.position='absolute';
  tmp.style.width='320px';
  tmp.style.height='87px';
  tmp.style.marginTop='228px';
  tmp.style.zIndex='10';
  $st('st_scrollarea').appendChild(tmp);

  tmp=document.createElement('div');
  tmp.style.backgroundImage='url(/stack/i/fuelol.png)';
  tmp.style.position='absolute';
  tmp.style.width='311px';
  tmp.style.height='39px';
  tmp.style.marginTop='217px';
  tmp.style.zIndex='20';
  $st('st_scrollarea').appendChild(tmp);

  tmp2=Math.floor(Math.random()*4)+1;

  tmp=document.createElement('div');
  tmp.id='stp_0';
  tmp.style.position='absolute';
  tmp.style.height=logh+'px';
  tmp.style.marginTop=sah-logh+'px';
  tmp.style.marginLeft=stmargin[0]-extraleft[sttype[0]]+7+'px';
  $st('st_scrollarea').appendChild(tmp);
  showaronk('stp_0',sttype[0],ststart[0],stwidth[0]);
  //addshadow();
  stack_init();
 }

function stack_init() {
 if(sts>10) {
  paddingtarget=(sts-10)*(logh-4);
  if(sts > 15) {
   $st('st_scrollarea').removeChild($st('stp_'+(sts-16)));
   if(sts % 2 == 0 && sts>16) {   $st('st_scrollarea').removeChild($st('shd_'+(sts-16)));}
  }
 }

 sts++;

 stwidth[sts]=stwidth[sts-1];
 ststart[sts]=(stwidth[sts]-270)*Math.random();
 stmargin[sts]=0; stdir=Math.log(sts+1)*2; $st('level').innerHTML=Math.floor(sts/10)+1;
 sttype[sts]=Math.floor(Math.random()*4)+1;
 if(Math.random()>.5) {stdir*=-1; stmargin[sts]=saw-stwidth[sts];}
 tmp=document.createElement('div');
 tmp.id='stp_'+sts;
// tmp.style.backgroundColor='#ffeb00';
// tmp.style.overflow='hidden';
 tmp.style.position='absolute';
 tmp.style.height=logh+'px';
 tmp.style.width=extraleft[sttype[sts]]+stwidth[sts]+extraright/2+'px';
 tmp.style.marginTop=sah-(sts+2)*(logh-4);
 tmp.style.marginLeft=stmargin[sts]-extraleft[sttype[sts]]+7+'px';
 $st('st_scrollarea').appendChild(tmp);
 showaronk('stp_'+sts,sttype[sts],ststart[sts],stwidth[sts]);
 stinterval=setInterval('stack_dothemove()',50);
}

function stack_dothemove() {
  //if($st('score').innerHTML < stscore) {
  // $st('score').innerHTML=Math.floor((parseInt($st('score').innerHTML)+stscore*3)/4);
  //}
  if(paddingtarget > paddingnow+1) {
   paddingnow=(paddingtarget+paddingnow)/2;
   $st('st_scrollarea').style.paddingTop=paddingnow+'px';
  }
  stmargin[sts]+=stdir;
  if(stmargin[sts] < 0) {stmargin[sts]=-stmargin[sts]; stdir*=-1;}
  else if(stmargin[sts]+stwidth[sts] > saw) {stmargin[sts]=saw-stwidth[sts]-stmargin[sts]-stwidth[sts]+ saw; stdir*=-1;}
  document.getElementById('stp_'+sts).style.marginLeft=stmargin[sts]-extraleft[sttype[sts]]+7+'px';
}

function handleclick() {
 if(dnd==1) {return false;}
 dnd=1;
 clearTimeout(stinterval);
 stwo=stwidth[sts];
 hcf='';
 if(stmargin[sts] < stmargin[sts-1]) {stwidth[sts]-=stmargin[sts-1]-stmargin[sts]; stmargin[sts]=stmargin[sts-1]; hcf='left';}
 if(stmargin[sts]+stwidth[sts] > stmargin[sts-1]+stwidth[sts-1]) {stwidth[sts]-= stmargin[sts]+stwidth[sts] - stmargin[sts-1]-stwidth[sts-1]; hcf='right';}
 if(stwidth[sts] <= 0) {hcf='all'}
 cutaronk('stp_'+sts,sttype[sts],ststart[sts],stwidth[sts],hcf);
 if(stwidth[sts] <= 0) {stwidth[sts]=0;}
 if(sts % 2 == 0 && stwidth[sts] > 0) {
  addshadow();
 }
 bon=Math.floor(stwidth[sts]/10*Math.log(sts+1));
 if(Math.abs(stwidth[sts] - stwidth[sts-1])<3 && stwidth[sts]>0) {
  bon*=2;
  $st('combo').innerHTML=parseInt($st('combo').innerHTML)+1;
  tmp=document.createElement('div');
  tmp.innerHTML='<div style="padding:5px"><b>STACKMASTER!</b></div>';
  tmp.id='box_perfect';
  tmp.style.zIndex='10';
  tmp.style.position='absolute';
  tmp.style.textAlign='center';
  tmp.style.width='150px';
  tmp.style.backgroundColor='#333333';
  tmp.style.marginLeft='85px';
  tmp3=(sah-(sts+2)*(logh-4)-16);
  tmp.style.marginTop=tmp3+'px';
  $st('st_scrollarea').appendChild(tmp);
  tmp2=new Array();
  tmp2[0]="";
  tmp2[1]="$st('score_title').style.color='#ffffff'; /stack/i/('box_perfect').style.marginTop='"+(tmp3-5)+"px';";
  tmp2[2]="$st('box_perfect').style.marginTop='"+(tmp3-10)+"px';";
  tmp2[3]="$st('box_perfect').style.marginTop='"+(tmp3-15)+"px';";
  tmp2[4]="$st('st_scrollarea').removeChild($st('box_perfect')); $st('score_title').style.color=''";
  ttt=Math.random();
  stispace[ttt]=tmp2;
  setTI(ttt,50);
 }
 stscore+=bon;
 $st('score').innerHTML=stscore;
 if(stscore>theirbest) {$st('score').style.color='#ff0000';}
}

function addshadow() {
  tmp=document.createElement('img');
  tmp.src='/stack/i/dropshadow.png';
  tmp.id='shd_'+sts;
  tmp.style.zIndex='15';
  tmp.style.position='absolute';
  tmp.style.width=(extraleft[sttype[sts]]+stwidth[sts]+extraright/2)+'px';
  tmp.style.height='30px';
  tmp.style.marginLeft=(stmargin[sts]-extraleft[sttype[sts]]+7)+'px';
  tmp.style.marginTop=(sah-(sts+1)*(logh-4)-1)+'px';
  $st('st_scrollarea').appendChild(tmp);
}

function cutaronk(crid,crtype,crstart,crstays,crfrom) {
 //srfrom: left: bal oldalrol vag le, right: jobb oldalrol vag le
 croriw=parseInt(document.getElementById(crid).getElementsByTagName('div')[0].getElementsByTagName('div')[0].style.width);
 if(crfrom == 'right') {
  document.getElementById(crid).getElementsByTagName('div')[0].getElementsByTagName('div')[0].style.width=crstays+'px';
  document.getElementById(crid).getElementsByTagName('div')[0].getElementsByTagName('img')[0].style.marginLeft=extraleft[crtype]+crstays-extraright/2+'px';
  showaronk(crid,crtype,crstart-crstays,croriw-crstays);
  document.getElementById(crid).childNodes[1].style.marginLeft=crstays+'px';
  document.getElementById(crid).childNodes[1].style.zIndex='12';
 } else if(crfrom == 'left'){
  document.getElementById(crid).getElementsByTagName('div')[0].getElementsByTagName('div')[0].style.width=crstays+'px';
  document.getElementById(crid).getElementsByTagName('div')[0].getElementsByTagName('div')[0].style.marginLeft=extraleft[crtype]+croriw-crstays+1+'px';
  document.getElementById(crid).getElementsByTagName('div')[0].getElementsByTagName('div')[0].style.backgroundPosition=crstart+crstays-croriw+'px';
  document.getElementById(crid).getElementsByTagName('div')[0].getElementsByTagName('img')[1].style.marginLeft=croriw-crstays+'px';
  showaronk(crid,crtype,crstart,croriw-crstays);
  document.getElementById(crid).childNodes[1].style.zIndex=(sts % 2 == 1)?(14):(16);
 }

 if(crfrom !='') {
  tmp=new Array();
  if(crfrom == 'left' || crfrom == 'right') {
   tmp[0]="$st('"+crid+"').style.marginTop='"+(sah-(sts+1)*(logh-4))+"px';document.getElementById('"+crid+"').childNodes[1].style.marginTop='2px';  document.getElementById('"+crid+"').childNodes[0].style.zIndex="+((sts % 2)?(13):(16))+";";
   tmp[1]="$st('"+crid+"').childNodes[1].style.opacity='.75'; $st('"+crid+"').childNodes[1].style.marginTop='7px';";
   tmp[2]="$st('"+crid+"').childNodes[1].style.opacity='.5';$st('"+crid+"').childNodes[1].style.marginTop='12px';";
   tmp[3]="$st('"+crid+"').childNodes[1].style.opacity='.25';$st('"+crid+"').childNodes[1].style.marginTop='17px';";
   tmp[4]="$st('"+crid+"').removeChild(document.getElementById('"+crid+"').childNodes[1]);"
  } else if(crfrom =='all') {
   tmp[0]="$st('"+crid+"').childNodes[0].style.marginTop='2px';";
   tmp[1]="$st('"+crid+"').childNodes[0].style.opacity='.75'; $st('"+crid+"').childNodes[0].style.marginTop='7px';";
   tmp[2]="$st('"+crid+"').childNodes[0].style.opacity='.5'; $st('"+crid+"').childNodes[0].style.marginTop='12px';";
   tmp[3]="$st('"+crid+"').childNodes[0].style.opacity='.25'; $st('"+crid+"').childNodes[0].style.marginTop='17px';";
   tmp[4]="$st('"+crid+"').removeChild(document.getElementById('"+crid+"').childNodes[0]);"
  }
  if(stwidth[sts] >0) { tmp[4]+="stack_init(); dnd=0;"; } else { tmp[4]+='gameover();' }
  ttt=Math.random();
  stispace[ttt]=tmp;
  setTI(ttt,50);
 } else {
  document.getElementById(crid).style.marginTop=(sah-(sts+1)*(logh-4))+'px';  document.getElementById(crid).childNodes[0].style.zIndex=((sts % 2)?(13):(16));
  stack_init();
 }
}

function showaronk(srid,srtype,srstart,srsize) {
 srt='/stack/i/wood/'+srtype
 tmp=document.createElement('div');
 tmp.style.position='absolute';
 tmp.style.width=extraleft[srtype]+srsize+extraright/2+'px';
 tmp.style.height=logh+'px';
 tmp.style.zIndex=15;

 tmp2=document.createElement('div');
 tmp2.style.position='absolute';
 tmp2.style.width=srsize+'px';
 tmp2.style.height=logh+'px';
 tmp2.style.marginLeft=extraleft[srtype]+'px';
 tmp2.style.backgroundImage='url('+srt+'2.png)';
 tmp2.style.backgroundPosition=srstart+'px 0';
 tmp.appendChild(tmp2);

 tmp2=document.createElement('img');
 tmp2.src=srt+'3.png';
 tmp2.style.marginLeft=extraleft[srtype]+srsize-extraright/2;
 tmp2.style.position='absolute';
 tmp.appendChild(tmp2);

 tmp2=document.createElement('img');
 tmp2.src=srt+'1.png';
 tmp2.style.position='absolute';
 tmp.appendChild(tmp2);

 $st(srid).appendChild(tmp);
}

function gameover() {
 gameisover=1;
 gamesplayed++;
 setCookie('stack_gamesplayed',gamesplayed);
 document.getElementById('gamesplayed').innerHTML=gamesplayed;
 if(stscore>theirbest) {
  setCookie('stack_bestscore',stscore);
  document.getElementById('yourbest').innerHTML=stscore;
  theirbest=stscore;
  ialert('<h1>Game over</h1>恭喜您，获得新高分!<br><br>'+'<h1>分数：'+stscore+'</h1>','gamerank();');
 } else {
  ialert('<h1>Game over</h1>堆木头得分:<br><br>'+'<h1>分数：'+stscore+'</h1>','gamerank();');
 }
 //urchinTracker('/stack/gamesplayed/');
 return false;
}

function gamerank() {
  dface_var.score = stscore;
  $.get('/game/new_score', {
    game: dface_var
  } , function(data){
    for(var di=0; di < data.length; di++ ){
    var h = "";
    h += "第"+(di+1)+'名 ' + data[di].uname + " 得分: "+ data[di].score + "<br/>"
    ialert('<h1>堆木头排名</h1>'+h,'restartgame()')
    }
  })
}

// (function($st) {
//     function gamerank() {
//       dface_var.score = stscore;
//       $st.get('/game/new_score', {
//         game: dface_var
//       } , function(data){
//         for(var di=0; di < data.length; di++ ){
//         var h = "";
//         h += "第"+(di+1)+'名 ' + data[di].uname + " 得分: "+ data[di].score + "<br/>"
//         ialert('<h1>堆木头排名</h1>'+h,'restartgame()')
//         }
//       })
//     }
// })(jQuery)

function restartgame() {
 clearInterval(stinterval);
 gameisover=0;
 stwidth=new Array();
 stmargin=new Array();
 sttype=new Array();
 ststart=new Array();
 stscore=0;
 sts=0;
 stwidth[0]=260; //a ronk maga!
 ststart[0]=(stwidth[0]-270)*Math.random();
 stmargin[0]=(saw-stwidth[0])/2; //ronk margoja!
 sttype[0]=Math.floor(Math.random()*4)+1;
 paddingtarget=0,paddingnow=0;
 dnd=0;
 $st('combo').innerHTML=0;
 $st('level').innerHTML=1;
 $st('score').innerHTML=stscore;
 $st('score').style.color='#ffffff';
 $st('st_outerarea').innerHTML='';
 init();
}

function pausegame() {
 clearTimeout(stinterval);
}

function resumegame() {
 if(gameisover == 0) {
  stinterval=setInterval('stack_dothemove()',50);
 }
}
