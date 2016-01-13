do ->

  'use strict'
  
  bhPost = ($stateParams, Posts) ->

    controller = ->
      vm = this
      slug = vm.slug or $stateParams.postSlug
      # TODO: Use post.id if slug undefined
      Posts.getBySlug(slug).then (post) ->
        vm.post = post
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
        'templates/directives/post-' + tpl + '.html'

    }

  bhPost.$inject = ['$stateParams', 'Posts']
  angular.module('bahnhof').directive 'bhPost', bhPost
  

