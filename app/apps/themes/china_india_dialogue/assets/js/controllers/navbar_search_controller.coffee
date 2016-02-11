

do ->
  'use strict'
  
  NavBarSearchCtrl = ($rootScope, $scope, $stateParams, $location, Categories, Posts) ->
    
    search_path = '/search'
    vm = this
    
    vm.isNotSearchPage = () ->
      search_path != $location.path()
      
    vm.search = ->
      $rootScope.keywords           = vm.keywords
      vm.keywords = ""
      $location.path search_path
    
    return
    
  
  NavBarSearchCtrl.$inject = ['$rootScope', '$scope', '$stateParams', '$location', 'Categories', 'Posts']
  angular.module('bahnhof').controller 'NavBarSearchCtrl', NavBarSearchCtrl