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
			SELECT Codi, Nom AS Nombre, DInicial AS 'F.Inicial',
				CASE Percent WHEN 0 THEN CONCAT(NouImport,' €') ELSE CONCAT(Percent,'%') END AS Descuento,
				MinAlumnCentre AS 'Mín.Alum.'
			FROM Descomptes
			*/
			sSql = "SELECT Codi, Nom AS Nombre, DInicial AS 'F.Inicial', ";
			sSql += "CASE Percent WHEN 0 THEN CONCAT(NouImport,' €') ELSE CONCAT(Percent,' %') END AS Descuento, ";
			sSql += "MinAlumnCentre AS 'Mín.Alum.' ";
			sSql += "FROM Descomptes";
			jsonString = sSelect2Json( sSql, false );
		} else {												// pel form
			/*
			SELECT * FROM Descomptes WHERE Codi = 1
			*/
			sSql = "SELECT * FROM Descomptes WHERE Codi="+sCodi;
			jsonString = sSelect2Json( sSql, true );
		}
	}
	else if( sMtd.equals("POST")){			// db insert
		String sData = request.getParameter("data");
		/*
		INSERT INTO Descomptes (Nom, ..) VALUES ("Nom", ..)
		*/
		String sSql = sInsertQuery( "Descomptes", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String sData = request.getParameter("data");
		/*
		UPDATE Descomptes SET Nom="Nom", ... WHERE Codi=3
		*/
		String sSql = sUpdateQuery( "Descomptes", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("DELETE")){		// db delete
		String sCodi = request.getParameter("codi");
		/*
		DELETE FROM Descomptes WHERE Codi=6
		*/
		String sSql = "DELETE FROM Descomptes WHERE Codi="+sCodi;
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