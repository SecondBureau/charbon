angular.module('bahnhof.directives')

.directive("bhPost", function($stateParams, Posts) {
    
  var controller = function () {
    var vm = this;
    var slug = vm.slug || $stateParams.postSlug;
    // TODO: Use post.id if slug undefined
    Posts.getBySlug(slug).then(function(post){
      vm.post = post;
      vm.loaded = true;
    });
  }

    return {
      controller: controller,
      controllerAs: 'vm',
      scope: {
        slug: '=',
        id: "=",
        social: "="
      },
      bindToController: true,
      templateUrl: function(elem, attr){
        tpl = attr.template || 'std';
        return 'templates/directives/post-' + tpl + '.html';
        }
      };
  });