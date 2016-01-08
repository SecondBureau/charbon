angular.module('bahnhof.services')



.factory('Posts', ['$filter', '$http', '$q', 'ENV',  function($filter, $http, $q, ENV) {

  var posts = [];
  var postIds = [];
  var homePosts = [];
  
  var posts_endpoint = ENV.apiEndpoint + "posts";
  
  function addPosts(newPosts){
    if (!angular.isArray(newPosts)) {
      newPosts = [posts];
    }
    angular.forEach(newPosts, function(post) {
      if (postIds.indexOf(post.id) == -1){
        posts.push(post);
        postIds.push(post.id);
      }
    })
    return posts;
  }

  return {
    
    all: function(){
      return $http.get(posts_endpoint).then(function(response){
        posts = response.data;
        return posts;
      });
    },
    
    getBySlug: function(slug) {
      post = $filter('filter')(posts, {slug: slug}, true)
      if (post.length > 0) {
        return $q(function(resolve, reject) {
            resolve(post[0]);
          })
      } else {
        return $http({
            url: posts_endpoint + '/' + slug, 
            method: "GET"
         }).then(function(response){
           return addPosts(response.data.post[0]);
        });
      }
    },
    
    // get: function(slug) {
    //   return $filter('filter')(posts, {slug: slug}, true)[0];
    // },
    
    search: function(search) {
      if (homePosts.length > 0) {
        return homePosts;
      } else {
      return $http({
          url: posts_endpoint, 
          method: "GET",
          params: {q: search}
       }).then(function(response){
        posts = addPosts(response.data);
        homePosts = posts;
        return response;
      });
    }
    },
    
    get: function(search, offset, limit) {
      //return $filter('filter')(posts, {category_id: categoryId}, true);
      return $http({
          url: posts_endpoint, 
          method: "GET",
          params: {s: search, offset: offset, limit: limit}
       }).then(function(response){
          addPosts(response.data);
          return response;
      });
    }
  }
}])
;
