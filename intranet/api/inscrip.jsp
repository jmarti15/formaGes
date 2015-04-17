<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
/*
SELECT I.Codi, Data as Fecha, A.Nom as Nombre, A.Cognoms as Apellidos, T.Nom as Tarifa, D.Nom as Descuento, 
	IF(Tripartita, 'Sí', 'No') as Tripartita
FROM Inscripcions I
INNER JOIN Alumnes A ON A.Codi = I.Alumne
INNER JOIN Tarifes T ON T.Codi = I.Tarifa
INNER JOIN Descomptes D ON D.Codi = I.Descompte
*/
	String sSql = "SELECT I.Codi, Data as Fecha, A.Nom as Nombre, A.Cognoms as Apellidos, T.Nom as Tarifa, D.Nom as Descuento, ";
	sSql += "IF(Tripartita, 'Sí', 'No') as Tripartita ";
	sSql += "FROM Inscripcions I ";
	sSql += "INNER JOIN Alumnes A ON A.Codi = I.Alumne ";
	sSql += "INNER JOIN Tarifes T ON T.Codi = I.Tarifa ";
	sSql += "INNER JOIN Descomptes D ON D.Codi = I.Descompte";
	String jsonString = sSelect2Json( sSql );
%>

<%=jsonString%>

<%
   response.setContentType("application/json");
%>