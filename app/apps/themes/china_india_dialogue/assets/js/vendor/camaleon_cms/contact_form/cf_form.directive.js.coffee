do ->

  'use strict'
 
  cfForm = (Forms, $sce) ->
    
    template = ->
      """<form ng-show="!vm.submitted" ng-submit="vm.submit()">
      <div ng-bind-html="vm.form_fields"></div>
      <div ng-bind-html="vm.form_submit"></div>
      </form>
      <div ng-show="vm.submitted" ng-bind-html="vm.message_submitted"></div>"""
    
    controller = ->
      vm = this
      vm.submitted = false
      
      vm.submit = ->
        console.log vm
        console.log vm.fields_c6
        vm.submitted = true
        

      
      formSlug = vm.slug
      themeSlug = vm.theme
      Forms.getForm(themeSlug, formSlug).then (response) ->
        vm.form_fields = $sce.trustAsHtml(decodeURIComponent(response.data.form.fields).replace(/name=\"fields\[([a-z0-9]+)\]\"/g,"ng-model=\"vm.\$1\""))
        vm.form_submit = $sce.trustAsHtml(decodeURIComponent(response.data.form.submit))
        vm.message_submitted = $sce.trustAsHtml(decodeURIComponent(response.data.messages.submitted))
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
      template: template
    }

  cfForm.$inject = ['Forms', '$sce']
  angular.module('cam.contactForm').directive 'cfForm', cfForm

