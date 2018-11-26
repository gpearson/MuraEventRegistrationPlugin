<cfsilent>
	<cfif Session.Mura.IsLoggedIn EQ False>
		<cflocation url="#CGI.Script_name##CGI.path_info#">
	</cfif>
</cfsilent>
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
              <cfelseif Session.Mura.SuperAdminRole EQ 1>
              <li class="<cfif rc.action contains 'siteadmin:caterers'>active</cfif>">
  							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('siteadmin:caterers.default')#">Catering Menu <span class="caret"></span></a>
  							<ul class="dropdown-menu">
  								<li class="<cfif rc.action eq 'siteadmin:caterers.default'>active</cfif>">
  									<a href="#buildURL('siteadmin:caterers.default')#">List Caterers</a>
  								</li>
  								<li class="<cfif rc.action eq 'siteadmin:caterers.addevent'>active</cfif>">
  									<a href="#buildURL('siteadmin:caterers.addcaterer')#">Add New Caterer</a>
  								</li>
  							</ul>
  						</li>
  						<li class="<cfif rc.action contains 'siteadmin:facility'>active</cfif>">
  							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('siteadmin:facility.default')#">Facility Menu <span class="caret"></span></a>
  							<ul class="dropdown-menu">
  								<li class="<cfif rc.action eq 'siteadmin:facility.default'>active</cfif>">
  									<a href="#buildURL('siteadmin:facility.default')#">List Facilities</a>
  								</li>
  								<li class="<cfif rc.action eq 'siteadmin:facility.addfacility'>active</cfif>">
  									<a href="#buildURL('siteadmin:facility.addfacility')#">Add New Facility</a>
  								</li>
  							</ul>
  						</li>
  						<li class="<cfif rc.action contains 'siteadmin:membership'>active</cfif>">
  							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('siteadmin:membership.default')#">Membership Menu <span class="caret"></span></a>
  							<ul class="dropdown-menu">
  								<li class="<cfif rc.action eq 'siteadmin:membership.default'>active</cfif>">
  									<a href="#buildURL('siteadmin:membership.default')#">List Membership</a>
  								</li>
  								<li class="<cfif rc.action eq 'siteadmin:membership.default'>active</cfif>">
  									<a href="#buildURL('siteadmin:membership.listescesa')#">List State ESC/ESA</a>
  								</li>
  								<li class="<cfif rc.action eq 'siteadmin:membership.addevent'>active</cfif>">
  									<a href="#buildURL('siteadmin:membership.addmembership')#">Add New Membership</a>
  								</li>
  							</ul>
  						</li>
  						<li class="<cfif rc.action contains 'siteadmin:users'>active</cfif>">
  							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('siteadmin:users.default')#">Users Menu <span class="caret"></span></a>
  							<ul class="dropdown-menu">
  								<li class="<cfif rc.action eq 'siteadmin:users.default'>active</cfif>">
  									<a href="#buildURL('siteadmin:users.default')#">List Users</a>
  								</li>
  								<li class="<cfif rc.action eq 'siteadmin:users.adduser'>active</cfif>">
  									<a href="#buildURL('siteadmin:users.adduser')#">Add New User</a>
  								</li>
  							</ul>
  						</li>

              <li class="<cfif rc.action eq 'public:usermenu'>active</cfif> dropdown">
                <a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('public:usermenu')#">Admin Menu<span class="caret"></span></a>
                <ul class="dropdown-menu">
                <li><a href="#buildURL('public:usermenu.eventhistory')#" class="active">Edit Grade Levels</a></li>
                  <li><a href="#buildURL('public:usermenu.eventhistory')#" class="active">Edit Grade Subjects</a></li>
                  <li><a href="#buildURL('public:usermenu.eventhistory')#" class="active">Edit Expense Categories</a></li>
                  <li><a href="#buildURL('public:usermenu.eventhistory')#" class="active">Edit Site Config</a></li>

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
