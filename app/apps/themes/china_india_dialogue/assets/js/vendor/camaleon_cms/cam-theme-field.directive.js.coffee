do ->

  'use strict'
 
  camThemeField = (Theme) ->
    
    controller = ->
      vm = this
      
      vm.html = (vm.type == 'html')
      vm.image = (vm.type == 'image')
      vm.link = (vm.type == 'link')
      fieldSlug = vm.slug
      themeSlug = vm.theme
      Theme.getField(themeSlug, fieldSlug).then (response) ->
        contents = decodeURIComponent(response.data.field_contents)
        if vm.image
          contents = "<img src='" + contents + "' class='img-responsive' />"
        if vm.link
          contents = "<a href='" + contents + "'>" + vm.linkContents + "</a>"
        vm.contents = contents
        return
      return

    {
      restrict: 'E'
      controller: controller
      controllerAs: 'vm'
      scope: true
      bindToController: 
        slug: '@'
        theme: '@'
        type: "@"
        linkContents: "@"
      template: '<div ng-bind-html="vm.contents"></div>'
    }

  camThemeField.$inject = ['Theme']
  angular.module('camaleonCms').directive 'camThemeField', camThemeField

