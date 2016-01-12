do ->
  PostsCtrl = ($scope, $stateParams, Categories, Posts) ->

    load = (page) ->
      limit = 12
      offset = limit * (page - 1)
      isComplete = $scope.pagination and $scope.pagination.current_page >= $scope.pagination.total_pages
      if !isComplete
        $scope.loading = true
        Categories.all().then ->
          $scope.category = Categories.get($stateParams.categorySlug)
          cid = ''
          if angular.isObject($scope.category)
            search = '"category":' + $scope.category.id
          Posts.search(search, offset, limit).then (response) ->
            $scope.pagination = angular.fromJson(response.headers('x-pagination'))
            $scope.posts = $scope.posts or []
            Array::push.apply $scope.posts, response.data
            $scope.loading = false
            return
          return
      return

    $scope.$on 'endlessScroll:next', ->
      page = if $scope.pagination then $scope.pagination.current_page + 1 else 1
      load page
      return
    load if $stateParams.page then parseInt($stateParams.page, 10) else 1
    return

  'use strict'
  angular.module('bahnhof').controller 'PostsCtrl', PostsCtrl
  return
