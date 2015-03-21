<%@ page language="java" contentType="text/html; charset=UTF-8" session="false" import="java.sql.*"
    import="java.io.*"
    import="java.security.MessageDigest"
    import="java.util.Date"
    import="java.text.SimpleDateFormat"
		import = "java.util.Map"    
    pageEncoding="UTF-8"
%>
<%!
	public static int iNivellUsuari( String sUser ) {
		int iNivell = -1;
		String url = "jdbc:mysql://localhost:3306/LPFGest";
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(url,"admin","1234");
			if (conn != null) {
				Statement stmt = conn.createStatement();
				ResultSet res = stmt.executeQuery( "SELECT nivell FROM Usuaris where nom='"+sUser+"'" );
				if( res.next() ) {
					iNivell = res.getInt("nivell");				
				}
				res.close();
				stmt.close();
				conn.close();
			}
		} catch (Exception e) {
			System.out.println("\n\niNivellUsuari -Error : "+e.getLocalizedMessage().toString());
		}
		return iNivell;
	}

	public static boolean acces(String sUser, String sPass, String sLlavor, Contenidor Nivell) {
/*
out.println( "User: "+request.getParameter("user")+"<br/>" );
out.println( "Psw: "+request.getParameter("pass")+"<br/>" );
out.println( "PswEnc: "+request.getParameter("passH")+"<br/>" );
*/
		boolean bAcces = false;
		String url = "jdbc:mysql://localhost:3306/LPFGest";
		Connection conn = null;
		try {
			Class.forName("com.mysql.jdbc.Driver").newInstance();
			conn = DriverManager.getConnection(url,"admin","1234");
			if (conn != null) {
//System.out.println("Conexión a base de datos " + url + " ... Ok");				
				Statement stmt = conn.createStatement();
				ResultSet res = stmt.executeQuery( "SELECT psw, nivell FROM Usuaris where nom='"+sUser+"'" );
				if( res.next() ) {
					String sPsw  = res.getString("psw");
//System.out.println( "Psw_BD: "+sPsw );
					String sPswHash = sha256(sPsw+sLlavor);
//System.out.println( "Psw_H : "+sPswHash );
					bAcces = sPswHash.equals(sPass);
//System.out.println( "Pass  : "+sPass );
				}
				if( bAcces )
					Nivell.setInt( res.getInt("nivell") );
/*
				if(bAcces) {
System.out.println("Accés correcte: "+sUser);
				} 
				else
System.out.println("Accés INcorrecte");
//					out.println("User/Psw incorrecte<br/>");
*/					
				res.close();
				stmt.close();
				conn.close(); 
			}
			
		} catch (Exception e) {
			System.out.println("\n\nacces -Error : "+e.getLocalizedMessage().toString());
		}
		return bAcces;
	}

	public static Cookie borraCookie( ) {
		// Borrem cookie
		Cookie unCookie = new Cookie("user", null);
		unCookie.setPath("/");
		unCookie.setMaxAge(0);
		return unCookie;
	}

	public static String sha256(String sPsw) {
		try{
			MessageDigest digest = MessageDigest.getInstance("SHA-256");
			// byte[] hash = digest.digest(sPsw.getBytes("UTF-8"));
			//   Equival a:
			digest.update(sPsw.getBytes("UTF-8"));
			byte[] hash = digest.digest();
		    
		  StringBuffer hexString = new StringBuffer();
		  for (int i = 0; i < hash.length; i++) {
				/*
		    String hex = Integer.toHexString(0xff & hash[i]);
		    if(hex.length() == 1) hexString.append('0');
		    hexString.append(hex);
					Equival a:
				*/
				hexString.append(Integer.toString((hash[i] & 0xff) + 0x100, 16).substring(1));
		  }
			return hexString.toString();
			
	  } catch(Exception ex){
	  	throw new RuntimeException(ex);
	  }
	}

	public static String getClientIpAddr(HttpServletRequest request) {
	  String ip = request.getHeader("X-Forwarded-For");
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
    	ip = request.getHeader("Proxy-Client-IP");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	  	ip = request.getHeader("WL-Proxy-Client-IP");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	  	ip = request.getHeader("HTTP_CLIENT_IP");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	  	ip = request.getHeader("HTTP_X_FORWARDED_FOR");
	  }
	  if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
	  	ip = request.getRemoteAddr();
	  }
	  return ip;
  }
	
	class Contenidor{
		private int i;
		
		public void setInt(int ii){
	        this.i=ii;    
		}
		public int getInt(){
	        return this.i;    
		}
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<%
/// Mostro tots els paràmetres rebuts (GET+POST)
Map<String, String[]> parameters = request.getParameterMap();
for(String parameter : parameters.keySet())
	out.println( parameter+"="+request.getParameter(parameter)+"<br/>" );
out.println("===============================================================<br/>");
///

	boolean bLogin = request.getParameter("login") != null;

///	boolean bCliEnter = request.getParameter("cli_enter") != null;

	boolean bLogout = request.getParameter("opc")!=null && request.getParameter("opc").equals("7");
	boolean bConsulta = request.getParameter("opc")!=null && !request.getParameter("opc").equals("7");

	boolean bAccess=false, bAccVal=true, bMostraLoginForm=false, bMostraMenu=false;
	boolean bEntrant = !bLogin && !bConsulta && !bLogout;
///
out.println("bEntrant="+(bEntrant?"T":"F")+"  bLogin="+(bLogin?"T":"F")+"  bConsulta="+(bConsulta?"T":"F")+
						  "  bLogout="+(bLogout?"T":"F")+"  bAccess="+(bAccess?"T":"F")+"<br/>");
///
	HttpSession sesion=null;
	String sLlavor="000000", sSessID="", sIP="", sUser="";
	int iNivell=-1;
	
	if( bEntrant || bLogin || bConsulta || bLogout ) sesion = request.getSession();
	if( sesion != null ) sSessID = sesion.getId();
	sIP = getClientIpAddr(request);


	// Consulta
	if (bConsulta) {
		// Control d'accés vàlid (SessionId i IP)
		String sReqSess = request.getParameter("sessionid");
		String sReqIP = (String)sesion.getAttribute("ip");
//System.out.println( "==Sessió==" );
//System.out.println( "id "+sReqSess );
//System.out.println( "ip "+sReqIP );
//System.out.println( "user "+(String)sesion.getAttribute("user") );
		if( !sReqSess.equals(sSessID) ) {
			bAccVal = false;
			out.println("Session Err"+"<br/>");
		}
		if( !sReqIP.equals(sIP) ) {
			bAccVal = false;
			out.println("IP Err"+"<br/>");
		}
		iNivell = (Integer)sesion.getAttribute("nivell");
System.out.println( "Nivell : "+iNivell );		///FORA
/// L  Si el nivell de l'usuari és suficient pel menú && bAccVal
		if(bAccVal) bMostraMenu=true;

///    L  mostrar el formulari demanat (x opció de menú)
		String sOpc = request.getParameter("opc");
		if( sOpc.equals("11") ) {
			%>
			<div>
				<jsp:include page="lib/menu.html" />
			</div>
			<%
		}
	}


	// Logout
	if (bLogout) {
		sesion.invalidate();												// Finalitzem sessió
		response.addCookie(borraCookie());		// Borrem cookie
	}


	// Petició login
	if(bEntrant) {
		if( !sesion.isNew() ) {
			sesion.invalidate();
			sesion = request.getSession();
		}

		// Busquem cookie
		Cookie unCookie=null;
		Cookie [] todosLosCookies = request.getCookies();
		for (int i=0; i<todosLosCookies.length; i++) { 
			unCookie = todosLosCookies[i];
			if( unCookie.getName().equals("user") ) {
				// Accés automàtic
				sUser = unCookie.getValue();
				bAccess = true;
				break;
			}
		}

		if (!bAccess) {	// Si no entrem automàticament per cookie
			// Generem llavor pel xifrat
			Date dNow = new Date( );
			SimpleDateFormat ft = new SimpleDateFormat ("E yyyy.MM.dd 'at' hh:mm:ss a zzz");
			String sData = ft.format(dNow);
			sLlavor = sha256(sData+sIP);
			sesion.setAttribute("llavor",sLlavor);
			bMostraLoginForm=true;								// Mostrem login form 
		}
	}


	// Login
	if(bLogin) {
		sUser = request.getParameter("user")!=null ? request.getParameter("user") : "";
		String sPass = request.getParameter("passH")!=null ? request.getParameter("passH") : "";
		if(sUser!="" && sPass!="") {
			Date dAra = new Date();
			long lTemps = dAra.getTime() - sesion.getCreationTime();
			Date dTemps = new Date(lTemps);
//System.out.println("Temps: "+dTemps.getMinutes()+"min."+dTemps.getSeconds()+"seg");
			if( dTemps.getMinutes() > 0 ) {
				sesion.invalidate();
				out.println("El tiempo para iniciar sesión ha finalizado. Recuerde que dispone de 60 segundos"+"<br/>");
			}
			else {
				Contenidor objNivell = new Contenidor();
				bAccess = acces(sUser, sPass, (String)sesion.getAttribute("llavor"), objNivell);
				iNivell = objNivell.getInt();
			}
		}	else
			out.println("NO user/psw"+"<br/>");
	}


	// Cookie o login ok? 
	if( bEntrant || bLogin ) {
		if( bAccess ){
			sesion.setAttribute("ip",sIP);
			sesion.setAttribute("user",sUser);
			if( iNivell==-1 ) iNivell = iNivellUsuari(sUser);
			sesion.setAttribute("nivell",iNivell);

			// Si petició login o login+recordar
			if ( bEntrant || (request.getParameter("recordar") != null) ) {
				// Desem cookie
				Cookie unCookie = new Cookie("user",sUser);
				unCookie.setPath("/");
				unCookie.setMaxAge(60*60*24*31);
				response.addCookie(unCookie);
			} else
				// Borrem cookie (per si existia d'una sessió anterior)
				response.addCookie(borraCookie());

				bMostraMenu=true;
//			out.println("Accés ok!");
		} else
			out.println("NO ACCESS..."+"<br/>");
	}

	if(bMostraMenu) {
		%>
		<div>
			<jsp:include page="lib/menu.html" />
		</div>
		<%
	}
	
///
//out.println("bEntrant="+(bEntrant?"T":"F")+"  bLogin="+(bLogin?"T":"F")+"  bCliEnter="+(bCliEnter?"T":"F")+
//						  "  bLogout="+(bLogout?"T":"F")+"  bAccess="+(bAccess?"T":"F")+"<br/>");
///
%>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Low Pressure Fitness Gestión</title>
	<link type="image/x-icon" href="img/lpf13.ico" rel="shortcut icon">
	<link type="text/css" rel="stylesheet" charset="utf-8" href="css/estil.css">
	<script type="text/javascript" charset="utf-8" src="lib/sha2.js"></script>
	<script language="javascript" type="text/javascript">
		<!-- hide this script tag's contents from old browsers
	
		function controla(ev) {
/*			
			if(ev.keyCode == 27) {		// ESC
				document.getElementById("login_form").style.display="none";
			}
*/
		}
		
		function encrypt() {
			//var Pass = document.entrar.pass;
			var Pass = document.getElementsByName("pass")[0];
			//var PassH = document.entrar.passH;
			var PassH = document.getElementsByName("passH")[0];
			
			var sha2_pre=hex_sha256(Pass.value);
			var sha2=hex_sha256(sha2_pre+"<%out.print(sLlavor);%>");
			PassH.value=sha2;

			// No el deixem en blanc, posarem tants * com caràcters tenia pass
			var sTmp = '';
			for (i = 0; i < Pass.value.length; i++) { sTmp += "*"; }
			Pass.value = sTmp;
		}
		
	  // done hiding from old browsers -->
	</script>	
</head>

<body onkeyup="controla(event);">
<!-- 
<div id="cap">
	<div id="login_boto" style="display:<% ///out.println( bMostraBotoIntranet ? "block" : "none" ); %>;">
		<form action="index.jsp" method="post" novalidate>
			<input type="submit" value="Intranet" name="intranet">		
		</form>
	</div>
</div>
-->
 
 <div id="cos">
	<div class="popIn1" id="no_js1" style="display: block;">
	<div class="popIn2" id="no_js2">
		Es necesario JavaScript para el correcto funcionamiento de esta web.
		<br/><br/>
		Habilítelo en el navegador y vuelva a cargar la página.
	</div>
	</div>

	<div id="login_form" class="popIn1" style="display:<% out.print( bMostraLoginForm ? "block" : "none" ); %>;">
	<div class="finestra2"><div class="finestra3"><div class="finestra4">
		<h3>Inicio sesión</h3>
		<form name="entrar" action="index.jsp" method="post" onsubmit="encrypt();">		
			<input type="text" spellcheck="false" autocapitalize="off" autocorrect="off" placeholder="Usuario" name="user">
			<br/>
			<input type="password" placeholder="Contraseña" name="pass">
			<br/>
			<input type="hidden" name="passH">
			<input type="checkbox" id="recordar" name="recordar">
			<label for="recordar">Seguir conectado</label>
			<input type="submit" value="Entrar" name="login">
			<br/>
		</form>
	</div></div></div></div>
	
<!-- 	<br/><br/><br/><br/><br/><br/> -->
<!--
	<div>
		<h3>Ficha cliente</h3>
		<form name="cli_form" action="index.jsp" method="post">		
			<input type="text" spellcheck="false" autocapitalize="off" autocorrect="off" placeholder="Cliente" name="cli">
			<br/>
			<input type="hidden" name="sessionid" value="<% ///out.print( bAccess ? sSessID : "" ); %>">
			<input type="submit" class="botoBlau" value="Entrar" name="cli_enter">
		</form>
	</div>
 -->

<!--	
	<br/>
	<div>
		<form name="exit_form" action="index.jsp" method="post">		
			<input type="submit" class="botoBlau" value="Salir" name="logout">		
		</form>
	</div>
-->
</div>

<script language="javascript" type="text/javascript">
	<!-- hide this script tag's contents from old browsers
	// Activem web aquí usant js. Si js no està activat, no permetem login (no pot encriptar pasw)
	document.getElementById("no_js1").style.display="none";

	if( document.getElementById("login_form").style.display == "block" ) {
		document.getElementsByName("user")[0].focus();
		document.getElementsByName("user")[0].select();
	}

  // done hiding from old browsers -->
</script>	

</body>
</html>