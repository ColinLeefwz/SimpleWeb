`(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-39482115-1', 'prodygia.com');
ga('send', 'pageview');`

$(document).on 'page:change', ->
  if window._gaq?
    _gaq.push ['_trackPageview']  
  else if window.pageTracker?
    pageTracker._trackPageview()
