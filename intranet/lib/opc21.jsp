<!-- Niveles  -->
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="lib/js/mod21.js"></script>
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
<div ng-app="mod21" ng-init="rootWidth=600">
	<div ng-controller="nivellsCtrl" class="container" ng-style="{'width': rootWidth+'px'}">

		<form class="grup form-inline">
			<div class="form-group">
				<div class="input-group">
					<span class="input-group-addon"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></span>
					<input type="text" class="form-control" placeholder="Buscar" ng-model="search" ng-change="actualitza()">
					<span class="input-group-btn" ng-click="neteja()">
				    	<button class="btn btn-default" type="button"><strong>&times;</strong></button>
					</span>
				</div>
				<button class="btn btn-success" ng-click="detall('')">Añadir</button>
			 </div>
		</form>

		<scrollable-table watch="data">
			<table class="table table-striped table-bordered table-hover table-condensed">
				<thead>
					<tr>
						<th ng-repeat="key in dataKeys" sortable-header col="{{key}}" ng-hide="key == 'Codi'">{{key}}</th>
					</tr>
				</thead>
				<tbody>
					<tr ng-repeat="dataLin in data | filter:search" row-id="{{dataLin.Codi}}" ng-class="{info: selected == dataLin.Codi}"  ng-click="detall(dataLin)">
						<td ng-repeat="key in dataKeys"  ng-hide="key == 'Codi'">{{dataLin[key]}}</td>
					</tr>
				</tbody>
			</table>
		</scrollable-table>
			
		<div class="grup pull-right">{{(data | filter:search).length}} filas<span ng-show="search"> (total: {{data.length}})</span></div>
   	</div>
</div>