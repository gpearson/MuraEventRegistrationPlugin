<cfsilent>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cfset Session.PluginFramework = StructCopy(Variables.Framework)>
		</cflock>
	</cfif>
</cfsilent>
<cfoutput>
	<div class="row-fluid">
		<div class="col-md-12">
			<nav class="navbar navbar-inverse navbar-static-top" role="navigation">
				<div class="collapse navbar-collapse navbar-ex1-collapse">
					<ul id="navPrimary" class="nav navbar-nav">
						<li class="<cfif rc.action eq 'public:main.default'>active</cfif>">
							<a href="##" class="dropdown-toggle" data-toggle="dropdown">Home <b class="caret"></b></a>
							<ul class="dropdown-menu">
								<cfif Session.Mura.IsLoggedIn EQ True>
									<li class="">
										<a href="http://#CGI.server_name#/index.cfm?doaction=logout"><i class="icon-home"></i> Account Logout</a>
									</li>
								<cfelse>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#CGI.Script_name##CGI.path_info#?display=login"><i class="icon-home"></i> Account Login</a>
									</li>
									<li class="<cfif rc.action eq 'public:register.account'>active</cfif>">
										<a href="#buildURL('public:registeruser.default')#"><i class="icon-home"></i> Register Account</a>
									</li>
									<li class="<cfif rc.action eq 'public:main.forgotpassword'>active</cfif>">
										<a href="#buildURL('public:usermenu.forgotpassword')#"><i class="icon-leaf"></i> Forgot Password</a>
									</li>
								</cfif>
							</ul>
								<!--- 
										<cfif Session.Mura.IsLoggedIn EQ True>
											<li class="<cfif rc.action eq 'public:main.login'>active</cfif>"><a href="#buildURL('public:main.default')#"><i class="icon-home"></i> Event Listing</a></li>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#CGI.Script_name##CGI.path_info#?doaction=logout"><i class="icon-home"></i> Account Logout</a>
									</li>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#buildURL('public:usermenu.editprofile')#"><i class="icon-home"></i> Manage Profile</a>
									</li>
								<cfelse>
									
								</cfif>
									
								--->
						</li>
						<cfif $.currentUser().isSuperUser()>
							<li class=""><a href="/plugins/#Session.PluginFramework.CFCBase#/?#Session.PluginFramework.Action#=admin:main.default">Administration</a></li>
							<li class=""><a href="/plugins/#Session.PluginFramework.CFCBase#/?#Session.PluginFramework.Action#=eventcoordinator:main.default">Facilitator Menu</a></li>
						</cfif>
						<cfif $.currentUser().isInGroup("Event Facilitator")>
							<li class=""><a href="/plugins/#Session.PluginFramework.CFCBase#/?#Session.PluginFramework.Action#=eventcoordinator:main.default">Facilitator Menu</a></li>
						</cfif>

					</ul>
					<ul class="nav navbar-nav navbar-right">
						<li class="<cfif rc.action contains 'public:faq.default'>active</cfif>">
							<a href="#buildURL('public:faq.default')#">Questions?</a>
						</li>
						<li class="<cfif rc.action contains 'public:contactus'>active</cfif>">
							<a href="#buildURL('public:contactus.default')#">Contact Us&nbsp;&nbsp;</a>
						</li>
					</ul>
				</div>
			</nav>
		</div>
	</div>
	<div class="row-fluid">
		<div class="col-md-12">
			<cfdump var="#Session.PluginFramework#">
			#body#
		</div>
	</div>
</cfoutput>
	<!--- 
	<div class="row-fluid mfw1-example">
		<h3>Application ##2</h3>
		<div>
			<ul class="nav nav-tabs" role="tablist">
				<li<cfif rc.action eq 'app2:main.default'> class="active"</cfif>>
					<a href="#buildURL('app2:main')#">Application ##2 Main</a>
				</li>
				<li<cfif rc.action eq 'app2:main.another'> class="active"</cfif>>
					<a href="#buildURL('app2:main.another')#">Another Page</a>
				</li>
				<li<cfif rc.action eq 'app2:list.default'> class="active"</cfif>>
					<a href="#buildURL('app2:list')#">List Something</a>
				</li>
			</ul>
		</div>

		<div>#body#</div>

		<!--- Admin Link --->
		<cfif $.currentUser().isSuperUser()>
			<div class="row">
				<div class="col-md-12">
					<div class="mfw1-admin-links">
						<a class="btn btn-primary frontEndToolsModal" href="#rc.$.globalConfig('context')#/plugins/#rc.pc.getDirectory()#/index.cfm?MuraFW1Action=admin:main.default&amp;compactDisplay=true">Admin</a>
					</div>
				</div>
			</div>
		</cfif>
		<!--- /Admin Link --->

	</div>
--->