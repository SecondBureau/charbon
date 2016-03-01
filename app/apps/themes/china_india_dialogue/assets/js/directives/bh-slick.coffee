do ->

  'use strict'
  
  bhSlick = ($document, $timeout) ->
    ($scope, element, attrs) ->
      
      slick = ->
        element.slick
          infinite: false
          responsive: [
            {
              breakpoint: 1200
              settings:
                slidesToShow: 3
                infinite: true
            }
            {
              breakpoint: 992
              settings:
                slidesToShow: 2
                dots: true
            }
            {
              breakpoint: 768
              settings: 'unslick'
            }
          ]

      
      unregister = $scope.$watch "posts", (newValue, oldValue) -> 
        if (newValue && newValue.length > 0)
          unregister()
          $timeout slick, 0;
      return
      
  
  bhSlick.$inject = ['$document', '$timeout']
  angular.module('bahnhof').directive 'bhSlick', bhSlick
  return

