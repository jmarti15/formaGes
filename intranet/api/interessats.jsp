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
			SELECT I.Codi, I.Nom AS Nombre, Cognoms AS Apellidos, Adre AS Dirección, P.Nom AS Población, Telef1 AS Teléfono, Email AS eMail
			FROM Interessats I JOIN Poblacions P ON I.CodPobl = P.Codi
			*/
			sSql = "SELECT I.Codi, I.Nom AS Nombre, Cognoms AS Apellidos, Adre AS Dirección, P.Nom AS Población, Telef1 AS Teléfono, Email AS eMail ";
			sSql += "FROM Interessats I JOIN Poblacions P ON I.CodPobl = P.Codi";
			jsonString = sSelect2Json( sSql, false );
		} else {												// pel form
			/*
			SELECT * FROM Interessats WHERE Codi = 1
			*/
			sSql = "SELECT * FROM Interessats WHERE Codi="+sCodi;
			jsonString = sSelect2Json( sSql, true );
		}
	}
	else if( sMtd.equals("POST")){			// db insert
		String sData = request.getParameter("data");
// {"DAlta":"2015-05-02","Nom":"Jordi","Cognoms":"MC","Telef1":"605105350","Email":"dakar@tinet.cat","Adre":"Sales,+36","CodPobl":"38370"}
		/*
		INSERT INTO Interessats (Nom, ..) VALUES ("Hipo N4", ..)
		*/
		String sSql = sInsertQuery( "Interessats", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String sData = request.getParameter("data");
//	{"Codi":"1","Nom":"Joan","Cognoms":"Segarra+Alzina","Adre":"Maragall,+121","CodPobl":"12222","Telef1":"653105222","Telef2":null,"Email":"jsa@gmail.com","DAlta":"2015-08-18T00:00:00.000Z","CodOrganitzador":"0","PendentObrir":"0","Coment":""}
		/*
		UPDATE Interessats SET Nom="LPF N3", ... WHERE Codi=3
		*/
		String sSql = sUpdateQuery( "Interessats", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("DELETE")){		// db delete
		String sCodi = request.getParameter("codi");
		/*
		DELETE FROM Interessats WHERE Codi=6
		*/
		String sSql = "DELETE FROM Interessats WHERE Codi="+sCodi;
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