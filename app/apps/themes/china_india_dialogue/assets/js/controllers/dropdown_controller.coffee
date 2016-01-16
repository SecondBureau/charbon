do ->

  'use strict'
  
  DropdownCtrl = ($scope, $log) ->
    $scope.status = isopen: false

    $scope.toggleDropdown = ($event) ->
      $event.preventDefault()
      $event.stopPropagation()
      $scope.status.isopen = !$scope.status.isopen
      return

    return

  DropdownCtrl.$inject = ['$scope', '$log']
  
  angular.module('bahnhof').controller 'DropdownCtrl', DropdownCtrl
