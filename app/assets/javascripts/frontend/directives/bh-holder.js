angular.module('bahnhof.directives')
.directive("bhHolder",['preLoader', function(preLoader) {
  return({
    link: link,
    priority: 200,
    restrict: "A"
  });
  function link( scope, element, attrs ) {
    
    attrs.$observe('bhHolder', function(){
      if (attrs.bhHolder != 'x') {
        attrs.$set('data-src', 'holder.js/' + attrs.bhHolder + '?auto=yes&bg=f4f7fb&fg=f4f7fb');
        Holder.run({images:element[0]});
        preLoader(attrs.bhSrc, function(){
          attrs.$set('src', attrs.bhSrc);
        }, function(){
          console.log("chargement foiré");
        });
      }
    })

  }
 }])