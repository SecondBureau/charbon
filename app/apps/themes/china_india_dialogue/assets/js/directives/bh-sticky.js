(function() {
  function bhSticky($window) {
    return function($scope, element, attrs) {
      var pageYOffset = parseInt(attrs.bhSticky);
      angular.element($window).bind('scroll', function() {
        var parent = element.parent();
        var parent_top = parent[0].getBoundingClientRect().top;
        var parent_bottom = parent[0].getBoundingClientRect().bottom;
        var parent_width = parent[0].getBoundingClientRect().width;
        var element_bottom = element[0].getBoundingClientRect().bottom;
        var element_height = element[0].getBoundingClientRect().height;
        
        element_fixed_width = parent_width - parseInt(parent.css('padding-left')) - parseInt(parent.css('padding-right'))
      
        if (parent_top < pageYOffset) {
          if ( parent_bottom <= element_bottom && parent_bottom < pageYOffset + element_height) {
            element.css('position', 'absolute').css('top', 'auto').css('bottom', '0px').css('width', element_fixed_width);
          } else {
            element.css('position', 'fixed').css('top', pageYOffset + 'px').css('bottom', 'auto').css('width', element_fixed_width);
          }
        } else {
          element.css('position', 'relative').css('top', '0px').css('bottom', 'auto').css('width', '100%');
        }
        $scope.$apply();
      });
    };
  };
  'use strict';
  angular.module('bahnhof').directive('bhSticky', bhSticky);
})();