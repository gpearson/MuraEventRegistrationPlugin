<cfif not isDefined("FORM.formSubmit")>
	<cfquery name="getCaterers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, DeliveryInfo, GuaranteeInformation, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_Timezone, Active
		From p_EventRegistration_Caterers
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		Order by FacilityName
	</cfquery>
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
	<cfset Session.getActiveCaterers = StructCopy(getCaterers)>
<cfelse>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput.EventStep2 = #StructCopy(FORM)#>
	</cflock>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cflocation url="/" addtoken="false">
		</cflock>
	</cfif>
	<cfif FORM.UserAction EQ "Add Room Information">
		<cfif not isDefined("Session.FormInput")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cflock>
		</cfif>
		<cfif LEN(FORM.RoomName) LT 10>
			<cfscript>
				errormsg = {property="EmailMsg",message="Please enter a room name at this facility where participants will go to attend this event."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfif LEN(FORM.RoomName) EQ 0>
			<cfscript>
				errormsg = {property="EmailMsg",message="Please enter the maximum capacity of the room."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfquery name="insertMissingFacilityRoom" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Insert into p_EventRegistration_FacilityRooms(Site_ID, Facility_ID, RoomName, Capacity, Active)
			Values(
				<cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#FORM.LocationID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#FORM.RoomName#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#FORM.RoomCapacity#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="1" cfsqltype="cf_sql_bit">
			)
		</cfquery>
		<cfquery name="getFacilityAvailableRooms" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
			From p_EventRegistration_FacilityRooms
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Facility_ID = <cfqueryparam value="#Session.FormInput.EventStep1.LocationID#" cfsqltype="cf_sql_integer"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
			Order by RoomName
		</cfquery>
		<cfset Session.getActiveFacilityRooms = StructCopy(getFacilityAvailableRooms)>
	</cfif>
	<cfif FORM.UserAction EQ "Back to Step 1">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfif isDefined("Session.getActiveCaterers")><cfset temp = StructDelete(Session, "getActiveCaterers")></cfif>
		<cfif isDefined("Session.getMembership")><cfset temp = StructDelete(Session, "getMembership")></cfif>
		<cfif isDefined("Session.getFacilities")><cfset temp = StructDelete(Session, "getFacilities")></cfif>
		<cfif isDefined("Session.getUsers")><cfset temp = StructDelete(Session, "getUsers")></cfif>
		<cfif isDefined("Session.GetEventGroups")><cfset temp = StructDelete(Session, "GetEventGroups")></cfif>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfif not isDefined("Session.FormInput")>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfset Session.FormInput.EventStep2 = #StructCopy(FORM)#>
	</cflock>
	<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1>
		<cfif LEN(FORM.EventDate1) LT 10 or not isDate(FORM.EventDate1)>
			<cfscript>
				errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the second date this event will be held."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfif LEN(FORM.EventDate2) and not isDate(FORM.EventDate2)>
			<cfscript>
				errormsg = {property="EmailMsg",message="A Date was entered in the third Event Date spot and was not in proper date format. Please check what was entered and make any corrections necessary."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfif LEN(FORM.EventDate3) and not isDate(FORM.EventDate3)>
			<cfscript>
				errormsg = {property="EmailMsg",message="A Date was entered in the fourrth Date spot and was not in proper date format. Please check what was entered and make any corrections necessary."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfif LEN(FORM.EventDate4) and not isDate(FORM.EventDate4)>
			<cfscript>
				errormsg = {property="EmailMsg",message="A Date was entered in the fifth Event Date spot and was not in proper date format. Please check what was entered and make any corrections necessary."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfif LEN(FORM.EventDate5) and not isDate(FORM.EventDate5)>
			<cfscript>
				errormsg = {property="EmailMsg",message="A Date was entered in the sixth Event Date spot and was not in proper date format. Please check what was entered and make any corrections necessary."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfif LEN(FORM.EventDate6) and not isDate(FORM.EventDate6)>
			<cfscript>
				errormsg = {property="EmailMsg",message="A Date was entered in the seventh Event Date spot and was not in proper date format. Please check what was entered and make any corrections necessary."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cfif>
	
	<cfif Session.FormInput.EventStep1.Featured_Event CONTAINS 1>
		<cfif LEN(FORM.Featured_StartDate) and not isDate(FORM.Featured_StartDate)>
			<cfscript>
				errormsg = {property="EmailMsg",message="A Date was entered in the featured start date spot and was not in proper date format. Please check what was entered and make any corrections necessary."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfif LEN(FORM.Featured_EndDate) and not isDate(FORM.Featured_EndDate)>
			<cfscript>
				errormsg = {property="EmailMsg",message="A Date was entered in the featured end date spot and was not in proper date format. Please check what was entered and make any corrections necessary."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cfif>
	<cfif Session.FormInput.EventStep1.EarlyBird_Available CONTAINS 1>
		<cfif LEN(FORM.EarlyBird_Deadline) and not isDate(FORM.EarlyBird_Deadline)>
			<cfscript>
				errormsg = {property="EmailMsg",message="A Date was entered in the early bird registration deadline spot and was not in proper date format. Please check what was entered and make any corrections necessary."};
						arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cfif>
	<cfif Session.FormInput.EventStep1.Meal_Available CONTAINS 1>
		<cfif FORM.Meal_Included EQ "----">
			<cfscript>
				errormsg = {property="EmailMsg",message="Please select if the Meal for the participants is included in the cost of the event."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfif FORM.Meal_ProvidedBy EQ "----">
			<cfscript>
				errormsg = {property="EmailMsg",message="Please select who is providing the meal for the participants."};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cfif>
	<cfif FORM.Event_FacilityRoomID EQ "----">
		<cfscript>
			errormsg = {property="EmailMsg",message="Please select the room at the facility where this event will be held."};
			arrayAppend(Session.FormErrors, errormsg);
		</cfscript>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2&FormRetry=True" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfset newEvent = #Session.FormInput.FilePath# & #Session.FormInput.EventIDConfig#>

	<cfloop index="thefield" list="#form.fieldnames#">
		<cfif FORM[thefield] EQ "0,1"><cfset FORM[thefield] = 1></cfif>
		<cfset temp = #SetProfileString(variables.newEvent, "NewEvent_Step2", "#thefield#", FORM[thefield])#>
	</cfloop>

	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step3" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step3" >
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">
</cfif>