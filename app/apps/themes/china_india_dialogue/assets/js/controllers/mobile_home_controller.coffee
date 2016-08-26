do ->
  
  'use strict'
  
  MobileHomeCtrl = ($rootScope, $scope, $stateParams, $location, Categories, Posts) ->
    
  
    # jshint validthis: true
    endless_disabled = true
    limit = 15
  
    load = (page) ->
      offset = limit * (page - 1)
      $scope.isComplete = $scope.pagination and $scope.pagination.current_page >= $scope.pagination.total_pages
    
      if !$scope.isComplete
        $scope.loading = true
        search = {}
        Posts.search(angular.toJson(search), offset, limit).then (response) ->
          $scope.pagination = angular.fromJson(response.headers('x-pagination'))
          $scope.posts = $scope.posts or []
          Array::push.apply $scope.posts, response.data
          $scope.loading = false
          endless_disabled = false
          return
        return
      
    $scope.scrollToNextPage = () ->
      page = if $scope.pagination then $scope.pagination.current_page + 1 else 1
      if !endless_disabled
        load page
      return
    
    $scope.scrollIsDisabled = () ->
      $scope.loading || $scope.isComplete
  
    load if $stateParams.page then parseInt($stateParams.page, 10) else 1
    return
    
  MobileHomeCtrl.$inject = ['$rootScope', '$scope', '$stateParams', '$location', 'Categories', 'Posts']
  
  angular.module('bahnhof').controller 'MobileHomeCtrl', MobileHomeCtrl
  
