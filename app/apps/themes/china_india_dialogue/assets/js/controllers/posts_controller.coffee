do ->
  'use strict'
  
  PostsCtrl = ($rootScope, $scope, $stateParams, $location, Categories, Posts) ->

    endless_disabled = true
    limit = 15
    search_path = '/search'
    $scope.sort_order = "desc"
    $scope.myDate = new Date();

    $scope.minDate = new Date(
      $scope.myDate.getFullYear(),
      $scope.myDate.getMonth() - 2,
      $scope.myDate.getDate());

    $scope.maxDate = new Date(
      $scope.myDate.getFullYear(),
      $scope.myDate.getMonth() + 2,
      $scope.myDate.getDate());
    
    categoryIds = (categories) -> 
      ids = []
      for category in categories
        ids.push(category.id)
      ids
    
    init_scope_form = (options = {}) ->
      $scope.keywords   = null
      $scope.sort_order = "desc"
      $scope.min_date   = null
      $scope.max_date   = null
      $scope.checkedcategories = options.checkedcategories
    
    load = (page) ->
      offset = limit * (page - 1)
      $scope.isComplete = $scope.pagination and $scope.pagination.current_page >= $scope.pagination.total_pages
      
      if !$scope.isComplete
        $scope.loading = true
        Categories.all().then ->
         
          $scope.checkedcategories = []
          
          if $rootScope.checkedcategories
            $scope.checkedcategories = $rootScope.checkedcategories
            
          if $rootScope.keywords
            $scope.keywords = $rootScope.keywords
            
          if $rootScope.sort_order
            $scope.sort_order = $rootScope.sort_order
            
          if $rootScope.min_date
            $scope.min_date = $rootScope.min_date
            
          if $rootScope.max_date
            $scope.max_date = $rootScope.max_date
            
          if $stateParams.slug
            init_scope_form({checkedcategories: [Categories.get($stateParams.slug)]})
          
          search = {}
          if angular.isArray($scope.checkedcategories)
            search.categories = categoryIds($scope.checkedcategories)
          if $scope.keywords
            search.k = $scope.keywords
          if $scope.min_date
            search.min = $scope.min_date
          if $scope.max_date
            search.max = $scope.max_date
          
          search.order = 'published_at ' + $scope.sort_order
            
          #console.log angular.toJson(search) + " offset " + offset
                      
          Posts.search(angular.toJson(search), offset, limit).then (response) ->
            $scope.pagination = angular.fromJson(response.headers('x-pagination'))
            $scope.posts = $scope.posts or []
            Array::push.apply $scope.posts, response.data
            $scope.loading = false
            endless_disabled = false
            return
          return
      return
      
    $scope.search = ->
      endless_disabled = true
      $rootScope.checkedcategories  = $scope.checkedcategories
      if $scope.header_keywords 
         $scope.keywords            = $scope.header_keywords
         $scope.header_keywords     = null
      $rootScope.keywords           = $scope.keywords
      $rootScope.sort_order         = $scope.sort_order
      $rootScope.min_date           = $scope.min_date
      $rootScope.max_date           = $scope.max_date

      if $location.path() == search_path
        $scope.posts = []
        $scope.pagination = null
        load 1
      $location.path search_path

   
      
    $scope.scrollToNextPage = () ->
      page = if $scope.pagination then $scope.pagination.current_page + 1 else 1
      if !endless_disabled
        load page
      return
      
    $scope.scrollIsDisabled = () ->
      $scope.loading || $scope.isComplete
    
    load if $stateParams.page then parseInt($stateParams.page, 10) else 1
    return

  
  PostsCtrl.$inject = ['$rootScope', '$scope', '$stateParams', '$location', 'Categories', 'Posts']
  angular.module('bahnhof').controller 'PostsCtrl', PostsCtrl
