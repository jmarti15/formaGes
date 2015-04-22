<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
	String sMtd = request.getMethod();
	String jsonString = ""; 
//System.out.println( "paramMap:"+request.getParameterMap() );		// log

	if( sMtd.equals("GET")){						// db select
		String sCodi = request.getParameter("codi");
		/*
		SELECT Codi, Nom as Centro, Contacte as Contacto, Telef1 as 'Teléfono 1', Telef2 as 'Teléfono 2', Email as eMail, Adre as Dirección, 
			CP as 'C.Postal', Prov as Provincia, Pobl as Población, Coment as Comentarios, NomAdmin as Administrador, NIFAdmin as 'NIF admin.'
		FROM Centres
		
		SELECT Codi, Nom as Centro, Contacte as Contacto, Telef1 as Teléfono, Email as eMail, Adre as Dirección, Pobl as Población FROM Centres
		*/
		String sSql;
		if(sCodi==null) {								// per la taula
			sSql = "SELECT Codi, Nom as Centro, Contacte as Contacto, Telef1 as Teléfono, Email as eMail, Adre as Dirección, Pobl as Población ";
			sSql += "FROM Centres";
			jsonString = sSelect2Json( sSql, false );
		} else if(sCodi.equals("keys")) {			// keys
			sSql = "SELECT * FROM Centres LIMIT 1";
			jsonString = sKeys2Json( sSql );
		} else {												// pel form
			sSql = "SELECT Codi, Nom as Centro, Contacte as Contacto, Telef1 as 'Teléfono 1', Telef2 as 'Teléfono 2', ";
			sSql += "Email as eMail, Adre as Dirección, CP as 'C.Postal', Prov as Provincia, Pobl as Población, ";
			sSql += "Coment as Comentarios, NomAdmin as Administrador, NIFAdmin as 'NIF admin.' ";
			sSql += "FROM Centres WHERE Codi="+sCodi;
			jsonString = sSelect2Json( sSql, true );
		}
	} 
	else if( sMtd.equals("POST")){			// db insert
		String[] aKeys = request.getParameterValues("keys");
//	[Codi, Nom, Contacte, Telef1, Telef2, Email, Adre, CP, Prov, Pobl, Coment, NomAdmin, NIFAdmin]
		String sData = request.getParameter("data");
//  {"Centro":"1","Contacto":"2","Teléfono 1":"3","Teléfono 2":"4","eMail":"5","Dirección":"6","C.Postal":"7","Provincia":"8","Población":"9","Comentarios":"0","Administrador":"00","NIF admin.":"000"}

		/*
		INSERT INTO Centres (Nom) VALUES ("Hipo N4")
		*/
		String sSql = sInsertQuery( "Centres", aKeys, sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String[] aKeys = request.getParameterValues("keys");
//  ["Codi","Nom","Contacte","Telef1","Telef2","Email","Adre","CP","Prov","Pobl","Coment","NomAdmin","NIFAdmin"]
		String sData = request.getParameter("data");
//  {"Codi":"1","Centro":"Un punt de llum","Contacto":"Xus, Agnès i Mónica","Teléfono 1":"666 12 23 34","Teléfono 2":"777 123 456","eMail":"llum@gmail.com","Dirección":"llevant, 2","C.Postal":"08144","Provincia":"Barcelona","Población":"Mediona","Comentarios":"Espai de trobada de Mediona","Administrador":"Xus","NIF admin.":"39702777X"}

		/*
		UPDATE Centres SET Nom="LPF N3", ... WHERE Codi=3
		*/
		String sSql = sUpdateQuery( "Centres", aKeys, sData );		
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