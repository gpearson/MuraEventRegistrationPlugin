<cfif not isDefined("FORM.formSubmit")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>
	<cfset Session.getSelectedEvent = #StructCopy(getSelectedEvent)#>

	<cfswitch expression="#application.configbean.getDBType()#">
		<cfcase value="mysql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
			<cfset Session.getRegisteredParticipants = #StructCopy(getRegisteredParticipants)#>
		</cfcase>
		<cfcase value="mssql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfset Session.getRegisteredParticipants = #StructCopy(getRegisteredParticipants)#>
	</cfswitch>

	<cfif LEN(getSelectedEvent.PresenterID)>
		<cfquery name="getPresenter" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset Session.getSelectedEventPresenter = StructCopy(getPresenter)>
	</cfif>

<cfelseif isDefined("FORM.formSubmit")>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput = #StructCopy(FORM)#>
	</cflock>

	<cfif FORM.UserAction EQ "Back to Events Menu">
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
		<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>

		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfif Session.getRegisteredParticipants.RecordCount EQ 0>
		<cfquery name="updateEventToCancel" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Update p_EventRegistration_Events
			Set Active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				EventCancelled = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
				lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
			Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>
	<cfelse>
		<cfif not isDefined("FORM.EmailConfirmations")>
			<cfscript>
				errormsg = {property="EmailMsg",message="Please Select if you would like a cancellation event email sent to participants who are registered for this event."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.cancelevent&EventID=#URL.EventID#&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.cancelevent&EventID=#URL.EventID#&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		<cfelse>
			<cfif FORM.EmailConfirmations EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if you would like a cancellation event email sent to participants who are registered for this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.cancelevent&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.cancelevent&EventID=#URL.EventID#&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfif>
		<cfif LEN(FORM.EmailMsg) EQ 0>
			<cfscript>
				errormsg = {property="EmailMsg",message="Please enter a message that you would like participants to know about the cancellation of this event."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.cancelevent&EventID=#URL.EventID#&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.cancelevent&EventID=#URL.EventID#&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>

		<cfif FORM.EmailConfirmations CONTAINS 1>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfloop query="Session.getRegisteredParticipants">
				<cfset ParticipantInfo = StructNew()>
				<cfset ParticipantInfo.FName = #Session.getRegisteredParticipants.Fname#>
				<cfset ParticipantInfo.LName = #Session.getRegisteredParticipants.Lname#>
				<cfset ParticipantInfo.Email = #Session.getRegisteredParticipants.Email#>
				<cfset ParticipantInfo.CancelledByFName = #Session.Mura.FName#>
				<cfset ParticipantInfo.CancelledByLName = #Session.Mura.LName#>
				<cfset ParticipantInfo.CancelledByEmail = #Session.Mura.Email#>
				<cfset ParticipantInfo.EventShortTitle = #Session.GetSelectedEvent.ShortTitle#>
				<cfset ParticipantInfo.EventDate = #Session.GetSelectedEvent.EventDate#>
				<cfset ParticipantInfo.EmailMessageHTMLBody = #FORM.EmailMsg#>
				<cfset ParticipantInfo.EmailMessageTextBody = #ReReplaceNoCase(FORM.EmailMsg,"<[^>]*>","","ALL")#>
			
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, "127.0.0.1")#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #Variables.SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #Variables.SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #Variables.SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		<cfquery name="updateEventToCancel" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Update p_EventRegistration_Events
			Set Active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				EventCancelled = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
				lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
			Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
	</cfif>

	

	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventCancelled&Successful=True" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventCancelled&Successful=True" >
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">

</cfif>