<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
String sMtd = request.getMethod();
String jsonString = ""; 
//System.out.println( "paramMap:"+request.getParameterMap() );		// log

if( sMtd.equals("GET")){						// db select
	String sCodi = request.getParameter("codi");
	String sSql;
	if(sCodi==null) {								// per la taula
		/*
		SELECT I.Codi, Data as Fecha, A.Nom as Nombre, A.Cognoms as Apellidos, T.Nom as Tarifa, D.Nom as Descuento, 
			IF(Tripartita, 'Sí', 'No') as Tripartita
		FROM Inscripcions I
		INNER JOIN Alumnes A ON A.Codi = I.Alumne
		INNER JOIN Tarifes T ON T.Codi = I.Tarifa
		INNER JOIN Descomptes D ON D.Codi = I.Descompte
		*/
		sSql = "SELECT I.Codi, Data as Fecha, A.Nom as Nombre, A.Cognoms as Apellidos, T.Nom as Tarifa, D.Nom as Descuento, ";
		sSql += "IF(Tripartita, 'Sí', 'No') as Tripartita ";
		sSql += "FROM Inscripcions I ";
		sSql += "INNER JOIN Alumnes A ON A.Codi = I.Alumne ";
		sSql += "INNER JOIN Tarifes T ON T.Codi = I.Tarifa ";
		sSql += "INNER JOIN Descomptes D ON D.Codi = I.Descompte";
		jsonString = sSelect2Json( sSql, false );
	} else {												// pel form
		/*
		SELECT * FROM Inscripcions WHERE Codi = 1
		*/
		sSql = "SELECT * FROM Inscripcions WHERE Codi="+sCodi;
		jsonString = sSelect2Json( sSql, true );
	}
}
else if( sMtd.equals("POST")){			// db insert
	String sData = request.getParameter("data");
	/*
	INSERT INTO Inscripcions (Nom, ..) VALUES ("Nom", ..)
	*/
	String sSql = sInsertQuery( "Inscripcions", sData );
	int iRes = iExecQuery( sSql );
	JSONObject json = new JSONObject();
	json.put("res", iRes);
	jsonString = json.toJSONString();
}
else if( sMtd.equals("PUT")){				// db update
	String sData = request.getParameter("data");
	/*
	UPDATE Inscripcions SET Nom="Nom", ... WHERE Codi=3
	*/
	String sSql = sUpdateQuery( "Inscripcions", sData );
	int iRes = iExecQuery( sSql );
	JSONObject json = new JSONObject();
	json.put("res", iRes);
	jsonString = json.toJSONString();
}
else if( sMtd.equals("DELETE")){		// db delete
	String sCodi = request.getParameter("codi");
	/*
	DELETE FROM Inscripcions WHERE Codi=6
	*/
	String sSql = "DELETE FROM Inscripcions WHERE Codi="+sCodi;
	int iRes = iExecQuery( sSql );
	JSONObject json = new JSONObject();
	json.put("res", iRes);
	jsonString = json.toJSONString();
}
%>

<%=jsonString%>

<%
   response.setContentType("application/json");
%>