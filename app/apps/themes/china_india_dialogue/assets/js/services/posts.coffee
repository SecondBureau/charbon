do ->

  'use strict'
  
  Posts = ($filter, $http, $q, ENV) ->
    
    posts = []
    homePosts = []
    posts_endpoint = ENV.apiEndpoint + 'posts'

    postIds = ->
      postIds = []
      for post in posts
        postIds.push post.id
      postIds

    updatePosts = (newPosts) ->
      
      if !angular.isArray(newPosts)
        newPosts = [ posts ]

      for newPost in newPosts
        found = false
        for post in posts
          if (post.id == newPost.id)
            found = true
            angular.extend(post, newPost)
            break
        if !found
          posts.push newPost  
      
      posts

    {

      getBySlug: (slug) ->
        post = $filter('filter')(posts, { slug: slug }, true)
        if post.length > 0
          $q (resolve, reject) ->
            resolve post[0]
            return
        else
          $http(
            url: posts_endpoint + '/' + slug
            cache: true
            method: 'GET').then (response) ->
            updatePosts response.data
            response.data[0]
          , (response) ->
              '404'
      homePosts: (search) ->
        if homePosts.length > 0
          homePosts
        else
          $http(
            url: posts_endpoint + '/home'
            method: 'GET'
            cache: true
            params: 
              q: search).then (response) ->
            posts = updatePosts(response.data)
            homePosts = response.data
            
      search: (search, offset, limit) ->
        $http(
          url: posts_endpoint
          method: 'GET'
          cache: true
          params:
            #post_ids: postIds
            s: search
            offset: offset
            limit: limit).then (response) ->
          updatePosts response.data
          response

    }

  
  Posts.$inject = ['$filter', '$http', '$q', 'ENV']
  angular.module('bahnhof').factory 'Posts', Posts
  
