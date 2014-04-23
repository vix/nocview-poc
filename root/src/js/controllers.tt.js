var manocControllers = angular.module('manocControllers', []);
[%-  FOREACH controller IN controllers              -%]
[%-      INCLUDE "controllers/${controller}.js"     -%]
[%-   END                                           -%]
