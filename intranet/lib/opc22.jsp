<!-- Centres  -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="lib/js/mod22.js"></script>
<script type="text/javascript" src="lib/js/angular-scrollable-table.js"></script>
<link href="css/scrollable-table.css" rel="stylesheet" type="text/css">
 
<div ng-app="mod22" ng-init="rootWidth=1000">
	<div ng-controller="centresCtrl" class="container" ng-style="{'width': rootWidth+'px'}">

		<form class="grup form-inline">
			<div class="form-group">
				<div class="input-group">
					<span class="input-group-addon"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></span>
					<input type="text" class="form-control" placeholder="Buscar" ng-model="search" ng-change="actualitza()">
					<span class="input-group-btn" ng-click="neteja()">
				    	<button class="btn btn-default" type="button"><strong>&times;</strong></button>
					</span>
				</div>
				<button class="btn btn-success" ng-click="detall(null)">Añadir</button>
			 </div>
		</form>
		
		<script>
			// Per evitar un botó per defecte (Añadir)
			document.onkeydown = function (ev) {
				var ret = true;
				ev.which = ev.which || ev.keyCode;
		   		if(ev.which == 13) ret = false;
		   		return ret;
			}
		</script>

		<scrollable-table watch="data">
			<table class="table table-striped table-bordered table-hover table-condensed">
				<thead>
					<tr>
						<th ng-repeat="key in dataKeys" sortable-header col="{{key}}" ng-hide="key == 'Codi'">{{key}}</th>
					</tr>
				</thead>
				<tbody>
					<tr ng-repeat="dataLin in data | filter:search" row-id="{{dataLin.Codi}}" ng-class="{info: selected == dataLin.Codi}" ng-click="detall(dataLin.Codi)">
						<td ng-repeat="key in dataKeys"  ng-hide="key == 'Codi'">{{dataLin[key]}}</td>
					</tr>
				</tbody>
			</table>
		</scrollable-table>
			
		<div class="grup pull-right">{{(data | filter:search).length}} filas<span ng-show="search"> (total: {{data.length}})</span></div>
   	</div>
</div>