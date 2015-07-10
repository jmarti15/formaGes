'use strict';

var mod12 = angular.module('mod12', ['scrollable-table', 'ui.bootstrap']);

mod12.service('func', function() {
    this.keys = function(obj){
        return obj? Object.keys(angular.copy(obj)) : [];
    };
});

// Al Añadir:  pq mostri la data de la bbdd yyyy-MM-dd amb format dd/MM/yy
mod12.directive('datepickerPopup', function (dateFilter, datepickerPopupConfig) {
	return {
		restrict: 'A',
		priority: 1,
		require: 'ngModel',
		link: function(scope, element, attr, ngModel) {
	    	var dateFormat = attr.datepickerPopup || datepickerPopupConfig.datepickerPopup;
  			ngModel.$formatters.push(function (value) {
  				return dateFilter(value, dateFormat);
  			});
	    }
	};
});

mod12.controller('opcCtrl', function($scope, $http, $modal, func) {
	$scope.actualitza = function() {
		$scope.$broadcast("renderScrollableTable");
	};
	$scope.neteja = function() {
		if($scope.search){
			$scope.search='';
			$scope.$broadcast("renderScrollableTable");
		}
	};

	$scope.getData = function() {
		$http.get("api/interessats.jsp").success( function(data) {
		    $scope.data = data;
		    $scope.dataKeys = func.keys( $scope.data[0] );
		    $scope.filtered = $scope.data;
		    $scope.search = '';     // set the default search/filter term
		});
	};
	$scope.getData();

	$scope.detall = function(codi) {
		if(codi) {
			$http.get("api/interessats.jsp?codi="+codi).success( function(data) {
				$scope.mostraDetall(data);
			});
		} else {
			$scope.mostraDetall(null);
		}
	};

	$scope.mostraDetall = function(data) {
		var modalInstance = $modal.open({
			templateUrl: 'lib/interessat.html',
			controller: 'detallCtrl',
			size: '',         // large: 'lg'    normal: ''     small: 'sm'
			resolve: {
			    dataDet: function () {
			        return data;
			    }
			}
		});
		modalInstance.result.then( function() {
			$scope.getData();
		}, function () {
			// cancel
		});
	};

});


mod12.controller('detallCtrl', function($scope, $http, $timeout, $modalInstance, dateFilter, func, dataDet) {
// dataDet:	mod/del			{"Codi":"1","Nom":"Un punt de llum","Contacte":"Xus, Agnès i Mónica","Telef1":"666 12 23 34","Telef2":"777 123 456",
//													"Email":"llum@gmail.com","Adre":"Llevant, 2","CP":"08144","Prov":"Barcelona","Pobl":"Mediona",
//													"Coment":"Espai de trobada de Mediona","NomAdmin":"Xus","NIFAdmin":"39702772B"}
//						add					null

	if(dataDet){
		$scope.data = dataDet;
		$scope.codi = dataDet.Codi;
	} else {
		$scope.codi = '';
		$scope.data = {};
		$scope.data.DAlta = new Date();
	}
	$scope.dAlta = $scope.data.DAlta;
	
	$scope.delPremut = false;
	$scope.dangerMsg = '';

	
	// Data alta
	$scope.dataOpen = function($event) {
	    $event.preventDefault();
	    $event.stopPropagation();
	    $scope.opened = true;
	};
	$scope.dataKey = function(ev){
		ev.which = ev.which || ev.keyCode;
   		if( ev.which == 27) $scope.cancel();	//ESC
   		else {
   			var datEle = document.getElementById('DAlta');
   			var datLen = datEle.value.length;
   			if( datLen == 2 || datLen == 5 ){		// dd o dd/MM
   				// si acaben de prémer DEL, borrem també un altre caràcter
   				if( ev.which == 8 ) datEle.value = datEle.value.substring(0,datLen-1);
   				// si acaben d'entrar un nombre, afegim la /
   											else datEle.value = datEle.value + '/';
   			}
   		}
	};


	// Població
	$scope.deplegaPobl = false;
	$scope.carregaCodPobl = function(param){
		$http.get("api/poblacions.jsp?"+param).success( function(data) {
			$scope.deplegaPobl = (data.length > 1);
			if( data.length===0 ){		// cp inexistent
				$scope.cpErr = true;
			} else if( data.length===1 ){
				$scope.data.CodPobl = data[0].Codi;
				$scope.pobl = data[0].Pobl;
				$scope.prov = data[0].Prov;
				if( !$scope.codPos ){	// Acabem d'entrar
					$scope.codPos = data[0].CodPos;													// Omplim el CP
					$scope.carregaCodPobl( "codpos="+data[0].CodPos );	// Carreguem poblacions pel CP
					$scope.poblacio = $scope.data.CodPobl;									// Seleccionem al desplegable
				}
			} else {
				$scope.poblacions = data;
			}
		});
	};
	if( $scope.data && $scope.data.CodPobl ) $scope.carregaCodPobl( "codpobl="+$scope.data.CodPobl );
	
	
	// Posem el focus al final del camp
	$timeout( function() {
		$('#DAlta').focus();
		var strLength= $scope.dAlta.length;
		$('#DAlta')[0].setSelectionRange(strLength, strLength);
      }, 400);		// Esperem a que es renderitzi la finestra modal

	
	$scope.canvi = function(opc) {
		$scope.delPremut = false;
		$scope.dangerMsg = '';
		$scope.campErr=[];	// netegem els errors de camps obligatoris
		
		if( opc=='email' ){
			if( $scope.campErr ) $scope.campErr[3] = false;
			$scope.emailErr =  !validateEmail( $scope.data.Email );

		} else if( opc=='data' ){
			$scope.dataErr = !validaData( document.getElementById('DAlta').value );
			
		} else if( opc=='cp' ){
			if( $scope.campErr ) $scope.campErr[5] = false;
			var codPos = $scope.codPos;
			$scope.cpErr = !	validarCodPos( codPos );	// cp incorrecte
			$scope.deplegaPobl = false;
			$scope.pobl = '';
			$scope.prov = '';
			if( !$scope.data ) $scope.data = {};		// (al Añadir)  No han omplert cap camp
			$scope.data.CodPobl = '';
			if( codPos && !$scope.cpErr ){
				$scope.carregaCodPobl( "codpos="+codPos );
			}

		} else if( opc=='pobl' ){
			if( $scope.campErr ) $scope.campErr[5] = false;
//$scope.CodPobl		=34987
//$scope.poblacions = [{"Codi":"34987","Pobl":"MASO, LA","Prov":"Tarragona"},{"Codi":"34997","Pobl":"MILA, EL","Prov":"Tarragona"}]
			var idx = document.getElementById('Poble').selectedIndex;
			if( idx===0 ){
				$scope.data.CodPobl = null;		// al onKeyUp encara no s'ha actualitzat el valor de data.CodPobl
				$scope.pobl = '';
				$scope.prov = '';
			} else {
				$scope.data.CodPobl = $scope.poblacions[idx-1].Codi;		// al onKeyUp encara no s'ha actualitzat el valor de data.CodPobl
				for( var i in $scope.poblacions ){
					if( $scope.poblacions[i].Codi==$scope.data.CodPobl ){
						$scope.pobl = $scope.poblacions[i].Pobl;
						$scope.prov = $scope.poblacions[i].Prov;
						break;
					}
				}
			}
		}

	};

	
	$scope.validacions = function() {
		$scope.campErr = [];		// posarem a true pq s'apliqui la classe has-error (marca el camp en vermell) 
		
		if( $scope.emailErr ) {
			$scope.dangerMsg = "eMail incorrecto...";
			$('#Email').focus();
			return false;
		}

		if( $scope.dataErr ) {
			$scope.dangerMsg = "Fecha incorrecta...";
			$('#DAlta').focus();
			return false;
		}
		
		if( $scope.cpErr ) {
			$scope.dangerMsg = "Código Postal incorrecto...";
			$('#CodPos').focus();
			return false;
		}

		var campsOblig = ["DAlta","Nom","Cognoms","Telef1","Email","Adre","CodPobl"];
		var campDescri = function(camp){
/*keysDB -Codi:			
			[Nom, Contacte, Telef1, Telef2, Email, Adre, CodPos, Prov, Pobl, Coment, NomAdmin, NIFAdmin]
		alias:
			["Centro", "Contacto", "Teléfono 1", "Teléfono 2", "eMail", "Dirección", "C.Postal", "Provincia", "Población", "Comentarios", "Administrador", "NIF admin."]
*/
			var alias =	{"DAlta":"F.Alta","Nom":"Nombre", "Cognoms":"Apellidos", "Telef1":"Teléfono 1", "Telef2":"Teléfono 2", "Email":"eMail", "Adre":"Dirección", 
									"CP":"C.Postal","Pobl":"Población", "Coment":"Comentarios", "CodPobl":"C.Postal / Población"};
			return alias[camp];
		};
		$scope.msgErr = '';
		try {
			if( !$scope.data ){		// (al Añadir)  No han omplert cap camp
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
						$('#'+camp).focus();
						return false;
					}
				}
			}
		}
		catch(err) {
			 $scope.msgErr = 'Error:' + err.message;
		}
		
		// formategem la data per guardar-la a la bbdd
		//http://stackoverflow.com/questions/18061757/angular-js-and-html5-date-input-value-how-to-get-firefox-to-show-a-readable-d
		$scope.data.DAlta = dateFilter( $scope.data.DAlta, 'yyyy-MM-dd' );
		
		return true;	//ok
	};
	
	
	$scope.add = function() {
		if( !$scope.validacions() ) return;
		
		$http.post("api/interessats.jsp", null, {"params":{"data": $scope.data}} )
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

		$http.put("api/interessats.jsp", null, {"params":{"data": $scope.data}} )
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
// L   validar que no estigui en us
//		if( !$scope.validaDel() ) return;
		
		if( !$scope.delPremut ) {
			$scope.delPremut = true;
			$scope.dangerMsg = 'Pulse otra vez para eliminar';
		} else {
			$http.delete("api/interessats.jsp", {"params":{"codi": $scope.codi}})
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
    	if(which == 13 && $event.target.type != 'textarea') {		// al camp Coment pinto els Return's
        	if($scope.codi) $scope.mod();
        							else $scope.add();
       	}
    };

});
