/*jslint node: true */
/*global angular */
"use strict";

var mod11 = angular.module('mod11', []);

mod11.controller('clientsCtrl', function($scope, $http) {
	// Definim la funció dins del controlador
	/// Ja ho carrega a l'inici
	$scope.descargaArchivo = function() {
		$http.get("api/inscrip.jsp").success( function(data) {
///$http.get("api/_2_inscrip.jsp").success( function(data) {
			$scope.numLins = data.numLins;
			$scope.caps = data.caps;
			$scope.clientList = data.lins;
///$scope.clientList = data;			
		});
	};
	/// A clients.html cridem: <div ng-init="descargaArchivo();">
	/// També ho podríem cridar aquí:
$scope.descargaArchivo();
});
