

do ->
  'use strict'
  
  SharePostFormCtrl = ($scope, $http, ENV, $location) ->
    sharing_endpoint = ENV.apiEndpoint + 'sharing'
    
    vm = this
    vm.submitted = false
    vm.sending = false
    vm.postId = $scope.$parent.$parent.vm.post.id
    vm.postPath = $location.absUrl()
    vm.featuredImagePath = $scope.$parent.$parent.vm.post.featured_image_url
    
    
    
    vm.submit = -> 
      vm.submitted = true
      vm.sending = true
      data = 
        to : vm.to
        from: vm.from
        message: vm.message
        postId: vm.postId
        postPath: vm.postPath
        featuredImagePath: vm.featuredImagePath

       
       $http(
         url: sharing_endpoint
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
    
  SharePostFormCtrl.$inject = ['$scope', '$http', 'ENV', '$location']
  angular.module('bahnhof').controller 'SharePostFormCtrl', SharePostFormCtrl