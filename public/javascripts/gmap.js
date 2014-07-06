var map;
function initialize(lat, lng, zoom, move_marker) {
  var myOptions = {
    zoom: zoom || 15,
    center: new google.maps.LatLng(lat, lng),
    mapTypeId: google.maps.MapTypeId.ROADMAP
  };
  map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
};
function initialize_marker(lat, lng, draggable, flat, move_marker, icon) {
  var marker = new google.maps.Marker({
    map: map,
    draggable: draggable || true,
    flat: flat || true,
    animation: google.maps.Animation.DROP,
    position: new google.maps.LatLng(lat, lng)
  });
  if (move_marker == true) {
    google.maps.event.addListener(marker, 'drag', geo_value);
  }
  function geo_value() {
    if (document.getElementById('shop_geo_lat') != null) {
      document.getElementById('shop_geo_lat').value=marker.getPosition().lat();
    } else if (document.getElementById('subshop_geo_lat') != null) {
      document.getElementById('subshop_geo_lat').value=marker.getPosition().lat();
    }
    if (document.getElementById('shop_geo_long') != null) {
      document.getElementById('shop_geo_long').value=marker.getPosition().lng();
    } else if (document.getElementById('subshop_geo_long') != null) {
      document.getElementById('subshop_geo_long').value=marker.getPosition().lng();
    }
  }
  if ((typeof icon === 'string') || (typeof icon === google.maps.MarkerImage)) {
    marker.setIcon(icon);
  }
};

function mouse_sign() {
  if (document.getElementById('sign_layer') != null) {
    google.maps.event.addListener(map, 'mouseover', sign_layer);
  }
};

function sign_layer() {
  var sign_layer = document.getElementById('sign_layer');
  if (sign_layer != null) {
    if (sign_layer.style.display == '') {
      sign_layer.style.display = 'none';
    } else {
      sign_layer.style.display = 'block';
    }
  }
};
