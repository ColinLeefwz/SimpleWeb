// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery.min
//= require jquery_ujs
//= require jquery.remotipart
//= require s3_direct_upload
//= require jquery.throttledresize
//= require bootstrap
//= require imagesloaded.pkgd.min
//= require scrolltopcontrol
//= require jquery.isotope.min
//= require ckeditor/init
//= require paypal-button.min
//= require bootstrap-datetimepicker.min
//= require_tree .


$(document).ready(function() {
  if (sign_in_confirm() == true) {
    return false;
  }
  else {
    openTipbox();
  }
});

function openTipbox() {
  setTimeout( function() {
    $("#tip-trigger").find("a").trigger("click")
  }, 60000);
}
