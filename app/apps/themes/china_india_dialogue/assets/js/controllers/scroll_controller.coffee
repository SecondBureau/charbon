do ->
  
  'use strict'

  ScrollController = ($scope, $location, $anchorScroll) ->
    $scope.gotoTop = ->  
      $anchorScroll.yOffset = 50
      $scope.scrollToAnchor('top')
      return

    $scope.scrollToAnchor = (anchor) ->
      if $location.hash() != anchor
        $location.hash(anchor)
      else
        $anchorScroll()
      return

    return

  ScrollController.$inject = [
    '$scope'
    '$location'
    '$anchorScroll'
  ]

  angular.module('bahnhof').controller 'ScrollController', ScrollController
