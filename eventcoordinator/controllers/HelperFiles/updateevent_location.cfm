<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("FORM.PerformAction")>
	<cfquery name="getFacilities" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone, MailingAddress, MailingCity, MailingState, MailingZipCode, MailingZip4, Mailing_isAddressVerified, Mailing_USPSDeliveryPoint, Mailing_USPSCheckDigit, Mailing_USPSCarrierRoute, PrimaryVoiceNumber, PrimaryFaxNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, AdditionalNotes, Cost_HaveEventAt, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
		From p_EventRegistration_Facility
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		Order by FacilityName
	</cfquery>
	<cfset Session.getActiveFacilities = StructCopy(getFacilities)>
<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("FORM.PerformAction")>
	<cfif FORM.UserAction EQ "Back to Update Event">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
		<cfset temp = StructDelete(Session, "GetMembershipOrganizations")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "JSMuraScope")>
		<cfset temp = StructDelete(Session, "SignInReport")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&EventID=#URL.EventID#" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&EventID=#URL.EventID#" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
	</cflock>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cflocation url="/" addtoken="false">
		</cflock>
	</cfif>

	<cfswitch expression="#FORM.PerformAction#">
		<cfcase value="Step2">
			<cfset Session.FormInput.EventStep1 = #StructCopy(FORM)#>

			<cfquery name="getSelectedFacility" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone, MailingAddress, MailingCity, MailingState, MailingZipCode, MailingZip4, Mailing_isAddressVerified, Mailing_USPSDeliveryPoint, Mailing_USPSCheckDigit, Mailing_USPSCarrierRoute, PrimaryVoiceNumber, PrimaryFaxNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, AdditionalNotes, Cost_HaveEventAt, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#Session.FormInput.EventStep1.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				Order by FacilityName
			</cfquery>
			<cfquery name="getFacilityAvailableRooms" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_FacilityRooms
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Facility_ID = <cfqueryparam value="#Session.FormInput.EventStep1.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				Order by RoomName
			</cfquery>
			<cfset Session.getSelectedFacility = StructCopy(getSelectedFacility)>
			<cfset Session.getActiveFacilityRooms = StructCopy(getFacilityAvailableRooms)>
		</cfcase>
		<cfcase value="Step3">
			<cfset Session.FormInput.EventStep2 = #StructCopy(FORM)#>
			
			<cfquery name="getFacilitySelectedRoom" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_FacilityRooms
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Facility_ID = <cfqueryparam value="#Session.FormInput.EventStep1.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer"> and TContent_ID = <cfqueryparam value="#Session.FormInput.EventStep2.Event_FacilityRoomID#" cfsqltype="cf_sql_integer">
				Order by RoomName
			</cfquery>
			<cfset Session.getSelectedFacilityRoom = StructCopy(getFacilitySelectedRoom)>
		</cfcase>
		<cfcase value="UpdateEvent">
			<cfif FORM.EventMaxParticipants GT Session.getSelectedFacilityRoom.Capacity>
				<cfscript>
					errormsg = {property="EmailMsg",message="The system is not allowed to register more participants than the room will hold. Please update the Room Capacity or select a room with larger capacity."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_location&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_location&EventID=#URL.EventID#&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfset Session.FormInput.EventStep3 = #StructCopy(FORM)#>

			<cftry>
				<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set Event_HeldAtFacilityID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.FormInput.EventStep1.Event_HeldAtFacilityID#">,
						Event_FacilityRoomID = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.FormInput.EventStep2.Event_FacilityRoomID#">,
						Event_MaxParticipants = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.FormInput.EventStep3.EventMaxParticipants#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">
				</cfquery>
				<cfcatch type="any">
					<cfdump var="#CFCATCH#" abort="True">
				</cfcatch>
			</cftry>
			<cfset temp = StructDelete(Session, "FormErrors")>
			<cfset temp = StructDelete(Session, "FormInput")>
			<cfset temp = StructDelete(Session, "getActiveFacilities")>
			<cfset temp = StructDelete(Session, "getSelectedFacility")>
			<cfset temp = StructDelete(Session, "getActiveFacilityRooms")>
			<cfset temp = StructDelete(Session, "getSelectedFacilityRoom")>
									
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventPrices&EventID=#URL.EventID#&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventPrices&EventID=#URL.EventID#&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">			
		</cfcase>
	</cfswitch>
</cfif>

