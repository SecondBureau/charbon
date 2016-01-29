(function() {
  function bhSticky($window) {
    return function($scope, element, attrs) {
      var pageYOffset = parseInt(attrs.bhSticky);
      angular.element($window).bind('scroll', function() {
        var parent = element.parent();
        var parent_top = parent[0].getBoundingClientRect().top;
        var parent_bottom = parent[0].getBoundingClientRect().bottom;
        var element_bottom = element[0].getBoundingClientRect().bottom;
        var element_height = element[0].getBoundingClientRect().height;
      
        if (parent_top < pageYOffset) {
          if ( parent_bottom <= element_bottom && parent_bottom < pageYOffset + element_height) {
            element.css('position', 'absolute').css('top', 'auto').css('bottom', '0px');
          } else {
            element.css('position', 'fixed').css('top', pageYOffset + 'px').css('bottom', 'auto');
          }
        } else {
          element.css('position', 'relative').css('top', '0px').css('bottom', 'auto');
        }
        $scope.$apply();
      });
    };
  };
  'use strict';
  angular.module('bahnhof').directive('bhSticky', bhSticky);
})();