<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		
		<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, Twitter_Enabled, Twitter_ConsumerKey, Twitter_ConsumerSecret, Twitter_AccessToken, Twitter_AccessTokenSecret, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, CFServerJarFiles
			From p_EventRegistration_SiteConfig
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>

		<cfquery name="getAllEvents" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, WhatIf_MealCostPerAttendee, WhatIf_FacilityCostTotal, WhatIf_PresenterCostTotal
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			Order By EventDate DESC
		</cfquery>
		<cfset Session.getAllEvents = StructCopy(getAllEvents)>		
	</cffunction>

	<cffunction name="addevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/addevent.cfm">
	</cffunction>

	<cffunction name="addevent_step2" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/addevent_step2.cfm">
	</cffunction>

	<cffunction name="addevent_step3" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/addevent_step3.cfm">
	</cffunction>

	<cffunction name="addevent_review" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/addevent_review.cfm">
	</cffunction>

	<cffunction name="geteventinfo" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/geteventinfo.cfm">
	</cffunction>

	<cffunction name="addexpense" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/addexpense.cfm">
	</cffunction>

	<cffunction name="enterexpenses" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/enterexpenses.cfm">
	</cffunction>

	<cffunction name="eventdocs" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/eventdocs.cfm">
	</cffunction>

	<cffunction name="eventweblinks" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/eventweblinks.cfm">
	</cffunction>
	
	<cffunction name="registeruserforevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/registeruserforevent.cfm">
	</cffunction>

	<cffunction name="signinsheet" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/signinsheet.cfm">
	</cffunction>

	<cffunction name="deregisteruserforevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/deregisteruserforevent.cfm">
	</cffunction>

	<cffunction name="emailparticipants" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/emailparticipants.cfm">
	</cffunction>

	<cffunction name="cancelevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/cancelevent.cfm">
	</cffunction>

	<cffunction name="copyevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/copyevent.cfm">
	</cffunction>

	<cffunction name="generatenametags" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/generatenametags.cfm">
	</cffunction>

	<cffunction name="signinparticipant" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/signinparticipant.cfm">
	</cffunction>

	<cffunction name="sendcertificates" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/sendcertificates.cfm">
	</cffunction>

	<cffunction name="eventrevenue" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/eventrevenue.cfm">
	</cffunction>

	<cffunction name="viewprofitlossreport" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/viewprofitlossreport.cfm">
	</cffunction>

	<cffunction name="updateevent" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent.cfm">
	</cffunction>

	<cffunction name="updateevent_dates" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_dates.cfm">
	</cffunction>

	<cffunction name="updateevent_description" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_description.cfm">
	</cffunction>

	<cffunction name="updateevent_pricing" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_pricing.cfm">
	</cffunction>

	<cffunction name="updateevent_location" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_location.cfm">
	</cffunction>

	<cffunction name="updateevent_featured" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_featured.cfm">
	</cffunction>

	<cffunction name="updateevent_earlybird" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_earlybird.cfm">
	</cffunction>

	<cffunction name="updateevent_groupprice" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_groupprice.cfm">
	</cffunction>

	<cffunction name="updateevent_pgp" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_pgp.cfm">
	</cffunction>

	<cffunction name="updateevent_meal" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_meal.cfm">
	</cffunction>

	<cffunction name="updateevent_h323" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_h323.cfm">
	</cffunction>

	<cffunction name="updateevent_webinar" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_webinar.cfm">
	</cffunction>

	<cffunction name="updateevent_presenter" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_presenter.cfm">
	</cffunction>

	<cffunction name="updateevent_options" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_options.cfm">
	</cffunction>

	<cffunction name="updateevent_registrations" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/updateevent_registrations.cfm">
	</cffunction>

	<cffunction name="AddParticipantToDatabase" Access="Remote" returntype="Any" output="true" hint="Add Participant To Database">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfset requestData = getHttpRequestData()>
		<cfset requestContent = #variables.requestData.content#>
		<cfset requestContent = #Replace(variables.requestContent, "%7B", "{", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%22", '"', "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%3A", ":", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%2C", ",", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%2F", "/", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%7D", "}", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%40", "@", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%20", " ", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%2B", " ", "ALL")#>
		<cfset requestContent = #Replace(variables.requestContent, "%5E", "^", "ALL")#>
		<cfset Info = #ListLast(ListLast(variables.requestContent, "&"), "=")#>
		<cfset requestinfo = #DeserializeJSON(Info)#>

		<cfquery name="CheckAccount" Datasource="#requestinfo.DBInfo.Datasource#" username="#requestinfo.DBInfo.DBUsername#" password="#requestinfo.DBInfo.DBPassword#">
			Select UserID, Fname, Lname, Email
			From tusers
			Where UserName = <cfqueryparam value="#requestinfo.UserInfo.Email#" cfsqltype="cf_sql_varchar"> or Email = <cfqueryparam value="#requestinfo.UserInfo.Email#" cfsqltype="cf_sql_varchar">
			Order by Lname, Fname
		</cfquery>

		<cfif CheckAccount.RecordCount EQ 0>
			<cfset NewUser = #Application.userManager.readByUsername(requestinfo.UserInfo.Email, requestinfo.DBInfo.SiteID)#>
			<cfset NewUser.setInActive(1)>
			<cfset NewUser.setSiteID(requestinfo.DBInfo.SiteID)>
			<cfset NewUser.setFname(#Replace(requestinfo.UserInfo.Fname, "+", " ", "ALL")#)>
			<cfset NewUser.setLname(#Replace(requestinfo.UserInfo.Lname, "+", " ", "ALL")#)>
			<cfset NewUser.setPassword(#Trim(requestinfo.UserInfo.Email)#)>
			<cfset NewUser.setUsername(#Trim(requestinfo.UserInfo.Email)#)>
			<cfset NewUser.setEmail(#Trim(requestinfo.UserInfo.Email)#)>
			<cfset AddNewAccount = #Application.userManager.save(NewUser)#>

			<cfif LEN(AddNewAccount.getErrors()) EQ 0>
				
				<cfreturn SerializeJSON(True)>
			<cfelse>
				<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
			</cfif>
		<cfelse>
			<cfreturn SerializeJSON(FALSE)>
		</cfif>
	</cffunction>

	<cffunction name="SignInParticipantToDatabase" Access="Remote" returntype="string" returnformat="json" output="true" hint="Signin Participant To Database">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="Action" required="true" type="string" default="SignIn">
		<cfargument name="UserID" required="true" type="string" default="">
		<cfargument name="EventID" required="true" type="numeric" default="">

		<cfset UserIDPart = #ListFirst(Arguments.UserID, "_")#>
		<cfset DayNumberPart = #ListLast(Arguments.UserID, "_")#>

		<cfswitch expression="#Variables.DayNumberPart#">
			<cfcase value="1">
				<cftry>
					<cfswitch expression="#Arguments.Action#">
						<cfcase value="SignIn">
							<cfquery name="UpdateParticipant" datasource="#Application.configBean.getDatasource()#" username="#Application.configBean.getDbUsername()#" password="#Application.configBean.getDbPassword()#">
								Update p_EventRegistration_UserRegistrations
								Set AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where User_ID = <cfqueryparam value="#Variables.UserIDPart#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#Arguments.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfquery name="getUserInfo" datasource="#Application.configBean.getDatasource()#" username="#Application.configBean.getDbUsername()#" password="#Application.configBean.getDbPassword()#">
								Select Fname, Lname, UserName
								From tusers
								Where UserID = <cfqueryparam value="#Variables.UserIDPart#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="getSignInParticipant" datasource="#Application.configBean.getDatasource()#" username="#Application.configBean.getDbUsername()#" password="#Application.configBean.getDbPassword()#">
								Select User_ID
								From p_EventRegistration_UserRegistrations
								Where Event_ID = <cfqueryparam value="#Arguments.EventID#" cfsqltype="cf_sql_integer"> and AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							</cfquery>
							<cfquery name="getTotalParticipant" datasource="#Application.configBean.getDatasource()#" username="#Application.configBean.getDbUsername()#" password="#Application.configBean.getDbPassword()#">
								Select User_ID
								From p_EventRegistration_UserRegistrations
								Where Event_ID = <cfqueryparam value="#Arguments.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfcase>
						<cfcase value="SignOut">
							<cfquery name="UpdateParticipant" datasource="#Application.configBean.getDatasource()#" username="#Application.configBean.getDbUsername()#" password="#Application.configBean.getDbPassword()#">
								Update p_EventRegistration_UserRegistrations
								Set AttendedEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where User_ID = <cfqueryparam value="#Variables.UserIDPart#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#Arguments.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfquery name="getUserInfo" datasource="#Application.configBean.getDatasource()#" username="#Application.configBean.getDbUsername()#" password="#Application.configBean.getDbPassword()#">
								Select Fname, Lname, UserName
								From tusers
								Where UserID = <cfqueryparam value="#Variables.UserIDPart#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="getSignInParticipant" datasource="#Application.configBean.getDatasource()#" username="#Application.configBean.getDbUsername()#" password="#Application.configBean.getDbPassword()#">
								Select User_ID
								From p_EventRegistration_UserRegistrations
								Where Event_ID = <cfqueryparam value="#Arguments.EventID#" cfsqltype="cf_sql_integer"> and AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							</cfquery>
							<cfquery name="getTotalParticipant" datasource="#Application.configBean.getDatasource()#" username="#Application.configBean.getDbUsername()#" password="#Application.configBean.getDbPassword()#">
								Select User_ID
								From p_EventRegistration_UserRegistrations
								Where Event_ID = <cfqueryparam value="#Arguments.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfcase>
					</cfswitch>
					<cfcatch type="any">
						<cfset DBError = #SerializeJSON(cfcatch)#>
					</cfcatch>
				</cftry>
			</cfcase>
			<cfdefaultcase>
				<cfset Success = StructNew()>
				<cfset Success.Msg = "CFDEFAULTCASE">
				<cfset Success.DayNumber = #Variables.DayNumberPart#>
				<cfset Success.UserID = #Variables.UserIDPart#>
				<cfset Success.EventID = #Arguments.EventID#>
				<cfset Success.ParticipantsSignedIn = #getSignInParticipant.RecordCount#>
				<cfset Success.TotalParticipants = #getTotalParticipant.RecordCount#>
				<cfreturn SerializeJSON(Success)>
			</cfdefaultcase>
		</cfswitch>

		<cfset Success = StructNew()>
		<cfset Success.Msg = "OK">
		<cfset Success.DayNumber = #Variables.DayNumberPart#>
		<cfset Success.UserID = #Variables.UserIDPart#>
		<cfset Success.EventID = #Arguments.EventID#>
		<cfset Success.ParticipantsSignedIn = #getSignInParticipant.RecordCount#>
		<cfset Success.TotalParticipants = #getTotalParticipant.RecordCount#>
		<cfreturn SerializeJSON(Success)>
	</cffunction>
	
</cfcomponent>