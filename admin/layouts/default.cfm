<!---
	#rc.pc.getFullPath()# = /var/www/virtuals/devel.niesc.k12.in.us/www/plugins/SchoolMembership
	#HTMLEditFormat(rc.pc.getPackage())# = SchoolMembership
	#$.siteConfig('site')# = Default

	Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#"
--->
<cfoutput>
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
		<!--- <style>
			/* JS disabled styles */
			.no-js subnav li:hover ul { display:block; }

			/* base nav styles */
			subnav { display:block; margin:0 auto 20px; border:1px solid ##222; position:relative; background-color:##666666; font:16px Tahoma, Sans-serif; }
			subnav ul { padding:0; margin:0; }
			subnav li { position:relative; float:left; list-style-type:none; }
			subnav ul:after { content:"."; display:block; height:0; clear:both; visibility:hidden; }
			subnav li a { display:block; padding:10px 20px; border-left:1px solid ##999; border-right:1px solid ##222; color:##FFFFFF; text-decoration:none; }
			subnav li a:focus { outline:none; color:##CCCCCC; text-decoration:none; }
			subnav li a:hover { outline:none; color:##CCCCCC; text-decoration:none; }
			subnav li:first-child a { border-left:none; }
			subnav li.last a { border-right:none; }
			subnav a span { display:block; float:right; margin-left:5px; }
			subnav ul ul { display:none; width:100%; position:absolute; left:0; background:##6a6a6a; }
			subnav ul ul li { float:none; }
			subnav ul ul a { padding:5px 10px; border-left:none; border-right:none; font-size:14px; }
			subnav ul ul a:hover { background-color:##555; color:##fff; text-decoration:none;  }

			/* CSS3 */
			.borderradius subnav { -moz-border-radius:4px; -webkit-border-radius:4px; border-radius:4px; }
			.cssgradients subnav { background-image:-moz-linear-gradient(0% 22px 90deg, ##222, ##999); background-image:-webkit-gradient(linear, 0% 0%, 0% 70%, from(##999), to(##222)); }
			.boxshadow.rgba subnav { -moz-box-shadow:2px 2px 2px rgba(0,0,0,.75); -webkit-box-shadow:2px 2px 2px rgba(0,0,0,.75); box-shadow:2px 2px 2px rgba(0,0,0,.75); }
			.cssgradients subnav li:hover { background-image:-moz-linear-gradient(0% 100px 90deg, ##999, ##222); background-image:-webkit-gradient(linear, 0% 0%, 0% 100%, from(##222), to(##555)); }
			.borderradius subnav ul ul { -moz-border-radius-bottomleft:4px; -moz-border-radius-bottomright:4px; -webkit-border-bottom-left-radius:4px; -webkit-border-bottom-right-radius:4px; border-bottom-left-radius:4px; border-bottom-right-radius:4px; }
			.boxshadow.rgba subnav ul ul { background-color:rgba(0,0,0,0.8); -moz-box-shadow:2px 2px 2px rgba(0,0,0,.8); -webkit-box-shadow:2px 2px 2px rgba(0,0,0,.8); box-shadow:2px 2px 2px rgba(0,0,0,.8); }
			.rgba subnav ul ul li { border-left:1px solid rgba(0,0,0,0.1); border-right:1px solid rgba(0,0,0,0.1); }
			.rgba subnav ul ul a:hover { background-color:rgba(85,85,85,.9); }
			.borderradius.rgba subnav ul ul li.last { border-left:1px solid rgba(0,0,0,0.1); border-bottom:1px solid rgba(0,0,0,0.1); -moz-border-radius-bottomleft:4px; -moz-border-radius-bottomright:4px; -webkit-border-bottom-left-radius:4px; -webkit-border-bottom-right-radius:4px; border-bottom-left-radius:4px; border-bottom-right-radius:4px; }
			.csstransforms ul a span { -moz-transform:rotate(-180deg);-webkit-transform:rotate(-180deg); }
		</style> --->
		<!--[if IE]> <link rel="stylesheet" href="#$.siteConfig('themeAssetPath')#/css/subnavbar/subnavbar-ie.css"> <![endif]-->
		<script>
			(function($){
				//cache nav
				var browser = {};
				var nav = $("##subNav");

				//add indicators and hovers to submenu parents
				nav.find("li").each(function() {
					if ($(this).find("ul").length > 0) {
						$("<span>").text("^").appendTo($(this).children(":first"));

						//show subnav on hover
						$(this).mouseenter(function() {
							$(this).find("ul").stop(true, true).slideDown();
						});

						//hide submenus on exit
						$(this).mouseleave(function() {
							$(this).find("ul").stop(true, true).slideUp();
						});
					}
				});
			})(jQuery);
		</script>
	</head>
	<body class="no-js">
		<script>
			var el = document.getElementsByTagName("body")[0];
			el.className = "";
		</script>
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
						</li>
						<cfif Session.Mura.IsLoggedIn EQ "true">
							<cfif Session.Mura.Username EQ "admin">
								<li><a href="/plugins/EventRegistration/" class="active">Event Administration</a>
									<ul>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:caterers.default" class="active">Manage Catering</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:events.default" class="active">Manage Events</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:facilities.default" class="active">Manage Facilities</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:membership.default" class="active">Manage Membership</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:presenters.default" class="active">Manage Presenters</a></li>
										<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:users.default" class="active">Manage Users</a></li>
									</ul>
								</li>
								<li><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:sysadmin.default" class="active">System Administration</a>

								</li>
							</cfif>
						</cfif>
					</ul>
				</nav>

				<div class="art-layout-wrapper">
					<div class="art-content-layout">
						<div class="art-content-layout-row">
							<div class="art-layout-cell art-content">
								<article class="art-post art-article">
									<div class="art-block clearfix">
										<cfif isDefined("URL.EventRegistrationaction")>
											<cfswitch expression="#URL.EventRegistrationaction#">
												<cfcase value="caterers">
													<div class="art-blockheader">
														<h3 class="t">Manage Catering Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="admin:caterers">
													<div class="art-blockheader">
														<h3 class="t">Manage Catering Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="caterers.default">
													<div class="art-blockheader">
														<h3 class="t">Manage Catering Administrative Interface</h3>
													</div>
												</cfcase>

												<cfcase value="events">
													<div class="art-blockheader">
														<h3 class="t">Manage Events Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="admin:events">
													<div class="art-blockheader">
														<h3 class="t">Manage Events Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="events.default">
													<div class="art-blockheader">
														<h3 class="t">Manage Events Administrative Interface</h3>
													</div>
												</cfcase>

												<cfcase value="facilities">
													<div class="art-blockheader">
														<h3 class="t">Manage Facility Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="admin:facilities">
													<div class="art-blockheader">
														<h3 class="t">Manage Facility Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="facilities.default">
													<div class="art-blockheader">
														<h3 class="t">Manage Facility Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="presenters">
													<div class="art-blockheader">
														<h3 class="t">Manage Presenters Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="admin:presenters">
													<div class="art-blockheader">
														<h3 class="t">Manage Presenters Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="presenters.default">
													<div class="art-blockheader">
														<h3 class="t">Manage Presenters Administrative Interface</h3>
													</div>
												</cfcase>

												<cfcase value="users">
													<div class="art-blockheader">
														<h3 class="t">Manage Users Administrative Interface</h3>
													</div>
												</cfcase>
												<cfcase value="users.default">
													<div class="art-blockheader">
														<h3 class="t">Manage Users Administrative Interface</h3>
													</div>
												</cfcase>
											</cfswitch>
										<cfelse>
											<div class="art-blockheader">
												<h3 class="t">Event Registration Administrative Interface</h3>
											</div>
										</cfif>
										<div class="art-blockcontent">
											<p>#body#</p>
										</div>

								<!---
								<article class="art-post art-article">
									<div class="art-postmetadataheader">
										<h2 class="art-postheader"><span class="art-postheadericon">Page 1</span></h2>
									</div>
									<div class="art-postcontent art-postcontent-0 clearfix">
										<div class="art-content-layout">
											<div class="art-content-layout-row">
												<div class="art-layout-cell layout-item-0" style="width: 100%" >
													<p>Top Center Content Box</p>
												</div>
											</div>
										</div>
										<div class="art-content-layout">
											<div class="art-content-layout-row">
												<div class="art-layout-cell layout-item-0" style="width: 100%" >
													<p><img src="images/preview.jpg" alt="an image" id="preview-image" name="preview-image" class="">Enter Page content here...</p>
													<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam pharetra, tellus sit amet congue vulputate, nisi erat iaculis nibh, vitae feugiat sapien ante eget mauris.&nbsp;Aenean sollicitudin imperdiet arcu, vitae dignissim est posuere id.</p>
													<p><a href="">Read more</a></p>
												</div>
											</div>
										</div>
										<div class="art-content-layout">
											<div class="art-content-layout-row">
												<div class="art-layout-cell layout-item-0" style="width: 100%" >
													<p><input type="text"><br></p>
												</div>
											</div>
										</div>
										<div class="art-content-layout">
											<div class="art-content-layout-row">
												<div class="art-layout-cell layout-item-0" style="width: 50%" >
													<ul>
														<li>Suspendisse pharetra auctor pharetra. Nunc a sollicitudin est.</li>
														<li>Donec vel neque in neque porta venenatis sed sit amet lectus.</li>
														<li>Curabitur ullamcorper gravida felis, sit amet scelerisque lorem iaculis sed.</li>
													</ul>
												</div>
												<div class="art-layout-cell layout-item-0" style="width: 50%" >
													<blockquote style="margin: 10px 0">Nunc a sollicitudin est. Curabitur ullamcorper gravida felis, sit amet scelerisque lorem iaculis sed. Donec vel neque in neque porta venenatis sed sit amet lectus.</blockquote>
												</div>
											</div>
										</div>
									</div>

								--->
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
</cfoutput>