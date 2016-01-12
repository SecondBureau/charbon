do ->

  bhScrollTop = ($window) ->
    ($scope, element, attrs) ->
      pageYOffset = undefined
      pageYOffset = parseInt(attrs.bhScrollTop)
      angular.element($window).bind 'scroll', ->
        #console.log(this.pageYOffset + " " + $scope.minifyNavbar);
        if @pageYOffset >= pageYOffset
          $scope.minifyNavbar = true
        else
          $scope.minifyNavbar = false
        $scope.$apply()
        return
      return

  'use strict'
  angular.module('bahnhof').directive 'bhScrollTop', bhScrollTop
  return