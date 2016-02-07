do ->

  'use strict'
  
  bhPost = ($stateParams, $location, Posts, Users) ->

    highlight = (content, words) ->
      if words && content
        words = words.split(',')
        for word in words
          content = content.replace(new RegExp('('+word.trim()+')', 'gi'),'<span class="highlighted">$1</span>')
      content
      
    init_highlight = (post, words) ->
      post.bodies     = [post.body,     highlight(post.body,    words)]
      post.summaries  = [post.summary,  highlight(post.summary, words)]
      post.titles     = [post.title,    highlight(post.title,   words)]
      post.highlightable = true
    
    controller = ->
      vm = this
      
      vm.toggleHighlight = (turn_on) ->

        if angular.isUndefined(turn_on) && !vm.post.highlighted || !angular.isUndefined(turn_on) && turn_on
          vm.post.body    = vm.post.bodies[1]
          vm.post.summary = vm.post.summaries[1]
          vm.post.title   = vm.post.titles[1]
          vm.post.highlighted = true
        else
          vm.post.body    = vm.post.bodies[0]
          vm.post.summary = vm.post.summaries[0]
          vm.post.title   = vm.post.titles[0]
          vm.post.highlighted = false
        
      slug = vm.slug or $stateParams.postSlug
      
      # TODO: Use post.id if slug undefined
      Posts.getBySlug(slug).then (post) ->
        post.url            = $location.absUrl()
        if !angular.isUndefined(vm.highlight) || !angular.isUndefined(vm.highlight) && !angular.isUndefined(post.highlight) && vm.highlight != post.highlight
          init_highlight(post, vm.highlight)
          post.highlight = vm.highlight
        
        if angular.isUndefined(post.highlight) || post.highlight == null
          post.highlightable  = false
        
        vm.post = post
        if post.highlight
          vm.toggleHighlight true 
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
        highlight: "="
      bindToController: true
      templateUrl: (elem, attr) ->
        tpl = attr.template or 'std'
        template_path('directives/post-' + tpl + '.html')

    }

  bhPost.$inject = ['$stateParams', '$location', 'Posts', 'Users']
  angular.module('bahnhof').directive 'bhPost', bhPost
  

