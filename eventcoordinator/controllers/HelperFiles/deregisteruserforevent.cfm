<cfif not isDefined("FORM.formSubmit")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>
	
	<cfswitch expression="#application.configbean.getDBType()#">
		<cfcase value="mysql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfcase value="mssql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfif LEN(getSelectedEvent.PresenterID)>
		<cfquery name="getPresenter" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset Session.getSelectedEventPresenter = StructCopy(getPresenter)>
	</cfif>

	<cfset temp = #QueryAddColumn(getRegisteredParticipants, "SortOrder", "integer")#>
	<cfset temp = #QueryAddColumn(getRegisteredParticipants, "TempColumn", "integer")#>
	<cfset temp = #QueryAddColumn(getRegisteredParticipants, "TempRow", "integer")#>
	<cfset DisplayQueryRows = Ceiling(getRegisteredParticipants.RecordCount / 4)>
	<cfset DisplayBlankRecords = (4 * Variables.DisplayQueryRows) - #getRegisteredParticipants.RecordCount#>
	<cfset temp = #QueryAddRow(getRegisteredParticipants, variables.DisplayBlankRecords)#>
	<cfloop query="getRegisteredParticipants">
		<cfset tempColumn = ((getRegisteredParticipants.CurrentRow - 1) \ Variables.DisplayQueryRows) + 1>
		<cfset temp = #QuerySetCell(getRegisteredParticipants, "TempColumn", variables.tempColumn, getRegisteredParticipants.CurrentRow)#>
		<cfset TempCalc = getRegisteredParticipants.CurrentRow MOD Variables.DisplayQueryRows>
		<cfif TempCalc EQ 0><cfset TempRow = Variables.DisplayQueryRows><cfelse><cfset TempRow = Variables.TempCalc></cfif>
		<cfset temp = #QuerySetCell(getRegisteredParticipants, "TempRow", variables.TempRow, getRegisteredParticipants.CurrentRow)#>	
	</cfloop>
	<cfquery name="GetSelectedAccountsWithinOrganizationReSorted" dbtype="Query">Select * from getRegisteredParticipants Order by TempRow ASC, TempColumn ASC </cfquery>
	<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
	<cfset Session.getRegisteredParticipants = StructCopy(GetSelectedAccountsWithinOrganizationReSorted)>
	<cfset Session.JSMuraScope = StructCopy(rc)>
<cfelseif isDefined("FORM.formSubmit")>
	<cfif FORM.UserAction EQ "Back to Event Listing">
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "JSMuraScope")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput = #StructCopy(FORM)#>
	</cflock>

	<cfif not isDefined("FORM.EmailConfirmations")>
		<cfscript>
				errormsg = {property="EmailMsg",message="Please Select if you would like a confirmation email sent to participants who are deregistered."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.deregisteruserforevent&EventID=#URL.EventID#&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.deregisteruserforevent&EventID=#URL.EventID#&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
	<cfelse>
		<cfif FORM.EmailConfirmations EQ "----">
			<cfscript>
				errormsg = {property="EmailMsg",message="Please Select if you would like a confirmation email sent to participants who are deregistered."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.deregisteruserforevent&EventID=#URL.EventID#&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.deregisteruserforevent&EventID=#URL.EventID#&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cfif>

	<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
	<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

	<cfloop list="#FORM.ParticipantEmployee#" delimiters="," index="i">
		<cfset ParticipantUserID = ListFirst(i, "_")>
		<cfset DayNumber = ListLast(i, "_")>

		<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.RequestsMeal, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, p_EventRegistration_Events.ShortTitle, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
			FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
			WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfswitch expression="#Variables.DayNumber#">
			<cfcase value="1">
				<cfswitch expression="#FORM.EmailConfirmations#">
					<cfcase value="1">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
						<cfset ParticipantInfo.RegistrationDay = 1>
						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, "127.0.0.1")#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>
						
						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 1 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 1 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
			<cfcase value="2">
				<cfswitch expression="#FORM.EmailConfirmations#">
					<cfcase value="1">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
						<cfset ParticipantInfo.RegistrationDay = 2>
						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, "127.0.0.1")#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>

						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 1 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate2 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 1 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate2 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
			<cfcase value="3">
				<cfswitch expression="#FORM.EmailConfirmations#">
					<cfcase value="1">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
						<cfset ParticipantInfo.RegistrationDay = 3>
						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, "127.0.0.1")#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>

						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 1 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate3 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 1 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate3 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
			<cfcase value="4">
				<cfswitch expression="#FORM.EmailConfirmations#">
					<cfcase value="1">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
						<cfset ParticipantInfo.RegistrationDay = 4>
						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, "127.0.0.1")#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>

						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 1 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate4 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 1 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate4 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
			<cfcase value="5">
				<cfswitch expression="#FORM.EmailConfirmations#">
					<cfcase value="1">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
						<cfset ParticipantInfo.RegistrationDay = 5>
						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, "127.0.0.1")#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>

						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 1 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate5 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 1 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate5 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
			<cfcase value="6">
				<cfswitch expression="#FORM.EmailConfirmations#">
					<cfcase value="1">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
						<cfset ParticipantInfo.RegistrationDay = 5>
						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, "127.0.0.1")#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>

						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 1>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate6 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfcase>
					<cfdefaultcase>
						<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 1>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Delete from p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						<cfelse>
							<cfquery name="RemoveRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate6 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="ReCheckRegistrationNumberDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
								From p_EventRegistration_UserRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
								<cfquery name="RemoveRegistration"Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Delete from p_EventRegistration_UserRegistrations
									Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfif>
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
		</cfswitch>
	</cfloop>
	<cfset temp = StructDelete(Session, "getAlLEvents")>
	<cfset temp = StructDelete(Session, "FormErrors")>
	<cfset temp = StructDelete(Session, "FormInput")>
	<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
	<cfset temp = StructDelete(Session, "getSelectedAccountsWithinOrganization")>
	<cfset temp = StructDelete(Session, "getSelectedEvent")>
	<cfset temp = StructDelete(Session, "JSMuraScope")>
	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=ParticipantDeRegistered&Successful=True" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=ParticipantDeRegistered&Successful=True" >
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">	
</cfif>