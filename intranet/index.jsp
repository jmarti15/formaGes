<%@ page language="java" contentType="text/html; charset=UTF-8" session="false" 
	import="java.util.Date"
    import="java.text.SimpleDateFormat"
		import = "java.util.Map"
    pageEncoding="UTF-8"
%>
<%/* 		no usats:
	import="java.security.MessageDigest"
	import="java.sql.*"
    import="java.io.*"
*/%>
<%@ include file="lib/funcions.jsp" %>

<!-- <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> -->
<!DOCTYPE html>
<html>
<%
/// Mostro tots els paràmetres rebuts (GET+POST)
///			CAL:  import = "java.util.Map"	!!!
/*
Map<String, String[]> parameters = request.getParameterMap();
for(String parameter : parameters.keySet())
	out.println( parameter+"="+request.getParameter(parameter)+"<br/>" );
out.println("===============================================================<br/>");
*/
///

	// Han pres "Entrar" al formulari de login (està a lib/login.html) ?
	boolean bLogin = request.getParameter("login") != null;

	// Opcions del menú
	boolean bLogout = request.getParameter("opc")!=null && request.getParameter("opc").equals("7");
	boolean bConsulta = request.getParameter("opc")!=null && !request.getParameter("opc").equals("7");

	// Volen accedir? (1er buscarem cookie, sinó mostrem form de login)
	boolean bEntrant = !bLogin && !bConsulta && !bLogout;
	
	boolean bAccess=false, bAccVal=true, bMostraLoginForm=false, bMostraMenu=false;
///
/*
out.println("bEntrant="+(bEntrant?"T":"F")+"  bLogin="+(bLogin?"T":"F")+"  bConsulta="+(bConsulta?"T":"F")+
						  "  bLogout="+(bLogout?"T":"F")+"  bAccess="+(bAccess?"T":"F")+"<br/>");
*/
///
	HttpSession Sessio=null;
	String sLlavor="000000", sSessID="", sIP="", sUser="";
	int iNivell=-1;
	
	if( bEntrant || bLogin || bConsulta || bLogout ) Sessio = request.getSession();
	if( Sessio != null ) sSessID = Sessio.getId();
	sIP = getClientIpAddr(request);


	// Consulta
	String sOpc="";
	if (bConsulta) {
		// Control d'accés vàlid (SessionId i IP)
		String sReqSess = request.getParameter("sessionid");
		String sReqIP = (String)Sessio.getAttribute("ip");
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
		iNivell = (Integer)Sessio.getAttribute("nivell");		// Nivell de l'usuari
		String[] sOpcions = request.getParameter("opc").split("#");	// A "opc" rebem:  opcio#nivell  (o només opcio quan nivell=3)
		int iOpcNivell = ( sOpcions.length == 1 ) ? 3 : Integer.parseInt( sOpcions[1] );		// Nivell del form (3 si no el rebem)
		if( iNivell > iOpcNivell ) {			// Nivell insuficient
			bAccVal = false;
			out.println("Level Err"+"<br/>");
		}
		if(bAccVal) {								// Tot ok
			bMostraMenu=true;
///
System.out.println( "Opc0: "+sOpcions[0] );
if( sOpcions.length ==2 ) System.out.println( "Opc1: "+sOpcions[1] );
///
			sOpc = sOpcions[0];
		}
	}


	if (bLogout) {
		Sessio.invalidate();										// Finalitzem sessió
		response.addCookie(borraCookie());		// Borrem cookie
	}


	if(bEntrant) {
		if( !Sessio.isNew() ) {
			Sessio.invalidate();
			Sessio = request.getSession();
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
			Sessio.setAttribute("llavor",sLlavor);
			bMostraLoginForm=true;								// Mostrem login form 
		}
	}


	// Login
	if(bLogin) {
		sUser = request.getParameter("user")!=null ? request.getParameter("user") : "";
		String sPass = request.getParameter("passH")!=null ? request.getParameter("passH") : "";
		if(sUser!="" && sPass!="") {
			Date dAra = new Date();
			long lTemps = dAra.getTime() - Sessio.getCreationTime();
			Date dTemps = new Date(lTemps);
//System.out.println("Temps: "+dTemps.getMinutes()+"min."+dTemps.getSeconds()+"seg");
			if( dTemps.getMinutes() > 0 ) {
				Sessio.invalidate();
				out.println("El tiempo para iniciar sesión ha finalizado. Recuerde que dispone de 60 segundos"+"<br/>");
			}
			else {
				Contenidor objNivell = new Contenidor();
				bAccess = acces(sUser, sPass, (String)Sessio.getAttribute("llavor"), objNivell);
				iNivell = objNivell.getInt();
			}
		}	else
			out.println("NO user/psw"+"<br/>");
	}


	// Cookie o login ok? 
	if( bEntrant || bLogin ) {
		if( bAccess ){
			Sessio.setAttribute("ip",sIP);
			Sessio.setAttribute("user",sUser);
			if( iNivell==-1 ) iNivell = iNivellUsuari(sUser);
			Sessio.setAttribute("nivell",iNivell);

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

	boolean bIncludeHtml=false, bIncludeJsp=false;
	String sInclude="";
	if( bMostraLoginForm ) {
		bIncludeHtml=true;
		sInclude="login.html";
	} else if( bConsulta ) {
		bIncludeJsp=true;
		sInclude="opc"+sOpc+".jsp";
	}

///
//out.println("bEntrant="+(bEntrant?"T":"F")+"  bLogin="+(bLogin?"T":"F")+"  bCliEnter="+(bCliEnter?"T":"F")+
//						  "  bLogout="+(bLogout?"T":"F")+"  bAccess="+(bAccess?"T":"F")+"<br/>");
///
%>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Low Pressure Fitness Gestión</title>
	<link type="image/x-icon" href="img/lpf13.ico" rel="shortcut icon">

	<!--
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap.min.css"></link>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/css/bootstrap-theme.min.css"></link>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular.min.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular-sanitize.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.12.0/ui-bootstrap-tpls.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.13/angular-ui-router.min.js"></script>
	<script src="https://code.angularjs.org/1.3.15/i18n/angular-locale_es-es.js"></script>
	-->
	<!-- If you are not sure which module is missing, use the not minified angular.js which gives a readable error message -->
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.css"></link>
	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap-theme.css"></link>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.2/jquery.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.3.13/angular-sanitize.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-bootstrap/0.12.0/ui-bootstrap-tpls.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/angular-ui-router/0.2.13/angular-ui-router.js"></script>
	<script src="https://code.angularjs.org/1.3.15/i18n/angular-locale_es-es.js"></script>

	<link type="text/css" rel="stylesheet" href="css/estil.css">
	<% if(bMostraMenu) { %><link type="text/css" rel="stylesheet" href="css/menu.css">	<% } %>
	<script type="text/javascript" charset="utf-8" src="lib/js/funcions.js"></script>	
	<script type="text/javascript" charset="utf-8" src="lib/js/sha2.js"></script>
	<script type="text/javascript">
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
	 <% 	if(bMostraMenu) { %>
		<jsp:include page="lib/menu.jsp">
			<jsp:param name="sessionid" value="<%=sSessID%>"/>
			<jsp:param name="nivell" value="<%=iNivell%>"/>
		</jsp:include>
	<% } %>

	 <div id="cos">
		<div class="popIn1" id="no_js1" style="display: block;">
		<div class="popIn2" id="no_js2">
			Es necesario JavaScript para el correcto funcionamiento de esta web.
			<br/><br/>
			Habilítelo en el navegador y vuelva a cargar la página.
		</div>
		</div>

		<% if(bIncludeHtml) { %>
			<jsp:include page="<%="lib/"+sInclude%>"/>
		<% } else if(bIncludeJsp) { %>
			<jsp:include page="<%="lib/"+sInclude%>">
				<jsp:param name="sessionid" value="<%=sSessID%>"/>
			</jsp:include>
		<% } %>
	</div>

	<script type="text/javascript">
		<!-- hide this script tag's contents from old browsers
		// Activem web aquí usant js. Si js no està activat, no permetem login (no pot encriptar pasw)
		document.getElementById("no_js1").style.display="none";
	
		if (document.getElementById("login_form") != null) {
			document.getElementsByName("user")[0].focus();
			document.getElementsByName("user")[0].select();
		}
	  // done hiding from old browsers -->
	</script>	
</body>
</html>