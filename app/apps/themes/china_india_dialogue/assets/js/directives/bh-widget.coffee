do ->

  'use strict'
  
  bhWidget = ($stateParams, $location, Posts, Categories) ->

    controller = ->
      slug = $stateParams.postSlug
      vm = this
      Posts.getBySlug(slug).then (post) ->
        search = {
          e: [post.id]
          categories: [post.category_id]
          order: 'published_at desc'
        }
        
        category = Categories.getById(post.category_id)
        vm.widget_title = category.label
              
        Posts.search(angular.toJson(search), 0, 6).then (posts) ->
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

  bhWidget.$inject = ['$stateParams', '$location', 'Posts', 'Categories']
  angular.module('bahnhof').directive 'bhWidget', bhWidget
  