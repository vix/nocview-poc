'use strict';
var module = angular.module("manocResource", ["ngResource"]);
module.factory( 'ManocResource', [ '$resource', '$http', function( $resource, $http ) {
    return function( url, params, methods ) {
	var dbicApiDataTransformer = function ($http) {
	    return $http.defaults.transformResponse.concat([
		function (data, headersGetter) {
		    var result = data.data;
		    result.success = data.success;
		    return result;
		}
	    ])
	};
	
	var defaults = {
	    query:  { method:'GET', isArray: true, transformResponse: dbicApiDataTransformer($http)  },
	    get:    { method:'GET', transformResponse: dbicApiDataTransformer($http)  },
            update: { method: 'PUT', isArray: false },
	    create: { method: 'POST' }
	};      
	methods = angular.extend( defaults, methods );
	
	var resource = $resource( url, params, methods );	
	resource.prototype.$save = function() {
	    if ( !this.id ) {
		return this.$create();
	    }
	    else {
		return this.$update();
	    }
	};	
	return resource;
    };
 }]);
[%   FOREACH service IN services           -%]
[%-      INCLUDE "services/${service}.js"  -%]
[%-   END                                  -%]
