do ->

  'use strict'
  
  Posts = ($filter, $http, $q, ENV) ->
    posts = []
    postIds = []
    homePosts = []
    posts_endpoint = ENV.apiEndpoint + 'posts'

    addPosts = (newPosts) ->
      if !angular.isArray(newPosts)
        newPosts = [ posts ]
      angular.forEach newPosts, (post) ->
        if postIds.indexOf(post.id) == -1
          posts.push post
          postIds.push post.id
        return
      posts

    {
      all: ->
        $http.get(posts_endpoint).then (response) ->
          posts = response.data
          posts
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
            addPosts response.data
            response.data[0]
      homePosts: (search) ->
        if homePosts.length > 0
          homePosts
        else
          $http(
            url: posts_endpoint + '/home'
            method: 'GET'
            cache: true
            params: q: search).then (response) ->
            posts = addPosts(response.data)
            homePosts = posts
            
      search: (search, offset, limit) ->
        $http(
          url: posts_endpoint
          method: 'GET'
          cache: true
          params:
            s: search
            offset: offset
            limit: limit).then (response) ->
          addPosts response.data
          response

    }

  
  Posts.$inject = ['$filter', '$http', '$q', 'ENV']
  angular.module('bahnhof').factory 'Posts', Posts
  
