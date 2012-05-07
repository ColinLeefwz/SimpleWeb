function user_like(shop_id, url) {
    jQuery.getJSON(
        '/user_like/shop/' + shop_id,
        function(data) {
 if (url != null && url != '') {
window.location.href=url;
} else {
            if (data['result']['like'] == '1') {
                $('#msgDiv').html('关注成功');
            } else if (data['result']['like'] == '2') {
                $('#msgDiv').html('您已关注该商家');
            } else {
                $('#msgDiv').html('关注该商家未成功,再关注一次!');
}            
}
        }
    );
   
}
