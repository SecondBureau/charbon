do ->

  'use strict'
  
  bhPost = ($stateParams, $location, Posts, Users) ->

    controller = ->
      vm = this
      slug = vm.slug or $stateParams.postSlug
      # TODO: Use post.id if slug undefined
      Posts.getBySlug(slug).then (post) ->
        vm.post = post 
        vm.post.url = $location.absUrl()
        Users.getById(post.author_id).then (user) ->
          vm.author = user
          vm.loaded = true
        return
      return

    {
      controller: controller
      controllerAs: 'vm'
      scope:
        slug: '='
        id: '='
        social: '='
      bindToController: true
      templateUrl: (elem, attr) ->
        tpl = attr.template or 'std'
        template_path('directives/post-' + tpl + '.html')

    }

  bhPost.$inject = ['$stateParams', '$location', 'Posts', 'Users']
  angular.module('bahnhof').directive 'bhPost', bhPost
  

