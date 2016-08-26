

do ->
  'use strict'
  
  SharePostFormCtrl = ($http, ENV) ->
    sharing_endpoint = ENV.apiEndpoint + 'sharing'
    
    vm = this
    vm.submitted = false
    
    
    
    
    vm.submit = -> 
      vm.submitted = true
      data = 
        to : vm.to,
        from: vm.from,
        message: vm.message
        postId: vm.postId
      
       $http(
         url: sharing_endpoint
         method: 'POST'
         data:
           data: data)
        
        .then (response) -> 
          vm.message_submitted = "Your message has been sent."
        , (response) ->
          vm.message_submitted = "Sorry. An error occured. Please try again."
        
      
    return
    
  SharePostFormCtrl.$inject = ['$http', 'ENV']
  angular.module('bahnhof').controller 'SharePostFormCtrl', SharePostFormCtrl