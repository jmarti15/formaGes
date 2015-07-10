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
			SELECT Codi, Nom AS Nombre, DInicial AS "F.Inicial", Import AS Importe, NumLinies AS "Núm.Líneas"
			FROM Tarifes
			*/
			sSql = "SELECT Codi, Nom AS Nombre, DInicial AS \"F.Inicial\", Import AS Importe, NumLinies AS \"Núm.Líneas\" ";
			sSql += "FROM Tarifes";
			jsonString = sSelect2Json( sSql, false );
		} else {												// pel form
			/*
			SELECT * FROM Tarifes WHERE Codi = 1
			*/
			sSql = "SELECT * FROM Tarifes WHERE Codi="+sCodi;
			jsonString = sSelect2Json( sSql, true );
		}
	}
	else if( sMtd.equals("POST")){			// db insert
		String sData = request.getParameter("data");
		/*
		INSERT INTO Tarifes (Nom, ..) VALUES ("1 nivell", ..)
		*/
		String sSql = sInsertQuery( "Tarifes", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("PUT")){				// db update
		String sData = request.getParameter("data");
		/*
		UPDATE Tarifes SET Nom="1 nivell", ... WHERE Codi=3
		*/
		String sSql = sUpdateQuery( "Tarifes", sData );
		int iRes = iExecQuery( sSql );
		JSONObject json = new JSONObject();
		json.put("res", iRes);
		jsonString = json.toJSONString();
	}
	else if( sMtd.equals("DELETE")){		// db delete
		String sCodi = request.getParameter("codi");
		/*
		DELETE FROM Tarifes WHERE Codi=6
		*/
		String sSql = "DELETE FROM Tarifes WHERE Codi="+sCodi;
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