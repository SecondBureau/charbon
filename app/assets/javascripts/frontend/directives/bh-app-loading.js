angular
  .module('bahnhof')
  .directive('bhAppLoading', bhAppLoading);


function bhAppLoading() {
  return({
    link: link,
    restrict: "C"
  });
  function link( scope, element, attributes ) {
    scope.$watch('categories', function(data) {
      if (angular.isArray(scope.categories) && scope.categories.length > 0) {
        element.remove();
      }
    });
    //scope.categories.then(function(){
      
      //});
  }
 }