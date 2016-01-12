angular
  .module('bahnhof')
  .controller('PostsCtrl', PostsCtrl);


function PostsCtrl($scope, $stateParams, Categories, Posts) {
  
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
}