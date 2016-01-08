angular.module('bahnhof.services')
.factory('preLoader', function(){
    return function (url, successCallback, errorCallback) {
        //Thank you Adriaan for this little snippet: http://www.bennadel.com/members/11887-adriaan.htm
        angular.element(new Image()).bind('load', function(){
            successCallback();
        }).bind('error', function(){
            errorCallback();
        }).attr('src', url);
    }
});