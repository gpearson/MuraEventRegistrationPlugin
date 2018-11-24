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
							<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
							<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
							<cfset UserMembershipQuery = #$.currentUser().getMembershipsQuery()#>
							<cfloop query="#Variables.UserMembershipQuery#">
								<cfif UserMembershipQuery.GroupName EQ "Event Facilitator"><cfset Session.Mura.EventCoordinatorRole = true></cfif>
								<cfif UserMembershipQuery.GroupName EQ "Presenter"><cfset Session.Mura.EventPresenterRole = true></cfif>
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
							<cfif Session.Mura.EventCoordinatorRole EQ "true" and Session.Mura.EventPresenterRole EQ "false">
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
							<cfelseif Session.Mura.EventCoordinatorRole EQ "false" and Session.Mura.EventPresenterRole EQ "true">
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
							<cfelseif Session.Mura.EventCoordinatorRole EQ "false" and Session.Mura.EventPresenterRole EQ "false">
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
									<div class="art-blockcontent">
										<cfif not isDefined("URL.EventID")><cflocation addtoken="true" url="/index.cfm"></cfif>
										<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
											From eEvents
											Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
												TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
												Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
												EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select Count(TContent_ID) as CurrentNumberofRegistrations
											From eRegistrations
											Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfquery name="getEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, GeoCode_Latitude, GeoCode_Longitude, GeoCode_StateLongName
											From eFacility
											Where FacilityType = <cfqueryparam value="#getSelectedEvent.LocationType#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfquery name="getEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select RoomName, Capacity
											From eFacilityRooms
											Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> and Facility_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select FName, Lname, Email
											From tusers
											Where UserID = <cfqueryparam value="#getSelectedEvent.Facilitator#" cfsqltype="cf_sql_varchar">
										</cfquery>
											<cfif not isDefined("URL.DrivingDirections")>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Viewing Event: #getSelectedEvent.ShortTitle#</h3>
			</div>
			<div class="art-blockcontent">
				<!--- <cfdump var="#getSelectedEvent#">
				<cfdump var="#getEventFacilityRoom#">
				<cfdump var="#getCurrentRegistrationsbyEvent#">
				<cfabort> --->
				<table class="art-article" style="width:100%;" border="1" cellpadding="1" cellspacing="1">
			<tbody>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;"><cfif LEN(getSelectedEvent.EventDate1) or LEN(getSelectedEvent.EventDate2) or LEN(getSelectedEvent.EventDate3) or LEN(getSelectedEvent.EventDate4)>Event Dates:<cfelse>Event Date:</cfif></span></td>
					<td colspan="3" rowspan="1">#DateFormat(getSelectedEvent.EventDate, "ddd mmm dd, yy")# <cfif LEN(getSelectedEvent.EventDate1)>, #DateFormat(getSelectedEvent.EventDate1, "ddd mmm dd, yy")#</cfif><cfif LEN(getSelectedEvent.EventDate2)>, #DateFormat(getSelectedEvent.EventDate2, "ddd mmm dd, yy")#</cfif><cfif LEN(getSelectedEvent.EventDate3)>, #DateFormat(getSelectedEvent.EventDate3, "ddd mmm dd, yy")#</cfif><cfif LEN(getSelectedEvent.EventDate4)>, #DateFormat(getSelectedEvent.EventDate4, "ddd mmm dd, yy")#</cfif></td>
				</tr>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Event Time:</span></td>
					<td style="width: 390px;">#TimeFormat(getSelectedEvent.Event_StartTime, "hh:mm t")# till #TimeFormat(getSelectedEvent.Event_EndTime, "hh:mm t")#</td>
					<td style="text-align: right; width: 175px;"><span style="font-weight: bold;">Registration Deadline:</span></td>
					<td style="width: 175px;">#DateFormat(getSelectedEvent.Registration_Deadline, "ddd mmm dd, yy")#</td>
				</tr>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Seats Available:</span></td>
					<td style="width: 390px;">
						<cfif getSelectedEvent.MaxParticipants EQ 0>
							<cfset SeatsLeft = #getEventFacilityRoom.Capacity# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
							#Variables.SeatsLeft# out of #getEventFacilityRoom.Capacity# Seats Left
						<cfelse>
							<cfset SeatsLeft = #getSelectedEvent.MaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
							#Variables.SeatsLeft# out of #getSelectedEvent.MaxParticipants# Seats Left
						</cfif>
					</td>
					<td style="text-align: right; width: 175px;"><span style="font-weight: bold;">onSite Registration:</span></td>
					<td style="width: 175px;">
						<cfif Len(getSelectedEvent.Registration_BeginTime) EQ 0>
						#TimeFormat(DateAdd("h", -1, getSelectedEvent.Event_StartTime), "hh:mm t")#
						<cfelse>
						#TimeFormat(getSelectedEvent.Registration_BeginTime, "hh:mm t")#
						</cfif>
						 - #TimeFormat(getSelectedEvent.Event_StartTime, "hh:mm t")#
					</td>
				</tr>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Description:</span></td>
					<td colspan="3">#getSelectedEvent.LongDescription#</td>
				</tr>
				<cfif LEN(getSelectedEvent.EventAgenda)>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Agenda:</span></td>
					<td colspan="3" style="width: 141px;">#getSelectedEvent.EventAgenda#</td>
				</tr>
				</cfif>
				<cfif LEN(getSelectedEvent.EventTargetAudience)>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Target Audience:</span></td>
					<td colspan="3" style="width: 141px;">#getSelectedEvent.EventTargetAudience#</td>
					</tr>
				</cfif>
				<cfif LEN(getSelectedEvent.EventStrategies)>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Strategies:</span></td>
					<td colspan="3" style="width: 141px;">#getSelectedEvent.EventStrategies#</td>
					</tr>
				</cfif>
				<cfif LEN(getSelectedEvent.EventSpecialInstructions)>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Special Instructions:</span></td>
					<td colspan="3">#getSelectedEvent.EventSpecialInstructions#</td>
					</tr>
				</cfif>
				<cfif getSelectedEvent.PGPAvailable GT 0 and getSelectedEvent.MealProvided EQ 1>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
					<td style="width: 390px;">#NumberFormat(getSelectedEvent.PGPPoints, "999.99")#</td>
					<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
					<td style="width: 175px;"><cfif getSelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
					</tr>
				<cfelseif getSelectedEvent.PGPAvailable GT 0 and getSelectedEvent.MealProvided EQ 0>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
					<td colspan="3">&nbsp;&nbsp;#NumberFormat(getSelectedEvent.PGPPoints, "999.99")#</td>
					</tr>
				<cfelseif getSelectedEvent.PGPAvailable EQ 0 and getSelectedEvent.MealProvided EQ 1>
					<tr>
					<td colspan="2">&nbsp;</td>
					<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
					<td style="width: 175px;"><cfif getSelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
					</tr>
				</cfif>
				<cfif getSelectedEvent.WebinarAvailable EQ 1>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Webinar Information:</span></td>
					<td colspan="3">#getSelectedEvent.WebinarConnectInfo#</td>
					</tr>
					<tr>
					<td colspan="4">
					<table border="0" colspan="0" cellspan="0" align="center" width="100%">
					<tr>
					<td width="25%"><span style="font-weight: bold;">Webinar Member Cost:</span></td>
					<td width="25%">#DollarFormat(getSelectedEvent.WebinarMemberCost)#</td>
					<td width="25%"><span style="font-weight: bold;">Webinar NonMember Cost:</span></td>
					<td width="25%">#DollarFormat(getSelectedEvent.WebinarNonMemberCost)#</td>
					</tr>
					</table>
					</td>
					</tr>
				</cfif>
				<cfif getSelectedEvent.WebinarAvailable EQ 0 and getEventFacility.RecordCount NEQ 0>
					<tr>
					<td style="width: 141px;" colspan="4">
					<table class="art-article" style="width:100%;">
					<tbody>
					<tr>
					<td style="width: 225px;"><span style="font-weight: bold;">Event Location:</span></td>
					<td style="width: 300px;"><address><strong>#getEventFacility.FacilityName#</strong><br>
					#getEventFacility.PhysicalAddress#<BR>
					#getEventFacility.PhysicalCity#, #getEventFacility.PhysicalState# #getEventFacility.PhysicalZipCode#</address><br>
					<abbr title="Phone">P:</abbr> #getEventFacility.PrimaryVoiceNumber#
					</td>
					<td colspan="1" rowspan="4" style="width: 475px; text-align: center; vertical-align: top;">
					<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
					<!--[if lte IE 8]> <link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.ie.css" /> <![endif]-->
					<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
					<div id="map" style="width: 475px; height: 300px;"></div>
					<script>
						var facilitymarker;
						var map = L.map('map');
						map.setView(new L.LatLng(#getEventFacility.GeoCode_Latitude#, #getEventFacility.GeoCode_Longitude#), 12);
						L.tileLayer('http://tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 18 }).addTo(map);
						var FacilityMarker = L.icon({
							iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
						});
						var marker = L.marker([#getEventFacility.GeoCode_Latitude#, #getEventFacility.GeoCode_Longitude#], {icon: FacilityMarker}).addTo(map);
					</script>
					</td>
					</tr>
					<tr>
					<td><span style="font-weight: bold;">Event Held In:</span></td>
					<td colspan="2" rowspan="1">#getEventFacilityRoom.RoomName#</td>
					</tr>
					<!--- <tr>
					<td><span style="font-weight: bold;">Driving Directions:</span></td>
					<td colspan="2" rowspan="1"><a href="/plugins/EventRegistration/?EventRegistrationaction=public:main.eventinfo&EventID=#URL.EventID#&DrivingDirections=True" target="_blank" class="art-button">Show Driving Directions</a></td>
					</tr> --->
					</tbody>
					</table>
					</td>
					</tr>
				<cfelseif getSelectedEvent.WebinarAvailable EQ 0 and getEventFacility.RecordCount EQ 0>
					<tr>
					<td style="width: 141px;" colspan="4">
						<h4><strong>Please contact us to find out where this event will be held as this information might not have been available when the event went live to see how much interest was generated.
					</td>
					</tr>
				</cfif>
			</tbody>
		</table>
		<table class="art-article" style="width:100%;" border="1" cellpadding="1" cellspacing="1">
			<tbody>
				<cfif getSelectedEvent.WebinarAvailable EQ 0>
					<tr>
						<td colspan="4"><big><big><span style="font-weight: bold;">Pricing Information:</span></big></big></td>
					</tr>
					<cfif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1 and DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GT 0>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Early Bird Registration Pricing</span></big></big></td>
						</tr>
						<tr>
							<td>Registration Deadline:</td>
							<td colspan="3">#DateFormat(getSelectedEvent.EarlyBird_RegistrationDeadline, "ddd mmm dd, yy")#</td>
						</tr>
						<tr>
							<td style="width: 155px;">ESC Member Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.EarlyBird_MemberCost)#</td>
							<td style="width: 155px;">ESC NonMember Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.EarlyBird_NonMemberCost)#</td>
						</tr>
					<cfelseif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1 and DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) EQ 0>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Early Bird Registration Pricing</span></big></big></td>
						</tr>
						<tr>
							<td>Registration Deadline:</td>
							<td colspan="3">#DateFormat(getSelectedEvent.EarlyBird_RegistrationDeadline, "ddd mmm dd, yy")#</td>
						</tr>
						<tr>
							<td colspan="4"><big style="color: red;"><big><span style="font-weight: bold;">Early Bird Registration Ends Today</span></big></big></td>
						</tr>
						<tr>
							<td style="width: 155px;">ESC Member Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.EarlyBird_MemberCost)#</td>
							<td style="width: 155px;">ESC NonMember Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.EarlyBird_NonMemberCost)#</td>
						</tr>
					<cfelse>
						<tr>
							<td style="width: 155px;">ESC Member Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.MemberCost)#</td>
							<td style="width: 155px;">ESC NonMember Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.NonMemberCost)#</td>
						</tr>
					</cfif>
					<cfif getSelectedEvent.ViewSpecialPricing EQ 1>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Special Price (<small><small>if Requirements are Met</small></small>)</span></big></big></td>
						</tr>
						<tr>
							<td style="width: 155px;">Requirements:</td>
							<td colspan="3">#getSelectedEvent.SpecialPriceRequirements#</td>
						</tr>
						<tr>
							<td style="width: 155px;">ESC Member Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.SpecialMemberCost)#</td>
							<td style="width: 155px;">ESC NonMember Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.SpecialNonMemberCost)#</td>
						</tr>
					</cfif>
					<cfif getSelectedEvent.AllowVideoConference EQ 1>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Video Conference Price</span></big></big></td>
						</tr>
						<tr>
							<td colspan="4" style="text-align: center;"><big style="color: red;"><span style="font-weight: bold;">Video Conference cost is based on a connection and does not reflect the number of participants at the remote location.</span></big></td>
						</tr>
						<tr>
							<td style="width: 155px;">Information Cost:</td>
							<td colspan="3">#getSelectedEvent.VideoConferenceInfo#</td>
						</tr>
						<tr>
							<td style="width: 155px;">Connection Cost:</td>
							<td colspan="3">#DollarFormat(getSelectedEvent.VideoConferenceCost)#</td>
						</tr>
					</cfif>
				</cfif>
				<tr>
					<td colspan="4"><big><big><span style="font-weight: bold;">Contact Information</span></big></big></td>
				</tr>
				<cfif Len(getSelectedEvent.Presenters)>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Presenter(s)</span></td>
						<td colspan="3" style="width: 740px;"></td>
					</tr>
				</cfif>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Facilitator:</span></td>
					<td colspan="3" style="width: 740px;">#getFacilitator.FName# #getFacilitator.LName#</td>
				</tr>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Still Have Questions</span></td>
					<td colspan="3"><a href="#buildURL('public:main.sendquestionform')#&EventID=#URL.EventID#" class="art-button">Send Questions</a></td>
				</tr>
				<tr align="right">
					<td colspan="4"><a href="/index.cfm" class="art-button">Return to Event Listing</a>
						<cfif getSelectedEvent.AcceptRegistrations EQ 1>
							<cfif DateDiff("d", Now(), getSelectedEvent.Registration_Deadline) GTE 0>
								<cfif Variables.SeatsLeft GT 0>
									<cfif Session.Mura.isLoggedIn EQ 0>
										<a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#URL.EventID#" class="art-button">Register</a>
									<cfelse>
										<a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#URL.EventID#" class="art-button">Register</a>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
					</td>
				</tr>
			</tbody>
		</table>
		</div>
		</div>
	<cfelseif isDefined("URL.DrivingDirections")>
		<div class="art-blockheader">
			<h3 class="t">Driving Directions to #getEventFacility.FacilityName#</h3>
		</div>
		<table class="art-article" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 225px;"><span style="font-weight: bold;">Event Location:</span></td>
					<td style="width: 300px;"><address><strong>#getEventFacility.FacilityName#</strong><br>
					#getEventFacility.PhysicalAddress#<BR>
					#getEventFacility.PhysicalCity#, #getEventFacility.PhysicalState# #getEventFacility.PhysicalZipCode#</address><br>
					<abbr title="Phone">P:</abbr> #getEventFacility.PrimaryVoiceNumber#
					</td>
					<td colspan="1" rowspan="4" style="width: 475px; text-align: center; vertical-align: top;">
					<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
					<!--[if lte IE 8]> <link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.ie.css" /> <![endif]-->
					<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
					<div id="map" style="width: 475px; height: 300px;"></div>

					</td>
				</tr>
			</tbody>
		</table>
	</cfif>
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
</cfoutput>