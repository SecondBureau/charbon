do ->
  
  BahnhofCtrl = ($scope, $location, $stateParams, Categories) ->
    $scope.categories = []
    Categories.all().then (categories) ->
      $scope.categories = categories
      return

    $scope.isActive = (route) ->
      route == $location.path()
    
    return

  'use strict'
  angular.module('bahnhof').controller 'BahnhofCtrl', BahnhofCtrl
  return