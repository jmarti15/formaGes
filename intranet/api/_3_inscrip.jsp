<%@ page language="java" contentType="text/html; charset=UTF-8"
	import = "java.util.*"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/dbInit.jsp" %>
<%
// 		Generem JSON sense cap llibreria (afegint {} i [] )

	Connection conn = null;
	int iRowCount = 0;
	String sCaps = "";
	String sLins = "";
	String sSizes = "";
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
				iRowCount = res.getRow();
				res.beforeFirst(); // not rs.first() because the rs.next() below will move on, missing the first element
			}

//			Interface ResultSetMetaData
// 		http://docs.oracle.com/javase/6/docs/api/java/sql/ResultSetMetaData.html

			ResultSetMetaData rsmd = res.getMetaData();
			int iNumCol = rsmd.getColumnCount();
			int colMaxLen[] = new int[iNumCol];

			// Calculem el width de cada columna (en %)
			String sTmp="";
			for (int i = 1; i <= iNumCol; i++) {
				sTmp = rsmd.getColumnLabel(i);
				colMaxLen[i-1] = sTmp.length();
			}
			while (res.next()) {
				for (int i = 1; i <= iNumCol; i++) {
					sTmp = res.getString(rsmd.getColumnLabel(i));
					if (sTmp.length()>colMaxLen[i-1]) colMaxLen[i-1] = sTmp.length();
				}
			}
			int iTotalLen=0; Double d;
			for (int i = 0; i <= iNumCol-1; i++) iTotalLen += colMaxLen[i];
			int colSize[] = new int[iNumCol];
			for (int i = 0; i <= iNumCol-1; i++) {
				d = Math.ceil( 100*colMaxLen[i]/iTotalLen );
				colSize[i] = d.intValue();
			}

			int iExtraCol = (iRowCount>11) ? 1 : 0;
			int iColSize;
			for (int i = 1; i <= iNumCol+iExtraCol; i++) {
				if (i==iNumCol+1) {
					sTmp = "";
					iColSize = 1;
				} 
				else {
					sTmp = rsmd.getColumnLabel(i);
					iColSize = colSize[i-1];
				}
				sCaps += "{\"size\":"+iColSize+",\"val\":\""+sTmp+"\"}";
				if (i<iNumCol+iExtraCol) sCaps += ",";
			}
			res.beforeFirst();
			while (res.next()) {
				sLins += "[";
				for (int i = 1; i <= iNumCol; i++) {
					sTmp = res.getString(rsmd.getColumnLabel(i));
					sLins += "{\"size\":"+colSize[i-1]+",\"val\":\""+sTmp+"\"}";
					if (i<iNumCol) sLins += ", ";
				}
				sLins += (res.isLast()) ? "]" : "],";
			}

			res.close();
			stmt.close();
			conn.close();
		}
	} catch (Exception e) {
		System.out.println("\n\n compoLlista -Error : "+e.getLocalizedMessage().toString());
	}
%>

<%= "{\"numLins\": "+iRowCount+", \"caps\":["+sCaps+"], \"lins\":["+sLins+"] }" 
//"{\"numLins\":13 ,       \"sizes\":["+sSizes+"],      \"caps\":["+sCaps+"], \"lins\":["+sLins+",[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi Joan Albert\",\"Martí \",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"],[\"2015-03-08\",\"Jordi\",\"Martí Cisteré\",\"Tarifa2\",\"Descompte3\",\"No\"]] }"
//"{\"numLins\": "+iRowCount+", \"caps\":["+sCaps+"], \"lins\":["+sLins+",[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}],[{\"size\":17,\"val\":\"2015-03-08=10\"},{\"size\":10,\"val\":\"Jordi=5\"},	{\"size\":23,\"val\":\"Martí Cisteré=13\"},	{\"size\":12,\"val\": \"Tarifa2=7\"}, {\"size\":17,\"val\": \"Descompte3=10\"}, {\"size\":17,\"val\": \"No=2\"}]"+"] }"
 %>

<%
   // Returns all employees (active and terminated) as json.
   response.setContentType("application/json");
%>