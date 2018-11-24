<cfset request.layout = false>
<cfoutput>
	#body#
</cfoutput>

	<!---
<!DOCTYPE html>
<html dir="ltr" lang="en-US">
	<head>
		<meta charset="utf-8">
		<title>Event Registration | Northern Indiana ESC - Administration Page</title>
		<meta name="viewport" content="initial-scale = 1.0, maximum-scale = 1.0, user-scalable = no, width = device-width">
		<meta name="ROBOTS" CONTENT="INDEX, FOLLOW" />
		<meta name="Author" content="Graham Pearson, webmaster@yourcfpro.com" />
		<link rel="shortcut icon" href="/favicon.ico" />

	<!--[if lt IE 9]><script src="https://html5shiv.googlecode.com/svn/trunk/html5.js"></script><![endif]-->
	<link href="//maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css" rel="stylesheet">
	<link rel="stylesheet" href="/plugins/EventRegistration/includes/assets/css/ui-custom/jquery-ui-1.10.4.custom.min.css" media="screen">
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/style.css" media="screen">
	<!--[if lte IE 7]><link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/style.ie7.css" media="screen" /><![endif]-->
	<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/style.responsive.css" media="all">

	<script src="#$.siteConfig('themeAssetPath')#/js/jquery.js"></script>
	<script src="/plugins/EventRegistration/includes/assets/js/jquery-ui-1.9.2.custom.min.js"></script>
	<script src="/plugins/EventRegistration/includes/assets/js/jquery-ui-timepicker-addon.js"></script>
	<script src="#$.siteConfig('themeAssetPath')#/js/script.js"></script>
	<script src="#$.siteConfig('themeAssetPath')#/js/script.responsive.js"></script>

	<style>
		.art-content .art-postcontent-0 .layout-item-0 { padding-right: 5px;padding-left: 5px;  }
		.ie7 .art-post .art-layout-cell {border:none !important; padding:0 !important; }
		.ie6 .art-post .art-layout-cell {border:none !important; padding:0 !important; }
	</style>
	<style>
		.alert-box { color:##555; border-radius:10px; font-family:Tohoma,Geneva,Arial,sans-serif; font-size:14px; padding: 10px 10px 10px 36px; margin:10px; }
		.alert-box span { font-weight: bold; text-transform: uppercase; }
		.error { background:##ffecec url('#$.siteConfig('themeAssetPath')#/images/alertbox/error.png') no-repeat 10px 50%; border:1px solid ##f5aca6; }
		.success { background:##e9ffd9 url('#$.siteConfig('themeAssetPath')#/images/alertbox/success.png') no-repeat 10px 50%; border:1px solid ##a6ca8a; }
		.warning { background:##fff8c4 url('#$.siteConfig('themeAssetPath')#/images/alertbox/warning.png') no-repeat 10px 50%; border:1px solid ##f2c779; }
		.notice { background:##e3f7fc url('#$.siteConfig('themeAssetPath')#/images/alertbox/notice.png') no-repeat 10px 50%; border:1px solid ##8ed9f6; }
	</style>
	<style>
		.ui-timepicker-div .ui-widget-header { margin-bottom: 8px; }
		.ui-timepicker-div dl { float: left; text-align: left; }
		.ui-timepicker-div dl dt { float: left; clear: left; padding: 0 0 0 5px; width: 25%; }
		.ui-timepicker-div dl dd { float: left; margin: 0 10px 10px 45%; width: 75%; }
		.ui-timepicker-div td { font-size: 90%; }
		.ui-tpicker-grid-label { background: none; border: none; margin: 0; padding: 0; }
		.ui-timepicker-rtl{ direction: rtl; }
		.ui-timepicker-rtl dl { text-align: right; padding: 0 5px 0 0; }
		.ui-timepicker-rtl dl dt{ float: right; clear: right; }
		.ui-timepicker-rtl dl dd { margin: 0 45% 10px 10px; }
	</style>
	<!--[if IE]> <link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/subnavbar/subnavbar-ie.css"> <![endif]-->
</head>
<body>
	<div id="art-main">
		<div class="art-sheet clearfix">
			<header class="art-header">
				<div class="art-shapes"></div>
				<div class="art-slider art-slidecontainerheader" data-width="898" data-height="150">
					<div class="art-slider-inner">
						<div class="art-slide-item art-slideheader0"></div>
						<div class="art-slide-item art-slideheader1"></div>
						<div class="art-slide-item art-slideheader2"></div>
						<div class="art-slide-item art-slideheader3"></div>
						<div class="art-slide-item art-slideheader4"></div>
					</div>
				</div>
				<div class="art-slidenavigator art-slidenavigatorheader" data-left="0" data-top="0">
					<a href="" class="art-slidenavigatoritem"></a>
					<a href="" class="art-slidenavigatoritem"></a>
					<a href="" class="art-slidenavigatoritem"></a>
					<a href="" class="art-slidenavigatoritem"></a>
					<a href="" class="art-slidenavigatoritem"></a>
				</div>
			</header>
			<nav class="art-hmenu">
				<ul class="art-hmenu">
					<li><a href="/index.cfm" class="active">Home</a>
						<cfif isDefined("Session.Mura")>
							<cfif Session.Mura.IsLoggedIn EQ "false">
								<ul>
									<li><a href="/index.cfm?display=login">Account Login</a></li>
									<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.lostpassword">Lost Password</a></li>
									<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registeruser.default">Create Account</a></li>
								</ul>
							<cfelseif Session.Mura.IsLoggedIn EQ "true">
								<ul>
									<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.changepassword">Change Password</a></li>
									<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.editprofile">Manage Account</a></li>
									<li><a href="/index.cfm?doaction=logout">Account Logout</a></li>
								</ul>
							</cfif>
						<cfelse>
							<ul>
								<li><a href="/index.cfm?display=login">Account Login</a></li>
								<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.lostpassword">Lost Password</a></li>
								<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registeruser.default">Create Account</a></li>
							</ul>
						</cfif>
					</li>
					<cfif isDefined("Session.Mura")>
						<cfif Session.Mura.IsLoggedIn EQ "true">
							<cfparam name="EventCoordinatorRole" default="0" type="boolean">
							<cfparam name="EventPresenterRole" default="0" type="boolean">
							<cfset UserMembershipQuery = #$.currentUser().getMembershipsQuery()#>
							<cfloop query="#Variables.UserMembershipQuery#">
								<cfif UserMembershipQuery.GroupName EQ "Event Coordinator"><cfset EventCoordinatorRole = true></cfif>
								<cfif UserMembershipQuery.GroupName EQ "Presenter"><cfset EventPresenterRole = true></cfif>
							</cfloop>
							<cfif Session.Mura.Username EQ "admin">
								<li><a href="/plugins/EventRegistration/" class="active">Event Administration</a>
									<ul>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=caterers.default" class="active">Manage Catering</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=events.default" class="active">Manage Events</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=facilities.default" class="active">Manage Facilities</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=membership.default" class="active">Manage Membership</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=presenters.default" class="active">Manage Presenters</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=users.default" class="active">Manage Users</a></li>
									</ul>
								</li>
							</cfif>
							<cfif Variables.EventCoordinatorRole EQ "true" and Variables.EventPresenterRole EQ "false">
								<li><a href="" class="active">Event Administration</a>
									<ul>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:caterers.default" class="active">Manage Catering</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:events.default" class="active">Manage Events</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:facilities.default" class="active">Manage Facilities</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:membership.default" class="active">Manage Membership</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:presenters.default" class="active">Manage Presenters</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:users.default" class="active">Manage Users</a></li>
									</ul>
								</li>
							<cfelseif Variables.EventCoordinatorRole EQ "false" and Variables.EventPresenterRole EQ "true">
								<li><a href="" class="active">Presenter Administration</a>
									<!--- <ul>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:caterers.default" class="active">Manage Catering</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:events.default" class="active">Manage Events</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:facilities.default" class="active">Manage Facilities</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:membership.default" class="active">Manage Membership</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:presenters.default" class="active">Manage Presenters</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:users.default" class="active">Manage Users</a></li>
									</ul> --->
								</li>
							<cfelseif Variables.EventCoordinatorRole EQ "false" and Variables.EventPresenterRole EQ "false">
								<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.default" class="active">User Administration</a>
									<ul>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.manageregistrations" class="active">Manage Registrations</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.getcertificate" class="active">Print Certificates</a></li>
									</ul>
								</li>
							</cfif>
						</cfif>
					</cfif>
					<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:feedback.default" class="active">Comments / Suggestions</a></li>
					<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:feedback.requestworkshop" class="active">Request Workshop</a></li>
				</ul>
			</nav>
			<div class="art-layout-wrapper">
				<div class="art-content-layout">
					<div class="art-content-layout-row">
						<div class="art-layout-cell art-content">
							<article class="art-post art-article">
								<div class="art-block clearfix">
									<cfif isDefined("URL.UserPasswordChangeSuccessfull")>
										<cfif URL.UserPasswordChangeSuccessfull EQ "True">
											<div class="alert-box success">You have updated your password and will need to use it upon next time you login to this system.</div>
										</cfif>
										<cfif URL.UserPasswordChangeSuccessfull EQ "False">
											<div class="alert-box error">Your account password has not been changed due to an error. Please try your request again.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.UserProfileUpdateSuccessfull")>
										<cfif URL.UserProfileUpdateSuccessfull EQ "true">
											<div class="alert-box success">Your profile has been updated with the information you have just submitted.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.SentCommentInquiry")>
										<cfif URL.SentCommentInquiry EQ "true">
											<div class="alert-box success">Your inquiry has been received and is in the process of being sent to someone who will be able to answer your inquiry. Please allow 1 - 2 business days for your inquiry to be answered.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.SentInquiry")>
										<cfif URL.SentInquiry EQ "true">
											<div class="alert-box success">Your inquiry has been received and is in the process of being sent to someone who will be able to answer your inquiry. Please allow 1 - 2 business days for your inquiry to be answered.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.UserRegistrationSuccessfull")>
										<cfif URL.UserRegistrationSuccessfull EQ "true">
											<div class="alert-box success">Your have successfully registered for an account on this system. Within the next few minutes you will receive an email confirmation with a special link to click on that will active your account. Once your account has been activated, you will be able to login to this site and register for any event or workshop you would like to attend.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.UserRegistrationActive")>
										<cfif URL.UserRegistrationActive EQ "true">
											<div class="alert-box success">Your account has been activated on this system. You will now be able to login with your email address and your password to register for any upcoming event you would like to attend.</div>
										</cfif>
										<cfif URL.UserRegistrationActive EQ "failed">
											<div class="alert-box error">User Activation Failed. The user activation process failed due to the time difference between the activation email which was sent and the time you viewed it in your browser was greater than 45 minutes. A new activation email has been sent to the email address this system has on file for your account.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.UserAccountPasswordVerify")>
										<cfif URL.UserAccountPasswordVerify EQ "true">
											<div class="alert-box success">Within the next few minutes, you should receive an email that will have further instructions on how to change your password with this system. If you do not receive this email, please check your SPAM or JUNK folders.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.UserAccountNotModified")>
										<cfif URL.UserAccountNotModified EQ "true">
											<div class="alert-box notice">Your account has not been modified due to not answering the question on the previous form correctly. If you intended for your account password to be changed, please go through the Lost Password steps again.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.UserAccountPasswordSent")>
										<cfif URL.UserAccountPasswordSent EQ "true">
											<div class="alert-box success">Within the next few minutes, you should receive an email that will have your temporary password within it. Once you receive this email you will be able to login and edito your profile to change your password to something easier to remember. If you do not receive this email, please check your SPAM or JUNK folders.</div>
										</cfif>
									</cfif>
									<cfif isDefined("URL.RegistrationSuccessfull")>
										<cfif URL.RegistrationSuccessfull EQ "true">
											<cfif isDefined("URL.SingleRegistration")>
												<cfif URL.SingleRegistration EQ "True">
													<div class="alert-box success">You have successfully completed the registration process  for yourself regarding the workshop or event you registered for. Within the next few minutes, you will be receiving an email confirmation with details about this event or workshop.</div>
												</cfif>
											</cfif>
											<cfif isDefined("URL.MultipleRegistration")>
												<cfif URL.MultipleRegistration EQ "true">
													<div class="alert-box success">You have successfully completed the registration process for multiple individuals to attend this event or workshop. Within the next few minutes each individaul will be receiving an email confirmation with details about this event or workshop.</div>
												</cfif>
											</cfif>
										</cfif>
									</cfif>
									<div class="art-blockcontent">
										<p>#body#</p>
									</div>
								</div>
							</article>
						</div>
					</div>
				</div>
			</div>
			<footer class="art-footer">
				<p><a href="">Link1</a> | <a href="">Link2</a> | <a href="">Link3</a></p>
				<p>Copyright &copy; #DateFormat(Now(), "yyyy")#. Northern Indiana Educational Services Center. All Rights Reserved.</p>
				<cfset DateLastRepositoryCommit = #CreateDate(2014, 06, 02)#>
				<p>Event Registration System Version 2.00a #DateFormat(Variables.DateLastRepositoryCommit, "full")#</p>
			</footer>
		</div>
	</div>
</body>
</html>
<cfdump var="#rc#"> --->
