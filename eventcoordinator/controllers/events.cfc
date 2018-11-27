<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		
		<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, ProcessPayments_Stripe, Stripe_TestMode, Stripe_testAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, Google_ReCaptchaEnabled, Google_ReCaptchaSiteKey, Google_ReCaptchaSecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, BillForNoShowRegistrations, RequireEventSurveyToGetCertificate
			From p_EventRegistration_SiteConfig
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>

		<cfquery name="getAllEvents" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, Member_Cost, NonMember_Cost, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPAvailable, PGPPoints, Meal_Available, Meal_Included, Meal_Notes, Meal_Cost, Meal_ProvidedBy, AllowVideoConference, VideoConferenceInfo, VideoConferenceMemberCost, VideoConferenceNonMemberCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, PresenterID, FacilitatorID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, PostedTo_Facebook, PostedTo_Twitter, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime, EventInvoicesGenerated, PGPCertificatesGenerated, BillForNoShow, EventPricePerDay, EventHasOptionalCosts
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

	<cffunction name="registeruserforevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/registeruserforevent.cfm">
	</cffunction>

	<cffunction name="deregisteruserforevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfinclude template="HelperFiles/deregisteruserforevent.cfm">
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
		<cfset Info = #ListLast(ListLast(variables.requestContent, "&"), "=")#>
		<cfset requestinfo = #DeserializeJSON(Info)#>

		<cfquery name="CheckAccount" Datasource="#requestinfo.DBInfo.Datasource#" username="#requestinfo.DBInfo.DBUsername#" password="#requestinfo.DBInfo.DBPassword#">
			Select UserID, Fname, Lname, Email
			From tusers
			Where UserName = <cfqueryparam value="#requestinfo.UserInfo.Email#" cfsqltype="cf_sql_varchar">
			Order by Lname, Fname
		</cfquery>

		<cfif CheckAccount.RecordCount EQ 0>
			<!--- Initiates the User Bean --->
			<cfset userRecord = Session.JSMuraScope.$.getBean('user').loadBy(username='#requestinfo.UserInfo.Email#', siteid='#requestinfo.DBInfo.SiteID#')>
			<cfset temp = #userRecord.set('siteid', requestinfo.DBInfo.SiteID)#>
			<cfset temp = #userRecord.set('fname', '#Replace(requestinfo.UserInfo.Fname, "+", " ", "ALL")#')#>
			<cfset temp = #userRecord.set('lname', '#Replace(requestinfo.UserInfo.Lname, "+", " ", "ALL")#')#>
			<cfset temp = #userRecord.set('username', '#Trim(requestinfo.UserInfo.Email)#')#>
			<cfset temp = #userRecord.set('email', '#Trim(requestinfo.UserInfo.Email)#')#>
			<cfset temp = #userRecord.set('InActive', 1)#>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
			
			<cfif userRecord.checkUsername() EQ "false">
			 	<cfdump var="#Variables.userRecord#" abort="true">
          	<cfelse>
          		<cfset AddNewAccount = #userRecord.save()#>
				<cfset NewUserAccountID = #Variables.AddNewAccount.GetUserID()#>

				<cfif RequestInfo.DBInfo.EmailConfirmations EQ true>
					<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(requestinfo.DBInfo.PackageName)#/library/components/EmailServices")>
					<cfset temp = #SendEmailCFC.SendAccountActivationEmailFromOrganizationPerson(requestinfo, NewUserAccountID)#>
				</cfif>
				<cfreturn SerializeJSON(True)>
			</cfif>
		<cfelse>
			<cfreturn SerializeJSON(FALSE)>
		</cfif>
	</cffunction>

	
	
</cfcomponent>