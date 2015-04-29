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
			SELECT C.Codi, C.Nom as Centro, Contacte as Contacto, Telef1 as Teléfono, Email as eMail, Adre as Dirección, P.Nom as Población 
			FROM Centres C JOIN Poblacions P ON C.CodPobl = P.Codi
			*/
			sSql = "SELECT C.Codi, C.Nom as Centro, Contacte as Contacto, Telef1 as Teléfono, Email as eMail, Adre as Dirección, P.Nom as Población ";
			sSql += "FROM Centres C JOIN Poblacions P ON C.CodPobl = P.Codi";
			jsonString = sSelect2Json( sSql, false );
		} else if(sCodi.equals("keys")) {			// keys				//+++++ NO CRIDAT
			sSql = "SELECT * FROM Centres LIMIT 1";
			jsonString = sKeys2Json( sSql );
		} else {												// pel form
			/*
			SELECT Codi, Nom, Contacte, Telef1, Telef2, Email, Adre, CodPobl, Coment, NomAdmin, NIFAdmin 
			FROM Centres WHERE Codi=1 
			*/
			sSql = "SELECT Codi, Nom, Contacte, Telef1, Telef2, Email, Adre, CodPobl, Coment, NomAdmin, NIFAdmin ";
			sSql += "FROM Centres WHERE Codi="+sCodi;
			
			/*
			SELECT C.Codi, C.Nom, Contacte, Telef1, Telef2, Email, Adre, CodPos, Po.Nom AS Pobl, Pr.Nom AS Prov, Coment, NomAdmin, NIFAdmin 
			FROM Centres C 
			JOIN Poblacions Po ON C.CodPobl = Po.Codi 
			JOIN Provincies Pr ON Po.CodProv = Pr.Codi 
			WHERE C.Codi=1 
			*/
/*			
			sSql = "SELECT C.Codi, C.Nom, Contacte, Telef1, Telef2, Email, Adre, CodPos, Po.Nom AS Pobl, Pr.Nom AS Prov, Coment, NomAdmin, NIFAdmin ";
			sSql += "FROM Centres C ";
			sSql += "JOIN Poblacions Po ON C.CodPobl = Po.Codi ";
			sSql += "JOIN Provincies Pr ON Po.CodProv = Pr.Codi ";
*/
			jsonString = sSelect2Json( sSql, true );
		}
	} 
	else if( sMtd.equals("POST")){			// db insert
		String sData = request.getParameter("data");
//	{"Nom":"Un punt de llum","Contacte":"Xus, Agnès i Mónica","Telef1":"666 12 23 34","Telef2":"777 123 456","Email":"llum@gmail.com","Adre":"Llevant, 2","CP":"08144","Prov":"Barcelona","Pobl":"Mediona","Coment":"Espai de trobada de Mediona","NomAdmin":"Xus","NIFAdmin":"39702772B"}

		/*
		INSERT INTO Centres (Nom, ..) VALUES ("Hipo N4", ..)
		*/
		String sSql = sInsertQuery( "Centres", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String sData = request.getParameter("data");
//	{"Codi":"1","Nom":"Un punt de llum","Contacte":"Xus, Agnès i Mónica","Telef1":"666 12 23 34","Telef2":"777 123 456","Email":"llum@gmail.com","Adre":"Llevant, 2","CP":"08144","Prov":"Barcelona","Pobl":"Mediona","Coment":"Espai de trobada de Mediona","NomAdmin":"Xus","NIFAdmin":"39702772B"}

		/*
		UPDATE Centres SET Nom="LPF N3", ... WHERE Codi=3
		*/
		String sSql = sUpdateQuery( "Centres", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("DELETE")){		// db delete
		String sCodi = request.getParameter("codi");
		/*
		DELETE FROM Centres WHERE Codi=6
		*/
		String sSql = "DELETE FROM Centres WHERE Codi="+sCodi;
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