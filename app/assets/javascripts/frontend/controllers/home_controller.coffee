do ->
  
  HomeCtrl = ($scope, $filter, Categories, Posts) ->
    
    # jshint validthis: true
    vm = this;

    searchString = (categories) ->
      c = 
        spotlight: 5
        business: 2
        policy: 1
        industry: 3
        internet: 3
        society: 3
        column: 4
        oneroadonebelt: 1
        environment: 1
        culture: 1
        travel: 6
      q = []
      #if (angular.isArray($scope.categories)) {
      angular.forEach c, (num, slug) ->
        category = Categories.get(slug)
        q.push category.id + ',' + num
        return
      q.join '|'
      #}

    myPosts = (searchString) ->
      if angular.isArray($scope.homePosts)
        return $scope.homePosts
      if angular.isUndefined($scope.homePosts)
        $scope.homePosts = Posts.homePosts(searchString)
      if $scope.homePosts and angular.isFunction($scope.homePosts.then)
        return $scope.homePosts.then((response) ->
          $scope.homePosts = response.data
          response.data
        )
      return

    $scope.getP = (categorySlug) ->
      if $scope.categories.length > 0
        posts = myPosts(searchString($scope.categories))
        category = $filter('filter')($scope.categories, { slug: categorySlug }, true)[0]
        if $scope.homePosts and angular.isFunction($scope.homePosts.then)
          $scope.homePosts.then (response) ->
            $filter('filter') response.data, { category_id: category.id }, true
        else
          if angular.isArray(posts)
            return $filter('filter')(posts, { category_id: category.id }, true)
      return

    $scope.getC = (categorySlug) ->
      if $scope.categories.length > 0
        return $filter('filter')($scope.categories, { slug: categorySlug }, true)[0]
      return

    $scope.get_category = (categorySlug) ->
      c = {}
      if angular.isArray($scope.categories)
        c = $filter('filter')($scope.categories, { slug: categorySlug }, true)[0]
      c

    return

  'use strict'
  angular.module('bahnhof').controller 'HomeCtrl', HomeCtrl
  return

