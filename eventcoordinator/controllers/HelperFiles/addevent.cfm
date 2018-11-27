<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getFacilities" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, AdditionalNotes, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Physical_isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">  and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				Order by FacilityName
			</cfquery>
			<cfset Session.getActiveFacilities = StructCopy(getFacilities)>
			<cfquery name="getPresenterUserID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID
				From tusers
				Where GroupName = <cfqueryparam value="Event Presenter" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="getAllPresenters" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select tusers.Fname, tusers.Lname, tusersmemb.UserID, tusers.Email, CONCAT(tusers.Lname, ', ', tusers.Fname) as DisplayName
				From tusersmemb LEFT JOIN tusers on tusers.UserID = tusersmemb.UserID
				Where tusersmemb.GroupID = <cfqueryparam value="#getPresenterUserID.UserID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset Session.getAllPresenters = #StructCopy(getAllPresenters)#>
		<cfelse>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif not isDefined("Session.FormInput")>
					<cfset Session.FormInput = #StructNew()#>
					<cfset Session.FormInput.EventIDConfig = #CreateUUID()# & ".cfg">
					<cfset Session.FormInput.FilePath = #ExpandPath("/plugins/#Session.PluginFramework.CFCBASE#/")# & "temp/">
				</cfif>
				<cfparam name="FORM.EventSpanDates" default="0">
				<cfparam name="FORM.EventFeatured" default="0">
				<cfparam name="FORM.EventHaveSessions" default="0">
				<cfparam name="FORM.EarlyBird_RegistrationAvailable" default="0">
				<cfparam name="FORM.ViewGroupPricing" default="0">
				<cfparam name="FORM.PGPAvailable" default="0">
				<cfparam name="FORM.AllowVideoConference" default="0">
				<cfparam name="FORM.MealAvailable" default="0">
				<cfparam name="FORM.WebinarEvent" default="0">
				<cfparam name="FORM.PostEventToFB" default="0">
				<cfparam name="FORM.BillForNoSHow" default="0">
				<cfparam name="FORM.EventCostPerDay" default="0">
				<cfparam name="FORM.EventHasOptionalCosts" default="0">
				<cfif FORM.PresenterID EQ "----"><cfset FORM.PresenterID = "0"></cfif>
				<cfset Session.FormInput.EventStep1 = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Events Menu">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "SiteConfigSettings")>
				<cfset temp = StructDelete(Session, "getActiveFacilities")>
				<cfif isDefined("Session.getCaterers")><cfset temp = StructDelete(Session, "getCaterers")></cfif>
				<cfif isDefined("Session.getMembership")><cfset temp = StructDelete(Session, "getMembership")></cfif>
				<cfif isDefined("Session.getFacilities")><cfset temp = StructDelete(Session, "getFacilities")></cfif>
				<cfif isDefined("Session.getUsers")><cfset temp = StructDelete(Session, "getUsers")></cfif>
				<cfif isDefined("Session.GetEventGroups")><cfset temp = StructDelete(Session, "GetEventGroups")></cfif>
				<cfif isDefined("Session.getAllPresenters")><cfset temp = StructDelete(Session, "getAllPresenters")></cfif>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			
			<cfif LEN(FORM.EventDate) LT 10 or not isDate(FORM.EventDate)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the date of this new event or workshop."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Registration_Deadline) LT 10 or not isDate(FORM.Registration_Deadline)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the date of when registrations will not be available after."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Registration_BeginTime) LT 6 or LEN(FORM.Registration_BeginTime) GT 7>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid time on when participants are able to register onsite for the event or workshop."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Event_StartTime) LT 6  or LEN(FORM.Event_StartTime) GT 7>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid time on when the event or workshop will start"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Event_EndTime) LT 6  or LEN(FORM.Event_EndTime) GT 7>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid time on when the event or workshop will end"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.ShortTitle) LT 10>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a short title for this event"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.LongDescription) LT 10>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a detailed description for this event"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.LocationID EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please select the location where this event will be held."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfset TimeHours = #ListFirst(FORM.Registration_BeginTime, ":")#>
			<cfset TimeMinutes = #Left(ListLast(FORM.Registration_BeginTime, ":"), 2)#>
			<cfset TimeAMPM = #Right(ListLast(FORM.Registration_BeginTime, ":"), 2)#>
			<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
			<cfset FORM.Registration_BeginTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
			<cfset Session.FormInput.EventStep1.Registration_BeginTime = #FORM.Registration_BeginTime#>

			<cfset TimeHours = #ListFirst(FORM.Event_StartTime, ":")#>
			<cfset TimeMinutes = #Left(ListLast(FORM.Event_StartTime, ":"), 2)#>
			<cfset TimeAMPM = #Right(ListLast(FORM.Event_StartTime, ":"), 2)#>
			<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
			<cfset FORM.Event_StartTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
			<cfset Session.FormInput.EventStep1.Event_StartTime = #FORM.Event_StartTime#>

			<cfset TimeHours = #ListFirst(FORM.Event_EndTime, ":")#>
			<cfset TimeMinutes = #Left(ListLast(FORM.Event_EndTime, ":"), 2)#>
			<cfset TimeAMPM = #Right(ListLast(FORM.Event_EndTime, ":"), 2)#>
			<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
			<cfset FORM.Event_EndTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
			<cfset Session.FormInput.EventStep1.Event_EndTime = #FORM.Event_EndTime#>

			<cfset newEvent = #Session.FormInput.FilePath# & #Session.FormInput.EventIDConfig#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventSpanDates", FORM.EventSpanDates)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventFeatured", FORM.EventFeatured)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventCostPerDay", FORM.EventCostPerDay)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventHaveSessions", FORM.EventHaveSessions)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EarlyBird_RegistrationAvailable", FORM.EarlyBird_RegistrationAvailable)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "ViewGroupPricing", FORM.ViewGroupPricing)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "PGPAvailable", FORM.PGPAvailable)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "MealAvailable", FORM.MealAvailable)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "AllowVideoConference", FORM.AllowVideoConference)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "WebinarEvent", FORM.WebinarEvent)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "PostEventToFB", FORM.PostEventToFB)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "BillForNoSHow", FORM.BillForNoSHow)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventDate", FORM.EventDate)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "Registration_Deadline", FORM.Registration_Deadline)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "Registration_BeginTime", FORM.Registration_BeginTime)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "Event_StartTime", FORM.Event_StartTime)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "Event_EndTime", FORM.Event_EndTime)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "ShortTitle", FORM.ShortTitle)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "LongDescription", FORM.LongDescription)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventMemberCost", FORM.MemberCost)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventNonMemberCost", FORM.NonMemberCost)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "LocationID", FORM.LocationID)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventAgenda", FORM.EventAgenda)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventTargetAudience", FORM.EventTargetAudience)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventStrategies", FORM.EventStrategies)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventSpecialInstructions", FORM.EventSpecialInstructions)#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "PresenterID", FORM.PresenterID)#>

			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>