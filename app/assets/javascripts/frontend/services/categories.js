angular
  .module('bahnhof')
  .factory('Categories', Categories);


function Categories ($filter, $http, $q, ENV) {
  var categories = [];
  var categories_endpoint = ENV.apiEndpoint + "categories"

  return {
    all: function() {
      if (categories.length > 0) {
        return $q(function(resolve, reject) {
            resolve(categories);
          })
      } else {
        return $http.get(categories_endpoint).then(function(response){
        categories = response.data;
        return categories;
      })};
    },
    get: function(slug) {
      return $filter('filter')(categories, {slug: slug}, true)[0];
    }
  }
}
