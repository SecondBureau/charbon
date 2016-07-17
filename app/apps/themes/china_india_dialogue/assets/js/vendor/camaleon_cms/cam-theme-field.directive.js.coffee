do ->

  'use strict'
 
  camThemeField = (Theme, $sce, $compile) ->
    
    controller = ->

      vm = this
      
      vm.html = (vm.type == 'html')
      vm.image = (vm.type == 'image')
      vm.link = (vm.type == 'link')
      vm.popup = (vm.type == 'popup')
      vm.show = false
      fieldSlug = vm.slug
      themeSlug = vm.theme
      Theme.getField(themeSlug, fieldSlug).then (response) ->
        contents = decodeURIComponent(response.data.field_contents)
        if vm.image
          contents = "<img src='" + contents + "' class='img-responsive' />"
        if vm.link
          contents = "<a href='" + contents + "'>" + vm.linkContents + "</a>"
        if vm.popup
          contents = "<a href='#' class='popup' data-popup-content='"+ contents + "'>" + vm.popupButton + "</a>"
          #contents = '<button type="button" class="popup btn btn-primary btn-lg" data-toggle="modal" data-target="#myModal">Launch demo modal</button>'
          contents = $sce.trustAsHtml(contents)
          
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
        popupButton: "@"
      template: '<div ng-bind-html="vm.contents"></div>'
    }

  camThemeField.$inject = ['Theme', '$sce', '$compile']
  angular.module('camaleonCms').directive 'camThemeField', camThemeField

