<cfoutput>
	<div class="container">
		<!--- PRIMARY NAV --->
		<div class="row-fluid">
			<nav class="navbar">
				<div class="navbar-inner">
					<div class="navbar-header">
						<a class="navbar-brand"><!--- #HTMLEditFormat(rc.pc.getPackage())# ---></a>
					</div>
					<ul class="nav navbar-nav">
						<li class="<cfif rc.action eq 'selleradmin:main'>active</cfif> dropdown">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('selleradmin:main')#">Home <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<cfif Session.Mura.IsLoggedIn EQ True>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#CGI.Script_name##CGI.path_info#?doaction=logout">Account Logout</a>
									</li>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#CGI.Script_name##CGI.path_info#?display=login">Manage Profile</a>
									</li>
								<cfelse>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#CGI.Script_name##CGI.path_info#?display=login">Account Login</a>
									</li>
									<li class="<cfif rc.action eq 'public:register.account'>active</cfif>">
										<a href="#buildURL('public:register.account')#">Register Account</a>
									</li>
									<li class="<cfif rc.action eq 'public:main.forgotpassword'>active</cfif>">
										<a href="#buildURL('public:main.forgotpassword')#">Forgot Password</a>
									</li>
								</cfif>

							</ul>
						</li>
					</ul>
					<ul class="nav navbar-nav">
						<li class="<cfif rc.action contains 'eventcoord:events'>active</cfif>">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('eventcoord:events.default')#">Event Menu <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li class="<cfif rc.action eq 'eventcoord:events.default'>active</cfif>">
									<a href="#buildURL('eventcoord:events.default')#">List Events</a>
								</li>
								<li class="<cfif rc.action eq 'eventcoord:events.addevent'>active</cfif>">
									<a href="#buildURL('eventcoord:events.addevent')#">Add New Event</a>
								</li>
							</ul>
						</li>
						<li class="<cfif rc.action contains 'eventcoord:caterers'>active</cfif>">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('eventcoord:caterers.default')#">Catering Menu <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li class="<cfif rc.action eq 'eventcoord:caterers.default'>active</cfif>">
									<a href="#buildURL('eventcoord:caterers.default')#">List Caterers</a>
								</li>
								<li class="<cfif rc.action eq 'eventcoord:caterers.addevent'>active</cfif>">
									<a href="#buildURL('eventcoord:caterers.addcaterer')#">Add New Caterer</a>
								</li>
							</ul>
						</li>
						<li class="<cfif rc.action contains 'eventcoord:facilities'>active</cfif>">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('eventcoord:facilities.default')#">Facility Menu <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li class="<cfif rc.action eq 'eventcoord:facilities.default'>active</cfif>">
									<a href="#buildURL('eventcoord:facilities.default')#">List Facilities</a>
								</li>
								<li class="<cfif rc.action eq 'eventcoord:facilities.addevent'>active</cfif>">
									<a href="#buildURL('eventcoord:facilities.addcaterer')#">Add New Facility</a>
								</li>
							</ul>
						</li>
						<li class="<cfif rc.action contains 'eventcoord:membership'>active</cfif>">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('eventcoord:membership.default')#">Membership Menu <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li class="<cfif rc.action eq 'eventcoord:membership.default'>active</cfif>">
									<a href="#buildURL('eventcoord:membership.default')#">List Membership</a>
								</li>
								<li class="<cfif rc.action eq 'eventcoord:membership.addevent'>active</cfif>">
									<a href="#buildURL('eventcoord:membership.addmembership')#">Add New Membership</a>
								</li>
							</ul>
						</li>
						<li class="<cfif rc.action contains 'eventcoord:presenters'>active</cfif>">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('eventcoord:presenters.default')#">Presenters Menu <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li class="<cfif rc.action eq 'eventcoord:presenters.default'>active</cfif>">
									<a href="#buildURL('eventcoord:presenters.default')#">List Presenters</a>
								</li>
								<li class="<cfif rc.action eq 'eventcoord:presenters.addevent'>active</cfif>">
									<a href="#buildURL('eventcoord:presenters.addmembership')#">Add New Presenter</a>
								</li>
							</ul>
						</li>
						<li class="<cfif rc.action contains 'eventcoord:users'>active</cfif>">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('eventcoord:users.default')#">Users Menu <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li class="<cfif rc.action eq 'eventcoord:users.default'>active</cfif>">
									<a href="#buildURL('eventcoord:users.default')#">List Users</a>
								</li>
								<li class="<cfif rc.action eq 'eventcoord:users.addevent'>active</cfif>">
									<a href="#buildURL('eventcoord:users.addmembership')#">Add New User</a>
								</li>
							</ul>
						</li>
					</ul>
					<!---
					<ul class="nav navbar-nav navbar-right">
						<li class="<cfif rc.action eq 'selleradmin:main'>active</cfif> dropdown">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('selleradmin:settings.default')#">Settings <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<li class="<cfif rc.action eq 'selleradmin:settings.locations'>active</cfif>">
									<a href="#buildURL('selleradmin:settings.locations')#"> Locations</a>
								</li>
								<li class="<cfif rc.action eq 'selleradmin:settings.updateorganization'>active</cfif>">
									<a href="#buildURL('selleradmin:settings.updateorganization')#">Update Organization</a>
								</li>
								<li class="<cfif rc.action eq 'selleradmin:settings.users'>active</cfif>">
									<a href="#buildURL('selleradmin:settings.users')#">Users</a>
								</li>
							</ul>
						</li>
					</ul>
					--->
				</div>
			</nav>
		</div>
		<div class="row-fluid">
			<!--- SUB-NAV --->
			<div class="span3">
				<ul class="nav nav-list">

				</ul>
			</div>
			<!--- BODY --->
			<div class="span9">
				#body#
			</div>
		</div>
	</div>
</cfoutput>.