/*
**	Anderson Ferminiano
**	contato@andersonferminiano.com -- feel free to contact me for bugs or new implementations.
**	jQuery ScrollPagination
**	28th/March/2011
**	http://andersonferminiano.com/jqueryscrollpagination/
**	You may use this script for free, but keep my credits.
**	Thank you.
*/

(function( $ ){


 $.fn.scrollPagination = function(options) {

                var opts = $.extend($.fn.scrollPagination.defaults, options);  
                var target = opts.scrollTarget;
                if (target == null){
                        target = obj; 
                }
                opts.scrollTarget = target;

                return this.each(function() {
                  $.fn.scrollPagination.init($(this), opts);
                });

  };

  $.fn.stopScrollPagination = function(){
          return this.each(function() {
                $(this).attr('scrollPagination', 'disabled');
          });

  };

  $.fn.scrollPagination.loadContent = function(obj, opts){
         var target = opts.scrollTarget;
         var mayLoadContent = $(target).scrollTop()+opts.heightOffset >= $(document).height() - $(target).height();
         if (mayLoadContent){
                 if (opts.beforeLoad != null){
                        opts.beforeLoad(); 
                 }
                 $(obj).children().attr('rel', 'loaded');
                 $.ajax({
                          type: 'POST',
                          url: opts.contentPage,
                          data: opts.contentData,
                          success: function(data){
                                // $(obj).append(data); 
                                 if(data.length>0) {
                                 var shops = [];
}
                                 var o_lat = sessionStorage.getItem("lat_cur");
                                 var o_lng = sessionStorage.getItem("lng_cur");
                                 for(var i=0;i<data.length;i++){
                                   if (typeof data[i].mshop === "object") {
                                     shops.push(data[i]);
                                   } else {
                                     o_lat = data[i].offset_lat;
                                     o_lng = data[i].offset_lng;
                                   }
                                 }
                                  for(var i=0;i<shops.length;i++){
                                    // shops[i].diff=GetDistance(lat_cur,lng_cur,shops[i].mshop.lat,shops[i].mshop.lng);
                                    shops[i].diff=GetDistance(o_lat, o_lng,shops[i].mshop.lat,shops[i].mshop.lng);
                                    sessionStorage.setItem("shop" + shops[i].mshop.id + '_lat', shops[i].mshop.lat);
                                    sessionStorage.setItem("shop" + shops[i].mshop.id + '_lng', shops[i].mshop.lng);
                                 }
                                 $("#shopTemplate").tmpl(shops).appendTo("#content");
                                var objectsRendered = $(obj).children('[rel!=loaded]');
                                if (opts.afterLoad != null){
                                  opts.afterLoad(objectsRendered);	
                                }
                          },
                          dataType: 'json'
                 });
         }

  };

  $.fn.scrollPagination.init = function(obj, opts){
         var target = opts.scrollTarget;
         $(obj).attr('scrollPagination', 'enabled');

         $(target).scroll(function(event){
                if ($(obj).attr('scrollPagination') == 'enabled'){
                        $.fn.scrollPagination.loadContent(obj, opts);		
                }
                else {
                        event.stopPropagation();	
                }
         });

         $.fn.scrollPagination.loadContent(obj, opts);

 };

 $.fn.scrollPagination.defaults = {
         'contentPage' : null,
         'contentData' : {},
                 'beforeLoad': null,
                 'afterLoad': null	,
                 'scrollTarget': null,
                 'heightOffset': 0		  
 };	
})( jQuery );
