<%@ page language="java" contentType="text/html; charset=UTF-8"
	import = "java.util.*"
	import = "org.json.simple.*"
    pageEncoding="UTF-8"%>
<%@ include file="../lib/funcions.jsp" %>
<%
	String sMtd = request.getMethod();
//	request.getParameter("opc")
System.out.println(sMtd);



/*
SELECT Codi, Nom AS Nivel FROM Nivells
*/
	String sSql = "SELECT Codi, Nom AS Nivel FROM Nivells";
	String jsonString = sSelect2Json( sSql );
/*
	Connection conn = null;
	String jsonString = "";
	try {
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		conn = DriverManager.getConnection(dbUrl,dbUser,dbPass);
		if (conn != null) {
			Statement stmt = conn.createStatement(); 
//
SELECT Codi, Nom AS Nivel FROM Nivells
//
			String sSql = "SELECT Codi, Nom AS Nivel FROM Nivells";
			ResultSet res = stmt.executeQuery( sSql );

			int iNumFil = 0;
			if (res.last()) {
				iNumFil = res.getRow();
				res.beforeFirst(); // not rs.first() because the rs.next() below will move on, missing the first element
			}

//			Interface ResultSetMetaData
// 		http://docs.oracle.com/javase/6/docs/api/java/sql/ResultSetMetaData.html
			ResultSetMetaData rsmd = res.getMetaData();
			int iNumCol = rsmd.getColumnCount();

			List  l = new LinkedList();
			Map m[] = new Map[iNumFil];
			int j = 0;
			while (res.next()) {
				m[j] = new LinkedHashMap();
				for (int i = 1; i <= iNumCol; i++) {
					m[j].put( rsmd.getColumnLabel(i), res.getString(rsmd.getColumnLabel(i)) );
				}
				l.add(m[j++]);
			}
			jsonString = JSONValue.toJSONString(l);

			res.close();
			stmt.close();
			conn.close();
		}
	} catch (Exception e) {
		System.out.println("\n\n /api/nivells.jsp -Error : "+e.getLocalizedMessage().toString());
	}
*/
%>

<%=jsonString%>

<%
   response.setContentType("application/json");
%>