

(function() {
  function bhScrollTop($window) {
    return function($scope, element, attrs) {
      var pageYOffset;
      pageYOffset = parseInt(attrs.bhScrollTop);
      angular.element($window).bind('scroll', function() {
        if (this.pageYOffset >= pageYOffset) {
          $scope.minifyNavbar = true;
        } else {
          $scope.minifyNavbar = false;
        }
        $scope.$apply();
      });
    };
  };
  'use strict';
  angular.module('bahnhof').directive('bhScrollTop', bhScrollTop);
})();