<cfsilent>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cfset Session.PluginFramework = StructCopy(Variables.Framework)>
		</cflock>
	</cfif>
</cfsilent>
<cfhtmlhead><style>.BtnSameSize { width: 110px; padding: 2px; margin: 2px; }</style></cfhtmlhead>
<cfif Session.Mura.IsLoggedIn EQ True>
	<cfset userBean = rc.$.getBean('user').loadBy(username='#Session.Mura.Username#', siteid='#rc.$.siteConfig('siteID')#')>
</cfif>
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
									<cfif not userBean.isInGroup("Event Facilitator") and not userBean.isInGroup("Event Presenter")>
										<li class="">
											<a href="#buildURL('public:usermenu.editprofile')#"><i class="icon-home"></i> Manage Profile</a>
										</li>
									</cfif>
								<cfelse>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#CGI.Script_name##CGI.path_info#?display=login"><i class="icon-home"></i> Account Login</a>
									</li>
									<li class="<cfif rc.action eq 'public:register.account'>active</cfif>">
										<a href="#buildURL('public:registeraccount.default')#"><i class="icon-home"></i> Register Account</a>
									</li>
									<li class="<cfif rc.action eq 'public:main.forgotpassword'>active</cfif>">
										<a href="#buildURL('public:usermenu.forgotpassword')#"><i class="icon-leaf"></i> Forgot Password</a>
									</li>
								</cfif>
							</ul>
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfif not userBean.isInGroup("Event Facilitator") and not userBean.isInGroup("Event Presenter")>
									<li class="">
										<a href="#buildURL('public:main.default')#">All Events</a>
									</li>
									<li class="<cfif rc.action eq 'public:usermenu.default'>active</cfif>">
										<a href="##" class="dropdown-toggle" data-toggle="dropdown">My Events <b class="caret"></b></a>
										<ul class="dropdown-menu">
											<li class=""><a href="#buildURL('public:usermenu.upcomingevents')#">Upcoming Events</a></li>
											<li class=""><a href="#buildURL('public:usermenu.eventhistory')#">Event History & Certificates</a></li>
										</ul>
									</li>
								</cfif>
							</cfif>
								<!--- 
										<cfif Session.Mura.IsLoggedIn EQ True>
											<li class="<cfif rc.action eq 'public:main.login'>active</cfif>"><a href="#buildURL('public:main.default')#"><i class="icon-home"></i> Event Listing</a></li>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#CGI.Script_name##CGI.path_info#?doaction=logout"><i class="icon-home"></i> Account Logout</a>
									</li>
									
								<cfelse>
									
								</cfif>
									
								--->
						</li>
						<cfif isDefined("Variables.userBean")>
							<cfif userBean.getValue('s2') EQ 1>
								<li class=""><a href="/plugins/#Session.PluginFramework.CFCBase#/?#Session.PluginFramework.Action#=admin:main.default">Administration</a></li>
								<li class=""><a href="/plugins/#Session.PluginFramework.CFCBase#/?#Session.PluginFramework.Action#=eventcoordinator:main.default">Facilitator Menu</a></li>
								<li class=""><a href="/plugins/#Session.PluginFramework.CFCBase#/?#Session.PluginFramework.Action#=eventpresenter:main.default">Presenter Menu</a></li>
							</cfif>
							<cfif userBean.isInGroup("Event Facilitator")>
								<li class=""><a href="/plugins/#Session.PluginFramework.CFCBase#/?#Session.PluginFramework.Action#=eventcoordinator:main.default">Facilitator Menu</a></li>
							</cfif>
							<cfif userBean.isInGroup("Event Presenter")>
								<li class=""><a href="/plugins/#Session.PluginFramework.CFCBase#/?#Session.PluginFramework.Action#=eventpresenter:main.default">Presenter Menu</a></li>
							</cfif>
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
			<cfif StructKeyExists(session, "MuraPreviousUser")>
				<div class="text-left">
					<div class="alert alert-info">
						<span>Logged In As:</span> #Session.Mura.FName# #Session.Mura.LName#.<br />To return back to your user account, click <a href="/plugins/#variables.Framework.package##buildURL('public:main.default')#&PerformAction=LogoutUser" class="art-button">here</a>
					</div>
				</div>
			</cfif>
			<cfif Session.Mura.IsLoggedIn EQ "True">
				<div class="text-right">
					Current User: #Session.Mura.FName# #Session.Mura.LName# (#Session.Mura.Company#) <a href="#CGI.Script_name##CGI.path_info#?doaction=logout" class="btn btn-sm btn-primary">Logout</a><br>
					<hr>
				</div>
			<cfelse>
				<div class="text-right">
					Current User: Guest User <a href="#CGI.Script_name##CGI.path_info#?display=login" class="btn btn-sm btn-primary BtnSameSize">Login</a> | <a href="#buildURL('public:registeraccount.default')#" class="btn btn-sm btn-primary BtnSameSize">Create Account</a>
					<hr>
				</div>
			</cfif>
		</div>
	</div>
	<div class="row-fluid">
		<div class="col-md-12">
			#body#
		</div>
	</div>
</cfoutput>