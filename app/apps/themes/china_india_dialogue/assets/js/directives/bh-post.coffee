do ->

  'use strict'
  
  bhPost = ($sce, $stateParams, $location, Posts, Users) ->

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
      vm.showSendEmailForm = false
      vm.absUrl = $location.absUrl()
      vm.loading = true
      
      vm.getTemplateUrl = ->
        tpl = vm.template or 'std'
        if vm.usePostType && vm.post
          tpl = tpl + '-' + vm.post.post_type
        template_path('directives/post-' + tpl + '.html')
      
      vm.showSendEmail = ->
        vm.showSendEmailForm = true
        
      vm.hideSendEmail = ->
        vm.showSendEmailForm = false
      
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
        
      slug = vm.slug or $stateParams.slug
      
      # TODO: Use post.id if slug undefined
      Posts.getBySlug(slug).then (post) ->

        vm.loading = false
        if post == '404'
          $location.hash('/error/404')
          return
        
        body = $(post.body)
        
        img_class = post.images_class
        if angular.isUndefined(img_class) || !img_class
          img_class = 'img-responsive img-thumbnail'
        body.find('img:not([width])').addClass(img_class)
        
        img_class = post.fixed_width_images_class
        if angular.isUndefined(img_class) || !img_class
          img_class = 'pull-left inline-image img-thumbnail'
        body.find('img[width]').addClass(img_class)
        body.find('img[width].pull-left').parent('figure').addClass('pull-left')

        post.body = $('<div>').append(body.clone()).html().replace(/<!-- pagebreak -->/g, '<div class="clearfix"></div>')
        
        
        if !angular.isUndefined(vm.highlight) || !angular.isUndefined(vm.highlight) && !angular.isUndefined(post.highlight) && vm.highlight != post.highlight
          init_highlight(post, vm.highlight)
          post.highlight = vm.highlight
        
        if angular.isUndefined(post.highlight) || post.highlight == null
          post.highlightable  = false
        
        vm.post = post
        
        if post.highlight
          vm.toggleHighlight true 
        
        if !post.author && post.author_id
          Users.getById(post.author_id).then (user) ->
            vm.author = user
            vm.loaded = true
          return
        else
          vm.author = {}
          vm.author.fullname = post.author
          vm.loaded = true
        
      return

    {
      controller: controller
      controllerAs: 'vm'
      scope:
        slug: '='
        id: '='
        social: '='
        highlight: "="
        template: "="
        usePostType: "="
      bindToController: true
      template : '<div ng-include="vm.getTemplateUrl()"></div>'

    }

  bhPost.$inject = ['$sce', '$stateParams', '$location', 'Posts', 'Users']
  angular.module('bahnhof').directive 'bhPost', bhPost
  

