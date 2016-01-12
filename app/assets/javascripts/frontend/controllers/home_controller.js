angular
  .module('bahnhof')
  .controller('HomeCtrl', HomeCtrl);

function HomeCtrl($scope, $filter, Categories, Posts) {
  
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
        if (angular.isArray(posts))
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
  
}