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
	<cfinclude template="#$.siteConfig('themeAssetPath')#/templates/inc/html2_head.cfm" />
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
											<a href="#buildURL('eventcoordinator:main.default')#" class="dropdown-toggle" data-toggle="dropdown">Main <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<cfif Session.Mura.IsLoggedIn EQ True>
													<li class="">
														<a href="http://#CGI.server_name#/index.cfm?doaction=logout"><i class="icon-home"></i> Account Logout</a>
													</li>
												<cfelse>

												</cfif>
											</ul>
										</li>
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Caterers<b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:catering.addcaterer')#">Add New Caterer</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:catering.default')#">List All Caterers</a></li>
											</ul>
										</li>
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Events <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:events.addevent')#">Add New Event</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:events.addexpense')#">Add New Event Expense</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:events.default')#">List All Events</a></li>
											</ul>
										</li>
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Facilities <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:facilities.addfacility')#">Add New Facility</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:facilities.default')#">List All Facilities</a></li>
											</ul>
										</li>
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Membership <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:membership.addmember')#">Add New Member</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:membership.default')#">List All Members</a></li>
											</ul>
										</li>
										
										<li class="">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Users <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:users.newuser')#">Add New User</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:users.default')#">List All Users</a></li>
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