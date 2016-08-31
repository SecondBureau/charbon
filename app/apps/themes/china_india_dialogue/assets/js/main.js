//= require ./camThemeFieldCallback

//= require ./vendor/jquery-2.2.0
//= require ./vendor/jquery.flexslider
//= require ./vendor/bootstrap.min
    
//= require ./vendor/ionic.bundle.min
//= require ./vendor/toArrayFilter
//= require ./vendor/ng-infinite-scroll
//= require ./vendor/angular-flexslider
//= require ./vendor/angular-checklist-model

//= require ./vendor/angulartics.min
//= require ./vendor/angulartics-woopra.min

    
//= require ./vendor/spin
//= require ./vendor/angular-spinner
    
//= require ./vendor/ui-bootstrap-tpls
//= require ./vendor/holder

//= require ./vendor/qrcode
//= require ./vendor/angular-qr.js

//= require ./vendor/camaleon_cms

//= require ./vendor/slick

//= require ./vendor/angular-socialshare
     
//= require ./app
//= require ./config

//= require ./controllers
//= require ./services
//= require ./directives



$(document).on("click", '.popup', function( event ) {
  event.preventDefault();
  var popup = $('#popup').find(".modal-body")
  if (popup.html() == "")
    popup.prepend("<img class='img-responsive' src='" + $(this).data('popup-content') + "'>");
  $('#popup').modal('show');
  

});