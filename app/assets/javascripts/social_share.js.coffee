# var social_popup = function(){
#   $('a[data-popup]').on('click', function(e){
#      window.open( $(this).attr('href'), "Popup", "height=600, width=600");
#      e.preventDefault();
#   });

social_popup = ->
  $('a[data-popup]').on('click', (e)->
     window.open( $(this).attr('href'), "Popup", "height=600, width=600")
     e.preventDefault()
  )

count_shares = ->
  $.getJSON("http://www.linkedin.com/countserv/count/share?url=www.google.com&callback=?", (li_count) ->
    if $("#li-shares").length
      $("#li-shares").html(li_count.count)
  )

  $.getJSON("http://graph.facebook.com/?id=http://www.google.com&callback=?", (fb_count) ->
    # if $("#fb-shares").length
    #   $("#fb-shares").html(fb_count.count)
    alert fb_count.count
  )

  $.getJSON("http://urls.api.twitter.com/1/urls/count.json?url=www.google.com&callback=?", (tw_count) ->
    if $("#tw-shares").length
      $("#tw-shares").html(tw_count.count)
  )

  # $.getJSON("https://plusone.google.com/_/+1/fastbutton?url=http://stackoverflow.com&callback=?", (gp_count) ->
  # )

#   // function get_plusones($url) {
#   //   $curl = curl_init();
#   //   curl_setopt($curl, CURLOPT_URL, "https://clients6.google.com/rpc");
#   //   curl_setopt($curl, CURLOPT_POST, 1);
#   //   curl_setopt($curl, CURLOPT_POSTFIELDS, '[{"method":"pos.plusones.get","id":"p","params":{"nolog":true,"id":"' . $url . '","source":"widget","userId":"@viewer","groupId":"@self"},"jsonrpc":"2.0","key":"p","apiVersion":"v1"}]');
#   //   curl_setopt($curl, CURLOPT_RETURNTRANSFER, true);
#   //   curl_setopt($curl, CURLOPT_HTTPHEADER, array('Content-type: application/json'));
#   //   $curl_results = curl_exec ($curl);
#   //   curl_close ($curl);
#   //   $json = json_decode($curl_results, true);
#   //   return intval( $json[0]['result']['metadata']['globalCounts']['count'] );
#   // }
#   
# }

$(document).ready(social_popup)
$(document).on('page:load', social_popup)

$(document).on('ajax:success', count_shares)

