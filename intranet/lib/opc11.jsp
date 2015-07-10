<!-- Inscripciones  -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="lib/js/mod11.js"></script>
<script type="text/javascript" src="lib/js/angular-scrollable-table.js"></script>
<link href="css/scrollable-table.css" rel="stylesheet" type="text/css">
 
<!--
 <div class="container" ng-app="mod11" ng-controller="clientsCtrl">
	<table class="llista table table-striped table-hover table-condensed">
		<thead><tr>
			<th ng-repeat="cap in caps" style="width: {{cap.size}}%;">{{cap.val}}</th>
		</tr></thead>
		<tbody>
			<tr ng-repeat="client in clientList">
				<td ng-repeat= "camp in client" style="width: {{camp.size}}%;">{{camp.val}}</td>
			</tr>
		</tbody>
	</table>	
-->
<div ng-app="mod11" ng-init="rootWidth=1000">
	<div ng-controller="opcCtrl" class="container" ng-style="{'width': rootWidth+'px'}">
		<h2>Gestión de Inscripciones</h2>
<!-- 
{{data}}<br><br>
{{dataCap}}<br><br>
{{dataKeys}}<br><br>
-->
		<form class="grup form-inline">
			<div class="form-group">
				<div class="input-group">
					<span class="input-group-addon"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></span>
					<input type="text" class="form-control" placeholder="Buscar" ng-model="search" ng-change="actualitza()">
					<span class="input-group-btn" ng-click="neteja()">
				    		<button class="btn btn-default" type="button"><strong>&times;</strong></button>
					</span>
				</div>
				<button class="btn btn-success" ng-disabled="selected" ng-click="detall(null)">Añadir</button>
			 </div>
		</form>

		<script>
			// Per evitar un botó per defecte (Añadir)
			document.onkeydown = function (ev) {
				var ret = true;
				ev.which = ev.which || ev.keyCode;
				if(ev.which == 13 && ev.target.type != 'textarea') ret = false;	// accepto els Return's als camps textarea (Coment, ...)
		   		return ret;
			}
		</script>
		
		<scrollable-table watch="data" >
			<table class="table table-striped table-bordered table-hover table-condensed">
				<thead>
					<tr>
						<th ng-repeat="key in dataKeys" sortable-header col="{{key}}" ng-hide="key == 'Codi'">{{key}}</th>
					</tr>
				</thead>
				<tbody>
					<tr ng-repeat="dataLin in data | filter:search" row-id="{{dataLin.Codi}}" ng-class="{info: selected == dataLin.Codi}" ng-click="detall(dataLin.Codi)">
						<td ng-repeat="key in dataKeys" ng-hide="key == 'Codi'">{{dataLin[key]}}</td>
					</tr>
				</tbody>
			</table>
		</scrollable-table>

		<div class="grup pull-right">{{(data | filter:search).length}} filas<span ng-show="search"> (Total: {{data.length}})</span></div>
   		<button ng-click="getData()"><span class="glyphicon glyphicon-refresh" aria-hidden="true" ></span> Actualizar</button>
   	</div>
   	
   	<br><br>
   	<div ng-controller="detallCtrl" class="container" ng-style="{'width': '1000px'}" ng-hide="detOcult">
{{data}}<br><br>{{alumne}}
		<div class="panel panel-warning">
      		<div class="panel-heading"><h3>Detalle de la Inscripción</h3></div>
      		
      		<div class="panel-body" ng-keydown="execDefault($event)">
				<form class="form-horizontal">
			  		<div class="form-group" ng-class="{'has-error': dataErr || campErr[0]}">
			  			<label class="col-sm-3 control-label">Fecha</label>
						<div class="col-sm-9">
							<p class="input-group">
								<input type="text" class="form-control" id="Data" date-fix datepicker-popup="dd/MM/yy" ng-model="data.Data" is-open="opened" datepicker-options="dateOptions" current-text="Hoy" clear-text="Borrar" close-text="Salir"  ng-change="canvi('data')" ng-keyup="dataKey($event)">
								<span class="input-group-btn">
									<button type="button" class="btn btn-default" ng-click="dataOpen($event)"><i class="glyphicon glyphicon-calendar"></i></button>
								</span>
							</p>
						</div>
			  		</div>
			  		<div class="form-group">
						<label class="col-sm-3 control-label">Alumno</label>
						<div class="col-sm-9">
							<p class="input-group">
								<input type="text" class="form-control"  ng-model="nomAlu"  disabled>
								<span class="input-group-btn">
									<button type="button" class="btn btn-default" ng-click="dataOpen($event)"><i class="glyphicon glyphicon-log-out"></i></button>
								</span>
								<span class="input-group-btn">
									<button type="button" class="btn btn-default" ng-click="aluDetall()"><i class="glyphicon glyphicon-option-horizontal"></i></button>
																													<!-- aluOcult=false -->
								</span>
 							</p>
						</div>
			  		</div>
			  	</form>

<!-- 
				<div class="panel panel-info" ng-hide="aluOcult">
      				<div class="panel-heading">Detalle del Alumno</div>
      				<div class="panel-body">
xxx
		      		</div>
					<div class="panel-footer text-right">
						<button class="btn btn-info" ng-click="aluMod()">Modificar</button>
						<button class="btn btn-warning" ng-click="aluCancel()">Cerrar</button>
      				</div>
      			</div>
-->		
      		
      		
      		
      		
      		</div>
      		
			<div class="panel-footer text-right">
				<div class="alert alert-danger" role="alert" ng-show="dangerMsg">
					  <span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
					  {{dangerMsg}}
				</div>
				<button class="btn btn-success" ng-show="!codi" ng-click="add()">Añadir</button>
				<button class="btn btn-info" ng-show="codi" ng-click="mod()">Modificar</button>
				<button class="btn" ng-class="delPremut ? 'btn-danger' : 'btn-warning'" ng-show="codi" ng-click="del()">Eliminar</button>
				<button class="btn btn-warning" ng-click="cancel()">Salir</button>
			</div>
    		</div>
   	</div>
</div>