<cfoutput>
	<div class="container">
		<!--- PRIMARY NAV --->
		<div class="row-fluid">
			<nav class="navbar navbar-inverse navigation-clean">
				<div class="navbar-inner">
					<div class="navbar-header">
						<a class="navbar-brand"><!--- #HTMLEditFormat(rc.pc.getPackage())# ---></a>
					</div>
					<ul class="nav navbar-nav">
						<li class="<cfif rc.action eq 'public:main'>active</cfif> dropdown">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('public:main')#">Home <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<cfif Session.Mura.IsLoggedIn EQ True>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>"><a href="#buildURL('public:main.default')#"><i class="icon-home"></i> Event Listing</a></li>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#CGI.Script_name##CGI.path_info#?doaction=logout"><i class="icon-home"></i> Account Logout</a>
									</li>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="#buildURL('public:usermenu.editprofile')#"><i class="icon-home"></i> Manage Profile</a>
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
						</li>
					</ul>
					<cfif Session.Mura.IsLoggedIn EQ "True">
						<ul class="nav navbar-nav">
							<cfif Session.Mura.EventCoordinatorRole EQ 0 and Session.Mura.EventPresenterRole EQ 0 and Session.Mura.SuperAdminRole EQ 0>
							<li class="<cfif rc.action eq 'public:usermenu'>active</cfif> dropdown">
								<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('public:usermenu')#">User Menu<span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li><a href="#buildURL('public:usermenu.eventhistory')#" class="active">My Event History</a></li>
									<li><a href="#buildURL('public:usermenu.upcomingevents')#" class="active">My Upcoming Events</a></li>
								</ul>
							</li>
							</cfif>
						</ul>
					</cfif>
					<ul class="nav navbar-nav navbar-right">
						<li class="<cfif rc.action contains 'public:faq'>active</cfif>">
							<a href="#buildURL('public:faq.default')#"><i class="icon-info-sign"></i> Questions?</a>
						</li>
						<li class="<cfif rc.action contains 'public:contactus'>active</cfif>">
							<a href="#buildURL('public:contactus.sendfeedback')#"><i class="icon-info-sign"></i> Contact Us</a>
						</li>
					</ul>
				</div>
			</nav>
			<cfif Session.Mura.IsLoggedIn EQ "True">
				<div class="text-right">
					Current User: #Session.Mura.FName# #Session.Mura.LName# (#Session.Mura.Company#) <a href="#CGI.Script_name##CGI.path_info#?doaction=logout" class="btn btn-sm btn-primary">Logout</a><br>
					<hr>
				</div>
			<cfelse>
				<div class="text-right">
					Current User: Guest User <a href="#CGI.Script_name##CGI.path_info#?display=login" class="btn btn-sm btn-primary">Login</a> | <a href="#buildURL('public:registeruser.default')#" class="btn btn-sm btn-primary">Create Account</a>
					<hr>
				</div>
			</cfif>
		</div>
		<div class="container-fluid">
			<div class="row">
				<!--- SUB-NAV --->
				<!--- >
				<div class="col-sm-2">
					<ul class="nav nav-list">

					</ul>
				</div>
				--->
				<!--- BODY --->
				<div class="col-sm-12">
					#body#
				</div>
			</div>
		</div>
	</div>
</cfoutput>