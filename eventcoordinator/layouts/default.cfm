<cfsilent>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cfset Session.PluginFramework = StructCopy(Variables.Framework)>
		</cflock>
	</cfif>
</cfsilent>
<cfoutput>
	<!DOCTYPE html>
	<html lang="en">
		<head>
			<meta charset="utf-8">
			<meta http-equiv="X-UA-Compatible" content="IE=edge">
			<meta name="viewport" content="width=device-width, initial-scale=1.0">
			<meta name="generator" content="Mura CMS #$.globalConfig('version')#">
			<title>Event Registration - #esapiEncode('html', $.siteConfig('site'))#</title>
			<!--- Mura CMS Base Styles--->
			<link rel="stylesheet" href="#$.siteConfig('assetPath')#/css/mura.7.0.min.css?v=#$.siteConfig('version')#">
			<!--- Optional: Mura CMS Skin Styles. Duplicate to your theme to customize, changing 'assetPath' to 'themeAssetPath' below. Don't forget to move, remove or replace sprite.png. --->
			<link rel="stylesheet" href="#$.siteConfig('assetPath')#/css/mura.7.0.skin.css?v=#$.siteConfig('version')#">
			<!--- Bootstrap core CSS --->
			<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/assets/bootstrap/css/bootstrap.min.css">
			<!--- Font Awesome --->
			<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/assets/font-awesome/css/font-awesome.css">
			<link rel="stylesheet" type="text/css" href="/plugins/#Variables.Framework.CFCBASE#/assets/js/jquery-datepicker/css/jquery.datepick.css"> 
			<link rel="stylesheet" type="text/css" href="/plugins/#Variables.Framework.CFCBASE#/assets/js/jquery-timepicker/jquery.timepicker.min.css"> 

			<!---
				THEME CSS
				This has been compiled using a pre-processor such as CodeKit or Prepros
			--->
			<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/theme/theme.min.css">
			<!--[if IE]>
				<link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/ie/ie.min.css">
			<![endif]-->

			<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
			<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
			<!--[if lt IE 9]>
				<script src="#$.siteConfig('themeAssetPath')#/js/html5shiv/html5shiv.js"></script>
				<script src="#$.siteConfig('themeAssetPath')#/js/respond/respond.min.js"></script>
			<![endif]-->
			
			<!--- jQuery --->
			<script src="#$.siteConfig('assetPath')#/js/external/jquery.min.js"></script>
			<script src="/plugins/#Variables.Framework.CFCBASE#/assets/js/jquery-datepicker/js/jquery.plugin.js"></script>
			<script src="/plugins/#Variables.Framework.CFCBASE#/assets/js/jquery-datepicker/js/jquery.datepick.js"></script>
			<script src="/plugins/#Variables.Framework.CFCBASE#/assets/js/jquery-timepicker//jquery.timepicker.min.js"></script>

			<!--- FAV AND TOUCH ICONS --->
			<link rel="shortcut icon" href="#$.siteConfig('assetPath')#/images/favicon.ico">
			<!--- <link rel="apple-touch-icon-precomposed" sizes="144x144" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-144-precomposed.png">
				<link rel="apple-touch-icon-precomposed" sizes="114x114" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-114-precomposed.png">
				<link rel="apple-touch-icon-precomposed" sizes="72x72" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-72-precomposed.png">
				<link rel="apple-touch-icon-precomposed" href="#$.siteConfig('themeAssetPath')#/images/ico/ico/apple-touch-icon-57-precomposed.png"> --->
			<style>
				.dropdown-submenu { position: relative; }
				.dropdown-submenu>.dropdown-menu { top: 0; left: 100%; margin-top: -6px; margin-left: -1px; -webkit-border-radius: 0 6px 6px 6px; -moz-border-radius: 0 6px 6px; border-radius: 0 6px 6px 6px; }
				.dropdown-submenu:hover>.dropdown-menu { display: block; }
				.dropdown-submenu>a:after { display: block; content: " "; float: right; width: 0; height: 0; border-color: transparent; border-style: solid; border-width: 5px 0 5px 5px; border-left-color: ##ccc; margin-top: 5px; margin-right: -10px; }
				.dropdown-submenu:hover>a:after { border-left-color: ##fff; }
				.dropdown-submenu.pull-left { float: none; }
				.dropdown-submenu.pull-left>.dropdown-menu { left: -100%; margin-left: 10px; -webkit-border-radius: 6px 0 6px 6px; -moz-border-radius: 6px 0 6px 6px; border-radius: 6px 0 6px 6px; } 
			</style>
		</head>
		<body id="EventRegistrationPlugin" class="home" data-spy="scroll" data-target=".subnav" data-offset="50">
			<header class="navbar-wrapper">
				<nav class="navbar navbar-inverse navbar-static-top" role="navigation">
					<div class="container">
						<div class="navbar-header">
							<a class="navbar-brand" href="#$.createHREF(filename='')#">#esapiEncode('html', $.siteConfig('site'))# - #esapiEncode('html', Variables.Framework.Package)#</a>
						</div><!--- /.navbar-header --->
						<div class="collapse navbar-collapse navbar-ex1-collapse">
							<div class="row">
								<div class="col-md-9">
									<ul id="navPrimary" class="nav navbar-nav">
										<li class="<cfif URL[Variables.Framework.Action] CONTAINS 'eventcoordinator:main'>active</cfif>">
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
										<li class="<cfif URL[Variables.Framework.Action] CONTAINS 'eventcoordinator:catering'>active</cfif>">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Catering Menu <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:catering.addcaterer')#">Add New Caterer</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:catering.default')#">List All Caterers</a></li>
											</ul>
										</li>
										<li class="<cfif URL[Variables.Framework.Action] CONTAINS 'eventcoordinator:events'>active</cfif>">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Events Menu <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:events.addevent')#">Add New Event</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:events.default')#">List All Events</a></li>
											</ul
											>
										</li>
										<li class="<cfif URL[Variables.Framework.Action] CONTAINS 'eventcoordinator:facilities'>active</cfif>">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Facility Menu <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:facilities.addfacility')#">Add New Facility</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:facilities.default')#">List All Facilities</a></li>
											</ul>
										</li>
										<li class="<cfif URL[Variables.Framework.Action] CONTAINS 'eventcoordinator:membership'>active</cfif>">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Membership Menu <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:membership.addmember')#">Add New Member</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:membership.default')#">List All Members</a></li>
											</ul>
										</li>
										<li class="<cfif URL[Variables.Framework.Action] CONTAINS 'eventcoordinator:users'>active</cfif>">
											<a href="##" class="dropdown-toggle" data-toggle="dropdown">Users Menu <b class="caret"></b></a>
											<ul class="dropdown-menu">
												<li class=""><a href="#buildURL('eventcoordinator:users.newuser')#">Add New User</a></li>
												<li class=""><a href="#buildURL('eventcoordinator:users.default')#">List All Users</a></li>
											</ul>
										</li>
									</ul>
								</div>
							</div><!--- /.row --->
						</div><!--- /.navbar-collapse --->
					</div><!--- /.container --->
				</nav><!--- /nav --->
			</header>
			<cfsavecontent variable="local.errors">
				<cfif StructKeyExists(rc, 'errors') and IsArray(rc.errors) and ArrayLen(rc.errors)>
					<div class="alert alert-error">
						<button type="button" class="close" data-dismiss="alert"><i class="icon-remove-sign"></i></button>
						<h2>Alert!</h2>
						<h3>Please note the following message<cfif ArrayLen(rc.errors) gt 1>s</cfif>:</h3>
						<ul>
							<cfloop from="1" to="#ArrayLen(rc.errors)#" index="local.e">
								<li>
									<cfif IsSimpleValue(rc.errors[local.e])>
										<cfoutput>#rc.errors[local.e]#</cfoutput>
									<cfelse>
										<cfdump var="#rc.errors[local.e]#" />
									</cfif>
								</li>
							</cfloop>
						</ul>
					</div><!--- /.alert --->
				</cfif>
			</cfsavecontent>
				
			
			<div class="container">
				<div class="row">
					<section class="col-md-12 content">
						<br>
						#body#
					</section>
				</div><!--- /.row --->			
			</div><!-- /.container -->
			<footer class="footer-wrapper">
				<div class="container">
					<div class="row footer-top">
						<div class="col-md-3">
							<cfif LEN(Session.SiteConfigSettings.GitHub_URL) or LEN(Session.SiteConfigSettings.Twitter_URL) or LEN(Session.SiteConfigSettings.Facebook_URL) or LEN(Session.SiteConfigSettings.GoogleProfile_URL) or LEN(Session.SiteConfigSettings.LinkedIn_URL)>
							<h4>Follow</h4>
							<ul class="nav nav-pills nav-social">
								<cfif LEN(Session.SiteConfigSettings.GitHub_URL)><li><a class="github" href="#Session.SiteConfigSettings.GitHub_URL#" target="_blank"><i class="fa fa-github"></i></a></li></cfif>
								<cfif LEN(Session.SiteConfigSettings.Twitter_URL)><li><a class="twitter" href="#Session.SiteConfigSettings.Twitter_URL#" target="_blank"><i class="fa fa-twitter"></i></a></li></cfif>
								<cfif LEN(Session.SiteConfigSettings.Facebook_URL)><li><a class="facebook" href="#Session.SiteConfigSettings.Facebook_URL#" target="_blank"><i class="fa fa-facebook"></i></a></li></cfif>
								<cfif LEN(Session.SiteConfigSettings.GoogleProfile_URL)><li><a class="google" href="#Session.SiteConfigSettings.GoogleProfile_URL#" target="_blank"><i class="fa fa-google"></i></a></li></cfif>
								<cfif LEN(Session.SiteConfigSettings.LinkedIn_URL)><li><a class="linkedin" href="#Session.SiteConfigSettings.LinkedIn_URL#" target="_blank"><i class="fa fa-linkedin"></i></a></li></cfif>
							</ul>
							</cfif>
						</div>
						<div class="col-md-3">
							<h4>Contact Info</h4>
							<ul class="nav nav-stacked">
								<li>
									<a href="tel:#esapiEncode('html', $.siteConfig('contactphone'))#"><i class="fa fa-phone"></i> #esapiEncode('html', $.siteConfig('contactphone'))#</a>
								</li>
								<li>
									<a href="mailto:#esapiEncode('html', $.siteConfig('contactemail'))#"><i class="fa fa-envelope"></i> #esapiEncode('html', $.siteConfig('contactemail'))#</a>
								</li>
							</ul>
						</div>
						<div class="col-md-6">
							<h4>About</h4>
							<p>Mura CMS's rich feature set and powerful extensibility provides a toolkit for tackling and completing challenging Web projects, even those requiring deep integration and custom development. Our professional services team can assist your developers or lead the project from conception to delivery.</p>
						</div>
					</div>
					<div class="row footer-bottom">
						<div class="col-lg-10">
							<ul class="pull-left breadcrumb">
								<li>&copy; #esapiEncode('html', $.siteConfig('site'))# #year(now())#</li>
								<!---
									These links are dependent upon specific Pages to exist within Mura,
									and are used with the MuraBootstrap3 Bundle
									<li><a href="#$.createHref(filename='site-map')#">Site Map</a></li>
									<li><a href="#$.createHref(filename='font-awesome')#">Font Awesome</a></li>
									<li><a href="#$.createHref(filename='bootstrap')#">Bootstrap</a></li>
								--->
								<li><a href="##myModal" data-toggle="modal">Sample Modal Window</a></li>
								<li><a href="http://www.getmura.com"><i class="fa fa-plug"></i> Powered by Mura</a></li>
							</ul>
						</div>
						<cfset backToTop = '<a class="btn back-to-top" href="##"><i class="fa fa-chevron-up"></i></a>' />
						<div class="col-lg-2">
							<p class="scroll-top hidden-sm hidden-xs pull-right">#backToTop#</p>
							<p class="scroll-top visible-sm visible-xs pull-left">#backToTop#</p>
						</div>
					</div>
				</div>
			</footer>
			#$.dspThemeInclude('display_objects/examples/sampleModalWindow.cfm')#
			<!--- Bootstrap JavaScript --->
			<script src="#$.siteConfig('themeAssetPath')#/assets/bootstrap/js/bootstrap.min.js"></script>
    		<!--- Theme JavaScript --->
    		<script src="#$.siteConfig('themeAssetPath')#/js/theme/theme.min.js"></script>
		</body>
	</html>
</cfoutput>