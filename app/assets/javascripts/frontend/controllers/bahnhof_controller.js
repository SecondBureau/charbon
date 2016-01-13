
(function() {

'use strict';
angular
  .module('bahnhof')
  .controller('BahnhofCtrl', BahnhofCtrl);


function BahnhofCtrl($scope, $location, $stateParams, Categories) {
  $scope.categories = [];
  Categories.all().then(function(categories) {
    $scope.categories = categories;
  });
  $scope.isActive = function(route) {
    return route === $location.path();
  };
}

})();


