do ->

  'use strict'
  
  bhMainMenu = ($compile)->

    link = (scope, element, attributes) ->
      
      max_items = 8
      max_items_sm = 5
      nb_items = element.children('li').length
      
      if nb_items <= max_items_sm or nb_items < 1 
        return
      
      vm = scope
      
      vm.open = false
      
      vm.toggle = ->
        vm.open = if vm.open then false else true
        
      btn = """
        <button type="button" class="toggle" ng-class="{open: open}" ng-click="toggle()">
        <a href role="button">
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
          <span class="icon-bar"></span>
        </a>
        </button>
      """
      
      items = element.clone().children('li')
      ul = angular.element('<ul class="dropdown-menu"></ul>').html(items)
      ul.children('li').slice(0, max_items_sm).addClass('hidden-sm')
      ul.children('li').slice(0, max_items).addClass('hidden-md hidden-lg')
      button = angular.element(btn).append(ul)
      
      element.html(element.children('li').slice(0,max_items))
      element.children('li').after('<li style="width:10%"></li>')
      element.children('li').slice(max_items_sm * 2).addClass('hidden-sm')
      element.children('li').addClass('hidden-xs')
      element.children('li:last').after('<li style="width:50px">'+ button.prop('outerHTML') + '</li>')
      
      if nb_items <= max_items
        element.find('button').addClass('hidden-md hidden-lg')
      
      $compile(element.contents())(scope);


    {
      link: link
      restrict: 'C'
      replace: true
    }

  bhMainMenu.$inject = ['$compile']
  angular.module('bahnhof').directive 'bhMainMenu', bhMainMenu
