/*jslint node: true */
/*global angular */
"use strict";

var mod21 = angular.module('mod21', ['scrollable-table', 'ui.bootstrap']);

mod21.controller('nivellsCtrl', function($scope, $http, $modal) {
	// Definim la funció dins del controlador
	/// Ja ho carrega a l'inici
	
	$scope.actualitza = function() {
		$scope.$broadcast("renderScrollableTable");
	}
	$scope.neteja = function() {
		if($scope.search){
			$scope.search='';
			$scope.$broadcast("renderScrollableTable");
		}
	}
    $scope.keys = function(obj){
        return obj? Object.keys(angular.copy(obj)) : [];
    };

	$scope.getNivells = function() {
		$http.get("api/nivells.jsp").success( function(data) {
		    $scope.data = data;
		    $scope.dataKeys = $scope.keys( $scope.data[0] );
		    $scope.filtered = $scope.data;
		    $scope.search = '';     // set the default search/filter term
		});
	};
	/// A clients.html cridem: <div ng-init="descargaArchivo();">
	/// També ho podríem cridar aquí:
	$scope.getNivells();

/* ho cridem:																	rebem:				resolve:								rebem a nivellDetallCtrl:
			detall(dataLin.Codi)											(Codi)					return Codi						1
 			detall(dataLin)														(Codi)					return Codi						{"Codi":"1","Nivel":"Hipo N1"}
 			detall(dataLin.Codi, dataLin.Nivel) 			(Codi,Desc)		return [Codi,Desc]		["1","Hipo N1"] 
 */
	$scope.detall = function(dataLin) {
//		alert(Codi);
        var modalInstance = $modal.open({
            templateUrl: 'lib/nivell.html',
            controller: 'nivellDetallCtrl',
            size: '',         // large: 'lg'    normal: ''     small: 'sm'
            resolve: {
                nivLin: function () {
                    return dataLin;
                }
            }
        });

        modalInstance.result.then( function() {
        	$scope.getNivells();
        }, function () {
        	// cancel
        });
	}

});

mod21.controller('nivellDetallCtrl', function($scope, $http, $timeout, $modalInstance, nivLin) {
																																																// {"Codi":"1","Nivel":"Hipo N1"}
	$scope.codNiv = nivLin.Codi;
	$scope.nomNiv = nivLin.Nivel;
	$scope.delPremut = false;
	$scope.dangerMsg = '';

	// Posem el focus al final del camp amb id="nomID"
	$timeout(function() {
		$('#nomID').focus();
		var strLength= $scope.nomNiv.length;
		$('#nomID')[0].setSelectionRange(strLength, strLength);
      }, 400);		// Esperem a que es renderitzi la finestra modal

	$scope.canvi = function() {
		$scope.delPremut = false;
	}

	$scope.add = function() {
		$http({
		    method: 'POST',
		    url: "api/nivells.jsp",
		    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
		    transformRequest: function(obj) {
		        var str = [];
		        for(var p in obj)
		        str.push(encodeURIComponent(p) + "=" + encodeURIComponent(obj[p]));
		        return str.join("&");
		    },
		    data: {"nom":$scope.nomNiv}
		}).success( function(data) {
			if(data.res > 0) {
				$modalInstance.close();
			} else {
				$scope.dangerMsg = "Error de Base de Datos...";
			}
		})
		.error( function () {
			$scope.dangerMsg = "Error de comunicaciones...";
		});
	};

	$scope.mod = function() {
		$scope.delPremut = false;

		$http.put("api/nivells.jsp", null, {"params":{"codi": $scope.codNiv, "nom": $scope.nomNiv}} )
		.success(function(data) {
			if(data.res > 0) {
				$modalInstance.close();
			} else {
				$scope.dangerMsg = "Error de Base de Datos...";
			}
		})
		.error( function () {
			$scope.dangerMsg = "Error de comunicaciones...";
		});
	}

	$scope.del = function() {
		if( !$scope.delPremut ) {
			$scope.delPremut = true;
			$scope.dangerMsg = 'Pulse otra vez para eliminar';
		} else {
			$http.delete("api/nivells.jsp", {"params":{"codi": $scope.codNiv}})
			.success(function(data) {
				if(data.res > 0) {
					$modalInstance.close();
				} else {
					$scope.dangerMsg = "Error de Base de Datos...";
				}
			})
			.error( function () {
				$scope.dangerMsg = "Error de comunicaciones...";
			});
		}
	}

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };

    $scope.execDefault = function ($event) {
    	// Definim un botó per defecte
    	var which = $event.which || $event.keyCode;
       	if(which == 13) {
        	if($scope.codNiv) $scope.mod();
        								else $scope.add();
       	}
    }

});
