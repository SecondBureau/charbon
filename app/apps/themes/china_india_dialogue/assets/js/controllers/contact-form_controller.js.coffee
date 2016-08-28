

do ->
  'use strict'
  
  ContactFormCtrl = ($scope, $http, ENV, $location) ->
    endpoint = ENV.apiEndpoint + 'contactform'
    
    vm = this
    vm.filling = false
    vm.submitted = false
    
    vm.gotFocus = ->
      vm.filling = true
    
    vm.submit = -> 
      vm.submitted = true
      vm.sending = true
      data = 
        from: vm.from
        title: vm.title
        message: vm.message

       
       $http(
         url: endpoint
         method: 'POST'
         data:
           data: data)
        
        .then (response) -> 
          vm.sending = false
          vm.message_submitted = "Your message has been sent."
        , (response) ->
          vm.sending = false
          vm.message_submitted = "Sorry. An error occured. Please try again."
        
      
    return
    
  ContactFormCtrl.$inject = ['$scope', '$http', 'ENV', '$location']
  angular.module('bahnhof').controller 'ContactFormCtrl', ContactFormCtrl