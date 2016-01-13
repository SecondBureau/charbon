do ->

  'use strict'
 
  bhHomeCategory = ($filter) ->
    # function template( element, attributes) {
    #      var tpl = '<p>Inside <b>Template</b></p><ul><li>LABEL: {{category.label}}</li></ul>';
    #      return tpl;
    #    };

    template = (element, attributes) ->
      template_path("directives/home-category-" + attributes.template + ".html")

    link = (scope, element, attributes, controllers) ->
      attributes.$observe 'bhCategory', (category) ->
        if category != ''
          scope.category = angular.fromJson(category)
          element.removeAttr 'bh-category'
        return
      attributes.$observe 'bhPosts', (posts) ->
        if posts != ''
          scope.posts = angular.fromJson(posts)
          element.removeAttr 'bh-posts'
        return
      return

    {
      link: link
      restrict: 'E'
      templateUrl: template
      controller: [
        '$scope'
        ($scope) ->
          #console.log($scope.categories);

          @posts = ->
            {
              a: 1
              b: 2
            }

          return
      ]
      scope: {}
    }

  bhHomeCategory.$inject = ['$filter']
  angular.module('bahnhof').directive 'bhHomeCategory', bhHomeCategory

