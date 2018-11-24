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
						<li class="<cfif rc.action eq 'public:main'>active</cfif> dropdown">
							<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('public:main')#">Home <span class="caret"></span></a>
							<ul class="dropdown-menu">
								<cfif Session.Mura.IsLoggedIn EQ True>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="/index.cfm/auction-site/?doaction=logout"><i class="icon-home"></i> Account Logout</a>
									</li>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="?display=login"><i class="icon-home"></i> Manage Profile</a>
									</li>
								<cfelse>
									<li class="<cfif rc.action eq 'public:main.login'>active</cfif>">
										<a href="?display=login"><i class="icon-home"></i> Account Login</a>
									</li>
									<li class="<cfif rc.action eq 'public:register.account'>active</cfif>">
										<a href="#buildURL('public:register.account')#"><i class="icon-home"></i> Register Account</a>
									</li>
									<li class="<cfif rc.action eq 'public:main.forgotpassword'>active</cfif>">
										<a href="#buildURL('public:main.forgotpassword')#"><i class="icon-leaf"></i> Forgot Password</a>
									</li>
								</cfif>

							</ul>
						</li>
					</ul>
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