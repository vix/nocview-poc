'use strict';
/* Controllers */
var app = angular.module('manocApp', [
[% FOREACH module IN modules -%]
'[% module %]'[% "," UNLESS loop.last %]
[%- END -%]
]);
app.config(function($routeProvider) {
  $routeProvider
[%-  FOREACH route IN routes              -%]
[%-      INCLUDE "routes/${route}.js"     -%]
[%-   END                                 -%]
  .otherwise({redirectTo: '/building'});
});
