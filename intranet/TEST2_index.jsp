<!DOCTYPE html>
<html lang="en">
<head>
  
  <%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
	<!--  
    <link rel="stylesheet" type="text/css" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
	-->
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css"></link>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css"></link>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.15/angular.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular-sanitize.min.js"></script>
 <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.12.0/ui-bootstrap-tpls.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.13/angular-ui-router.min.js"></script>
  	<!--
    <script type="text/javascript" src="http://codeorigin.jquery.com/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="http://code.angularjs.org/1.2.19/angular.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular.min.js"></script>
	-->

<!-- If you are not sure which module is missing, use the not minified angular.js which gives a readable error message -->
<!--
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.css"></link>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.css"></link>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular-sanitize.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.12.0/ui-bootstrap-tpls.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.13/angular-ui-router.js"></script>
-->

	<script type="text/javascript" src="lib/js/angular-scrollable-table.js"></script>
	<link href="css/scrollable-table.css" rel="stylesheet" type="text/css">

	<link type="text/css" rel="stylesheet" charset="utf-8" href="css/estil.css">
	<script src="lib/js/mod11.js"></script>
</head>
  
<body ng-app="mod11" ng-init="rootWidth=1200">
	<div ng-controller="clientsCtrl" class="container" ng-style="{'width': rootWidth+'px'}">

		<form class="grup form-inline">
			<div class="form-group">
				<div class="input-group">
					<span class="input-group-addon"><span class="glyphicon glyphicon-search" aria-hidden="true"></span></span>
					<input type="text" class="form-control" placeholder="Buscar" ng-model="searchFish" ng-change="actualitza()">
					<span class="input-group-btn" ng-click="neteja()">
				    	<button class="btn btn-default" type="button"><strong>&times;</strong></button>
					</span>
				</div>
			 </div>
		</form>

		<scrollable-table watch="visibleProjects">
			<table class="table table-striped table-bordered">
				<thead>
					<tr>
						<th ng-repeat="key in keys(projectsCap)" sortable-header col="{{key}}">{{key}}</th>
					</tr>
				</thead>
				<tbody>
<!-- 				<tr ng-repeat="response in visibleProjects | filter:searchFish" row-id="{{ response.facility }}" ng-class="{info: selected == response.facility}" >	-->
					<tr ng-repeat="response in visibleProjects | filter:searchFish" row-id="{{ response.Nombre }}" ng-class="{info: selected == response.Nombre}" >
						<td ng-repeat="key in projectsKeys">{{response[key]}}</td>
					</tr>
				</tbody>
			</table>
		</scrollable-table>
			
		<div class="grup pull-right">{{(visibleProjects | filter:searchFish).length}} filas<span ng-show="searchFish"> (total: {{visibleProjects.length}})</span></div>

<!--
    1: {{visibleProjects}}<br><br>
    2: {{projectsCap}}<br><br>
    3: {{projectsKeys}}<br><br>
-->

		<button ng-click="descargaArchivo()">Actualitzar</button>
		
	</div>
</body> 
