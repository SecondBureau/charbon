do ->
  'use strict'
  
  PostCtrl = ($scope, $location, $anchorScroll) ->
    
    console.log 'postCr'
    console.log $location.hash()
    
    anchor = 'top'
    
    $anchorScroll.yOffset = 201
    #if $location.hash() != anchor
    $location.hash(anchor)
    #else
    $anchorScroll()
    
  PostCtrl.$inject = ['$scope', '$location', '$anchorScroll']
  angular.module('bahnhof').controller 'PostCtrl', PostCtrl