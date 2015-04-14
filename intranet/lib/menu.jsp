<%
	int iNivell = Integer.parseInt( request.getParameter("nivell") );
%>

<div class="barra_menu">
	<div class="logo"><a href="http://www.hipopresivos.com/es/"><img src="img/1413961502_gyPQ.jpg" border="0"></a></div>

	<div id="header"><form method="post" novalidate>
		<ul class="nav">
			<li><span>Alumnos</span>
				<ul>
					<li><button name="opc" value="11" >Inscripciones</button></li>
					<li><button name="opc" value="12" >Interesados</button></li>
					<li><button name="opc" value="13" >Alumnos</button></li>
				</ul>
			</li>
			<li><span>Gestión</span>
				<ul>
					<li><button name="opc" value="21" >Niveles</button></li>
				</ul>
			</li>

			<%	if (iNivell<=2) { %>
			<li><span>Almenys nivell mig (2 i 1)</span>
				<ul>
					<li><button name="opc" value="xx2#2" >Nivell mig (2 i 1)</button></li>
					<%	if (iNivell<=1) { %>
					<li><button name="opc" value="xx1#1" >Només nivell max (1)</button></li>
					<% } %>
				</ul>
			</li>
			<% } %>

			<li><button name="opc" value="7" >Salir</button></li>
<!--
			<li><a href="">Alumnos2</a></li>
			<li><a href="">Servicios</a>
				<ul>
					<li><a href="">Submenu1</a></li>
					<li><a href="">Submenu2</a></li>
					<li><a href="">Submenu3</a></li>
					<li><a href="">Submenu4</a>
						<ul>
							<li><a href="">Submenu1</a></li>
							<li><a href="">Submenu2</a></li>
							<li><a href="">Submenu3</a></li>
							<li><a href="">Submenu4</a></li>
						</ul>
					</li>
				</ul>
			</li>
			<li><a href="">Acerca de</a>
				<ul>
					<li><a href="">Submenu1</a></li>
					<li><a href="">Submenu2</a></li>
					<li><a href="">Submenu3</a></li>
					<li><a href="">Submenu4</a></li>
				</ul>
			</li>
			<li><a href="">Contacto</a></li>
 -->
<!-- 	<li><a href="?var1=xxx">SalirGET</a></li>
			<li><button class="mnubut" name="opc" value="7" >SalirPOST</button></li> -->

		</ul>
		<input type="hidden" name="sessionid" value="<%=request.getParameter("sessionid")%>">
	</form>	</div>
</div>