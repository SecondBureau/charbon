angular
  .module('bahnhof')
  .controller('DropdownCtrl', DropdownCtrl);


function DropdownCtrl ($scope, $log) {

  $scope.status = {
    isopen: false
  };

  $scope.toggleDropdown = function($event) {
    $event.preventDefault();
    $event.stopPropagation();
    $scope.status.isopen = !$scope.status.isopen;
  };
}