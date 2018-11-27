<cfif not isDefined("FORM.formSubmit")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>
	<cfset Session.getSelectedEvent = #StructCopy(getSelectedEvent)#>

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

	<cfif FORM.UserAction EQ "Back to Event Listing">
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
		<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>

		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfquery name="copyExisitngEvent" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
	Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_SortOrder, EarlyBird_Available, GroupPrice_Available, PGPCertificate_Available, Meal_Available, Meal_Included, Meal_ProvidedBy, FacilitatorID, Webinar_Available, Event_DailySessions, H323_Available, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Event_StartTime, Event_EndTime)
	Values(
		<cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="Copied - #Session.getSelectedEvent.ShortTitle#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate#">,
		<cfqueryparam value="#Session.getSelectedEvent.Event_MemberCost#" cfsqltype="cf_sql_double">,
		<cfqueryparam value="#Session.getSelectedEvent.Event_NonMemberCost#" cfsqltype="cf_sql_double">,
		<cfqueryparam value="#Session.getSelectedEvent.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer">,
		<cfqueryparam value="#Session.getSelectedEvent.Event_FacilityRoomID#" cfsqltype="cf_sql_integer">,
		<cfqueryparam value="#Session.getSelectedEvent.Event_MaxParticipants#" cfsqltype="cf_sql_integer">,
		<cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.Registration_Deadline#">,
		<cfqueryparam value="#Session.getSelectedEvent.Registration_BeginTime#" cfsqltype="cf_sql_time">,
		<cfqueryparam value="#Session.getSelectedEvent.Registration_EndTime#" cfsqltype="cf_sql_time">,
		<cfqueryparam value="#Session.getSelectedEvent.Featured_Event#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.Featured_SortOrder#" cfsqltype="cf_sql_integer">,
		<cfqueryparam value="#Session.getSelectedEvent.EarlyBird_Available#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.GroupPrice_Available#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.PGPCertificate_Available#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.Meal_Available#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.Meal_Included#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.Meal_ProvidedBy#" cfsqltype="cf_sql_integer">,
		<cfqueryparam value="#Session.getSelectedEvent.FacilitatorID#" cfsqltype="cf_sql_varchar">,
		<cfqueryparam value="#Session.getSelectedEvent.Webinar_Available#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.Event_DailySessions#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.H323_Available#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.BillForNoShow#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.EventPricePerDay#" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
		<cfqueryparam value="#Session.getSelectedEvent.Event_OptionalCosts#" cfsqltype="cf_sql_bit">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
		<cfqueryparam cfsqltype="cf_sql_time" value="#Session.getSelectedEvent.Event_StartTime#">,
		<cfqueryparam cfsqltype="cf_sql_time" value="#Session.getSelectedEvent.Event_EndTime#">
		)
	</cfquery>

	<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5) or isDate(Session.getSelectedEvent.EventDate6)>

		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						<cfif isDate(Session.getSelectedEvent.EventDate1)>, EventDate1 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate1#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate2)>, EventDate2 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate2#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate3)>, EventDate3 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate3#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate4)>, EventDate4 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate4#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate5)>, EventDate5 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate5#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate6)>, EventDate6 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate6#"></cfif>
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						<cfif isDate(Session.getSelectedEvent.EventDate1)>, EventDate1 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate1#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate2)>, EventDate2 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate2#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate3)>, EventDate3 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate3#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate4)>, EventDate4 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate4#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate5)>, EventDate5 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate5#"></cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate6)>, EventDate6 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.getSelectedEvent.EventDate6#"></cfif>
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif LEN(Session.getSelectedEvent.LongDescription) or LEN(Session.getSelectedEvent.EventAgenda) or LEN(Session.getSelectedEvent.EventTargetAudience) or LEN(Session.getSelectedEvent.EventStrategies) or LEN(Session.getSelected.EventSpecialInstructions) or LEN(Session.getSelectedEvent.Event_SpecialMessage) or LEN(Session.getSelectedEvent.PresenterID)>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						<cfif LEN(Session.getSelectedEvent.LongDescription)>, LongDescription = <cfqueryparam value="#Session.getSelectedEvent.LongDescription#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.EventAgenda)>, EventAgenda = <cfqueryparam value="#Session.getSelectedEvent.EventAgenda#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.EventTargetAudience)>, EventTargetAudience = <cfqueryparam value="#Session.getSelectedEvent.EventTargetAudience#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.EventStrategies)>, EventStrategies = <cfqueryparam value="#Session.getSelectedEvent.EventStrategies#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.EventSpecialInstructions)>, EventSpecialInstructions = <cfqueryparam value="#Session.getSelectedEvent.EventSpecialInstructions#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.Event_SpecialMessage)>, Event_SpecialMessage = <cfqueryparam value="#Session.getSelectedEvent.Event_SpecialMessage#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.PresenterID)>, PresenterID = <cfqueryparam value="#Session.getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar"></cfif>
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						<cfif LEN(Session.getSelectedEvent.LongDescription)>, LongDescription = <cfqueryparam value="#Session.getSelectedEvent.LongDescription#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.EventAgenda)>, EventAgenda = <cfqueryparam value="#Session.getSelectedEvent.EventAgenda#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.EventTargetAudience)>, EventTargetAudience = <cfqueryparam value="#Session.getSelectedEvent.EventTargetAudience#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.EventStrategies)>, EventStrategies = <cfqueryparam value="#Session.getSelectedEvent.EventStrategies#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.EventSpecialInstructions)>, EventSpecialInstructions = <cfqueryparam value="#Session.getSelectedEvent.EventSpecialInstructions#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.Event_SpecialMessage)>, Event_SpecialMessage = <cfqueryparam value="#Session.getSelectedEvent.Event_SpecialMessage#" cfsqltype="cf_sql_varchar"></cfif>
						<cfif LEN(Session.getSelectedEvent.PresenterID)>, PresenterID = <cfqueryparam value="#Session.getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar"></cfif>
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.Featured_Event EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Featured_StateDate = <cfqueryparam value="#Session.getSelectedEvent.Featured_StateDate#" cfsqltype="cf_sql_date">,
						Featured_EndDate = 	<cfqueryparam value="#Session.getSelectedEvent.Featured_EndDate#" cfsqltype="cf_sql_date">	
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Featured_StateDate = <cfqueryparam value="#Session.getSelectedEvent.Featured_StateDate#" cfsqltype="cf_sql_date">,
						Featured_EndDate = 	<cfqueryparam value="#Session.getSelectedEvent.Featured_EndDate#" cfsqltype="cf_sql_date">	
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						EarlyBird_Deadline = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_Deadline#" cfsqltype="cf_sql_date">,
						EarlyBird_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_MemberCost#" cfsqltype="cf_sql_double">,
						EarlyBird_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						EarlyBird_Deadline = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_Deadline#" cfsqltype="cf_sql_date">,
						EarlyBird_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_MemberCost#" cfsqltype="cf_sql_double">,
						EarlyBird_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.GroupPrice_Available EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						GroupPrice_Requirements = <cfqueryparam value="#Session.getSelectedEvent.GroupPrice_Requirements#" cfsqltype="cf_sql_varchar">,
						GroupPrice_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.GroupPrice_MemberCost#" cfsqltype="cf_sql_double">,
						GroupPrice_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.GroupPrice_NonMemberCost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						GroupPrice_Requirements = <cfqueryparam value="#Session.getSelectedEvent.GroupPrice_Requirements#" cfsqltype="cf_sql_varchar">,
						GroupPrice_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.GroupPrice_MemberCost#" cfsqltype="cf_sql_double">,
						GroupPrice_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.GroupPrice_NonMemberCost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.PGPCertificate_Available EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						PGPCertificate_Points = <cfqueryparam value="#Session.getSelectedEvent.PGPCertificate_Points#" cfsqltype="cf_sql_integer">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						PGPCertificate_Points = <cfqueryparam value="#Session.getSelectedEvent.PGPCertificate_Points#" cfsqltype="cf_sql_integer">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.Meal_Available EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Meal_Information = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.getSelectedEvent.Meal_Information#">,
						Meal_Cost = <cfqueryparam value="#Session.getSelectedEvent.Meal_Cost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Meal_Information = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.getSelectedEvent.Meal_Information#">,
						Meal_Cost = <cfqueryparam value="#Session.getSelectedEvent.Meal_Cost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.Webinar_Available EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Webinar_ConnectInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.getSelectedEvent.Webinar_ConnectInfo#">,
						Webinar_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.Webinar_MemberCost#" cfsqltype="cf_sql_double">,
						Webinar_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.Webinar_NonMemberCost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Webinar_ConnectInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.getSelectedEvent.Webinar_ConnectInfo#">,
						Webinar_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.Webinar_MemberCost#" cfsqltype="cf_sql_double">,
						Webinar_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.Webinar_NonMemberCost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.Event_DailySessions EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Event_Session1BeginTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session1BeginTime#" cfsqltype="cf_sql_time">,
						Event_Session1EndTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session1EndTime#" cfsqltype="cf_sql_time">,
						Event_Session2BeginTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session2BeginTime#" cfsqltype="cf_sql_time">,
						Event_Session2EndTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session2EndTime#" cfsqltype="cf_sql_time">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Event_Session1BeginTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session1BeginTime#" cfsqltype="cf_sql_time">,
						Event_Session1EndTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session1EndTime#" cfsqltype="cf_sql_time">,
						Event_Session2BeginTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session2BeginTime#" cfsqltype="cf_sql_time">,
						Event_Session2EndTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session2EndTime#" cfsqltype="cf_sql_time">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.Event_DailySessions EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Event_Session1BeginTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session1BeginTime#" cfsqltype="cf_sql_time">,
						Event_Session1EndTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session1EndTime#" cfsqltype="cf_sql_time">,
						Event_Session2BeginTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session2BeginTime#" cfsqltype="cf_sql_time">,
						Event_Session2EndTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session2EndTime#" cfsqltype="cf_sql_time">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						Event_Session1BeginTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session1BeginTime#" cfsqltype="cf_sql_time">,
						Event_Session1EndTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session1EndTime#" cfsqltype="cf_sql_time">,
						Event_Session2BeginTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session2BeginTime#" cfsqltype="cf_sql_time">,
						Event_Session2EndTime = <cfqueryparam value="#Session.getSelectedEvent.Event_Session2EndTime#" cfsqltype="cf_sql_time">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif Session.getSelectedEvent.H323_Available EQ 1>
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						H323_ConnectInfo = <cfqueryparam value="#Session.getSelectedEvent.H323_ConnectInfo#" cfsqltype="cf_sql_varchar">,
						H323_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.H323_MemberCost#" cfsqltype="cf_sql_double">,
						H323_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.H323_NonMemberCost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Events
					Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						H323_ConnectInfo = <cfqueryparam value="#Session.getSelectedEvent.H323_ConnectInfo#" cfsqltype="cf_sql_varchar">,
						H323_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.H323_MemberCost#" cfsqltype="cf_sql_double">,
						H323_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.H323_NonMemberCost#" cfsqltype="cf_sql_double">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
				</cfquery>
			</cfcase>
		</cfswitch>
	</cfif>
	<cfset temp = StructDelete(Session, "getSelectedEvent")>
	<cfset temp = StructDelete(Session, "FormInput")>
	<cfset temp = StructDelete(Session, "FormErrors")>
	<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
	<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>

	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventCopied&Successful=True" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventCopied&Successful=True" >
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">

</cfif>