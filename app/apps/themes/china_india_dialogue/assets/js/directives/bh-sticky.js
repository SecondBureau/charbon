(function() {
  function bhSticky($window) {
    
    return function($scope, element, attrs) {
      var pageYOffset = parseInt(attrs.bhSticky);
      var width       = parseInt(attrs.width);
      
      function css_width(e, w) {
        if (isNaN(width))
          e.css('width', w)
      }
      angular.element($window).bind('scroll', function() {
        var parent = element.parent();
        if (angular.isUndefined(parent.data('orig-height'))) {
          var parent_height = parent[0].getBoundingClientRect().height;
          parent.data('orig-height', parent_height)
        }

        var element_height = element[0].getBoundingClientRect().height;        
        var parent_top = parent[0].getBoundingClientRect().top;
        var parent_bottom = parent[0].getBoundingClientRect().bottom;
        var parent_width = parent[0].getBoundingClientRect().width;
        var element_bottom = element[0].getBoundingClientRect().bottom;
        var element_fixed_width = parent_width - parseInt(parent.css('padding-left')) - parseInt(parent.css('padding-right'))
      
        
        if (parent_top < pageYOffset) {
          if ( parent_bottom <= element_bottom && parent_bottom <= pageYOffset + element_height) {
            element.css('position', 'absolute').css('top', 'auto').css('bottom', '0px');
            parent.css('height', parent.data('orig-height'));
            css_width(element, element_fixed_width);
          } else {
            element.css('position', 'fixed').css('top', pageYOffset + 'px').css('bottom', 'auto');
            css_width(element, element_fixed_width);
          }
        } else {
          element.css('position', 'relative').css('top', '0px').css('bottom', 'auto');
          css_width(element, '100%');
        }
        $scope.$apply();
      });
    };
  };
  'use strict';
  angular.module('bahnhof').directive('bhSticky', bhSticky);
})();