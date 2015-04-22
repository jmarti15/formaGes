'use strict';

var mod22 = angular.module('mod22', ['scrollable-table', 'ui.bootstrap']);

mod22.service('func', function() {
    this.keys = function(obj){
        return obj? Object.keys(angular.copy(obj)) : [];
    };
});

mod22.controller('centresCtrl', function($scope, $http, $modal, func) {
	$scope.actualitza = function() {
		$scope.$broadcast("renderScrollableTable");
	};
	$scope.neteja = function() {
		if($scope.search){
			$scope.search='';
			$scope.$broadcast("renderScrollableTable");
		}
	};

	$scope.getCentres = function() {
		$http.get("api/centres.jsp").success( function(data) {
		    $scope.data = data;
		    $scope.dataKeys = func.keys( $scope.data[0] );
		    $scope.filtered = $scope.data;
		    $scope.search = '';     // set the default search/filter term
		});
	};
	$scope.getCentres();

	$http.get("api/centres.jsp?codi=keys").success( function(data) {
	    $scope.keysDb = data;
	});

	$scope.detall = function(codi) {
		if(codi) {
			$http.get("api/centres.jsp?codi="+codi).success( function(data) {
				$scope.mostraDetall(data);
			});
		} else {
			$scope.mostraDetall(null);
		}
	};

	$scope.mostraDetall = function(data) {
		var modalInstance = $modal.open({
			templateUrl: 'lib/centre.html',
			controller: 'centreDetallCtrl',
			size: '',         // large: 'lg'    normal: ''     small: 'sm'
			resolve: {
			    keysDb: function () {
			        return $scope.keysDb;
			    },
			    dataDet: function () {
			        return data;
			    }
			}
		});
		modalInstance.result.then( function() {
			$scope.getCentres();
		}, function () {
			// cancel
		});
	};

});

mod22.controller('centreDetallCtrl', function($scope, $http, $timeout, $modalInstance, func, keysDb, dataDet) {
// keysDb:		[Codi, Nom, Contacte, Telef1, Telef2, Email, Adre, CP, Prov, Pobl, Coment, NomAdmin, NIFAdmin]
// dataDet:	mod/del			{"Codi":"1", "Centro":"Un punt de llum","Contacto":"Xus, Agnès i Mónica","Teléfono 1":"666 12 23 34",
//													"Teléfono 2":"777 123 456", "eMail":"llum@gmail.com","Dirección":"llevant, 2","C.Postal":"08144",
//													"Provincia":"Barcelona","Población":"Mediona", "Comentarios":"Espai de trobada de Mediona",
//													"Administrador":"Xus","NIF admin.":"39702777X"}
//						add					null
	$scope.keysDb = keysDb;
	$scope.data = dataDet;
	if(dataDet){
		$scope.codi = dataDet.Codi;
		$scope.nom = dataDet.Centro;
	} else {
		$scope.codi = '';
		$scope.nom = '';
	}
	
	$scope.delPremut = false;
	$scope.dangerMsg = '';
	$scope.nifErr = $scope.data && !validaNifNie( $scope.data['NIF admin.'] );
	
	// Posem el focus al final del camp
	$timeout(function() {
		$('#Centro').focus();
		var strLength= $scope.nom.length;
		$('#Centro')[0].setSelectionRange(strLength, strLength);
      }, 400);		// Esperem a que es renderitzi la finestra modal

	$scope.canvi = function(opc) {
		$scope.delPremut = false;
		$scope.dangerMsg = '';
		
		if( opc=='nif' ){
			$scope.nifErr = !validaNifNie( $scope.data['NIF admin.'] );
		}
	};

	$scope.validacions = function() {
		if( $scope.nifErr ) {
			$scope.dangerMsg = "NIF o NIE incorrecto...";
			return false;
		}

		var campsOblig =  ["Centro","Contacto","Teléfono 1","eMail","Dirección","C.Postal","Provincia","Población"];
		var campDescri = function(camp){
			if(camp=="Centro"){ return "Descripción"; }
			else { return camp; }
		};
		$scope.msgErr = '';
		$scope.campErr = [];
		try {
			if( !$scope.data ){		// (a Añadir)  No han omplert cap camp 
														// (Els elements de $scope.data es defineixen quan són informats, a l'inici $scope.data val null)   
				$scope.dangerMsg = "Debe rellenar el campo: "+campDescri( campsOblig[0] );
				$scope.campErr[0] = true;
$('#'+campsOblig[0]).focus();
				return false;
			} else {
				for( var i in campsOblig ){
					var camp = campsOblig[i];
					var valor = $scope.data[camp];
					if( !valor ){
						$scope.dangerMsg = "Debe rellenar el campo: "+campDescri( camp );
						$scope.campErr[i] = true;
//$('#'+camp).focus();
$("[id='"+camp+"']").focus();
						return false;
					}
				}
			}
		}
		catch(err) {
			 $scope.msgErr = 'Error:' + err.message;
		}
		
		return true;	//ok
	};
	
	$scope.add = function() {
		if( !$scope.validacions() ) return;
		
		$http.post("api/centres.jsp", null, {"params":{"keys": $scope.keysDb, "data": $scope.data}} )
		.success( function(data) {
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
		if( !$scope.validacions() ) return;

		$http.put("api/centres.jsp", null, {"params":{"keys": $scope.keysDb, "data": $scope.data}} )
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
	};

	$scope.del = function() {
// validar que no estigui en us
//		if( !$scope.validaDel() ) return;
		
		if( !$scope.delPremut ) {
			$scope.delPremut = true;
			$scope.dangerMsg = 'Pulse otra vez para eliminar';
		} else {
			$http.delete("api/centres.jsp", {"params":{"codi": $scope.codi}})
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
	};

    $scope.cancel = function () {
        $modalInstance.dismiss('cancel');
    };

    $scope.execDefault = function ($event) {
    	// Definim un botó per defecte
    	var which = $event.which || $event.keyCode;
       	if(which == 13) {
        	if($scope.codi) $scope.mod();
        							else $scope.add();
       	}
    };

});
