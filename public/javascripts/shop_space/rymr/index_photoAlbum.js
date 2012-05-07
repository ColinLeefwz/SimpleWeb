
$(window).load(function(){
	var iClass, iGap, iShow, iSpeed, iClassAll, iWidth, iHeight, iImages, iMove;
	
	iClass = '.pa ';
	
	iGap = 0;/**控制图片间距**/
	
	iShow = 5;/**控制图片显示的数量**/
	
	iSpeed = 1500;/**控制速度**/
	
	iClassAll = $(iClass + 'li.piclist');
	iWidth = $(iClass + 'li.piclist a').width();
	iHeight = $(iClass + 'li.piclist a').height();
	iImages = $(iClass + 'li.piclist a').length;
		
	iMove = '-'+(iWidth*iShow + iGap*(iShow-1) +'px');
	
	$(iClass).width(iWidth*iShow + iGap*(iShow+1) +'px');
	$(iClass).height(iHeight+iGap*2+'px');
	iClassAll.width((iWidth+iGap)*iImages+'px');
	iClassAll.css('paddingTop',iGap+'px').css('left',iGap +'px');
	
	$(iClass + 'li.piclist a').css('marginRight',iGap+'px');

	$('.photoAlbum span.LeftBotton').css('top',((iHeight+iGap*2)-32)/2+'px');
	$('.photoAlbum span.RightBotton').css('top',((iHeight+iGap*2)-32)/2+'px');
/****	$(iClass + 'span.LeftBotton').css('top',((iHeight+iGap*2)-32)/2+'px').hide();
	$(iClass + 'span.RightBotton').css('top',((iHeight+iGap*2)-32)/2+'px').hide();****/
	
	
	if (iImages>iShow) {
	
		if (iImages/2 < iShow) {
			iMove = '-'+(iWidth*(iImages-iShow) + iGap*(iShow-1) +'px');
			iShow = iWidth-iShow;
		}
	
	
		/****$(iClass).mouseover(function() {      鼠标覆盖时显示翻页箭头
			$(iClass + 'span.LeftBotton').show();
			$(iClass + 'span.RightBotton').show();
		});
	
	
		$(iClass).mouseleave(function() {          鼠标离开时显示翻页箭头
			$(iClass + 'span.LeftBotton').hide();
			$(iClass + 'span.RightBotton').hide();
		});****/
	
	
		$('.photoAlbum span.RightBotton').click(function() {
			if($(iClass + 'li.piclist a').length<=5){return false;}
			
			iClassAll.animate({left: iMove},iSpeed,"easeOutBounce", function() {
				for (var i=0; i<iShow; i++) {
					iClassAll.find(':first').remove().appendTo('.pa li.piclist');
				}
			iClassAll.css('left', iGap +'px');
			});
		});
	
		$('.photoAlbum span.LeftBotton').click(function() {
			if($(iClass + 'li.piclist a').length<=5){return false;}
			for (var i=0; i<iShow; i++) {
				iClassAll.find(':last').remove().prependTo('.pa li.piclist');
			}
			iClassAll.css('left', iMove);
			iClassAll.animate({left: iGap +'px'},iSpeed,"easeOutBounce");
		});
	
	}

});