<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, Event_HasMultipleDates, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>
	<cfquery name="GetSelectedEventDocuments" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ResourceType, ResourceDocument, ResourceContentType, ResourceDocumentSize, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
		From p_EventRegistration_EventResources
		Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and ResourceType = <cfqueryparam value="D" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
	</cfquery>
	<cfquery name="GetSelectedEventLinks" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ResourceType, ResourceDocument, ResourceContentType, ResourceDocumentSize, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
		From p_EventRegistration_EventResources
		Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
	</cfquery>
	<cflock scope="Session" type="exclusive" timeout="60">
		<cfset Session.WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
	</cflock>
	<cfswitch expression="#URL.EmailType#">
		<cfcase value="EmailRegistered">
			<cfquery name="GetRegisteredUsersForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
				WHERE (p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">) and
					(
						(p_EventRegistration_UserRegistrations.AttendedEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate2 = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate3 = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate4 = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate5 = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate6 = <cfqueryparam value="0" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">)
					)
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
			<cfquery name="GetRegisteredEmailLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, MsgBody, EmailSentToParticipants, LinksToInclude, DocsToInclude
				From p_EventRegistration_EventEmailLog
				Where EmailType = <cfqueryparam value="EmailRegistered" cfsqltype="cf_sql_varchar"> and Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflock scope="Session" type="exclusive" timeout="60">
				<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
				<cfset Session.GetSelectedEventLinks = StructCopy(GetSelectedEventLinks)>
				<cfset Session.GetSelectedEventDocuments = StructCopy(GetSelectedEventDocuments)>
				<cfset Session.GetEventEmailLogs = StructCopy(GetRegisteredEmailLog)>
				<cfset Session.GetParticipantsForEvent = StructCopy(GetRegisteredUsersForEvent)>
			</cflock>
		</cfcase>
		<cfcase value="EmailAttended">
			<cfquery name="GetSelectedEventRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE (p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">) and
					(
						(p_EventRegistration_UserRegistrations.AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
						(p_EventRegistration_UserRegistrations.AttendedEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">)
					)
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
			<cfquery name="GetAttendedEmailLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, MsgBody, EmailSentToParticipants, LinksToInclude, DocsToInclude
				From p_EventRegistration_EventEmailLog
				Where EmailType = <cfqueryparam value="EmailAttended" cfsqltype="cf_sql_varchar"> and Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflock scope="Session" type="exclusive" timeout="60">
				<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
				<cfset Session.GetSelectedEventLinks = StructCopy(GetSelectedEventLinks)>
				<cfset Session.GetSelectedEventDocuments = StructCopy(GetSelectedEventDocuments)>
				<cfset Session.GetEventEmailLogs = StructCopy(GetAttendedEmailLog)>
				<cfset Session.GetParticipantsForEvent = StructCopy(GetSelectedEventRegistrations)>
			</cflock>
		</cfcase>
	</cfswitch>
<cfelseif isDefined("URL.EventID") and isDefined("FORM.formSubmit")>
	<cfif FORM.UserAction EQ "Back to Event Listing">
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "GetSelectedEventLinks")>
		<cfset temp = StructDelete(Session, "GetSelectedEventDocuments")>
		<cfset temp = StructDelete(Session, "GetEventEmailLogs")>
		<cfset temp = StructDelete(Session, "GetParticipantsForEvent")>
		<cfset temp = StructDelete(Session, "WebEventDirectory")>
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventpresenter:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventpresenter:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput = #StructCopy(FORM)#>
	</cflock>

	<cfif LEN(FORM.EmailMsg) EQ 0>
		<cfswitch expression="#URL.EmailType#">
			<cfcase value="EmailRegistered">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a message that will be sent to all participants who have been registered for this event. "};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			</cfcase>
			<cfcase value="EmailAttended">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a message that will be sent to all participants who have attended this event. "};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			</cfcase>
		</cfswitch>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventpresenter:events.emailparticipants&EventID=#URL.EventID#&EmailType=#URL.EmailType#&FormRetry=True" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventpresenter:events.emailparticipants&EventID=#URL.EventID#&EmailType=#URL.EmailType#&FormRetry=True" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfset ParentDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/">
	<cfset EventDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #URL.EventID# & "/">
	<cfset WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
	<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
	<cflock scope="Session" type="exclusive" timeout="60">
		<cfset Session.WebEventDirectory = #Variables.WebEventDirectory#>
	</cflock>
	
	<cfswitch expression="#FORM.EmailType#">
		<cfcase value="EmailRegistered">
			<cfquery name="InsertEmailMessageLog" result="insertNewEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Insert into p_EventRegistration_EventEmailLog(Site_ID, Event_ID, EmailType, MsgBody, EmailSentToParticipants, dateCreated, lastUpdated, lastUpdateBy)
				Values(
					<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#FORM.EmailType#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#FORM.EmailMsg#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#ValueList(Session.GetParticipantsForEvent.User_ID)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<cfloop query="Session.GetParticipantsForEvent">
				<cfset ParticipantInfo = StructNew()>
				<cfset ParticipantInfo.FName = #Session.GetParticipantsForEvent.Fname#>
				<cfset ParticipantInfo.LName = #Session.GetParticipantsForEvent.Lname#>
				<cfset ParticipantInfo.EmailType = "EmailRegistered">
				<cfset ParticipantInfo.Email = #Session.GetParticipantsForEvent.Email#>
				<cfset ParticipantInfo.EventShortTitle = #Session.GetSelectedEvent.ShortTitle#>
				<cfset ParticipantInfo.EmailMessageHTMLBody = #FORM.EmailMsg#>
				<cfset ParticipantInfo.EmailMessageTextBody = #ReReplaceNoCase(FORM.EmailMsg,"<[^>]*>","","ALL")#>
				<cfset ParticipantInfo.WebEventDirectory = #Variables.WebEventDirectory#>
				<cfset ParticipantInfo.EventDocsDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #FORM.EventID# & "/">
				<cfif isDefined("FORM.IncludeDocumentLinkInEmail")>
					<cfquery name="GetSelectedEventDocuments" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
						From p_EventRegistration_EventResources
						Where TContent_ID IN (#FORM.IncludeDocumentLinkInEmail#)
					</cfquery>
					<cfset ParticipantInfo.DocumentLinksInEmail = #StructCopy(GetSelectedEventDocuments)#>
				</cfif>
				<cfif isDefined("FORM.IncludeWebLinkInEmail")>
					<cfquery name="GetSelectedEventWebLinks" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
						From p_EventRegistration_EventResources
						Where TContent_ID IN (#FORM.IncludeWebLinkInEmail#)
					</cfquery>
					<cfset ParticipantInfo.WebLinksInEmail = #StructCopy(GetSelectedEventWebLinks)#>
				</cfif>
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #Variables.SendEmailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo, "127.0.0.1")#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #Variables.SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #Variables.SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #Variables.SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
			</cfloop>
			<cfif isDefined("FORM.IncludeDocumentLinkInEmail")>
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="UpdateEmailMessageLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set DocsToInclude = <cfqueryparam value="#FORM.IncludeDocumentLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="UpdateEmailMessageLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set DocsToInclude = <cfqueryparam value="#FORM.IncludeDocumentLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATEDKEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
			<cfif isDefined("FORM.IncludeWebLinkInEmail")>
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="UpdateEmailMessageLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set LinksToInclude = <cfqueryparam value="#FORM.IncludeWebLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="UpdateEmailMessageLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set LinksToInclude = <cfqueryparam value="#FORM.IncludeWebLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATEDKEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
		</cfcase>
		<cfcase value="EmailAttended">
			<cfquery name="InsertEmailMessageLog" result="insertNewEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Insert into p_EventRegistration_EventEmailLog(Site_ID, Event_ID, EmailType, MsgBody, EmailSentToParticipants, dateCreated, lastUpdated, lastUpdateBy)
				Values(
					<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#FORM.EmailType#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#FORM.EmailMsg#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#ValueList(Session.GetParticipantsForEvent.User_ID)#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<cfloop query="Session.GetParticipantsForEvent">
				<cfset ParticipantInfo = StructNew()>
				<cfset ParticipantInfo.FName = #Session.GetParticipantsForEvent.Fname#>
				<cfset ParticipantInfo.LName = #Session.GetParticipantsForEvent.Lname#>
				<cfset ParticipantInfo.EmailType = "EmailAttended">
				<cfset ParticipantInfo.Email = #Session.GetParticipantsForEvent.Email#>
				<cfset ParticipantInfo.EventShortTitle = #Session.GetSelectedEvent.ShortTitle#>
				<cfset ParticipantInfo.EmailMessageHTMLBody = #FORM.EmailMsg#>
				<cfset ParticipantInfo.EmailMessageTextBody = #ReReplaceNoCase(FORM.EmailMsg,"<[^>]*>","","ALL")#>
				<cfset ParticipantInfo.WebEventDirectory = #Variables.WebEventDirectory#>
				<cfset ParticipantInfo.EventDocsDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #FORM.EventID# & "/">
				<cfif isDefined("FORM.IncludeDocumentLinkInEmail")>
					<cfquery name="GetSelectedEventDocuments" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
						From p_EventRegistration_EventResources
						Where TContent_ID IN (#FORM.IncludeDocumentLinkInEmail#)
					</cfquery>
					<cfset ParticipantInfo.DocumentLinksInEmail = #StructCopy(GetSelectedEventDocuments)#>
				</cfif>
				<cfif isDefined("FORM.IncludeWebLinkInEmail")>
					<cfquery name="GetSelectedEventWebLinks" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
						From p_EventRegistration_EventResources
						Where TContent_ID IN (#FORM.IncludeWebLinkInEmail#)
					</cfquery>
					<cfset ParticipantInfo.WebLinksInEmail = #StructCopy(GetSelectedEventWebLinks)#>
				</cfif>
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #Variables.SendEmailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo, "127.0.0.1")#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #Variables.SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #Variables.SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #Variables.SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
			</cfloop>
			<cfif isDefined("FORM.IncludeDocumentLinkInEmail")>
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="UpdateEmailMessageLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set DocsToInclude = <cfqueryparam value="#FORM.IncludeDocumentLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="UpdateEmailMessageLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set DocsToInclude = <cfqueryparam value="#FORM.IncludeDocumentLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATEDKEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
			<cfif isDefined("FORM.IncludeWebLinkInEmail")>
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="UpdateEmailMessageLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set LinksToInclude = <cfqueryparam value="#FORM.IncludeWebLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="UpdateEmailMessageLog" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set LinksToInclude = <cfqueryparam value="#FORM.IncludeWebLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATEDKEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
		</cfcase>
	</cfswitch>
	<cfset temp = StructDelete(Session, "FormErrors")>
	<cfset temp = StructDelete(Session, "FormInput")>
	<cfset temp = StructDelete(Session, "getAllEvents")>
	<cfset temp = StructDelete(Session, "GetEventEmailLogs")>
	<cfset temp = StructDelete(Session, "GetParticipantsForEvent")>
	<cfset temp = StructDelete(Session, "GetSelectedEvent")>
	<cfset temp = StructDelete(Session, "GetSelectedEventDocuments")>
	<cfset temp = StructDelete(Session, "GetSelectedEventLinks")>
	<cfset temp = StructDelete(Session, "WebEventDirectory")>
	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventpresenter:events.default&UserAction=EmailSentToparticipants&Successful=True" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventpresenter:events.default&UserAction=EmailSentToparticipants&Successful=True" >
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">
</cfif>