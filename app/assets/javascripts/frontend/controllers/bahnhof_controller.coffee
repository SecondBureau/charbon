do ->
  
  'use strict'

  BahnhofCtrl = ($scope, $location, $stateParams, Categories) ->
    $scope.categories = []
    Categories.all().then (categories) ->
      $scope.categories = categories
      return

    $scope.isActive = (route) ->
      route == $location.path()

    return

  BahnhofCtrl.$inject = [
    '$scope'
    '$location'
    '$stateParams'
    'Categories'
  ]

  angular.module('bahnhof').controller 'BahnhofCtrl', BahnhofCtrl

