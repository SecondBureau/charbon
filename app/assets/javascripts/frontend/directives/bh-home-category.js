angular.module('bahnhof.directives')

.directive("bhHomeCategory", ['$filter', function( $filter ) {
  return({
    link: link,
    restrict: "E",
    templateUrl: template,
    controller: ['$scope', function($scope) { 
      //console.log($scope.categories);
  this.posts = function(){
    return {a: 1, b:2}
  }
}],
    scope: {
    },
  });
  
   // function template( element, attributes) {
//      var tpl = '<p>Inside <b>Template</b></p><ul><li>LABEL: {{category.label}}</li></ul>';
//      return tpl;
//    };



  
   function template( element, attributes) {
     return '/templates/directives/home-category-' + attributes.template + '.html';
   };
  
  function link( scope, element, attributes, controllers ) {

    attributes.$observe('bhCategory', function (category) {
      if (category != '') {
        scope.category = angular.fromJson(category);
        element.removeAttr('bh-category');
      }
    });
    
    attributes.$observe('bhPosts', function (posts) {
      if (posts != '') {
        scope.posts = angular.fromJson(posts);
        element.removeAttr('bh-posts');
      }
    });
    
  };
 }])

