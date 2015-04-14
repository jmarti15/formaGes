<%@ page language="java" contentType="text/html; charset=UTF-8"
	import = "java.util.*"
    pageEncoding="UTF-8"%>
<%@ include file="dbInit.jsp" %>
<%
	Connection conn = null;
	int rowcount = 0;
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		conn = DriverManager.getConnection(dbUrl,dbUser,dbPass);
		if (conn != null) {
			Statement stmt = conn.createStatement();
/*
SELECT Data as Fecha, A.Nom as Nombre, A.Cognoms as Apellidos, T.Nom as Tarifa, D.Nom as Descuento, 
	IF(Tripartita, 'Sí', 'No') as Tripartita
FROM Inscripcions I
INNER JOIN Alumnes A ON A.Codi = I.Alumne
INNER JOIN Tarifes T ON T.Codi = I.Tarifa
INNER JOIN Descomptes D ON D.Codi = I.Descompte
*/
			String sSql = "SELECT Data as Fecha, A.Nom as Nombre, A.Cognoms as Apellidos, T.Nom as Tarifa, D.Nom as Descuento, ";
			sSql += "IF(Tripartita, 'Sí', 'No') as Tripartita ";
			sSql += "FROM Inscripcions I ";
			sSql += "INNER JOIN Alumnes A ON A.Codi = I.Alumne ";
			sSql += "INNER JOIN Tarifes T ON T.Codi = I.Tarifa ";
			sSql += "INNER JOIN Descomptes D ON D.Codi = I.Descompte";
			ResultSet res = stmt.executeQuery( sSql );

			if (res.last()) {
			  rowcount = res.getRow();
			  res.beforeFirst(); // not rs.first() because the rs.next() below will move on, missing the first element
			}
			
///////////////////////////////
//			Interface ResultSetMetaData
// 		http://docs.oracle.com/javase/6/docs/api/java/sql/ResultSetMetaData.html

			ResultSetMetaData rsmd = res.getMetaData();
			int iNumCol = rsmd.getColumnCount();
			int iWidth = 100 / iNumCol;
/*			  
			for (int i = 1; i <= rsmd.getColumnCount(); i++) {
				out.write(rsmd.getColumnName(i)+"/"+rsmd.getColumnLabel(i)+"<br>"  );					// nom de la columna / alias (as alias_name)
			}
*/
///////////////////////////////
%>
<div class="llista"><form action="index.jsp" method="post" novalidate>
	<table class="llista" border="1" style="width:100%">
		<thead>
			<tr>
				<% for (int i = 1; i <= iNumCol; i++) { %>
				<th style="width: <%= iWidth %>%;"><%= rsmd.getColumnLabel(i) %></th>
				<% } %>
<!-- 
				<th>Fecha</th>
				<th>Nombre</th>
				<th>Apellidos</th>
 -->
				<th> </th>				<!-- per alinear amb la barra d'scroll -->
<% if(rowcount > 11) { %>
				<th> </th>				<!-- per alinear amb la barra d'scroll -->
<% } %>
	  		</tr>
		</thead>
  		<tbody>
<%		while (res.next()) { %>
<!-- 
			<tr>
				<td><button name="inscrip" value="13" >Jill jill jill</button></td>
				<td>Smith</td>		
				<td>50</td>
			</tr>
			<tr><td>Eve</td><td>Jackson</td><td>94</td></tr>
 -->
 <%		} %>
			<tr><td style="width: 16%;">2015-03-08</td><td style="width: 16%;">Jordi</td><td style="width: 16%;">Martí Cisteré</td><td style="width: 16%;">Tarifa2</td><td style="width: 16%;">Descompte3</td><td style="width: 16%;">No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
			<tr><td>2015-03-08</td><td>Jordi</td><td>Martí Cisteré</td><td>Tarifa2</td><td>Descompte3</td><td>No</td></tr>
		</tbody>
	</table>
	<input type="hidden" name="sessionid" value="<%=request.getParameter("sessionid")%>">
	<input type="hidden" name="opc" value="<%= request.getParameter("opc") %>">
</form></div>
<%
			res.close();
			stmt.close();
			conn.close();
		}
	} catch (Exception e) {
		System.out.println("\n\n compoLlista -Error : "+e.getLocalizedMessage().toString());
	}
%>