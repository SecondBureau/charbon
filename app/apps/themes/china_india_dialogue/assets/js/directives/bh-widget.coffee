do ->

  'use strict'
  
  bhWidget = ($stateParams, $location, Posts, Categories) ->

    controller = ->
      slug = $stateParams.slug
      vm = this
      Posts.getBySlug(slug, false).then (post) ->
        search = {
          e: [post.id]
          categories: if parseInt(post.category_id) > 0 then [post.category_id] else []
          order: 'published_at desc'
        }
        
        category = Categories.getById(post.category_id)
        if category
          vm.widget_title = category.label
        else
          vm.widget_title = 'Recent posts'
              
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
  