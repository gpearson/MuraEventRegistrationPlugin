<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
<!---
<cfset Session.UserSuppliedInfo.FB.AppID = "923408481055376">
<cfset Session.UserSuppliedInfo.FB.AppSecretKey = "fb6fc196185850747a2250646ba378af">
<cfset Session.UserSuppliedInfo.FB.PageID = "172096152818693">
<cfset Session.UserSuppliedInfo.FB.AppScope = "publish_actions,publish_pages">
--->
</cfsilent>

<cfif isDefined("URL.EventID") and isDefined("URL.AutomaticPost")>
	<cfscript>
		import plugins.EventRegistration.library.FacebookSDK.sdk.FacebookApp;
		import plugins.EventRegistration.library.FacebookSDK.sdk.FacebookGraphAPI;

		userID = 0;

		if (Session.PostEventToFB.FacebookAppID is "" or Session.PostEventToFB.FacebookAppSecretKey is "") {
			// Application Not Configured
		} else {
			// Create facebookApp instance
			facebookApp = new FacebookApp(appId=Session.PostEventToFB.FacebookAppID, secretKey=Session.PostEventToFB.FacebookAppSecretKey);

			userId = facebookApp.getUserId();

			if (userId) {
				try {
					userAccessToken = facebookApp.getUserAccessToken();
					facebookGraphAPI = new FacebookGraphAPI(accessToken=userAccessToken, appId=Session.PostEventToFB.FacebookAppID);
					pageAccessToken = FacebookGraphAPI.getPageAccessToken(Session.PostEventToFB.FacebookPageID);
					facebookPageGraphAPI = new FacebookGraphAPI(accessToken=pageAccessToken, appId=Session.PostEventToFB.FacebookAppID);
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
				parameters = {scope=Session.PostEventToFB.FacebookAppScope};
				loginUrl = facebookApp.getLoginUrl(parameters);
			};
		}
	</cfscript>
	<cfoutput>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Publish Event to Facebook: #Session.PostEventToFB.EventTitle#</h1></div>
			<div class="panel-body">
				<div id="fb-root"></div>
				<script>
					window.fbAsyncInit = function() {
						FB.init({
							appId   : '#facebookApp.getAppId()#',
							cookie  : true, // enable cookies to allow the server to access the session
							oauth	  : true, // OAuth 2.0
							status  : true, // check login status
							version : "v2.10",
							xfbml   : true // parse XFBML
						});
						FB.Canvas.setSize({height:1800});
					};
					(function() {
						var e = document.createElement('script');
						e.src = document.location.protocol + '//connect.facebook.net/en_US/sdk.js';
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
							}, {scope:'#Session.PostEventToFB.FacebookAppScope#'});
						}
					</cfif>
				</script>
				<cfif userId eq 0>
					<div class="alert alert-info">Please complete this form to post this event to the Organization's Facebook Wall</div>
					<hr>
					<h2 align="center">Login To Facebook</h2>
					<div class="alert-box">Please click the Login To Facebook Link Below to allow this website the ability to publish this newly created event to the Organization's Facebook Page.<br>
						<br /><br /><a href="javascript:login()" class="art-button">Login To Facebook</a>
				    </div>
					<hr />
				<cfelse>
					<cfset FBMessagePost = "On " & #DateFormat(Session.PostEventToFB.EventDate, "full")# & " we will be hosting an event titled " & #Session.PostEventToFB.EventTitle# & ". " & #Session.PostEventToFB.LongDescription# & " This event will be held at " & #Session.PostEventToFB.FacilityName# & " (" & #Session.PostEventToFB.FacilityAddress# & " " & #Session.PostEventToFB.FacilityCity# & ", " & #Session.PostEventToFB.FacilityState# & " " & #Session.PostEventToFB.FacilityZipCode# & "). " & " For more information regarding this event or to register to attend this event, please visit our Event Registration System by clicking the link in this post.">
					<cfset FBMessageRegLink = "http://" & #cgi.server_name# & "#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#URL.EventID#">
					<cfscript>
						FBMsg = facebookPageGraphAPI.publishLink(profileId=Session.PostEventToFB.FacebookPageID, link="#Variables.FBMessageRegLink#", message='#Variables.FBMessagePost#');
					</cfscript>

					<cfif FBMsg CONTAINS "172096152818693_">
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=PostToFB&Successful=True" addtoken="false">
					<cfelseif isNumeric(FBMsg)>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=PostToFB&Successful=True" addtoken="false">
					<cfelse>
						<div class="alert alert-warning">An error has occurred in posting this event to the organization's Facebook Page.</div>
					</cfif>
				</cfif>
			</div>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.EventID") and not isDefined("URL.AutomaticPost")>
	<cfoutput>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Publish Event to Facebook: #Session.GetSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="PerformAction" value="FacebookAuthenticate">
				<div class="panel-body">
					<div class="alert alert-info">Please review this form to post the following event to the Organization's Facebook Page</div>
					<h2 class="panel-title">Event Date and Time Information</h2>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#DateFormat(Session.getSelectedEvent.EventDate, 'full')#" disabled="yes"></div>
					</div>
					<cfif LEN(Session.GetSelectedEvent.EventDate1) or LEN(Session.GetSelectedEvent.EventDate2) or LEN(Session.GetSelectedEvent.EventDate3) or LEN(Session.GetSelectedEvent.EventDate4)>
						<cfif isDate(Session.GetSelectedEvent.EventDate1)>
							<div class="form-group">
								<label for="EventDate" class="control-label col-sm-3">2nd Event Date:&nbsp;</label>
								<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#DateFormat(Session.getSelectedEvent.EventDate1, 'full')#" disabled="yes"></div>
							</div>
						</cfif>
						<cfif isDate(Session.GetSelectedEvent.EventDate2)>
							<div class="form-group">
								<label for="EventDate2" class="control-label col-sm-3">3rd Event Date:&nbsp;</label>
								<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#DateFormat(Session.getSelectedEvent.EventDate2, 'full')#" disabled="yes"></div>
							</div>
						</cfif>
						<cfif isDate(Session.GetSelectedEvent.EventDate3)>
							<div class="form-group">
								<label for="EventDate3" class="control-label col-sm-3">4th Event Date:&nbsp;</label>
								<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#DateFormat(Session.getSelectedEvent.EventDate3, 'full')#" disabled="yes"></div>
							</div>
						</cfif>
						<cfif isDate(Session.GetSelectedEvent.EventDate4)>
							<div class="form-group">
								<label for="EventDate4" class="control-label col-sm-3">5th Event Date:&nbsp;</label>
								<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#DateFormat(Session.getSelectedEvent.EventDate4, 'full')#" disabled="yes"></div>
							</div>
						</cfif>
					</cfif>
					<div class="form-group">
						<label for="EventTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventTitle" name="EventTitle" value="#Session.getSelectedEvent.ShortTitle#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventLongDescription" class="control-label col-sm-3">Full Description:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventLongDescription" cols="90" rows="10" disabled>#ReReplaceNoCase(Session.GetSelectedEvent.LongDescription,'<[^>]*>',' ','ALL')#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventRegistrationDeadline" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventRegistrationDeadline" name="EventRegistrationDeadline" value="#DateFormat(Session.getSelectedEvent.Registration_Deadline, 'full')#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventBeginTime" class="control-label col-sm-3">Event Start Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventBeginTime" name="EventBeginTime" value="#TimeFormat(Session.getSelectedEvent.Event_StartTime, 'hh:mm tt')#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventEndTime" class="control-label col-sm-3">Event End Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventEndTime" name="EventEndTime" value="#TimeFormat(Session.getSelectedEvent.Event_EndTime, 'hh:mm tt')#" disabled="yes"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Publish To Facebook"><br /><br />
				</div>
			</cfform>
		</div>
	</cfoutput>
</cfif>