function load_visitors(shop_id, title_length){

    title_length = typeof(title_length) != 'undefined' ? title_length : 6;
    $.ajax({
        url:'/shop_space/latest_visitors?shop_id='+shop_id,
        data:'',
        type:'get',
        dataType:'json',
        success:function(users) {
var visitors = '<div class="friends"><div class="friend_img"><img src="${user.logo_path}"  alt="点击查看好友信息"></div><span class="friend_name"><a href="${user.id}" target="_blank" title="${user.name}">${user.name.substring(0, ' + title_length + ')}</a></span></div>';

/* Compile markup string as a named template */
$.template("visitorsTemplate", visitors);

/* Render the named template */
  $( "#latest_visitors" ).empty();
  $.tmpl("visitorsTemplate", users).appendTo( "#latest_visitors" );
}
});
}

function load_photos(menu_id, page, per_page){
    page = typeof(page) != 'undefined' ? page : 1;
    per_page = typeof(per_page) != 'undefined' ? per_page : 6;
    $.ajax({
        url:'/shop_space/latest_photos?menu_id='+menu_id+'&page='+page+'&per_page='+per_page,
        data:'',
        type:'get',
        dataType:'json',
        success:function(photos) {
var photos_div = '<div class="photo"><div class="photo_img"><a href="${photo.url}" title="${photo.name}"><img src="${photo.photo_path}" alt="${photo.name}"></a></div><span class="photo_name"><a href="${photo.url}" title="${photo.name}">${photo.name}</a></span></div>';

/* Compile markup string as a named template */
$.template("photosTemplate", photos_div);

/* Render the named template */
  $( "#latest_photos" ).empty();
  $.tmpl("photosTemplate", photos).appendTo( "#latest_photos" );
}
});
}

function load_tuangous(shop_id, page, per_page, title_length){
    page = typeof(page) != 'undefined' ? page : 1;
    per_page = typeof(per_page) != 'undefined' ? per_page : 3;
    title_length = typeof(title_length) != 'undefined' ? title_length : 30;
    $.ajax({
        url:'/shop_space/latest_tuangous?shop_id='+shop_id+'&page='+page+'&per_page='+per_page,
        data:'',
        type:'get',
        dataType:'json',
        success:function(tuangous) {
var tuangous_div = '<div class="dis"><div class="dis_name"><a href="/tuangou_list/show/${tuangou.id}" target="_blank">${tuangou.name.substring(0, ' + title_length + ')}</a></div><a href="/tuangou_list/show/${tuangou.id}" target="_blank"><img alt="${tuangou.name}" class="dis_photo" src="${tuangou.goods_image}"></a><div class="dis_bottom"><span class="l"><b class="red">${tuangou.buy}</b>人已购买</span><a href="/tuangou_list/show/${tuangou.id}" target="_blank"><img alt="查看" class="r" src="/img/shop_space/view.jpg" title="查看"></a></div></div>';

/* Compile markup string as a named template */
$.template("tuangousTemplate", tuangous_div);

/* Render the named template */
  $( "#latest_tuangous" ).empty();
  $.tmpl("tuangousTemplate", tuangous).appendTo( "#latest_tuangous" );
}
});
}

function load_articles(menu_id, page, per_page, title_length, showdate){
    page = typeof(page) != 'undefined' ? page : 1;
    per_page = typeof(per_page) != 'undefined' ? per_page : 3;
    title_length = typeof(title_length) != 'undefined' ? title_length : 20;
    $.ajax({
        url:'/shop_space/latest_articles?menu_id='+menu_id+'&page='+page+'&per_page='+per_page,
        data:'',
        type:'get',
        dataType:'json',
        success:function(articles) {
var articles_div = '<li>';
if (showdate) {
articles_div = articles_div + '<span class="r">${article.created_at}</span>';
}
articles_div = articles_div + '<a href="/shop_space/article/${article.id}">${article.title.substring(0, ' + title_length + ')}</a></li>';

/* Compile markup string as a named template */
$.template("articlesTemplate", articles_div);

/* Render the named template */
  $( "#latest_articles" ).empty();
  $.tmpl("articlesTemplate", articles).appendTo( "#latest_articles" );
}
});
}

function load_links() {
    var links = '[{"title": "友情链接--企博", "url": "http://www.bokee.net"}, {"title": "友情链接--一渡", "url": "http://www.1dooo.com"}]';
    $("#links").setTemplate('<div class="box_content"><div class="news_content"><ul>{#foreach $T as record}<li><a href="{$T.record.url}">{$T.record.title}</a></li>{#/for}</ul></div></div>');
    $("#links").processTemplate($.parseJSON(links));
}

$(document).ready(function(){
        $("#DH a img").css("display","none");
        $("#DH a img").eq(0).css("display","block");
        (function(){
                var curr = 0,j=0,num;
            num=$("#DH img").length;	

                $("#DHNum .def").each(function(i){
                        $(this).click(function(){
                                curr = i;
                                $("#DH a img").css("z-index","0");
                                if(i==1){$("#DH a img").css("display","none");$("#DH a img").eq(0).css("display","block");}
                                if(i!=0||i==(num-1))$("#DH a img").eq(i-1).css("z-index","1");
                                $("#DH").find("img").eq(i).hide();
                                $("#DH").find("img").eq(i).fadeIn(2000).css("z-index","1");
                                $(this).siblings(".def").removeClass("selected").end().addClass("selected");
                                return false;
                        });
                });

                var pg = function(flag){
                        if (flag) {
                                if (curr == 0) {
                                        todo = num-1;
                                } else {
                                        todo = (curr - 1) % num;
                                }

                        } else {
                                todo = (curr + 1) % num;

                        }
                        $("#DHNum .def").eq(todo).click();
                };

                //单击左箭头
                $("#Prev").click(function(){
                        clearInterval(timer);
                        pg(true);
                        timer = setInterval(function(){
                        todo = (curr+1) % num;
                        $("#DHNum .def").eq(todo).click();
                },6000);
                        return false;
                });

                //单击右箭头
                $("#Next").click(function(){
                        clearInterval(timer);
                        pg(false);
                        timer = setInterval(function(){
                        todo = (curr+1) % num;
                        $("#DHNum .def").eq(todo).click();
                },6000);
                        return false;
                });

                //Զ
                var timer = setInterval(function(){
                        todo = (curr+1) % num;
                        $("#DHNum .def").eq(todo).click();
                },6000);


                $("#DHNum a").mouseover(function(){
                                clearInterval(timer);
                        }
                );
                $("#DHNum a").mouseout(
                        function(){
                                timer = setInterval(function(){
                                        todo = (curr+1) % num;
                                        $("#DHNum .def").eq(todo).click();
                                },6000);			
                        }
                );
        })();


});
