do ->

  'use strict'
  
  bhWidget = ($stateParams, $location, Posts) ->

    controller = ->
      vm = this
      search = '"category":72, "order":"published_at desc"'
      
      Posts.search(search, 0, 6).then (posts) ->
        vm.posts = posts.data
        return
      
      return

    {
      controller: controller
      controllerAs: 'vm'
      bindToController: true
      templateUrl: (elem, attr) ->
        template_path('directives/widget-recent.html')
    }

  bhWidget.$inject = ['$stateParams', '$location', 'Posts']
  angular.module('bahnhof').directive 'bhWidget', bhWidget
  