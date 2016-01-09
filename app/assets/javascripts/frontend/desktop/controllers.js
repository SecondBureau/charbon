angular.module('bahnhof.controllers', [])



.controller('bahnhofCtrl', function($scope, $location, $stateParams, Categories) {
  $scope.categories = []
  Categories.all().then(function(categories){
    $scope.categories = categories;
  });
  $scope.isActive = function(route) {
    return route === $location.path();
  }
})

.controller('HomeCtrl', function($scope, $filter, Categories, Posts) {
  
  $scope.loading=true;
  
  searchString = function(categories) {
    var c = {spotlight: 5, business: 2, policy: 1, industry: 3, internet: 3, society: 3, column: 4, oneroadonebelt: 1, environment: 1, culture: 1, travel: 6};
    var q = [];
    //if (angular.isArray($scope.categories)) {
      angular.forEach(c, function(num, slug) {
        category = Categories.get(slug);
        q.push(category.id + ',' + num);
      });
      return q.join('|');
    //}
  }
  
  myPosts = function(searchString) {
    if (angular.isArray($scope.homePosts))
      return $scope.homePosts;
    if (angular.isUndefined($scope.homePosts))
      $scope.homePosts = Posts.homePosts(searchString);
    if ($scope.homePosts && angular.isFunction($scope.homePosts.then)) {
      return $scope.homePosts.then(function(response) {
        $scope.homePosts = response.data;
        return response.data;
      })
    }
  }

  $scope.getP = function(categorySlug){
    if ($scope.categories.length > 0) {
      posts = myPosts(searchString($scope.categories));
      var category = $filter('filter')($scope.categories, {slug: categorySlug}, true)[0];
      if ($scope.homePosts && angular.isFunction($scope.homePosts.then)) {
        $scope.homePosts.then(function(response) {
          return $filter('filter')(response.data, {category_id: category.id}, true);
        })
      } else {
        return $filter('filter')(posts, {category_id: category.id}, true);
      } 
    }
    } 
    
  
  $scope.getC = function(categorySlug){
    if ($scope.categories.length > 0) {
      return $filter('filter')($scope.categories, {slug: categorySlug}, true)[0];
    }
  }
  
  
  $scope.get_category = function (categorySlug) {
    var c = {} 
    if (angular.isArray($scope.categories)) {
      c = $filter('filter')($scope.categories, {slug: categorySlug}, true)[0]
    }
    return c;
  }
  
})



// .controller('HomeCategoryCtrl', function($scope, $document, Categories, Posts) {
//   $scope.loading = true;
//   $scope.get = function(categorySlug, limit) {
//   $scope.categories.then(function(){
//     $scope.category = Categories.get(categorySlug);
//     Posts.getbyCategory($scope.category.id, 0, limit).then(function(response){
//       $scope.posts = response.data;
//       if (categorySlug == 'spotlight') {
//         $document.ready(function() {
//           $('.flexslider').flexslider({
//               animation: "slide"
//             });
//         });
//       }
//       $scope.loading = false;
//     }), function (response) {
//       console.log ('HomeCategoryCtrl ERROR');
//       console.log (response);
//   };
//   });
//  };
// })



.controller('PostsCtrl', function($scope, $stateParams, Categories, Posts) {
  
  function load(page) {
    
    var limit = 12;
    var offset = limit * (page - 1);
    var isComplete = $scope.pagination && $scope.pagination.current_page >= $scope.pagination.total_pages;
    
    if (!isComplete) {
      
      $scope.loading = true;
      
      Categories.all().then(function(){
        $scope.category = Categories.get($stateParams.categorySlug);
        var cid = "";
        if (angular.isObject($scope.category))
          search = '"category":' + $scope.category.id;
        Posts.search(search, offset, limit).then(function(response){
          $scope.pagination = angular.fromJson(response.headers('x-pagination'));
          $scope.posts = $scope.posts || [];
          Array.prototype.push.apply($scope.posts, response.data);
          $scope.loading = false;
        });
      });
    };
  };
  
  $scope.$on('endlessScroll:next', function() {
    var page = $scope.pagination ? $scope.pagination.current_page + 1 : 1;
    load(page);
  });
  
  load($stateParams.page ? parseInt($stateParams.page, 10) : 1);
})



.controller('DropdownCtrl', function ($scope, $log) {

  $scope.status = {
    isopen: false
  };

  $scope.toggleDropdown = function($event) {
    $event.preventDefault();
    $event.stopPropagation();
    $scope.status.isopen = !$scope.status.isopen;
  };
});


  
  