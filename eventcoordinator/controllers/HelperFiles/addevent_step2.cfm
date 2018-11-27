<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getCaterers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, DeliveryInfo, GuaranteeInformation, AdditionalNotes, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, isAddressVerified, GeoCode_latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Caterers
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				Order by FacilityName
			</cfquery>
			<cfquery name="getFacilityAvailableRooms" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_FacilityRooms
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Facility_ID = <cfqueryparam value="#Session.FormInput.EventStep1.LocationID#" cfsqltype="cf_sql_integer"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				Order by RoomName
			</cfquery>
			<cfquery name="getSelectedFacility" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, AdditionalNotes, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Physical_isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#Session.FormInput.EventStep1.LocationID#" cfsqltype="cf_sql_integer">
				Order by FacilityName
			</cfquery>
			<cfset Session.getSelectedFacility = StructCopy(getSelectedFacility)>
			<cfset Session.getActiveFacilityRooms = StructCopy(getFacilityAvailableRooms)>
			<cfset Session.getActiveCaterers = StructCopy(getCaterers)>			
			<cfset newEvent = #Session.FormInput.FilePath# & #Session.FormInput.EventIDConfig#>
			<cfif not isDefined("Session.FormInput.EventStep1.MealAvailable")><cfset Session.FormInput.EventStep1.MealAvailable = #GetProfileString(newEvent, "NewEvent", "MealAvailable")#></cfif>
		<cfelse>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
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
			<cfif Session.FormInput.EventStep1.EventSpanDates EQ 1>
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
			</cfif>
			<cfif Session.FormInput.EventStep1.EventFeatured EQ 1>
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
			<cfif Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable EQ 1>
				<cfif LEN(FORM.EarlyBird_RegistrationDeadline) and not isDate(FORM.EarlyBird_RegistrationDeadline)>
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
			<cfif Session.FormInput.EventStep1.MealAvailable EQ 1>
				<cfif FORM.MealIncluded EQ "----">
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
				<cfif FORM.MealProvidedBy EQ "----">
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
			<cfset newEvent = #Session.FormInput.FilePath# & #Session.FormInput.EventIDConfig#>
			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "Facilitator", FORM.Facilitator)#>
			<cfset Session.FormInput.EventStep2 = #StructCopy(FORM)#>

			<cfif Session.FormInput.EventStep1.EventSpanDates EQ 1>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventDate1", FORM.EventDate1)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventDate2", FORM.EventDate2)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventDate3", FORM.EventDate3)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventDate4", FORM.EventDate4)#>
			</cfif>

			<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "LocationRoomID", FORM.LocationRoomID)#>
			
			<cfif Session.FormInput.EventStep1.EventFeatured EQ 1>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "Featured_StartDate", FORM.Featured_StartDate)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "Featured_EndDate", FORM.Featured_EndDate)#>
			</cfif>

			<cfif Session.FormInput.EventStep1.EventHaveSessions EQ 1>
				<cfset TimeHours = #ListFirst(FORM.EventSession1_StartTime, ":")#>
				<cfset TimeMinutes = #Left(ListLast(FORM.EventSession1_StartTime, ":"), 2)#>
				<cfset TimeAMPM = #Right(ListLast(FORM.EventSession1_StartTime, ":"), 2)#>
				<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
				<cfset FORM.EventSession1_StartTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
				<cfset Session.FormInput.EventStep2.EventSession1_StartTime = #FORM.EventSession1_StartTime#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventSession1_StartTime", FORM.EventSession1_StartTime)#>

				<cfset TimeHours = #ListFirst(FORM.EventSession1_EndTime, ":")#>
				<cfset TimeMinutes = #Left(ListLast(FORM.EventSession1_EndTime, ":"), 2)#>
				<cfset TimeAMPM = #Right(ListLast(FORM.EventSession1_EndTime, ":"), 2)#>
				<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
				<cfset FORM.EventSession1_EndTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
				<cfset Session.FormInput.EventStep2.EventSession1_EndTime = #FORM.EventSession1_EndTime#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventSession1_EndTime", FORM.EventSession1_EndTime)#>

				<cfset TimeHours = #ListFirst(FORM.EventSession2_StartTime, ":")#>
				<cfset TimeMinutes = #Left(ListLast(FORM.EventSession2_StartTime, ":"), 2)#>
				<cfset TimeAMPM = #Right(ListLast(FORM.EventSession2_StartTime, ":"), 2)#>
				<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
				<cfset FORM.EventSession2_StartTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
				<cfset Session.FormInput.EventStep2.EventSession2_StartTime = #FORM.EventSession2_StartTime#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventSession2_StartTime", FORM.EventSession2_StartTime)#>

				<cfset TimeHours = #ListFirst(FORM.EventSession2_EndTime, ":")#>
				<cfset TimeMinutes = #Left(ListLast(FORM.EventSession2_EndTime, ":"), 2)#>
				<cfset TimeAMPM = #Right(ListLast(FORM.EventSession2_EndTime, ":"), 2)#>
				<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
				<cfset FORM.EventSession2_EndTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
				<cfset Session.FormInput.EventStep2.EventSession2_EndTime = #FORM.EventSession2_EndTime#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventSession2_EndTime", FORM.EventSession2_EndTime)#>
			</cfif>

			<cfif Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable EQ 1>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EarlyBird_RegistrationDeadline", FORM.EarlyBird_RegistrationDeadline)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EarlyBird_Member", FORM.EarlyBird_Member)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EarlyBird_NonMemberCost", FORM.EarlyBird_NonMemberCost)#>
			</cfif>

			<cfif Session.FormInput.EventStep1.ViewGroupPricing EQ 1>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "GroupPriceRequirements", FORM.GroupPriceRequirements)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "GroupMemberCost", FORM.GroupMemberCost)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "GroupNonMemberCost", FORM.GroupNonMemberCost)#>
			</cfif>

			<cfif Session.FormInput.EventStep1.PGPAvailable EQ 1>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "PGPPoints", FORM.PGPPoints)#>
			</cfif>

			<cfif Session.FormInput.EventStep1.MealAvailable EQ 1>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "MealIncluded", FORM.MealIncluded)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "MealProvidedBy", FORM.MealProvidedBy)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "MealInformation", FORM.MealInformation)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "MealCost", FORM.MealCost)#>
			</cfif>

			<cfif Session.FormInput.EventStep1.AllowVideoConference EQ 1>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "H323ConnectionInfo", FORM.H323ConnectionInfo)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "H323ConnectionMemberCost", FORM.H323ConnectionMemberCost)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "H323ConnectionNonMemberCost", FORM.H323ConnectionNonMemberCost)#>
			</cfif>

			<cfif Session.FormInput.EventStep1.WebinarEvent EQ 1>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "WebinarConnectWebInfo", FORM.WebinarConnectWebInfo)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "WebinarMemberCost", FORM.WebinarMemberCost)#>
				<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "WebinarNonMemberCost", FORM.WebinarNonMemberCost)#>
			</cfif>
			
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step3" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step3" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>