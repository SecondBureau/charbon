do ->
  'use strict'
  
  ErrorCtrl = ($scope, $location, $anchorScroll) ->
    
    anchor = 'top'
    
    $anchorScroll.yOffset = 201
    #if $location.hash() != anchor
    $location.hash(anchor)
    #else
    $anchorScroll()
    
  ErrorCtrl.$inject = ['$scope', '$location', '$anchorScroll']
  angular.module('bahnhof').controller 'ErrorCtrl', ErrorCtrl