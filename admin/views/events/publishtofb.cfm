<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
<cfset Session.UserSuppliedInfo.FB.AppID = "923408481055376">
<cfset Session.UserSuppliedInfo.FB.AppSecretKey = "fb6fc196185850747a2250646ba378af">
<cfset Session.UserSuppliedInfo.FB.PageID = "172096152818693">
<cfset Session.UserSuppliedInfo.FB.AppScope = "publish_actions,publish_pages">
</cfsilent>

<cfif isDefined("URL.EventID") and isDefined("URL.AutomaticPost")>
	<cfscript>
		import plugins.EventRegistration.library.FacebookSDK.sdk.FacebookApp;
		import plugins.EventRegistration.library.FacebookSDK.sdk.FacebookGraphAPI;

		userID = 0;

		if (Session.UserSuppliedInfo.FB.AppID is "" or Session.UserSuppliedInfo.FB.AppSecretKey is "") {
			// Application Not Configured
		} else {
			// Create facebookApp instance
			facebookApp = new FacebookApp(appId=Session.UserSuppliedInfo.FB.AppID, secretKey=Session.UserSuppliedInfo.FB.AppSecretKey);

			userId = facebookApp.getUserId();

			if (userId) {
				try {
					userAccessToken = facebookApp.getUserAccessToken();
					facebookGraphAPI = new FacebookGraphAPI(accessToken=userAccessToken, appId=Session.UserSuppliedInfo.FB.AppID);
					pageAccessToken = FacebookGraphAPI.getPageAccessToken(Session.UserSuppliedInfo.FB.PageID);
					facebookPageGraphAPI = new FacebookGraphAPI(accessToken=pageAccessToken, appId=Session.UserSuppliedInfo.FB.AppID);
					userObject = FacebookGraphAPI.getObject(id=userId);
					userFriends = FacebookGraphAPI.getConnections(id=userId, type='taggable_friends', limit=10);
					authenticated = true;
				} catch (any exception) {
					// Usually an invalid session (OAuthInvalidTokenException), for example if the user logged out from facebook.com
					userId = 0;
					facebookGraphAPI = new FacebookGraphAPI();
				}
			} else {
				facebookGraphAPI = new FacebookGraphAPI();
			}

			if (userId eq 0) {
				parameters = {scope=Session.UserSuppliedInfo.FB.AppScope};
				loginUrl = facebookApp.getLoginUrl(parameters);
			};
		}
	</cfscript>
	<cfoutput>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Publish Event to Facebook: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
			</div>
			<div class="art-blockcontent">
				<div id="fb-root"></div>
				<script>
					window.fbAsyncInit = function() {
						FB.init({
							appId   : '#facebookApp.getAppId()#',
							cookie  : true, // enable cookies to allow the server to access the session
							oauth	  : true, // OAuth 2.0
							status  : false, // check login status
							xfbml   : true // parse XFBML
						});
						FB.Canvas.setSize({height:1800});
					};
					(function() {
						var e = document.createElement('script');
						e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js';
						e.async = true;
						document.getElementById('fb-root').appendChild(e);
					}());

					<cfif userId eq 0>
						function addLoginListener() {
							// whenever the user install the app or login, we refresh the page
							FB.Event.subscribe('auth.login', function(response) {
								window.location.reload();
							});
						}
						function login() {
							FB.login(function(response) {
								if (response.authResponse) {
									// user successfully authenticated in
									window.location.reload();
								} else {
									WriteDump(response.authResponse);
									// user cancelled login
								}
							}, {scope:'#Session.UserSuppliedInfo.FB.AppScope#'});
						}
					</cfif>
				</script>
				<cfif userId eq 0>
					<div class="alert-box notice">Please complete this form to post this event to the Organization's Facebook Wall</div>
					<hr>
					<h2 align="center">Login To Facebook</h2>
					<div class="alert-box">Please click the Login To Facebook Link Below to allow this website the ability to publish this newly created event to the Organization's Facebook Page.<br>
						<br /><br /><a href="javascript:login()" class="art-button">Login To Facebook</a>
				    </div>
					<hr />
				<cfelse>
					<cfset FBMessagePost = "On " & #DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate, "full")# & " we will be hosting an event titled " & #Session.UserSuppliedInfo.PickedEvent.ShortTitle# & ". " & #Session.UserSuppliedInfo.PickedEvent.LongDescription# & " This event will be held at " & #Session.UserSuppliedInfo.FacilityInfo.FacilityName# & " (" & #Session.UserSuppliedInfo.FacilityInfo.PhysicalAddress# & " " & #Session.UserSuppliedInfo.FacilityInfo.PhysicalCity# & ", " & #Session.UserSuppliedInfo.FacilityInfo.PhysicalState# & " " & #Session.UserSuppliedInfo.FacilityInfo.PhysicalZipCode# & "). " & " For more information regarding this event or to register to attend this event, please visit our Event Registration System by clicking the link in this post.">
					<cfset FBMessageRegLink = "http://" & #cgi.server_name# & "/plugins/EventRegistration/?EventRegistrationaction=public:events.eventinfo&EventID=#URL.EventID#">
					<cfscript>
						FBMsg = facebookPageGraphAPI.publishLink(profileId=Session.UserSuppliedInfo.FB.PageID, link="#Variables.FBMessageRegLink#", message='#Variables.FBMessagePost#');
					</cfscript>

					<cfif FBMsg CONTAINS "172096152818693_">
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.default&UserAction=PostToFB&Successful=True" addtoken="false">
					<cfelseif isNumeric(FBMsg)>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.default&UserAction=PostToFB&Successful=True" addtoken="false">
					<cfelse>
						<div class="alert-box error">An error has occurred in posting this event to the organization's Facebook Page.</div>
					</cfif>
				</cfif>
			</div>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.EventID")>
	<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
	<cflock timeout="60" scope="SESSION" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
		<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
	</cflock>
	<cfscript>
		timeConfig = structNew();
		timeConfig['show24Hours'] = false;
		timeConfig['showSeconds'] = false;
	</cfscript>
	<cfoutput>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Publish Event to Facebook: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
			</div>
			<div class="art-blockcontent">
				<div class="alert-box notice">Please complete this form to send a message to those who have registered for this event.<br><Strong>Number of Registrations Currently: #Session.EventNumberRegistrations#</Strong></div>
				<hr>
				<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.publishtofb&compactDisplay=false&EventID=#URL.EventID#&AutomaticPost=true" method="Post" id="EmailEventParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
					commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
					cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
					submitValue="Post Event to Facebook" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="formSubmit" value="true">
					<input type="hidden" name="PerformAction" value="FacebookAuthenticate">
					<uForm:fieldset legend="Event Date and Time">
						<uform:field label="Primary Event Date" name="EventDate" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
						<cfif Session.UserSuppliedInfo.PickedEvent.EventSpanDates EQ 1>
							<uform:field label="Second Event Date" name="EventDate1" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate1, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
							<uform:field label="Third Event Date" name="EventDate2" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate2, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
							<uform:field label="Fourth Event Date" name="EventDate3" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate3, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
							<uform:field label="Fifth Event Date" name="EventDate4" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate4, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
						</cfif>
						<uform:field label="Registration Deadline" name="Registration_Deadline" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.Registration_Deadline, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Accept Registration up to this date" />
						<uform:field label="Registration Start Time" name="Registration_BeginTime" isDisabled="true" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Registration_BeginTime, 'hh:mm tt')#" type="text" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
						<uform:field label="Event Start Time" name="Event_StartTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Event_StartTime, 'hh:mm tt')#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
						<uform:field label="Event End Time" name="Event_EndTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Event_EndTime, 'hh:mm tt')#" pluginSetup="#timeConfig#" hint="The ending time of this event" />
					</uForm:fieldset>
					<uForm:fieldset legend="Event Description">
						<uform:field label="Event Short Title" name="ShortTitle" isDisabled="true" value="#Session.UserSuppliedInfo.PickedEvent.ShortTitle#" maxFieldLength="50" type="text" hint="Short Event Title of Event" />
						<uform:field label="Event Description" name="LongDescription" isDisabled="true" value="#Session.UserSuppliedInfo.PickedEvent.LongDescription#" type="textarea" hint="Description of this meeting or event" />
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	</cfoutput>
</cfif>