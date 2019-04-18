<cfsilent>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cfset Session.PluginFramework = StructCopy(Variables.Framework)>
		</cflock>
	</cfif>
</cfsilent>
<cfsavecontent variable="htmlhead"><cfoutput>
	<style>.BtnSameSize { width: 200px; padding: 2px; margin: 2px; }</style>
</cfoutput></cfsavecontent>
<cfhtmlhead text="#htmlhead#" />
<cfoutput>
	<cfinclude template="#$.siteConfig('themeAssetPath')#/templates/inc/html_head.cfm" />
	<body id="homePage" class="sysHome">
		<div class="off-canvas-wrap">
			<div class="inner-wrap">
				<header>
					<div class="row">
						<img src="#$.siteConfig('AssetPath')#/images/NWIESC_Logo.jpg">
					</div>
				</header>
				<div class="row">
					<div class="col-12">
						<nav class="navbar navbar-default">
							<div class="container-fluid">
								<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
									<ul id="navPrimary" class="nav navbar-nav">
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Main <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<cfif Session.Mura.IsLoggedIn EQ True>
													<li class="">
														<a href="http://#CGI.server_name#/index.cfm?doaction=logout"><i class="icon-home"></i> Account Logout</a>
													</li>
												<cfelse>

												</cfif>
											</ul>
										</li>
										<li class="<cfif isDefined('URL[Variables.Framework.Action]')><cfif URL[Variables.Framework.Action] CONTAINS 'license'>active</cfif></cfif>">
											<a href="#buildURL('admin:license.default')#"><i class="icon-book"></i> License</a>
										</li>
										<li class="<cfif isDefined('URL[Variables.Framework.Action]')><cfif URL[Variables.Framework.Action] CONTAINS 'instructions'>active</cfif></cfif>">
											<a href="#buildURL('admin:instructions.default')#"><i class="icon-info-sign"></i> Instructions</a>
										</li>
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Catering <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('admin:catering.addcaterer')#">Add New Caterer</a></li>
												<li class=""><a href="#buildURL('admin:catering.default')#">List All Caterers</a></li>
											</ul>
										</li>
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Facilities <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('admin:facilities.addfacility')#">Add New Facility</a></li>
												<li class=""><a href="#buildURL('admin:facilities.default')#">List All Facilities</a></li>
											</ul>
										</li>
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Site Configuration <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('admin:siteconfig.default')#">Site Settings</a></li>
											</ul>
										</li>
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">User Management <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('admin:siteconfig.newuser')#">Add New User</a></li>
												<li class=""><a href="#buildURL('admin:siteconfig.usermain')#">List All Users</a></li>
											</ul>
										</li>
									</ul>
								</div>
							</div>
						</nav>
						<br>
						#body#
					</div>
				</div>
			<cfinclude template="#$.siteConfig('themeAssetPath')#/templates/inc/footer.cfm" />
		<cfinclude template="#$.siteConfig('themeAssetPath')#/templates/inc/html_foot.cfm" />
</cfoutput>
