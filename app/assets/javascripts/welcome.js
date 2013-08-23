if(document.readyState === "complete") {
  var container = document.querySelector('#container');
  var msnry = new Masonry( container, {
  // options
    columnWidth: 300,
    itemSelector: '.item',
    gutter: 10
  });
}
	
  // $("img.lazy").lazyload({
  //   effect : "fadeIn"
  // });

  // (function(d, s, id) {
  //   var js, fjs = d.getElementsByTagName(s)[0];
  //   if (d.getElementById(id)) return;
  //   js = d.createElement(s); js.id = id;
  //   js.src = "//connect.facebook.net/en_GB/all.js#xfbml=1";
  //   fjs.parentNode.insertBefore(js, fjs);
  // }(document, 'script', 'facebook-jssdk'));

