<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset PriorDate = #DateAdd("m", -8, Now())#>
		<cfquery name="Session.getAvailableEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, ShortTitle, EventDate, LongDescription, PGPAvailable, MemberCost, NonMemberCost
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				EventDate >= <cfqueryparam value="#Variables.PriorDate#" cfsqltype="cf_sql_date"> and
				EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			Order by EventDate DESC
		</cfquery>
		<cfif isDefined("Session.getFacilityInformation")><cfset temp = StructDelete(Session, "getFacilityInformation")></cfif>
		<cfif isDefined("Session.getFacilityRoomInfo")><cfset temp = StructDelete(Session, "getFacilityRoomInfo")></cfif>
		<cfif isDefined("Session.getFeaturedEvents")><cfset temp = StructDelete(Session, "getFeaturedEvents")></cfif>
		<cfif isDefined("Session.getNonFeaturedEvents")><cfset temp = StructDelete(Session, "getNonFeaturedEvents")></cfif>
		<cfif isDefined("Session.getSpecificFacilityRoomInfo")><cfset temp = StructDelete(Session, "getSpecificFacilityRoomInfo")></cfif>

	</cffunction>

	<cffunction name="addevent" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cfif FORM.AddNewEventStep EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "UserSuppliedInfo")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" addtoken="false">
			</cfif>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif FORM.EventFeatured EQ "----"><cfset FORM.EventFeatured = 0></cfif>
			<cfif FORM.EventSpanDates EQ "----"><cfset FORM.EventSpanDates = 0></cfif>
			<cfif FORM.EarlyBird_RegistrationAvailable EQ "----"><cfset FORM.EarlyBird_RegistrationAvailable = 0></cfif>
			<cfif FORM.ViewSpecialPricing EQ "----"><cfset FORM.ViewSpecialPricing = 0></cfif>
			<cfif FORM.PGPAvailable EQ "----"><cfset FORM.PGPAvailable = 0></cfif>
			<cfif FORM.MealProvided EQ "----"><cfset FORM.MealProvided = 0></cfif>
			<cfif FORM.AllowVideoConference EQ "----"><cfset FORM.AllowVideoConference = 0></cfif>
			<cfif FORM.WebinarEvent EQ "----"><cfset FORM.WebinarEvent = 0></cfif>
			<cfif FORM.PostEventToFB EQ "----"><cfset FORM.PostEventToFB = 0></cfif>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = #StructCopy(FORM)#>
			</cflock>

			<cfif LEN(FORM.LongDescription) LT 50>
				<cfscript>
					eventdate = {property="EventDate",message="Please enter more than 50 characters to accuratly describe this event or workshop."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			</cfif>

			<cfif not isNumericDate(FORM.EventDate)>
				<cfscript>
					eventdate = {property="EventDate",message="Event Date is not in correct date format"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			</cfif>
			<cfif not isNumericDate(FORM.Registration_Deadline)>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Registration Deadline is not in correct date format"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent&FormRetry=True" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>
		<cfelseif not isDefined("FORM.formSubmit")>
			<cfif isDefined("Session.UserSuppliedInfo.AddNewEventStep")>
				<cfswitch expression="#Session.UserSuppliedInfo.AddNewEventStep#">
					<cfcase value="Add Event - Step 2">
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
					</cfcase>
					<cfcase value="Add Event - Step 3">
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step3&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
					</cfcase>
					<cfcase value="Add Event - Step 4">
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
					</cfcase>
					<cfcase value="Add Event - Review Information">
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
					</cfcase>
					<cfcase value="Add Event">
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
					</cfcase>
				</cfswitch>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="addevent_step2" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfif not isDefined("Session.UserSuppliedInfo.WebinarEvent")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" addtoken="false">
			</cfif>
			<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
				<cfquery name="Session.getFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, FacilityName
					From p_EventRegistration_Facility
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
					Order by FacilityName
				</cfquery>
			</cfif>
			<cfif Session.UserSuppliedInfo.MealProvided EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
				<cfquery name="Session.getCatererInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, FacilityName
					From p_EventRegistration_Caterers
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
				</cfquery>
			</cfif>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfif FORM.AddNewEventStep EQ "Back to Step 1">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent&FormRetry=True" addtoken="false">
			</cfif>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<!--- Clear out the Array from Previous Submissions --->
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif isDefined("FORM.EventDate1")><cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate1#></cfif>
				<cfif isDefined("FORM.EventDate2")><cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate2#></cfif>
				<cfif isDefined("FORM.EventDate3")><cfset Session.UserSuppliedInfo.EventDate3 = #FORM.EventDate3#></cfif>
				<cfif isDefined("FORM.EventDate4")><cfset Session.UserSuppliedInfo.EventDate4 = #FORM.EventDate4#></cfif>
				<cfif isDefined("FORM.EventAgenda")><cfset Session.UserSuppliedInfo.EventAgenda = #FORM.EventAgenda#></cfif>
				<cfif isDefined("FORM.EventTargetAudience")><cfset Session.UserSuppliedInfo.EventTargetAudience = #FORM.EventTargetAudience#></cfif>
				<cfif isDefined("FORM.EventStrategies")><cfset Session.UserSuppliedInfo.EventStrategies = #FORM.EventStrategies#></cfif>
				<cfif isDefined("FORM.EventSpecialInstructions")><cfset Session.UserSuppliedInfo.EventSpecialInstructions = #FORM.EventSpecialInstructions#></cfif>
				<cfif isDefined("FORM.MemberCost")><cfset Session.UserSuppliedInfo.MemberCost = #FORM.MemberCost#></cfif>
				<cfif isDefined("FORM.NonMemberCost")><cfset Session.UserSuppliedInfo.NonMemberCost = #FORM.NonMemberCost#></cfif>
				<cfif isDefined("FORM.Featured_StartDate")><cfset Session.UserSuppliedInfo.Featured_StartDate = #FORM.Featured_StartDate#></cfif>
				<cfif isDefined("FORM.Featured_EndDate")><cfset Session.UserSuppliedInfo.Featured_EndDate = #FORM.Featured_EndDate#></cfif>
				<cfif isDefined("FORM.Featured_SortOrder")><cfset Session.UserSuppliedInfo.Featured_SortOrder = #FORM.Featured_SortOrder#></cfif>
				<cfif isDefined("FORM.EarlyBird_RegistrationDeadline")><cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = #FORM.EarlyBird_RegistrationDeadline#></cfif>
				<cfif isDefined("FORM.EarlyBird_MemberCost")><cfset Session.UserSuppliedInfo.EarlyBird_MemberCost = #FORM.EarlyBird_MemberCost#></cfif>
				<cfif isDefined("FORM.EarlyBird_NonMemberCost")><cfset Session.UserSuppliedInfo.EarlyBird_NonMemberCost = #FORM.EarlyBird_NonMemberCost#></cfif>
				<cfif isDefined("FORM.SpecialPriceRequirements")><cfset Session.UserSuppliedInfo.SpecialPriceRequirements = #FORM.SpecialPriceRequirements#></cfif>
				<cfif isDefined("FORM.SpecialMemberCost")><cfset Session.UserSuppliedInfo.SpecialMemberCost = #FORM.SpecialMemberCost#></cfif>
				<cfif isDefined("FORM.SpecialNonMemberCost")><cfset Session.UserSuppliedInfo.SpecialNonMemberCost = #FORM.SpecialNonMemberCost#></cfif>
				<cfif isDefined("FORM.PGPPoints")><cfset Session.UserSuppliedInfo.PGPPoints = #FORM.PGPPoints#></cfif>
				<cfif isDefined("FORM.MealCost_Estimated")><cfset Session.UserSuppliedInfo.MealCost_Estimated = #FORM.MealCost_Estimated#></cfif>
				<cfif isDefined("FORM.MealProvidedBy")><cfset Session.UserSuppliedInfo.MealProvidedBy = #FORM.MealProvidedBy#></cfif>
				<cfif isDefined("FORM.VideoConferenceInfo")><cfset Session.UserSuppliedInfo.VideoConferenceInfo = #FORM.VideoConferenceInfo#></cfif>
				<cfif isDefined("FORM.VideoConferenceCost")><cfset Session.UserSuppliedInfo.VideoConferenceCost = #FORM.VideoConferenceCost#></cfif>
				<cfif isDefined("FORM.LocationID")><cfset Session.UserSuppliedInfo.LocationID = #FORM.LocationID#></cfif>
				<cfif isDefined("FORM.WebinarConnectWebInfo")><cfset Session.UserSuppliedInfo.WebinarConnectWebInfo = #FORM.WebinarConnectWebInfo#></cfif>
				<cfif isDefined("FORM.WebinarMemberCost")><cfset Session.UserSuppliedInfo.WebinarMemberCost = #FORM.WebinarMemberCost#></cfif>
				<cfif isDefined("FORM.WebinarNonMemberCost")><cfset Session.UserSuppliedInfo.WebinarNonMemberCost = #FORM.WebinarNonMemberCost#></cfif>
				<cfset Session.UserSuppliedInfo.AddNewEventStep = #FORM.AddNewEventStep#>
			</cflock>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
					<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
						<cfif Session.UserSuppliedInfo.MealProvidedBy EQ 0>
							<cfscript>
								errormsg = {property="MealProvidedBy",message="Please Select a Caterer for this meal's event"};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
						</cfif>
					</cfif>
					<cfif Session.UserSuppliedInfo.LocationID EQ 0>
						<cfscript>
							errormsg = {property="LocationID",message="Please Select Facility where event will be held"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cfif>
				</cfif>
			</cflock>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step3&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="addevent_step3" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getFacilityRoomInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select p_EventRegistration_Facility.FacilityName, p_EventRegistration_Facility.PhysicalAddress, p_EventRegistration_Facility.PhysicalCity, p_EventRegistration_Facility.PhysicalState, p_EventRegistration_Facility.PhysicalZipCode,
					p_EventRegistration_Facility.PhysicalZip4, p_EventRegistration_Facility.PrimaryVoiceNumber, p_EventRegistration_Facility.BusinessWebsite, p_EventRegistration_FacilityRooms.TContent_ID as RoomID, p_EventRegistration_FacilityRooms.RoomName, p_EventRegistration_FacilityRooms.Capacity, p_EventRegistration_FacilityRooms.RoomFees
				From p_EventRegistration_Facility INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.Facility_ID = p_EventRegistration_Facility.TContent_ID
				Where p_EventRegistration_Facility.TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_Facility.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfif FORM.AddNewEventStep EQ "Back to Step 2">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&FormRetry=True" addtoken="false">
			</cfif>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfif FORM.LocationRoomID EQ "----">
				<cfscript>
					errormsg = {property="MealProvidedBy",message="Please Select a Room at the Facility you selected where this event will be held in"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step3&PerformAction=Step3&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
			</cfif>
			<cfif isDefined("FORM.LocationRoomID")><cfset Session.UserSuppliedInfo.LocationRoomID = #FORM.LocationRoomID#></cfif>
			<cfset Session.UserSuppliedInfo.AddNewEventStep = #FORM.AddNewEventStep#>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addevent_step4" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSpecificFacilityRoomInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select p_EventRegistration_Facility.FacilityName, p_EventRegistration_Facility.PhysicalAddress, p_EventRegistration_Facility.PhysicalCity, p_EventRegistration_Facility.PhysicalState, p_EventRegistration_Facility.PhysicalZipCode,
					p_EventRegistration_Facility.PhysicalZip4, p_EventRegistration_Facility.PrimaryVoiceNumber, p_EventRegistration_Facility.BusinessWebsite, p_EventRegistration_FacilityRooms.TContent_ID as RoomID, p_EventRegistration_FacilityRooms.RoomName, p_EventRegistration_FacilityRooms.Capacity, p_EventRegistration_FacilityRooms.RoomFees
				From p_EventRegistration_Facility INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.Facility_ID = p_EventRegistration_Facility.TContent_ID
				Where p_EventRegistration_FacilityRooms.TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationRoomID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_Facility.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfif FORM.AddNewEventStep EQ "Back to Step 3">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step3&FormRetry=True" addtoken="false">
			</cfif>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.UserSuppliedInfo.MaxRoomParticipants = #FORM.RoomMaxParticipants#>
			<cfset Session.UserSuppliedInfo.AddNewEventStep = #FORM.AddNewEventStep#>

			<cfif LEN(FORM.RoomMaxParticipants) EQ 0>
				<cfscript>
					errormsg = {property="MealProvidedBy",message="Please Enter the maximum number of participants for this event or workshop"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.AcceptRegistrations EQ "----">
				<cfscript>
					errormsg = {property="MealProvidedBy",message="Please select whether to accept individuals to register for this event or not at this time."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
			</cfif>

			<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
				<cfif FORM.RoomMaxParticipants GT Session.getSpecificFacilityRoomInfo.Capacity>
					<cfscript>
					errormsg = {property="MealProvidedBy",message="Maximum Participants enteres is greater than the Room Capacity this event will be held in."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>
			<cfif isDefined("FORM.RoomMaxParticipants")><cfset Session.UserSuppliedInfo.RoomMaxParticipants = #FORM.RoomMaxParticipants#></cfif>
			<cfif isDefined("FORM.AcceptRegistrations")><cfset Session.UserSuppliedInfo.AcceptRegistrations = #FORM.AcceptRegistrations#></cfif>

			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addevent_review" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>

		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfif FORM.AddNewEventStep EQ "Back to Step 4">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&FormRetry=True" addtoken="false">
			</cfif>

			<cfset Session.UserSuppliedInfo.EventDate = #FORM.EventDate#>
			<cfset Session.UserSuppliedInfo.Registration_Deadline = #FORM.Registration_Deadline#>
			<cfset Session.UserSuppliedInfo.Registration_BeginTime = #FORM.Registration_BeginTime#>
			<cfset Session.UserSuppliedInfo.Event_StartTime = #FORM.Event_StartTime#>
			<cfset Session.UserSuppliedInfo.Event_EndTime = #FORM.Event_EndTime#>
			<cfset Session.UserSuppliedInfo.ShortTitle = #FORM.ShortTitle#>
			<cfset Session.UserSuppliedInfo.PostEventToFB = #FORM.PostEventToFB#>
			<cfset Session.UserSuppliedInfo.AcceptRegistrations = #FORM.AcceptRegistrations#>
			<cfset Session.UserSuppliedInfo.EventFeatured = #FORM.EventFeatured#>
			<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable = #FORM.EarlyBird_RegistrationAvailable#>
			<cfset Session.UserSuppliedInfo.ViewSpecialPricing = #FORM.ViewSpecialPricing#>
			<cfset Session.UserSuppliedInfo.PGPAvailable = #FORM.PGPAvailable#>
			<cfset Session.UserSuppliedInfo.MealProvided = #FORM.MealProvided#>
			<cfset Session.UserSuppliedInfo.AllowVideoConference = #FORM.AllowVideoConference#>
			<cfset Session.UserSuppliedInfo.WebinarEvent = #FORM.WebinarEvent#>
			<cfset Session.UserSuppliedInfo.LocationID = #FORM.LocationID#>
			<cfset Session.UserSuppliedInfo.LocationRoomID = #FORM.LocationRoomID#>
			<cfset Session.UserSuppliedInfo.MemberCost = #FORM.MemberCost#>
			<cfset Session.UserSuppliedInfo.NonMemberCost = #FORM.NonMemberCost#>
			<cfset Session.UserSuppliedInfo.RoomMaxParticipants = #FORM.RoomMaxParticipants#>
			<cfset Session.UserSuppliedInfo.AddNewEventStep = #FORM.AddNewEventStep#>


			<cfif FORM.EventSpanDates EQ 1>
				<cfset Session.UserSuppliedInfo.EventSpanDates = #FORM.EventSpanDates#>
				<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate1#>
				<cfif isDefined("FORM.EventDate2")><cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate2#></cfif>
				<cfif isDefined("FORM.EventDate3")><cfset Session.UserSuppliedInfo.EventDate3 = #FORM.EventDate3#></cfif>
				<cfif isDefined("FORM.EventDate4")><cfset Session.UserSuppliedInfo.EventDate4 = #FORM.EventDate4#></cfif>
			</cfif>

			<cfif isDefined("FORM.LongDescription")><cfset Session.UserSuppliedInfo.LongDescription = #FORM.LongDescription#></cfif>
			<cfif isDefined("FORM.EventAgenda")><cfset Session.UserSuppliedInfo.EventAgenda = #FORM.EventAgenda#></cfif>
			<cfif isDefined("FORM.EventTargetAudience")><cfset Session.UserSuppliedInfo.EventTargetAudience = #FORM.EventTargetAudience#></cfif>
			<cfif isDefined("FORM.EventStrategies")><cfset Session.UserSuppliedInfo.EventStrategies = #FORM.EventStrategies#></cfif>
			<cfif isDefined("FORM.EventSpecialInstructions")><cfset Session.UserSuppliedInfo.EventSpecialInstructions = #FORM.EventSpecialInstructions#></cfif>
			<cfif isDefined("FORM.Featured_StartDate")><cfset Session.UserSuppliedInfo.Featured_StartDate = #FORM.Featured_StartDate#></cfif>
			<cfif isDefined("FORM.Featured_EndDate")><cfset Session.UserSuppliedInfo.Featured_EndDate = #FORM.Featured_EndDate#></cfif>
			<cfif isDefined("FORM.Featured_SortOrder")><cfset Session.UserSuppliedInfo.Featured_SortOrder = #FORM.Featured_SortOrder#></cfif>
			<cfif isDefined("FORM.EarlyBird_RegistrationDeadline")><cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = #FORM.EarlyBird_RegistrationDeadline#></cfif>
			<cfif isDefined("FORM.EarlyBird_Member")><cfset Session.UserSuppliedInfo.EarlyBird_Member = #FORM.EarlyBird_Member#></cfif>
			<cfif isDefined("FORM.EarlyBird_NonMemberCost")><cfset Session.UserSuppliedInfo.EarlyBird_NonMemberCost = #FORM.EarlyBird_NonMemberCost#></cfif>
			<cfif isDefined("FORM.SpecialPriceRequirements")><cfset Session.UserSuppliedInfo.SpecialPriceRequirements = #FORM.SpecialPriceRequirements#></cfif>
			<cfif isDefined("FORM.SpecialMemberCost")><cfset Session.UserSuppliedInfo.SpecialMemberCost = #FORM.SpecialMemberCost#></cfif>
			<cfif isDefined("FORM.SpecialNonMemberCost")><cfset Session.UserSuppliedInfo.SpecialNonMemberCost = #FORM.SpecialNonMemberCost#></cfif>
			<cfif isDefined("FORM.PGPPoints")><cfset Session.UserSuppliedInfo.PGPPoints = #FORM.PGPPoints#></cfif>
			<cfif isDefined("FORM.MealCost_Estimated")><cfset Session.UserSuppliedInfo.MealCost_Estimated = #FORM.MealCost_Estimated#></cfif>
			<cfif isDefined("FORM.MealProvidedBy")><cfset Session.UserSuppliedInfo.MealProvidedBy = #FORM.MealProvidedBy#></cfif>
			<cfif isDefined("FORM.VideoConferenceInfo")><cfset Session.UserSuppliedInfo.VideoConferenceInfo = #FORM.VideoConferenceInfo#></cfif>
			<cfif isDefined("FORM.VideoConferenceCost")><cfset Session.UserSuppliedInfo.VideoConferenceCost = #FORM.VideoConferenceCost#></cfif>
			<cfif isDefined("FORM.WebinarConnectWebInfo")><cfset Session.UserSuppliedInfo.WebinarConnectWebInfo = #FORM.WebinarConnectWebInfo#></cfif>
			<cfif isDefined("FORM.WebinarMemberCost")><cfset Session.UserSuppliedInfo.WebinarMemberCost = #FORM.WebinarMemberCost#></cfif>
			<cfif isDefined("FORM.WebinarNonMemberCost")><cfset Session.UserSuppliedInfo.WebinarNonMemberCost = #FORM.WebinarNonMemberCost#></cfif>

			<cfif LEN(FORM.LongDescription) LT 50>
				<cfscript>
					eventdate = {property="EventDate",message="Please enter more than 50 characters to accuratly describe this event or workshop."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif not isNumericDate(FORM.EventDate)>
				<cfscript>
					eventdate = {property="EventDate",message="Event Date is not in correct date format"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>
			<cfif not isNumericDate(FORM.Registration_Deadline)>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Registration Deadline is not in correct date format"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif isDefined("FORM.EventDate1")>
				<cfif not isNumericDate(FORM.EventDate1)>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="2nd Event Date is not in the correct date format."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif isDefined("FORM.EventDate2")>
				<cfif not isNumericDate(FORM.EventDate2)>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="3rd Event Date is not in the correct date format."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif isDefined("FORM.EventDate3")>
				<cfif not isNumericDate(FORM.EventDate3)>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="4th Event Date is not in the correct date format."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif isDefined("FORM.EventDate4")>
				<cfif not isNumericDate(FORM.EventDate4)>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="5th Event Date is not in the correct date format."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.PostEventToFB EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select one of the options whether to post this event the Facebook or not."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.AcceptRegistrations EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select whether to alloww individuals to register for this event or not at this time."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.EventFeatured EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select whether this event will be featured on the website or not."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif Session.UserSuppliedInfo.EventFeatured EQ 1 AND LEN(FORM.Featured_StartDate) EQ 0 OR Session.UserSuppliedInfo.EventFeatured EQ 1 AND LEN(FORM.Featured_EndDate) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please complete the missing information of either Featured Start Date or Featured Ending Date. To not use this you can change the value of Event Featured to 'No'"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.EarlyBird_RegistrationAvailable EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select whether this event will have Early Bird Registration Discounts availble to it for participants."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_RegistrationDeadline) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="To utilize the Early Bird Registration Feature a date is needed."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_Member) EQ 0 OR Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_NonMemberCost) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="To utilize the Early Bird Registration Feature you will need to enter the cost for members and non members if they register for the early bird deadline date."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.ViewSpecialPricing EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select whether this event will offer special pricing when participants have met the requirements for this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.ViewSpecialPricing EQ 1 and LEN(FORM.SpecialPriceRequirements) LT 50>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please enter the requirements needed for participants to meet in order to receive this special pricing for this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.ViewSpecialPricing EQ 1 and LEN(FORM.SpecialMemberCost) EQ 0 or FORM.ViewSpecialPricing EQ 1 and LEN(FORM.SpecialNonMemberCost) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please enter the special pricing amounts for Member and NonMember. To not use this feature you can simply change the value of View Special Pricing to 'No'"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.PGPAvailable EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select whether this event will offer Professional Growth Point Certificate to those individuals who attended the entire event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.PGPAvailable EQ 1 and LEN(FORM.PGPPoints) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please enter how many PGP Points you want to award the participants that successfully attended this event or workshop."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.MealProvided EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select if this event or workshop will include a meal for the participants who attend this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.MealProvided EQ 1 and LEN(FORM.MealCost_Estimated) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please enter an amount for the cost of each participant's meal. To not use this feature simply select No Meal is Provided."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.MealProvided EQ 1 and FORM.MealProvidedBy EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please enter who will be providing the meal for this event or workshop. To not use this feature simply change the option of Meal Provided to 'No'"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.AllowVideoConference EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select if this event or workshop will allow participants to connect with Distance Education Equipment (Polycom, Lifesize, Tangburg)."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.AllowVideoConference EQ 1 and LEN(FORM.VideoConferenceInfo) LT 50 or FORM.AllowVideoConference EQ 1 and LEN(FORM.VideoConferenceCost) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please enter information as to how the participant will connect to this event through the distance education equipment or enter the cost for the particpant to use this method to attend this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.WebinarEvent EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select if this event or workshop will only be allowed through a WebEx/Webinar availability."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.WebinarEvent EQ 1 and LEN(FORM.WebinarConnectWebInfo) LT 50 or FORM.WebinarEvent EQ 1 and LEN(FORM.WebinarMemberCost) EQ 0 or FORM.WebinarEvent EQ 1 and LEN(FORM.WebinarNonMemberCost) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please enter the necessary information to give particiants information on how to connect to this event as a webinar and/or the costs for a participant to utilize this option."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.WebinarEvent EQ 0>
				<cfif FORM.LocationID EQ "----">
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please select a facility that will hold this event for participants to attend"};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>

				<cfquery name="getFacilityRoomInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select p_EventRegistration_Facility.FacilityName, p_EventRegistration_Facility.PhysicalAddress, p_EventRegistration_Facility.PhysicalCity, p_EventRegistration_Facility.PhysicalState, p_EventRegistration_Facility.PhysicalZipCode,
						p_EventRegistration_Facility.PhysicalZip4, p_EventRegistration_Facility.PrimaryVoiceNumber, p_EventRegistration_Facility.BusinessWebsite, p_EventRegistration_FacilityRooms.TContent_ID as RoomID, p_EventRegistration_FacilityRooms.RoomName, p_EventRegistration_FacilityRooms.Capacity, p_EventRegistration_FacilityRooms.RoomFees
					From p_EventRegistration_Facility INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.Facility_ID = p_EventRegistration_Facility.TContent_ID
					Where p_EventRegistration_Facility.TContent_ID = <cfqueryparam value="#FORM.LocationID#" cfsqltype="cf_sql_integer"> and
						p_EventRegistration_FacilityRooms.TContent_ID = <cfqueryparam value="#FORM.LocationRoomID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfif getFacilityRoomInfo.RecordCount EQ 0>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please select a correct Room within the Facility that participants will be in for this event or workshop."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>

				<cfif FORM.RoomMaxParticipants GT getFacilityRoomInfo.Capacity>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please enter a smaller amount for maxuimum participants due to the room selected will not hold the number you requested."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.WebinarEvent EQ 0 and LEN(FORM.MemberCost) EQ 0 or FORM.WebinarEvent EQ 0 and LEN(FORM.NonMemberCost) EQ 0>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please review the event cost to attend for Members and NonMembers."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<!--- Create Date Object from User Inputted Time from Event Start Time --->
			<cfset EventStartTimeHours = #ListFirst(Session.UserSuppliedInfo.Event_StartTime, ":")#>
			<cfset EventStartTimeMinutes = #Left(ListLast(Session.UserSuppliedInfo.Event_StartTime, ":"), 2)#>
			<cfset EventStartTimeAMPM = #Right(ListLast(Session.UserSuppliedInfo.Event_StartTime, ":"), 2)#>
			<cfif EventStartTimeAMPM EQ "PM">
				<cfswitch expression="#Variables.EventStartTimeHours#">
					<cfcase value="12">
						<cfset EventStartTimeHours = #Variables.EventStartTimeHours#>
					</cfcase>
					<cfdefaultcase>
						<cfset EventStartTimeHours = #Variables.EventStartTimeHours# + 12>
					</cfdefaultcase>
				</cfswitch>
			</cfif>
			<cfset EventStartTimeObject = #CreateTime(Variables.EventStartTimeHours, Variables.EventStartTimeMinutes, 0)#>

			<!--- Create Date Object from User Inputted Time from Event End Time --->
			<cfset EventEndTimeHours = #ListFirst(Session.UserSuppliedInfo.Event_EndTime, ":")#>
			<cfset EventEndTimeMinutes = #Left(ListLast(Session.UserSuppliedInfo.Event_EndTime, ":"), 2)#>
			<cfset EventEndTimeAMPM = #Right(ListLast(Session.UserSuppliedInfo.Event_EndTime, ":"), 2)#>
			<cfif EventEndTimeAMPM EQ "PM">
				<cfswitch expression="#Variables.EventEndTimeHours#">
					<cfcase value="12">
						<cfset EventEndTimeHours = #Variables.EventEndTimeHours#>
					</cfcase>
					<cfdefaultcase>
						<cfset EventEndTimeHours = #Variables.EventEndTimeHours# + 12>
					</cfdefaultcase>
				</cfswitch>
			</cfif>
			<cfset EventEndTimeObject = #CreateTime(Variables.EventEndTimeHours, Variables.EventEndTimeMinutes, 0)#>

			<!--- Create Date Object from User Inputted Time from Event End Time --->
			<cfset RegistrationBeginTimeHours = #ListFirst(Session.UserSuppliedInfo.Registration_BeginTime, ":")#>
			<cfset RegistrationBeginTimeMinutes = #Left(ListLast(Session.UserSuppliedInfo.Registration_BeginTime, ":"), 2)#>
			<cfset RegistrationBeginTimeAMPM = #Right(ListLast(Session.UserSuppliedInfo.Registration_BeginTime, ":"), 2)#>
			<cfif RegistrationBeginTimeAMPM EQ "PM">
				<cfswitch expression="#Variables.RegistrationBeginTimeHours#">
					<cfcase value="12">
						<cfset RegistrationBeginTimeHours = #Variables.RegistrationBeginTimeHours#>
					</cfcase>
					<cfdefaultcase>
						<cfset RegistrationBeginTimeHours = #Variables.RegistrationBeginTimeHours# + 12>
					</cfdefaultcase>
				</cfswitch>
			</cfif>
			<cfset RegistrationBeginTimeObject = #CreateTime(Variables.RegistrationBeginTimeHours, Variables.RegistrationBeginTimeMinutes, 0)#>

			<cftry>
				<cfquery name="insertNewEvent" result="insertNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active, lastUpdated, lastUpdateBy)
					Values (
						<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#FORM.ShortTitle#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#CreateDate(ListLast(FORM.EventDate, '/'), ListFirst(FORM.EventDate, '/'), ListGetAt(FORM.EventDate, 2, '/'))#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#FORM.LongDescription#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Variables.EventStartTimeObject#" cfsqltype="cf_sql_time">,
						<cfqueryparam value="#Variables.EventEndTimeObject#" cfsqltype="cf_sql_time">,
						<cfqueryparam value="#CreateDate(ListLast(FORM.Registration_Deadline, '/'), ListFirst(FORM.Registration_Deadline, '/'), ListGetAt(FORM.Registration_Deadline, 2, '/'))#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#Variables.RegistrationBeginTimeObject#" cfsqltype="cf_sql_time">,
						<cfqueryparam value="#Variables.EventStartTimeObject#" cfsqltype="cf_sql_time">,
						<cfqueryparam value="#FORM.EventFeatured#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#FORM.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#FORM.ViewSpecialPricing#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#FORM.PGPAvailable#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#FORM.MealProvided#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#FORM.AllowVideoConference#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#FORM.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#FORM.RoomMaxParticipants#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="1" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>

				<cfquery name="updateEventLocationInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set LocationID = <cfqueryparam value="#FORM.LocationID#" cfsqltype="cf_sql_integer">,
						LocationRoomID = <cfqueryparam value="#FORM.LocationRoomID#" cfsqltype="cf_sql_integer">,
						MemberCost = <cfqueryparam value="#NumberFormat(FORM.MemberCost, '9999.99')#" cfsqltype="cf_sql_float">,
						NonMemberCost = <cfqueryparam value="#NumberFormat(FORM.NonMemberCost, '9999.99')#" cfsqltype="cf_sql_float">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfif isDefined("FORM.EventDate1")>
					<cfif #isDate(FORM.EventDate1)# EQ 1>
						<cfquery name="updateEventDate1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set EventDate1 = #CreateDate(ListLast(FORM.EventDate1, "/"), ListFirst(FORM.EventDate1, "/"), ListGetAt(FORM.EventDate1, 2, "/"))#,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("FORM.EventDate2")>
					<cfif #isDate(FORM.EventDate2)# EQ 1>
						<cfquery name="updateEventDate2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set EventDate2 = #CreateDate(ListLast(FORM.EventDate2, "/"), ListFirst(FORM.EventDate2, "/"), ListGetAt(FORM.EventDate2, 2, "/"))#,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("FORM.EventDate3")>
					<cfif #isDate(FORM.EventDate3)# EQ 1>
						<cfquery name="updateEventDate3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set EventDate3 = #CreateDate(ListLast(FORM.EventDate3, "/"), ListFirst(FORM.EventDate3, "/"), ListGetAt(FORM.EventDate3, 2, "/"))#,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("FORM.EventDate4")>
					<cfif #isDate(FORM.EventDate4)# EQ 1>
						<cfquery name="updateEventDate4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set EventDate4 = #CreateDate(ListLast(FORM.EventDate4, "/"), ListFirst(FORM.EventDate4, "/"), ListGetAt(FORM.EventDate4, 2, "/"))#,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("FORM.EventAgenda")>
					<cfif LEN(FORM.EventAgenda)>
						<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set EventAgenda = <cfqueryparam value="#FORM.EventAgenda#" cfsqltype="cf_sql_varchar">,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("FORM.EventTargetAudience")>
					<cfif LEN(FORM.EventTargetAudience)>
						<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set EventTargetAudience = <cfqueryparam value="#FORM.EventTargetAudience#" cfsqltype="cf_sql_varchar">,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("FORM.EventStrategies")>
					<cfif LEN(FORM.EventStrategies)>
						<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set EventStrategies = <cfqueryparam value="#FORM.EventStrategies#" cfsqltype="cf_sql_varchar">,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("FORM.EventSpecialInstructions")>
					<cfif LEN(FORM.EventSpecialInstructions)>
						<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set EventSpecialInstructions = <cfqueryparam value="#FORM.EventSpecialInstructions#" cfsqltype="cf_sql_varchar">,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif FORM.EventFeatured EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set Featured_StartDate = #CreateDate(ListLast(FORM.Featured_StartDate, "/"), ListFirst(FORM.Featured_StartDate, "/"), ListGetAt(FORM.Featured_StartDate, 2, "/"))#,
							Featured_EndDate = #CreateDate(ListLast(FORM.Featured_EndDate, "/"), ListFirst(FORM.Featured_EndDate, "/"), ListGetAt(FORM.Featured_EndDate, 2, "/"))#,
							Featured_SortOrder = <cfqueryparam value="#FORM.Featured_SortOrder#" cfsqltype="cf_sql_integer">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif FORM.EarlyBird_RegistrationAvailable EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set EarlyBird_RegistrationAvailable = <cfqueryparam value="#FORM.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
							EarlyBird_RegistrationDeadline = #CreateDate(ListLast(FORM.EarlyBird_RegistrationDeadline, "/"), ListFirst(FORM.EarlyBird_RegistrationDeadline, "/"), ListGetAt(FORM.EarlyBird_RegistrationDeadline, 2, "/"))#,
							EarlyBird_MemberCost = "#FORM.EarlyBird_MemberCost#",
							EarlyBird_NonMemberCost = "#FORM.EarlyBird_NonMemberCost#",
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif FORM.ViewSpecialPricing EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set ViewSpecialPricing = <cfqueryparam value="#FORM.ViewSpecialPricing#" cfsqltype="cf_sql_bit">,
							SpecialMemberCost = "#FORM.SpecialMemberCost#",
							SpecialNonMemberCost = "#FORM.SpecialNonMemberCost#",
							SpecialPriceRequirements = "#FORM.SpecialPriceRequirements#",
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif FORM.PGPAvailable EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set PGPAvailable = <cfqueryparam value="#FORM.PGPAvailable#" cfsqltype="cf_sql_bit">,
							PGPPoints = <cfqueryparam value="#FORM.PGPPoints#" cfsqltype="cf_sql_DECIMAL">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif FORM.MealProvided EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set MealCost_Estimated = <cfqueryparam value="#FORM.MealCost_Estimated#" cfsqltype="CF_SQL_MONEY">,
							MealProvidedBy = <cfqueryparam value="#FORM.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif FORM.AllowVideoConference EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set AllowVideoConference = <cfqueryparam value="#FORM.AllowVideoConference#" cfsqltype="cf_sql_bit">,
							VideoConferenceInfo = <cfqueryparam value="#FORM.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
							VideoConferenceCost = <cfqueryparam value="#FORM.VideoConferenceCost#" cfsqltype="CF_SQL_MONEY">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif FORM.WebinarEvent EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set WebinarAvailable = <cfqueryparam value="#FORM.WebinarEvent#" cfsqltype="cf_sql_bit">,
							WebinarConnectInfo = <cfqueryparam value="#FORM.WebinarConnectWebInfo#" cfsqltype="CF_SQL_VARCHAR">,
							WebinarMemberCost = <cfqueryparam value="#FORM.WebinarMemberCost#" cfsqltype="CF_SQL_MONEY">,
							WebinarNonMemberCost = <cfqueryparam value="#FORM.WebinarNonMemberCost#" cfsqltype="CF_SQL_MONEY">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfquery name="CheckEventMultipleDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select Site_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder,
						MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated,
						AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active, EventCancelled, WebinarAvailable,
						WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, PostedTo_Facebook, PostedTo_Twitter
					From p_EventRegistration_Events
					Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif isDate(CheckEventMultipleDates.EventDate1) or isDate(CheckEventMultipleDates.EventDate2) or isDate(CheckEventMultipleDates.EventDate3) or isDate(CheckEventMultipleDates.EventDate4) or isDate(CheckEventMultipleDates.EventDate5)>
					<cfif isDate(CheckEventMultipleDates.EventDate1)><cfset TotalNumberDays = 2></cfif>
					<cfif isDate(CheckEventMultipleDates.EventDate2)><cfset TotalNumberDays = 3></cfif>
					<cfif isDate(CheckEventMultipleDates.EventDate3)><cfset TotalNumberDays = 4></cfif>
					<cfif isDate(CheckEventMultipleDates.EventDate4)><cfset TotalNumberDays = 5></cfif>
					<cfif isDate(CheckEventMultipleDates.EventDate5)><cfset TotalNumberDays = 6></cfif>
					<cfif Len(CheckEventMultipleDates.ShortTitle) LTE 62>
						<cfset NewEventTitle = #CheckEventMultipleDates.ShortTitle# & " - Day 1 of " & #Variables.TotalNumberDays#>
					<cfelse>
						<cfset NewEventTitle = #Left(CheckEventMultipleDates.ShortTitle, 62)# & " - Day 1 of " & #Variables.TotalNumberDays#>
					</cfif>
					<cfquery name="UpdateEventTitle" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set ShortTitle = <cfqueryparam value="#Variables.NewEventTitle#" cfsqltype="CF_SQL_VARCHAR">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
				<cfif isDate(CheckEventMultipleDates.EventDate1)>
					<cfif Len(CheckEventMultipleDates.ShortTitle) LTE 62>
						<cfset NewEventTitle = #CheckEventMultipleDates.ShortTitle# & " - Day 2 of " & #Variables.TotalNumberDays#>
					<cfelse>
						<cfset NewEventTitle = #Left(CheckEventMultipleDates.ShortTitle, 62)# & " - Day 2 of " & #Variables.TotalNumberDays#>
					</cfif>

					<cfquery name="InsertSecondEventDate" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_RegistrationDeadline, MemberCost, NonMemberCost, EarlyBird_MemberCost, EarlyBird_NonMemberCost, SpecialMemberCost, SpecialNonMemberCost, MealCost_Estimated, WebinarMemberCost, WebinarNonMemberCost, VideoConferenceCost, SpecialPriceRequirements, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, WebinarConnectInfo, Presenters, PGPPoints, MealProvidedBy, LocationID, LocationRoomID, EventCancelled, WebinarAvailable, PostedTo_Facebook, PostedTo_Twitter, lastUpdated, lastUpdateBy)
						Values(
						<cfqueryparam value="#CheckEventMultipleDates.Site_ID#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#Variables.NewEventTitle#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventDate1#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.LongDescription#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.Event_StartTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.Event_EndTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.Registration_Deadline#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Registration_BeginTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.EventFeatured#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_RegistrationAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.ViewSpecialPricing#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PGPAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.MealProvided#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.AllowVideoConference#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.AcceptRegistrations#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.Facilitator#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.dateCreated#" cfsqltype="CF_SQL_TIMESTAMP">,
						<cfqueryparam value="#CheckEventMultipleDates.MaxParticipants#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.Active#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_StartDate#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_EndDate#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_SortOrder#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_RegistrationDeadline#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.MemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.NonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_MemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_NonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialNonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.MealCost_Estimated#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarNonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.VideoConferenceCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialPriceRequirements#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventAgenda#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventTargetAudience#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventStrategies#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventSpecialInstructions#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarConnectInfo#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.Presenters#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.PGPPoints#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.LocationID#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.LocationRoomID#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.EventCancelled#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PostedTo_Facebook#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PostedTo_Twitter#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.lastUpdated#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.lastUpdateBy#" cfsqltype="CF_SQL_CHAR">)
					</cfquery>
				</cfif>
				<cfif isDate(CheckEventMultipleDates.EventDate2)>
					<cfif Len(CheckEventMultipleDates.ShortTitle) LTE 62>
						<cfset NewEventTitle = #CheckEventMultipleDates.ShortTitle# & " - Day 3 of " & #Variables.TotalNumberDays#>
					<cfelse>
						<cfset NewEventTitle = #Left(CheckEventMultipleDates.ShortTitle, 62)# & " - Day 3 of " & #Variables.TotalNumberDays#>
					</cfif>

					<cfquery name="InsertSecondEventDate" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_RegistrationDeadline, MemberCost, NonMemberCost, EarlyBird_MemberCost, EarlyBird_NonMemberCost, SpecialMemberCost, SpecialNonMemberCost, MealCost_Estimated, WebinarMemberCost, WebinarNonMemberCost, VideoConferenceCost, SpecialPriceRequirements, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, WebinarConnectInfo, Presenters, PGPPoints, MealProvidedBy, LocationID, LocationRoomID, EventCancelled, WebinarAvailable, PostedTo_Facebook, PostedTo_Twitter, lastUpdated, lastUpdateBy)
						Values(
						<cfqueryparam value="#CheckEventMultipleDates.Site_ID#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#Variables.NewEventTitle#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventDate2#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.LongDescription#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.Event_StartTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.Event_EndTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.Registration_Deadline#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Registration_BeginTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.EventFeatured#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_RegistrationAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.ViewSpecialPricing#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PGPAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.MealProvided#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.AllowVideoConference#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.AcceptRegistrations#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.Facilitator#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.dateCreated#" cfsqltype="CF_SQL_TIMESTAMP">,
						<cfqueryparam value="#CheckEventMultipleDates.MaxParticipants#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.Active#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_StartDate#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_EndDate#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_SortOrder#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_RegistrationDeadline#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.MemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.NonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_MemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_NonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialNonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.MealCost_Estimated#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarNonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.VideoConferenceCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialPriceRequirements#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventAgenda#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventTargetAudience#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventStrategies#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventSpecialInstructions#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarConnectInfo#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.Presenters#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.PGPPoints#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.LocationID#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.LocationRoomID#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.EventCancelled#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PostedTo_Facebook#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PostedTo_Twitter#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.lastUpdated#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.lastUpdateBy#" cfsqltype="CF_SQL_CHAR">)
					</cfquery>
				</cfif>
				<cfif isDate(CheckEventMultipleDates.EventDate3)>
					<cfif Len(CheckEventMultipleDates.ShortTitle) LTE 62>
						<cfset NewEventTitle = #CheckEventMultipleDates.ShortTitle# & " - Day 4 of " & #Variables.TotalNumberDays#>
					<cfelse>
						<cfset NewEventTitle = #Left(CheckEventMultipleDates.ShortTitle, 62)# & " - Day 4 of " & #Variables.TotalNumberDays#>
					</cfif>

					<cfquery name="InsertSecondEventDate" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_RegistrationDeadline, MemberCost, NonMemberCost, EarlyBird_MemberCost, EarlyBird_NonMemberCost, SpecialMemberCost, SpecialNonMemberCost, MealCost_Estimated, WebinarMemberCost, WebinarNonMemberCost, VideoConferenceCost, SpecialPriceRequirements, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, WebinarConnectInfo, Presenters, PGPPoints, MealProvidedBy, LocationID, LocationRoomID, EventCancelled, WebinarAvailable, PostedTo_Facebook, PostedTo_Twitter, lastUpdated, lastUpdateBy)
						Values(
						<cfqueryparam value="#CheckEventMultipleDates.Site_ID#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#Variables.NewEventTitle#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventDate3#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.LongDescription#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.Event_StartTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.Event_EndTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.Registration_Deadline#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Registration_BeginTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.EventFeatured#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_RegistrationAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.ViewSpecialPricing#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PGPAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.MealProvided#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.AllowVideoConference#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.AcceptRegistrations#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.Facilitator#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.dateCreated#" cfsqltype="CF_SQL_TIMESTAMP">,
						<cfqueryparam value="#CheckEventMultipleDates.MaxParticipants#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.Active#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_StartDate#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_EndDate#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_SortOrder#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_RegistrationDeadline#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.MemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.NonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_MemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_NonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialNonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.MealCost_Estimated#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarNonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.VideoConferenceCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialPriceRequirements#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventAgenda#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventTargetAudience#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventStrategies#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventSpecialInstructions#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarConnectInfo#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.Presenters#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.PGPPoints#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.LocationID#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.LocationRoomID#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.EventCancelled#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PostedTo_Facebook#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PostedTo_Twitter#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.lastUpdated#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.lastUpdateBy#" cfsqltype="CF_SQL_CHAR">)
					</cfquery>
				</cfif>
				<cfif isDate(CheckEventMultipleDates.EventDate4)>
					<cfif Len(CheckEventMultipleDates.ShortTitle) LTE 62>
						<cfset NewEventTitle = #CheckEventMultipleDates.ShortTitle# & " - Day 5 of " & #Variables.TotalNumberDays#>
					<cfelse>
						<cfset NewEventTitle = #Left(CheckEventMultipleDates.ShortTitle, 62)# & " - Day 5 of " & #Variables.TotalNumberDays#>
					</cfif>

					<cfquery name="InsertSecondEventDate" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_RegistrationDeadline, MemberCost, NonMemberCost, EarlyBird_MemberCost, EarlyBird_NonMemberCost, SpecialMemberCost, SpecialNonMemberCost, MealCost_Estimated, WebinarMemberCost, WebinarNonMemberCost, VideoConferenceCost, SpecialPriceRequirements, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, WebinarConnectInfo, Presenters, PGPPoints, MealProvidedBy, LocationID, LocationRoomID, EventCancelled, WebinarAvailable, PostedTo_Facebook, PostedTo_Twitter, lastUpdated, lastUpdateBy)
						Values(
						<cfqueryparam value="#CheckEventMultipleDates.Site_ID#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#Variables.NewEventTitle#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventDate4#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.LongDescription#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.Event_StartTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.Event_EndTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.Registration_Deadline#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Registration_BeginTime#" cfsqltype="CF_SQL_TIME">,
						<cfqueryparam value="#CheckEventMultipleDates.EventFeatured#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_RegistrationAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.ViewSpecialPricing#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PGPAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.MealProvided#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.AllowVideoConference#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.AcceptRegistrations#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.Facilitator#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.dateCreated#" cfsqltype="CF_SQL_TIMESTAMP">,
						<cfqueryparam value="#CheckEventMultipleDates.MaxParticipants#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.Active#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_StartDate#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_EndDate#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.Featured_SortOrder#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_RegistrationDeadline#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.MemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.NonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_MemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.EarlyBird_NonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialNonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.MealCost_Estimated#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarNonMemberCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.VideoConferenceCost#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.SpecialPriceRequirements#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventAgenda#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventTargetAudience#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventStrategies#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.EventSpecialInstructions#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarConnectInfo#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.Presenters#" cfsqltype="CF_SQL_VARCHAR">,
						<cfqueryparam value="#CheckEventMultipleDates.PGPPoints#" cfsqltype="CF_SQL_DECIMAL">,
						<cfqueryparam value="#CheckEventMultipleDates.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.LocationID#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.LocationRoomID#" cfsqltype="CF_SQL_INTEGER">,
						<cfqueryparam value="#CheckEventMultipleDates.EventCancelled#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.WebinarAvailable#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PostedTo_Facebook#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.PostedTo_Twitter#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#CheckEventMultipleDates.lastUpdated#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#CheckEventMultipleDates.lastUpdateBy#" cfsqltype="CF_SQL_CHAR">)
					</cfquery>
				</cfif>
				<cfcatch type="Any">
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Event was not added to the database due to an error: " & cfcatch.detail};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default&UserAction=EventAdded&Successful=False" addtoken="false">
				</cfcatch>
			</cftry>
			<cfif FORM.PostEventToFB EQ 1>
				<cfquery name="getFacebookCredientials" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope
					From p_EventRegistration_SiteConfig
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfquery name="getFacilityLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode
					From p_EventRegistration_Facility
					Where TContent_ID = <cfqueryparam value="#FORM.LocationID#" cfsqltype="CF_SQL_INTEGER">
				</cfquery>

				<cfquery name="getCurrentRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select Count(RegistrationID) as NumRegistrations
					From p_EventRegistration_UserRegistrations
					Where EventID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset temp = #StructDelete(Session, "UserSuppliedInfo", "True")#>
					<cfif LEN(getFacebookCredientials.Facebook_AppID) and LEN(getFacebookCredientials.Facebook_AppSecretKey) and LEN(getFacebookCredientials.Facebook_PageID) and LEN(getFacebookCredientials.Facebook_AppScope)>
						<cfset Session.PostEventToFB = StructNew()>
						<cfset Session.PostEventToFB.RedirectURI = "http://#cgi.server_name#/#CGI.Script_name##CGI.path_info#?EventRegistrationaction=eventcoord:events.publishtofb&compactDisplay=false&EventID=#insertNewEvent.GENERATED_KEY#&PerformAction=AutomaticPost">
						<cfset Session.PostEventToFB.FacebookAppID = #getFacebookCredientials.Facebook_AppID#>
						<cfset Session.PostEventToFB.FacebookAppSecretKey = #getFacebookCredientials.Facebook_AppSecretKey#>
						<cfset Session.PostEventToFB.FacebookPageID = #getFacebookCredientials.Facebook_PageID#>
						<cfset Session.PostEventToFB.FacebookAppScope = #getFacebookCredientials.Facebook_AppScope#>
						<cfset Session.PostEventToFB.EventDate = #FORM.EventDate#>
						<cfset Session.PostEventToFB.EventTitle = #FORM.ShortTitle#>
						<cfset Session.PostEventToFB.LongDescription = #FORM.LongDescription#>
						<cfset Session.PostEventToFB.FacilityName = #getFacilityLocation.FacilityName#>
						<cfset Session.PostEventToFB.FacilityAddress = #getFacilityLocation.PhysicalAddress#>
						<cfset Session.PostEventToFB.FacilityCity = #getFacilityLocation.PhysicalCity#>
						<cfset Session.PostEventToFB.FacilityState = #getFacilityLocation.PhysicalState#>
						<cfset Session.PostEventToFB.FacilityZipCode = #getFacilityLocation.PhysicalZipCode#>
						<cfset Session.PostEventToFB.NumberRegistrations = #getCurrentRegistrations.NumRegistrations#>
						<cflocation url="http://#cgi.server_name#/#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.publishtofb&SiteID=#rc.$.siteConfig('siteID')#&EventID=#insertNewEvent.GENERATED_KEY#&AutomaticPost=True" addtoken="false">
					<cfelse>
						<cflocation url="http://#cgi.server_name#/#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=AddedEvent&Successful=true&FacebookPost=MissingInformation" addtoken="false">
					</cfif>
				</cflock>
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "UserSuppliedInfo", "True")#>
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=AddedEvent&Successful=true" addtoken="false">
			</cfif>

		</cfif>

	</cffunction>

	<cffunction name="publishtofb" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("URL.AutomaticPost")>
			<cfquery name="Session.GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime
				From p_EventRegistration_Events
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfelseif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("URL.AutomaticPost")>

		<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("URL.AutomaticPost")>
			<cfquery name="getFacebookCredientials" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, LocationID
				From p_EventRegistration_Events
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getFacilityLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode
				From p_EventRegistration_Facility
				Where TContent_ID = <cfqueryparam value="#GetSelectedEvent.LocationID#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfquery name="getCurrentRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(RegistrationID) as NumRegistrations
				From p_EventRegistration_UserRegistrations
				Where EventID = <cfqueryparam value="#GetSelectedEvent.TContent_ID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfif LEN(getFacebookCredientials.Facebook_AppID) and LEN(getFacebookCredientials.Facebook_AppSecretKey) and LEN(getFacebookCredientials.Facebook_PageID) and LEN(getFacebookCredientials.Facebook_AppScope)>
				<cfset Session.PostEventToFB = StructNew()>
				<cfset Session.PostEventToFB.RedirectURI = "http://#cgi.server_name#/#CGI.Script_name##CGI.path_info#?EventRegistrationaction=eventcoord:events.publishtofb&compactDisplay=false&EventID=#insertNewEvent.GENERATED_KEY#&PerformAction=AutomaticPost">
				<cfset Session.PostEventToFB.FacebookAppID = #getFacebookCredientials.Facebook_AppID#>
				<cfset Session.PostEventToFB.FacebookAppSecretKey = #getFacebookCredientials.Facebook_AppSecretKey#>
				<cfset Session.PostEventToFB.FacebookPageID = #getFacebookCredientials.Facebook_PageID#>
				<cfset Session.PostEventToFB.FacebookAppScope = #getFacebookCredientials.Facebook_AppScope#>
				<cfset Session.PostEventToFB.EventDate = #GetSelectedEvent.EventDate#>
				<cfset Session.PostEventToFB.EventTitle = #GetSelectedEvent.ShortTitle#>
				<cfset Session.PostEventToFB.LongDescription = #GetSelectedEvent.LongDescription#>
				<cfset Session.PostEventToFB.FacilityName = #getFacilityLocation.FacilityName#>
				<cfset Session.PostEventToFB.FacilityAddress = #getFacilityLocation.PhysicalAddress#>
				<cfset Session.PostEventToFB.FacilityCity = #getFacilityLocation.PhysicalCity#>
				<cfset Session.PostEventToFB.FacilityState = #getFacilityLocation.PhysicalState#>
				<cfset Session.PostEventToFB.FacilityZipCode = #getFacilityLocation.PhysicalZipCode#>
				<cfset Session.PostEventToFB.NumberRegistrations = #getCurrentRegistrations.NumRegistrations#>
				<cflocation url="http://#cgi.server_name#/#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.publishtofb&SiteID=#rc.$.siteConfig('siteID')#&EventID=#GetSelectedEvent.TContent_ID#&AutomaticPost=True" addtoken="false">
			<cfelse>
				<cflocation url="http://#cgi.server_name#/#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=PostToFacebook&Successful=False&FacebookPost=MissingInformation" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="cancelevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy,
					Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, PostedTo_Facebook, PostedTo_Twitter
				From p_EventRegistration_Events
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="CF_SQL_INTEGER"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" addtoken="false">
			</cfif>

			<cfif FORM.CancelEvent EQ "----">
				<cfscript>
					eventdate = {property="EventDate",message="Please select an option as to whether you want to cancel this event or not."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.cancelevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			<cfelseif FORM.CancelEvent EQ 0>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EventCancelled&Successful=False" addtoken="false">
			<cfelseif FORM.CancelEvent EQ 1>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfquery name="checkNumberRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select RegistrationID, User_ID
					From eRegistrations
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eEvents
					Set Active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
						EventCancelled = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif checkNumberRegistrations.RecordCount GT 0>
					<cfloop query="checkNumberRegistrations">
						<cfset Variables.Info = StructNew()>
						<cfset Variables.Info.RegistrationID = #checkNumberRegistrations.RegistrationID#>
						<cfset Variables.Info.UserID = #checkNumberRegistrations.User_ID#>
						<cfset Temp = SendEmailCFC.SendEventCancellationToSingleParticipant(rc, Variables.Info)>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>