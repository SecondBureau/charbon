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
        newPosts = [ newPosts ]
      for newPost in newPosts
        found = false
        for post in posts
          if (post.id == newPost.id)
            found = true
            angular.merge(post, newPost)
            break
        if !found
          posts.push newPost  
      posts

    {

      getBySlug: (slug, cache=true) ->
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
            if cache
              updatePosts response.data
            response.data[0]
          , (response) ->
              '404'
      homePosts: (search) ->
        #console.log 'homePosts >' + homePosts.length
        if homePosts.length > 0
          homePosts
        else
          $http(
            url: posts_endpoint + '/home'
            method: 'GET'
            cache: true
            params: 
              q: search).then (response) ->
            homePosts = response.data
            updatePosts(angular.copy(response.data))
            homePosts
            
            
      search: (search, offset, limit) ->
        #console.log 'search'
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
  
