angular.module('bahnhof.directives')

.directive("bhInclude",function( ) {
  return({
    link: link,
    restrict: "A",
    transclude: true,
    scope: {
      'bhIncludeParams': '&'
    },
    templateUrl: template,
    controller: ['$scope', function($scope) {
      $scope.categories.then(function(){
        $scope.homePosts.then(function(response) {
        console.log ('bhinclude search finished');
        console.log (response.data);
          });
        });
    }],
  });
  function template( element, attributes) {
    return attributes.bhInclude;
  };
  function link( scope, element, attributes, controllers ) {
    var vars, key, value;
    vars = scope.bhIncludeParams();
    for (key in vars) {
      value = vars[key];
      scope[key] = value;
    }
  };
 })

