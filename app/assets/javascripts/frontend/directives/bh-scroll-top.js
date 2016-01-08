angular.module('bahnhof.directives')

.directive("bhScrollTop", function ($window) {
  
  return function($scope, element, attrs) {
    
    var pageYOffset;
    pageYOffset = parseInt(attrs.bhScrollTop);
    angular.element($window).bind("scroll", function() {
      //console.log(this.pageYOffset + " " + $scope.minifyNavbar);
      if (this.pageYOffset >= pageYOffset) {
        $scope.minifyNavbar = true;
      } else {
        $scope.minifyNavbar = false;
      }
      $scope.$apply();
    });
  };
})