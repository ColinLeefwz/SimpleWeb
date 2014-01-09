var social_popup = function(){
  $('a[data-popup]').on('click', function(e){
     window.open( $(this).attr('href'), "Popup", "height=600, width=600");
     e.preventDefault();
  });

  // $.getJSON("http://www.linkedin.com/countserv/count/share?url=www.google.com&callback=?", function(li_count){
  //   alert("linkedIn:" + li_count.count);
  // });

  // $.getJSON("http://graph.facebook.com/?id=http://www.google.com&callback=?", function(fb_count){
  //   alert("facebook:" + fb_count.count);
  // });

  // $.getJSON("http://urls.api.twitter.com/1/urls/count.json?url=www.google.com&callback=?", function(tw_count){
  //   alert("twitter:" + tw_count.count);
  // });

}

$(document).ready(social_popup);
$(document).on('page:load', social_popup);

