$(document).ready(function(){
  $('.twitter_share').sharrre({
    share: {
      twitter: false
    },
    text: "#prodygia",
    enableHover: false,
    enableTracking: false,
    click: function(api, options){
      api.simulateClick();
      api.openPopup('twitter');
    }
  });

  $('.facebook_share').sharrre({
    share: {
        facebook: false
      },
    text: "prodygia",
    enableHover: false,
    enableTracking: false,
    click: function(api, options){
        api.simulateClick();
        api.openPopup('facebook');
      }
  });

  $('.google_plus_share').sharrre({
    share: {
        googlePlus: false
      },
    text: "prodygia",
    enableHover: false,
    enableTracking: false,
    click: function(api, options){
        api.simulateClick();
        api.openPopup('googlePlus');
      }
  });


  $('.linkedin_share').sharrre({
    share: {
        linkedin: false
      },
    text: "prodygia",
    enableHover: false,
    enableTracking: false,
    click: function(api, options){
        api.simulateClick();
        api.openPopup('linkedin');
      }
  });


  // $('#facebook_like').sharrre({
  //   share: {
  //       facebook_like: false
  //     },
  //   text: "prodygia",
  //   enableHover: false,
  //   enableTracking: false,
  //   buttons: {
  //     facebook: {
  //       action: 'like'
  //     }
  //   },
  //   click: function(api, options){
  //       api.simulateClick();
  //       api.openPopup('facebook');
  //     }
  // });
});
