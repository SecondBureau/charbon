do ->
  'use strict'
  
  PostsSearchCtrl = ($scope, $stateParams, Categories, Posts) ->
    
    searching = false
    endless_disabled = true
    
    load = (page) ->
      console.log 'loading... page ' + page
      limit = 10
      offset = limit * (page - 1)
      isComplete = $scope.pagination and $scope.pagination.current_page >= $scope.pagination.total_pages
      if !isComplete
        $scope.loading = true
        Categories.all().then ->
          $scope.category = Categories.get($stateParams.categorySlug)
          console.log 'searching ' + searching
          console.log $scope.checkedcategories
          if searching
            $scope.category = $scope.checkedcategories[0]
          else
            $scope.checkedcategories = [$scope.category]
            

          if angular.isObject($scope.category)
            search = '"category":' + $scope.category.id
          if $scope.keywords
            search = search + ',"k":"' +  $scope.keywords + '"'
            
          console.log search
          
          Posts.search(search, offset, limit).then (response) ->
            $scope.pagination = angular.fromJson(response.headers('x-pagination'))
            $scope.posts = $scope.posts or []
            Array::push.apply $scope.posts, response.data
            $scope.loading = false
            endless_disabled = false
            return
          return
      return
      
    $scope.search = ->
      
      console.log $scope.checkedcategories
      searching = true
      endless_disabled = true
      $scope.posts = []
      $scope.pagination = null 
      #load 1

    # $scope.$on 'endlessScroll:next', ->
    #   page = if $scope.pagination then $scope.pagination.current_page + 1 else 1
    #   if !endless_disabled
    #     load page
    #   return
    
    load if $stateParams.page then parseInt($stateParams.page, 10) else 1
    return
    
  PostsSearchCtrl.$inject = ['$scope', '$stateParams', 'Categories', 'Posts']
  angular.module('bahnhof').controller 'PostsSearchCtrl', PostsSearchCtrl