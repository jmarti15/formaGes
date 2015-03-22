<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<script src="lib/js/mod11.js"></script>
 
 <div class="container" ng-app="mod11" ng-controller="clientsCtrl">
	<table class="table table-striped table-hover table-condensed" style="table-layout:fixed; margin-bottom: 0px;">
		<thead><tr>
			<td ng-repeat="cap in caps">{{cap}}</td>
			<td ng-if= "numLins > 11" style="width: 14px;"></td>		<!-- per alinear amb la barra d'scroll -->
		</tr></thead>
	</table>	
	<div style="overflow-y: auto; height: 200px;">
		<table class="table table-striped table-hover table-condensed" class="table table-condensed"  style="table-layout:fixed">
			<tbody>
				<tr ng-repeat="client in clientList">
					<td ng-repeat= "camp in client">{{camp}}</td>
				</tr>
			</tbody>
		</table>	
	</div>
 	
 	<button ng-click="descargaArchivo()">Actualitzar</button>
</div>