<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset PriorDate = #DateAdd("m", -8, Now())#>
		<cfquery name="Session.getAvailableEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, PGPAvailable, MemberCost, NonMemberCost
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

			<cflock timeout="60" scope="Session" type="Exclusive"><cfset Session.FormErrors = #ArrayNew()#></cflock>

			<cfif FORM.EventFeatured EQ "----"><cfset FORM.EventFeatured = 0></cfif>
			<cfif FORM.EventSpanDates EQ "----"><cfset FORM.EventSpanDates = 0></cfif>
			<cfif FORM.EarlyBird_RegistrationAvailable EQ "----"><cfset FORM.EarlyBird_RegistrationAvailable = 0></cfif>
			<cfif FORM.ViewSpecialPricing EQ "----"><cfset FORM.ViewSpecialPricing = 0></cfif>
			<cfif FORM.PGPAvailable EQ "----"><cfset FORM.PGPAvailable = 0></cfif>
			<cfif FORM.MealProvided EQ "----"><cfset FORM.MealProvided = 0></cfif>
			<cfif FORM.AllowVideoConference EQ "----"><cfset FORM.AllowVideoConference = 0></cfif>
			<cfif FORM.WebinarEvent EQ "----"><cfset FORM.WebinarEvent = 0></cfif>
			<cfif FORM.PostEventToFB EQ "----"><cfset FORM.PostEventToFB = 0></cfif>

			<cflock timeout="60" scope="Session" type="Exclusive"><cfset Session.UserSuppliedInfo = #StructCopy(FORM)#></cflock>

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
			<cfif FORM.LocationID EQ "----">
				<cfscript>
					errormsg = {property="MealProvidedBy",message="Please Select a Facility to hold this event. If a facility does not display in the Location dropdown, you first must add a facility to the system."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&FormRetry=True" addtoken="false">
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
			<cfset Session.UserSuppliedInfo.AddNewEventStep = #FORM.AddNewEventStep#>
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
					Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active, lastUpdated, lastUpdateBy, EventCancelled)
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
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="0" cfsqltype="cf_sql_integer">
					)
				</cfquery>

				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="updateEventLocationInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set LocationID = <cfqueryparam value="#FORM.LocationID#" cfsqltype="cf_sql_integer">,
								LocationRoomID = <cfqueryparam value="#FORM.LocationRoomID#" cfsqltype="cf_sql_integer">,
								MemberCost = <cfqueryparam value="#Right(FORM.MemberCost, LEN(FORM.MemberCost) - 1)#" cfsqltype="cf_sql_money">,
								NonMemberCost = <cfqueryparam value="#Right(FORM.NonMemberCost, LEN(FORM.NonMemberCost) - 1)#" cfsqltype="cf_sql_money">,
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
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="updateEventLocationInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_Events
							Set LocationID = <cfqueryparam value="#FORM.LocationID#" cfsqltype="cf_sql_integer">,
								LocationRoomID = <cfqueryparam value="#FORM.LocationRoomID#" cfsqltype="cf_sql_integer">,
								MemberCost = <cfqueryparam value="#Right(FORM.MemberCost, LEN(FORM.MemberCost) - 1)#" cfsqltype="cf_sql_money">,
								NonMemberCost = <cfqueryparam value="#Right(FORM.NonMemberCost, LEN(FORM.NonMemberCost) - 1)#" cfsqltype="cf_sql_money">,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
						</cfquery>

						<cfif isDefined("FORM.EventDate1")>
							<cfif #isDate(FORM.EventDate1)# EQ 1>
								<cfquery name="updateEventDate1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events
									Set EventDate1 = #CreateDate(ListLast(FORM.EventDate1, "/"), ListFirst(FORM.EventDate1, "/"), ListGetAt(FORM.EventDate1, 2, "/"))#,
										lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
									Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
									Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
									Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
									Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
									Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
									Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
									Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif FORM.PGPAvailable EQ 1>
							<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_Events
								Set PGPAvailable = <cfqueryparam value="#FORM.PGPAvailable#" cfsqltype="cf_sql_bit">,
									PGPPoints = <cfqueryparam value="#FORM.PGPPoints#" cfsqltype="cf_sql_DECIMAL">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif FORM.MealProvided EQ 1>
							<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_Events
								Set MealCost_Estimated = <cfqueryparam value="#FORM.MealCost_Estimated#" cfsqltype="CF_SQL_MONEY">,
									MealProvidedBy = <cfqueryparam value="#FORM.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfcase>
				</cfswitch>
				<cfcatch type="Any">
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Event was not added to the database due to an error: " & cfcatch.detail};
						arrayAppend(Session.FormErrors, eventdate);
						arrayAppend(Session.FormErrors, cfcatch);
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
					From p_EventRegistration_UserRegistrations
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
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
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EventCancelled&Successful=True" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="copyevent" returntype="any" output="false">
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

			<cfif FORM.CopyEvent EQ "----">
				<cfscript>
					eventdate = {property="EventDate",message="Please select an option as to whether you want to copy this event to a new event or not."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.copyevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			<cfelseif FORM.CopyEvent EQ 0>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EventCopied&Successful=False" addtoken="false">
			<cfelseif FORM.CopyEvent EQ 1>
				<cftry>
					<cfquery name="insertNewEvent" result="insertNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active, lastUpdated, lastUpdateBy, EventCancelled, WebinarAvailable, PostedTo_Facebook, PostedTo_Twitter)
						Values (
							<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.getSelectedEvent.ShortTitle#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.getSelectedEvent.EventDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#Session.getSelectedEvent.LongDescription#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.getSelectedEvent.Event_StartTime#" cfsqltype="cf_sql_time">,
							<cfqueryparam value="#Session.getSelectedEvent.Event_EndTime#" cfsqltype="cf_sql_time">,
							<cfqueryparam value="#Session.getSelectedEvent.Registration_Deadline#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#Session.getSelectedEvent.Registration_BeginTime#" cfsqltype="cf_sql_time">,
							<cfqueryparam value="#Session.getSelectedEvent.Registration_EndTime#" cfsqltype="cf_sql_time">,
							<cfqueryparam value="#Session.getSelectedEvent.EventFeatured#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.ViewSpecialPricing#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.PGPAvailable#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.MealProvided#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.AllowVideoConference#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#Session.getSelectedEvent.MaxParticipants#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Session.getSelectedEvent.Active#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.getSelectedEvent.EventCancelled#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.WebinarAvailable#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.PostedTo_Facebook#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.PostedTo_Twitter#" cfsqltype="cf_sql_bit">
						)
					</cfquery>

					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfif LEN(Session.getSelectedEvent.EventDate1)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventDate1 = <cfqueryparam value="#Session.getSelectedEvent.EventDate1#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate2)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventDate2 = <cfqueryparam value="#Session.getSelectedEvent.EventDate2#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate3)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventDate3 = <cfqueryparam value="#Session.getSelectedEvent.EventDate3#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate4)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventDate4 = <cfqueryparam value="#Session.getSelectedEvent.EventDate4#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.Featured_StartDate)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set Featured_StartDate = <cfqueryparam value="#Session.getSelectedEvent.Featured_StartDate#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.Featured_EndDate)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set Featured_EndDate = <cfqueryparam value="#Session.getSelectedEvent.Featured_EndDate#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.Featured_SortOrder)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set Featured_SortOrder = <cfqueryparam value="#Session.getSelectedEvent.Featured_SortOrder#" cfsqltype="cf_sql_integer"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.MemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set MemberCost = <cfqueryparam value="#Session.getSelectedEvent.MemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.NonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.NonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EarlyBird_RegistrationDeadline)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EarlyBird_RegistrationDeadline = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_RegistrationDeadline#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EarlyBird_MemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EarlyBird_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_MemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EarlyBird_NonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EarlyBird_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.SpecialMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set SpecialMemberCost = <cfqueryparam value="#Session.getSelectedEvent.SpecialMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.SpecialNonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set SpecialNonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.SpecialNonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.SpecialPriceRequirements)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set SpecialPriceRequirements = <cfqueryparam value="#Session.getSelectedEvent.SpecialPriceRequirements#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.PGPPoints)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set PGPPoints = <cfqueryparam value="#Session.getSelectedEvent.PGPPoints#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.MealProvidedBy)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set MealProvidedBy = <cfqueryparam value="#Session.getSelectedEvent.MealProvidedBy#" cfsqltype="cf_sql_integer"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.MealCost_Estimated)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set MealCost_Estimated = <cfqueryparam value="#Session.getSelectedEvent.MealCost_Estimated#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.VideoConferenceInfo)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set VideoConferenceInfo = <cfqueryparam value="#Session.getSelectedEvent.VideoConferenceInfo#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.VideoConferenceCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set VideoConferenceCost = <cfqueryparam value="#Session.getSelectedEvent.VideoConferenceCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventAgenda)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventAgenda = <cfqueryparam value="#Session.getSelectedEvent.EventAgenda#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventStrategies)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventStrategies = <cfqueryparam value="#Session.getSelectedEvent.EventStrategies#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventTargetAudience)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventTargetAudience = <cfqueryparam value="#Session.getSelectedEvent.EventTargetAudience#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.LocationID)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set LocationID = <cfqueryparam value="#Session.getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.LocationRoomID)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set LocationRoomID = <cfqueryparam value="#Session.getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.Presenters)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set Presenters = <cfqueryparam value="#Session.getSelectedEvent.Presenters#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.WebinarConnectInfo)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set WebinarConnectInfo = <cfqueryparam value="#Session.getSelectedEvent.WebinarConnectInfo#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.WebinarMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set WebinarMemberCost = <cfqueryparam value="#Session.getSelectedEvent.WebinarMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.WebinarNonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set WebinarNonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.WebinarNonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
						</cfcase>
						<cfcase value="mssql">
							<cfif LEN(Session.getSelectedEvent.EventDate1)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventDate1 = <cfqueryparam value="#Session.getSelectedEvent.EventDate1#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate2)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventDate2 = <cfqueryparam value="#Session.getSelectedEvent.EventDate2#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate3)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventDate3 = <cfqueryparam value="#Session.getSelectedEvent.EventDate3#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate4)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventDate4 = <cfqueryparam value="#Session.getSelectedEvent.EventDate4#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.Featured_StartDate)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set Featured_StartDate = <cfqueryparam value="#Session.getSelectedEvent.Featured_StartDate#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.Featured_EndDate)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set Featured_EndDate = <cfqueryparam value="#Session.getSelectedEvent.Featured_EndDate#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.Featured_SortOrder)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set Featured_SortOrder = <cfqueryparam value="#Session.getSelectedEvent.Featured_SortOrder#" cfsqltype="cf_sql_integer"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.MemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set MemberCost = <cfqueryparam value="#Session.getSelectedEvent.MemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.NonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.NonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EarlyBird_RegistrationDeadline)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EarlyBird_RegistrationDeadline = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_RegistrationDeadline#" cfsqltype="cf_sql_date"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EarlyBird_MemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EarlyBird_MemberCost = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_MemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EarlyBird_NonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EarlyBird_NonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.SpecialMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set SpecialMemberCost = <cfqueryparam value="#Session.getSelectedEvent.SpecialMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.SpecialNonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set SpecialNonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.SpecialNonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.SpecialPriceRequirements)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set SpecialPriceRequirements = <cfqueryparam value="#Session.getSelectedEvent.SpecialPriceRequirements#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.PGPPoints)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set PGPPoints = <cfqueryparam value="#Session.getSelectedEvent.PGPPoints#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.MealProvidedBy)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set MealProvidedBy = <cfqueryparam value="#Session.getSelectedEvent.MealProvidedBy#" cfsqltype="cf_sql_integer"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.MealCost_Estimated)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set MealCost_Estimated = <cfqueryparam value="#Session.getSelectedEvent.MealCost_Estimated#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.VideoConferenceInfo)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set VideoConferenceInfo = <cfqueryparam value="#Session.getSelectedEvent.VideoConferenceInfo#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.VideoConferenceCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set VideoConferenceCost = <cfqueryparam value="#Session.getSelectedEvent.VideoConferenceCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventAgenda)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventAgenda = <cfqueryparam value="#Session.getSelectedEvent.EventAgenda#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventStrategies)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventStrategies = <cfqueryparam value="#Session.getSelectedEvent.EventStrategies#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.EventTargetAudience)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set EventTargetAudience = <cfqueryparam value="#Session.getSelectedEvent.EventTargetAudience#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.LocationID)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set LocationID = <cfqueryparam value="#Session.getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.LocationRoomID)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set LocationRoomID = <cfqueryparam value="#Session.getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.Presenters)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set Presenters = <cfqueryparam value="#Session.getSelectedEvent.Presenters#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.WebinarConnectInfo)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set WebinarConnectInfo = <cfqueryparam value="#Session.getSelectedEvent.WebinarConnectInfo#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.WebinarMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set WebinarMemberCost = <cfqueryparam value="#Session.getSelectedEvent.WebinarMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.WebinarNonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set WebinarNonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.WebinarNonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
						</cfcase>
					</cfswitch>

					<cfcatch type="Any">
						<cfscript>
							eventdate = {property="Registration_Deadline",message="Event was not added to the database due to an error: " & cfcatch.detail};
							arrayAppend(Session.FormErrors, eventdate);
							arrayAppend(Session.FormErrors, cfcatch);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default&UserAction=EventCopied&Successful=False" addtoken="false">
					</cfcatch>
				</cftry>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EventCopied&Successful=True" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="registeruserforevent" returntype="any" output="false">
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
			<cfquery name="Session.GetMembershipOrganizations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
				From p_EventRegistration_Membership
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by OrganizationName
			</cfquery>
			<cfif isDefined("URL.EventStatus")>
				<cfswitch expression="#URl.EventStatus#">
					<cfcase value="ShowCorporations">
						<cfquery name="Session.GetSelectedAccountsWithinOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select UserID, Fname, Lname, Email
							From tusers
							WHERE 1 = 1 AND
								SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								Email LIKE '%#Session.UserRegister.DistrictDomain#%'
							Order by Lname, Fname
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" addtoken="false">
			</cfif>
			<cfswitch expression="#URL.EventStatus#">
				<cfcase value="ShowCorporations">
					<cfquery name="GetMembershipOrganizations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
						From p_EventRegistration_Membership
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#FORM.DistrictName#" cfsqltype="cf_sql_integer">
						Order by OrganizationName
					</cfquery>
					<cfset Session.UserRegister = #StructNew()#>
					<cfset Session.UserRegister.DistrictDomain = #GetMembershipOrganizations.OrganizationDomainName#>
					<cfset Session.UserRegister.DistrictMembership = #GetMembershipOrganizations.Active#>
					<cfset Session.UserRegister.FirstStep = #StructCopy(FORM)#>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<cfif FORM.WebinarParticipant EQ "----">
							<cfscript>
								eventdate = {property="EventDate",message="Please select whether the participants you will be registering will participate in this event through the Webinar Option."};
								arrayAppend(Session.FormErrors, eventdate);
							</cfscript>
							<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
						</cfif>
						<cfif FORM.FacilityParticipant EQ "----">
							<cfscript>
								eventdate = {property="EventDate",message="Please select whether the participants you will be registering will participat live at the designated facility for this event."};
								arrayAppend(Session.FormErrors, eventdate);
							</cfscript>
							<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
						</cfif>
					</cfif>
					<cfif FORM.EmailConfirmations EQ "----">
						<cfscript>
							eventdate = {property="EventDate",message="Please select whether the participants will receive an Email Confirmation regarding this Registration or not."};
							arrayAppend(Session.FormErrors, eventdate);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
					</cfif>
					<cfif FORM.DistrictName EQ "----">
						<cfscript>
							eventdate = {property="EventDate",message="Please select which School District the participants are from or whether the participant is from a business organization."};
							arrayAppend(Session.FormErrors, eventdate);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
					</cfif>
					<cfquery name="Session.GetSelectedAccountsWithinOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID, Fname, Lname, Email
						From tusers
						WHERE 1 = 1 AND
							SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							Email LIKE '%#GetMembershipOrganizations.OrganizationDomainName#%'
						Order by Lname, Fname
					</cfquery>

					<cfif Session.GetSelectedAccountsWithinOrganization.RecordCount EQ 0><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventStatus=AddNewParticipants&EventID=#URL.EventID#" addtoken="false"></cfif>
				</cfcase>
				<cfcase value="RegisterParticipants">
					<cfif StructCount(Session.UserRegister.FirstStep) EQ 0>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations" addtoken="false">
					</cfif>
					<cfset Session.UserRegister.SecondStep = #StructCopy(FORM)#>
					<cfif not isDefined("FORM.ParticipantEmployee")>
						<cfscript>
							eventdate = {property="EventDate",message="Please select atleast 1 participant that you would like to register from the list provided. Or if the individual is not listed in the list, please add them in the space provided and click the Add Button."};
							arrayAppend(Session.FormErrors, eventdate);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations" addtoken="false">
					</cfif>
					<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
					<cfloop list="#Session.UserRegister.SecondStep.ParticipantEmployee#" delimiters="," index="i">
						<cfset ParticipantUserID = ListFirst(i, "_")>
						<cfset DayNumber = ListLast(i, "_")>
						<cfswitch expression="#Variables.DayNumber#">
							<cfcase value="1">
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From p_EventRegistration_UserRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfset RegistrationUUID = #CreateUUID()#>
									<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate1)
										Values(
											<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="1" cfsqltype="cf_sql_bit">
										)
									</cfquery>
								<cfelse>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfcase>
							<cfcase value="2">
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From p_EventRegistration_UserRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfset RegistrationUUID = #CreateUUID()#>
									<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate2)
										Values(
											<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="1" cfsqltype="cf_sql_bit">
										)
									</cfquery>
								<cfelse>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfcase>
							<cfcase value="3">
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From p_EventRegistration_UserRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfset RegistrationUUID = #CreateUUID()#>
									<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate3)
										Values(
											<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="1" cfsqltype="cf_sql_bit">
										)
									</cfquery>
								<cfelse>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfcase>
							<cfcase value="4">
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From p_EventRegistration_UserRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfset RegistrationUUID = #CreateUUID()#>
									<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate4)
										Values(
											<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="1" cfsqltype="cf_sql_bit">
										)
									</cfquery>
								<cfelse>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfcase>
							<cfcase value="5">
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From p_EventRegistration_UserRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfset RegistrationUUID = #CreateUUID()#>
									<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate5)
										Values(
											<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="1" cfsqltype="cf_sql_bit">
										)
									</cfquery>
								<cfelse>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfcase>
							<cfcase value="6">
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From p_EventRegistration_UserRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfset RegistrationUUID = #CreateUUID()#>
									<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate6)
										Values(
											<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
											<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
											<cfqueryparam value="1" cfsqltype="cf_sql_bit">
										)
									</cfquery>
								<cfelse>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfcase>
						</cfswitch>

						<cfif CheckRegisteredAlready.RecordCount EQ 0>
							<cfswitch expression="#application.configbean.getDBType()#">
								<cfcase value="mysql">
									<cfif Session.getSelectedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set RequestsMeal = <cfqueryparam value="#Session.UserRegister.SecondStep.RegisterParticipantStayForMeal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set WebinarParticipant = <cfqueryparam value="#Session.UserRegister.SecondStep.RegisterParticipantWebinarOption#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfif  Session.UserRegister.DistrictMembership EQ 1>
										<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.getSelectedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.getSelectedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set AttendeePrice = <cfqueryparam value="#Variables.AttendeePrice#" cfsqltype="cf_sql_money">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
									<cfelse>
										<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.getSelectedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.getSelectedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set AttendeePrice = <cfqueryparam value="#Variables.AttendeePrice#" cfsqltype="cf_sql_money">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From p_EventRegistration_UserRegistrations
										Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
											and OnWaitingList = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.getSelectedEvent.MaxParticipants>
										<cfif Session.UserRegister.FirstStep.EmailConfirmations EQ 1>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set OnWaitingList = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfif Session.UserRegister.FirstStep.EmailConfirmations EQ 1>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY)#>
										</cfif>
									</cfif>
								</cfcase>
								<cfcase value="mssql">
									<cfif Session.getSelectedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set RequestsMeal = <cfqueryparam value="#Session.UserRegister.SecondStep.RegisterParticipantStayForMeal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.IdentityCol#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set WebinarParticipant = <cfqueryparam value="#Session.UserRegister.SecondStep.RegisterParticipantWebinarOption#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.IdentityCol#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfif  Session.UserRegister.DistrictMembership EQ 1>
										<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.getSelectedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.getSelectedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set AttendeePrice = <cfqueryparam value="#Variables.AttendeePrice#" cfsqltype="cf_sql_money">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.IdentityCol#" cfsqltype="cf_sql_integer">
										</cfquery>
									<cfelse>
										<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.getSelectedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.getSelectedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set AttendeePrice = <cfqueryparam value="#Variables.AttendeePrice#" cfsqltype="cf_sql_money">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.IdentityCol#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From p_EventRegistration_UserRegistrations
										Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
											and OnWaitingList = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfdump var="#Session.UserRegister#">
									<cfabort>
									<cfif GetEventRegistered.RecordCount LTE Session.getSelectedEvent.MaxParticipants>
										<cfif Session.UserRegister.FirstStep.EmailConfirmations EQ 1>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.IdentityCol)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set OnWaitingList = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.IdentityCol#" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfif Session.UserRegister.FirstStep.EmailConfirmations EQ 1>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.IdentityCol)#>
										</cfif>
									</cfif>
								</cfcase>
							</cfswitch>
						</cfif>
					</cfloop>
					<cfset temp = StructDelete(Session, "UserRegister")>
					<cfset temp = StructDelete(Session, "FormErrors")>
					<cfset temp = StructDelete(Session, "GetSelectedAccountsWithinOrganization")>
					<cfset temp = StructDelete(Session, "GetSelectedEvent")>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=ParticipantsRegistered&Successful=True" addtoken="false">
				</cfcase>
			</cfswitch>
		</cfif>
	</cffunction>

	<cffunction name="geteventinfo" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID")>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(TContent_ID) as CurrentNumberofRegistrations
				From p_EventRegistration_UserRegistrations
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, GeoCode_Latitude, GeoCode_Longitude, GeoCode_StateLongName
				From p_EventRegistration_Facility
				Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select RoomName, Capacity
				From p_EventRegistration_FacilityRooms
				Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> and
					Facility_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FName, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getSelectedEvent.Facilitator#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfset Session.EventInfo.SelectedEvent = #StructCopy(getSelectedEvent)#>
			<cfset Session.EventInfo.EventRegistrations = #StructCopy(getCurrentRegistrationsbyEvent)#>
			<cfset Session.EventInfo.EventFacility = #StructCopy(getEventFacility)#>
			<cfset Session.EventInfo.EventFacilityRoom = #StructCopy(getEventFacilityRoom)#>
			<cfset Session.EventInfo.EventFacilitator = #StructCopy(getFacilitator)#>
		<cfelse>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="emailregistered" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(RegistrationID) as NumRegistrations
				From p_EventRegistration_UserRegistrations
				Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfif GetSelectedEventRegistrations.RecordCount>
				<cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.NumRegistrations#>
			<cfelse>
				<cfset Session.EventNumberRegistrations = 0>
			</cfif>
			<cfset ParentDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/">
			<cfset EventDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #URL.EventID# & "/">
			<cfset WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
			<cfif not DirectoryExists(variables.ParentDirectory)><cfdirectory action="Create" directory="#Variables.ParentDirectory#"></cfif>
			<cfif not DirectoryExists(variables.EventDirectory)><cfdirectory action="Create" directory="#Variables.EventDirectory#"></cfif>
			<cfdirectory action="list" directory="#Variables.EventDirectory#" name="EventDocuments" type="file">
			<cfset Session.EventDocuments = #StructCopy(EventDocuments)#>
			<cfset Session.WebEventDirectory = #Variables.WebEventDirectory#>

			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="DeleteEventDocument">
						<cfloop query="EventDocuments">
							<cfif EventDocuments.name EQ URL.DocumentName>
								<cffile action="delete" file="#Variables.EventDirectory##URL.DocumentName#">
								<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailregistered&EventID=#URL.EventID#" addtoken="false">
							</cfif>
						</cfloop>
					</cfcase>
				</cfswitch>
			</cfif>
		<cfelseif isDefined("URL.EventID") and isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
			<cfif FORM.SendEmail EQ "----">
				<cfscript>
					eventdate = {property="EventDate",message="Please select the option to send email to participants so they can be informed with information regarding this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailregistered&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			<cfelseif FORM.SendEmail EQ 0>
				<cfscript>
					eventdate = {property="EventDate",message="Email message to registered participations of the #Session.getSelectedEvent.ShortTitle# was not sent due to selecting the option to send email to particpants was 'No'."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailParticipants&Successful=NotSent" addtoken="false">
			<cfelse>
				<cfif LEN(EmailMsg) EQ 0>
					<cfscript>
						eventdate = {property="EventDate",message="Please enter the message body which you want to send to users who have already registered for this event."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailregistered&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
				</cfif>
				<cfif isDefined("FORM.IncludePreviousDocumentsInEmail")>
					<cfif FORM.IncludePreviousDocumentsInEmail EQ "----">
						<cfscript>
							eventdate = {property="EventDate",message="Please select the option as to attach the previous uploaded documents to this email when it is sent to registered participants."};
							arrayAppend(Session.FormErrors, eventdate);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailregistered&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
					</cfif>
				<cfelseif not isDefined("FORM.IncludePreviousDocumentsInEmail")>
					<cfset FORM.IncludePreviousDocumentsInEmail = 0>
				</cfif>
				<cfquery name="GetRegisteredUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.Site_ID, p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, p_EventRegistration_UserRegistrations.AttendeePrice,
						p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.Comments, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email
					FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
					WHERE p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
						Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
						EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
						EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
						ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
						MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
						AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
						LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
						WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
					From p_EventRegistration_Events
					Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

				<cfif LEN(FORM.FirstDocument) EQ 0 and LEN(FORM.SecondDocument) EQ 0 and LEN(FORM.ThirdDocument) EQ 0 and LEN(FORM.FourthDocument) EQ 0 and LEN(FORM.FifthDocument) EQ 0>
					<cfloop query="GetRegisteredUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetRegisteredUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetRegisteredUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetRegisteredUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
						<cfif FORM.IncludePreviousDocumentsInEmail EQ 1><cfset ParticipantInfo.DocLinksInEmail = 1><cfelse><cfset ParticipantInfo.DocLinksInEmail = 0></cfif>

						<cfif LEN(FORM.FirstWebLink) or LEN(FORM.SecondWebLink) or LEN(FORM.ThirdWebLink)>
							<cfset ParticipantInfo.WebLinksInEmail = 1>
							<cfset ParticipantInfo.WebLink1 = #FORM.FirstWebLink#>
							<cfset ParticipantInfo.WebLink2 = #FORM.SecondWebLink#>
							<cfset ParticipantInfo.WebLink3 = #FORM.ThirdWebLink#>
						<cfelse>
							<cfset ParticipantInfo.WebLinksInEmail = 0>
						</cfif>
						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo)#>
					</cfloop>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailParticipants&Successful=True" addtoken="false">
				<cfelseif LEN(FORM.FirstDocument) or LEN(FORM.SecondDocument) or LEN(FORM.ThirdDocument) or LEN(FORM.FourthDocument) or LEN(FORM.FifthDocument)>
					<cfset ParentDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/">
					<cfset EventDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #FORM.EventID# & "/">
					<cfset WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #FORM.EventID# & "/">
					<cfif not DirectoryExists(variables.ParentDirectory)><cfdirectory action="Create" directory="#Variables.ParentDirectory#"></cfif>
					<cfif not DirectoryExists(variables.EventDirectory)><cfdirectory action="Create" directory="#Variables.EventDirectory#"></cfif>
					<cfif LEN(FORM.FirstDocument)>
						<cffile action="upload" fileField="FORM.FirstDocument" result="EventDocumentOne" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileOne = #Replace(Variables.EventDocumentOne.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentOne.ServerFile#" Destination="#Variables.NewServerFileOne#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileOne#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileOne#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfif LEN(FORM.SecondDocument)>
						<cffile action="upload" fileField="FORM.SecondDocument" result="EventDocumentTwo" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileTwo = #Replace(Variables.EventDocumentTwo.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentTwo.ServerFile#" Destination="#Variables.NewServerFileTwo#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileTwo#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileTwo#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfif LEN(FORM.ThirdDocument)>
						<cffile action="upload" fileField="FORM.ThirdDocument" result="EventDocumentThree" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileThree = #Replace(Variables.EventDocumentThree.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentThree.ServerFile#" Destination="#Variables.NewServerFileThree#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileThree#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileThree#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfif LEN(FORM.FourthDocument)>
						<cffile action="upload" fileField="FORM.FourthDocument" result="EventDocumentFourth" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileFourth = #Replace(Variables.EventDocumentFourth.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentFourth.ServerFile#" Destination="#Variables.NewServerFileFourth#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileFourth#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileFourth#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfif LEN(FORM.FifthDocument)>
						<cffile action="upload" fileField="FORM.FifthDocument" result="EventDocumentFifth" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileFifth = #Replace(Variables.EventDocumentFifth.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentFifth.ServerFile#" Destination="#Variables.NewServerFileFifth#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileFifth#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileFifth#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfloop query="GetRegisteredUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetRegisteredUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetRegisteredUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetRegisteredUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
						<cfset ParticipantInfo.WebEventDirectory = #Variables.WebEventDirectory#>
						<cfif isDefined("Variables.EmailMessageWithFile")>
							<cfdirectory action="list" directory="#Variables.EventDirectory#" name="EventDocuments" type="file">
							<cfset ParticipantInfo.DocLinksInEmail = 1>
							<cfset ParticipantInfo.EventDocuments = #StructCopy(EventDocuments)#>
						</cfif>
						<cfif LEN(FORM.FirstWebLink) or LEN(FORM.SecondWebLink) or LEN(FORM.ThirdWebLink)>
							<cfset ParticipantInfo.WebLinksInEmail = 1>
							<cfset ParticipantInfo.WebLink1 = #FORM.FirstWebLink#>
							<cfset ParticipantInfo.WebLink2 = #FORM.SecondWebLink#>
							<cfset ParticipantInfo.WebLink3 = #FORM.ThirdWebLink#>
						<cfelse>
							<cfset ParticipantInfo.WebLinksInEmail = 0>
						</cfif>

						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo)#>
					</cfloop>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailParticipants&Successful=True" addtoken="false">
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="eventsigninsheet" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
			</cfswitch>
			<cfset EventDateQuery = #QueryNew("EventDate")#>
			<cfif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) EQ 0 and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 4)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate3, 4)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4)>
				<cfset temp = #QueryAddRow(EventDateQuery, 5)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate3, 4)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate4, 5)#>
			</cfif>
			<cfset Session.SignInSheet = #StructNew()#>
			<cfset Session.SignInSheet.EventDates = ValueList(EventDateQuery.EventDate, ",")>
		</cfif>
	</cffunction>

	<cffunction name="deregisteruserforevent" returntype="any" output="false">
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

			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
			</cfswitch>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>

			<cfif not isDefined("FORM.ParticipantEmployee")>
				<cfscript>
					eventdate = {property="EventDate",message="You will need to select at least one participant from the list below to remove them from the registration of this event"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.deregisteruserforevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.SendConfirmation EQ "----">
				<cfscript>
					eventdate = {property="EventDate",message="Please select the option as to whether the participant will receive an email confirmation regarding the removal of this registration."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.deregisteruserforevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			</cfif>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

			<cfloop list="#FORM.ParticipantEmployee#" delimiters="," index="i">
				<cfset ParticipantUserID = ListFirst(i, "_")>
				<cfset DayNumber = ListLast(i, "_")>
				<cfswitch expression="#Variables.DayNumber#">
					<cfcase value="1">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 1 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
									WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 1>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 1 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="2">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 1 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate2 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
									WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 2>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 1 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate2 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="3">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 1 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate3 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
									WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 3>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 1 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate3 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="4">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 1 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate4 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
									WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 4>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 1 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate4 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="5">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 1 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate5 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
									WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 5>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 1 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate5 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="6">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 1>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate6 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
									WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 6>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 1>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate6 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
				</cfswitch>
			</cfloop>

			<cfset temp = StructDelete(Session, "getSelectedEvent")>
			<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
			<cfset temp = StructDelete(Session, "FormErrors")>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=RemovedParticipants&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="signinparticipant" returntype="any" output="false">
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

			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
							p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">) and
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
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
							p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">) and
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
				</cfcase>
			</cfswitch>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>

			<cfloop list="#FORM.ParticipantEmployee#" delimiters="," index="i">
				<cfset ParticipantUserID = ListFirst(i, "_")>
				<cfset DayNumber = ListLast(i, "_")>
				<cfswitch expression="#Variables.DayNumber#">
					<cfcase value="1">
						<cfquery name="SignInParticipant" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_UserRegistrations
							Set AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							Where EventID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
								User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
								Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfcase>
					<cfcase value="2">
						<cfquery name="SignInParticipant" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_UserRegistrations
							Set AttendedEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							Where EventID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
								User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
								Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfcase>
					<cfcase value="3">
						<cfquery name="SignInParticipant" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_UserRegistrations
							Set AttendedEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							Where EventID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
								User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
								Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfcase>
					<cfcase value="4">
						<cfquery name="SignInParticipant" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_UserRegistrations
							Set AttendedEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							Where EventID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
								User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
								Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfcase>
					<cfcase value="5">
						<cfquery name="SignInParticipant" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_UserRegistrations
							Set AttendedEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							Where EventID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
								User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
								Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfcase>
					<cfcase value="6">
						<cfquery name="SignInParticipant" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_UserRegistrations
							Set AttendedEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							Where EventID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
								User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
								Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfcase>

				</cfswitch>
			</cfloop>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.signinparticipant&UserAction=ParticipantsChecked&Successful=True&EventID=#FORM.EventID#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="namebadges" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
			</cfswitch>

			<cfset EventDateQuery = #QueryNew("EventDate")#>
			<cfif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) EQ 0 and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 4)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate3, 4)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4)>
				<cfset temp = #QueryAddRow(EventDateQuery, 5)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate3, 4)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate4, 5)#>
			</cfif>
			<cfset Session.SignInSheet = #StructNew()#>
			<cfset Session.SignInSheet.EventDates = ValueList(EventDateQuery.EventDate, ",")>
		<cfelseif isDefined("URL.EventID") and isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructNew()#>
				<cfset Session.FormInput.StepOne = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="emailattended" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
					p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">) and
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

			<cfif GetSelectedEventRegistrations.RecordCount>
				<cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.RecordCount#>
			<cfelse>
				<cfset Session.EventNumberRegistrations = 0>
			</cfif>
			<cfset ParentDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/">
			<cfset EventDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #URL.EventID# & "/">
			<cfset WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
			<cfif not DirectoryExists(variables.ParentDirectory)><cfdirectory action="Create" directory="#Variables.ParentDirectory#"></cfif>
			<cfif not DirectoryExists(variables.EventDirectory)><cfdirectory action="Create" directory="#Variables.EventDirectory#"></cfif>
			<cfdirectory action="list" directory="#Variables.EventDirectory#" name="EventDocuments" type="file">
			<cfset Session.EventDocuments = #StructCopy(EventDocuments)#>
			<cfset Session.WebEventDirectory = #Variables.WebEventDirectory#>

			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="DeleteEventDocument">
						<cfloop query="EventDocuments">
							<cfif EventDocuments.name EQ URL.DocumentName>
								<cffile action="delete" file="#Variables.EventDirectory##URL.DocumentName#">
								<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailattended&EventID=#URL.EventID#" addtoken="false">
							</cfif>
						</cfloop>
					</cfcase>
				</cfswitch>
			</cfif>
		<cfelseif isDefined("URL.EventID") and isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
			<cfif FORM.SendEmail EQ "----">
				<cfscript>
					eventdate = {property="EventDate",message="Please select the option to send email to participants so they can be informed with information regarding this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailattended&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			<cfelseif FORM.SendEmail EQ 0>
				<cfscript>
					eventdate = {property="EventDate",message="Email message to registered participations of the #Session.getSelectedEvent.ShortTitle# was not sent due to selecting the option to send email to particpants was 'No'."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailParticipants&Successful=NotSent" addtoken="false">
			<cfelse>
				<cfif LEN(EmailMsg) EQ 0>
					<cfscript>
						eventdate = {property="EventDate",message="Please enter the message body which you want to send to users who have already registered for this event."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailattended&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
				</cfif>
				<cfif isDefined("FORM.IncludePreviousDocumentsInEmail")>
					<cfif FORM.IncludePreviousDocumentsInEmail EQ "----">
						<cfscript>
							eventdate = {property="EventDate",message="Please select the option as to attach the previous uploaded documents to this email when it is sent to registered participants."};
							arrayAppend(Session.FormErrors, eventdate);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailattended&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
					</cfif>
				<cfelseif not isDefined("FORM.IncludePreviousDocumentsInEmail")>
					<cfset FORM.IncludePreviousDocumentsInEmail = 0>
				</cfif>
				<cfquery name="GetRegisteredUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.Site_ID, p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, p_EventRegistration_UserRegistrations.AttendeePrice,
						p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.Comments, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email
					FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
					WHERE p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
						Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
						EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
						EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
						ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
						MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
						AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
						LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
						WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
					From p_EventRegistration_Events
					Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

				<cfif LEN(FORM.FirstDocument) EQ 0 and LEN(FORM.SecondDocument) EQ 0 and LEN(FORM.ThirdDocument) EQ 0 and LEN(FORM.FourthDocument) EQ 0 and LEN(FORM.FifthDocument) EQ 0>
					<cfloop query="GetRegisteredUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetRegisteredUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetRegisteredUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetRegisteredUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
						<cfif FORM.IncludePreviousDocumentsInEmail EQ 1><cfset ParticipantInfo.DocLinksInEmail = 1><cfelse><cfset ParticipantInfo.DocLinksInEmail = 0></cfif>

						<cfif LEN(FORM.FirstWebLink) or LEN(FORM.SecondWebLink) or LEN(FORM.ThirdWebLink)>
							<cfset ParticipantInfo.WebLinksInEmail = 1>
							<cfset ParticipantInfo.WebLink1 = #FORM.FirstWebLink#>
							<cfset ParticipantInfo.WebLink2 = #FORM.SecondWebLink#>
							<cfset ParticipantInfo.WebLink3 = #FORM.ThirdWebLink#>
						<cfelse>
							<cfset ParticipantInfo.WebLinksInEmail = 0>
						</cfif>
						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo)#>
					</cfloop>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailAttended&Successful=True" addtoken="false">
				<cfelseif LEN(FORM.FirstDocument) or LEN(FORM.SecondDocument) or LEN(FORM.ThirdDocument) or LEN(FORM.FourthDocument) or LEN(FORM.FifthDocument)>
					<cfset ParentDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/">
					<cfset EventDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #FORM.EventID# & "/">
					<cfset WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #FORM.EventID# & "/">
					<cfif not DirectoryExists(variables.ParentDirectory)><cfdirectory action="Create" directory="#Variables.ParentDirectory#"></cfif>
					<cfif not DirectoryExists(variables.EventDirectory)><cfdirectory action="Create" directory="#Variables.EventDirectory#"></cfif>
					<cfif LEN(FORM.FirstDocument)>
						<cffile action="upload" fileField="FORM.FirstDocument" result="EventDocumentOne" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileOne = #Replace(Variables.EventDocumentOne.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentOne.ServerFile#" Destination="#Variables.NewServerFileOne#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileOne#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileOne#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfif LEN(FORM.SecondDocument)>
						<cffile action="upload" fileField="FORM.SecondDocument" result="EventDocumentTwo" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileTwo = #Replace(Variables.EventDocumentTwo.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentTwo.ServerFile#" Destination="#Variables.NewServerFileTwo#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileTwo#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileTwo#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfif LEN(FORM.ThirdDocument)>
						<cffile action="upload" fileField="FORM.ThirdDocument" result="EventDocumentThree" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileThree = #Replace(Variables.EventDocumentThree.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentThree.ServerFile#" Destination="#Variables.NewServerFileThree#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileThree#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileThree#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfif LEN(FORM.FourthDocument)>
						<cffile action="upload" fileField="FORM.FourthDocument" result="EventDocumentFourth" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileFourth = #Replace(Variables.EventDocumentFourth.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentFourth.ServerFile#" Destination="#Variables.NewServerFileFourth#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileFourth#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileFourth#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfif LEN(FORM.FifthDocument)>
						<cffile action="upload" fileField="FORM.FifthDocument" result="EventDocumentFifth" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileFifth = #Replace(Variables.EventDocumentFifth.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentFifth.ServerFile#" Destination="#Variables.NewServerFileFifth#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileFifth#" Destination="#Variables.EventDirectory#/#Variables.NewServerFileFifth#">
						<cfset EmailMessageWithFile = True>
					</cfif>
					<cfloop query="GetRegisteredUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetRegisteredUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetRegisteredUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetRegisteredUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
						<cfset ParticipantInfo.WebEventDirectory = #Variables.WebEventDirectory#>
						<cfif isDefined("Variables.EmailMessageWithFile")>
							<cfdirectory action="list" directory="#Variables.EventDirectory#" name="EventDocuments" type="file">
							<cfset ParticipantInfo.DocLinksInEmail = 1>
							<cfset ParticipantInfo.EventDocuments = #StructCopy(EventDocuments)#>
						</cfif>
						<cfif LEN(FORM.FirstWebLink) or LEN(FORM.SecondWebLink) or LEN(FORM.ThirdWebLink)>
							<cfset ParticipantInfo.WebLinksInEmail = 1>
							<cfset ParticipantInfo.WebLink1 = #FORM.FirstWebLink#>
							<cfset ParticipantInfo.WebLink2 = #FORM.SecondWebLink#>
							<cfset ParticipantInfo.WebLink3 = #FORM.ThirdWebLink#>
						<cfelse>
							<cfset ParticipantInfo.WebLinksInEmail = 0>
						</cfif>

						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo)#>
					</cfloop>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailAttended&Successful=True" addtoken="false">
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="sendpgpcertificates" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
					p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">) and
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
			<cfif GetSelectedEventRegistrations.RecordCount>
				<cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.RecordCount#>
			<cfelse>
				<cfset Session.EventNumberRegistrations = 0>
			</cfif>
			<cfset EventDateQuery = #QueryNew("EventDate")#>
			<cfif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) EQ 0 and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
				<cfset temp = #QueryAddRow(EventDateQuery, 4)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate3, 4)#>
			<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4)>
				<cfset temp = #QueryAddRow(EventDateQuery, 5)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate3, 4)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate4, 5)#>
			</cfif>
			<cfset Session.SignInSheet = #StructNew()#>
			<cfset Session.SignInSheet.EventDates = ValueList(EventDateQuery.EventDate, ",")>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>

			<cfif LEN(FORM.EmailMsg) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Enter some text that you would like to relay to those participants who are receiving the PGP Certificate."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.sendpgpcertificates&SiteID=#rc.$.siteConfig('siteID')#&EventID=#Session.UserSuppliedInfo.PickedEvent.RecNo#" addtoken="false">
			</cfif>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, tusers.Email, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
					p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">) and
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
			<cfset NumberOfEventDays = #ListLen(Session.SignInSheet.EventDates, ",")#>
			<cfset CertificateTemplateDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")#>
			<cfset CertificateExportTemplateDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")#>
			<cfset CertificateMasterTemplate = #Variables.CertificateTemplateDir# & "NIESCRisePGPCertificateTemplate.pdf">

			<cfloop query="GetSelectedEventRegistrations">
				<cfset ParticipantNumberOfPGPCertificatePoints = 0>
				<cfset EventDates = "">
				<cfif GetSelectedEventRegistrations.RegisterForEventDate1 EQ 1 and GetSelectedEventRegistrations.AttendedEventDate1 EQ 1><cfif LEN(Variables.EventDates) EQ 0><cfset EventDates = #DateFormat(GetSelectedEventRegistrations.EventDate, "mm/dd/yy")#><cfelse><cfset EventDates = #Variables.EventDates# & ", " & #DateFormat(GetSelectedEventRegistrations.EventDate, "mm/dd/yy")#></cfif><cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPPoints#></cfif>
				<cfif GetSelectedEventRegistrations.RegisterForEventDate2 EQ 1 and GetSelectedEventRegistrations.AttendedEventDate2 EQ 1><cfif LEN(Variables.EventDates) EQ 0><cfset EventDates = #DateFormat(GetSelectedEventRegistrations.EventDate1, "mm/dd/yy")#><cfelse><cfset EventDates = #Variables.EventDates# & ", " & #DateFormat(GetSelectedEventRegistrations.EventDate1, "mm/dd/yy")#></cfif><cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPPoints#></cfif>
				<cfif GetSelectedEventRegistrations.RegisterForEventDate3 EQ 1 and GetSelectedEventRegistrations.AttendedEventDate3 EQ 1><cfif LEN(Variables.EventDates) EQ 0><cfset EventDates = #DateFormat(GetSelectedEventRegistrations.EventDate2, "mm/dd/yy")#><cfelse><cfset EventDates = #Variables.EventDates# & ", " & #DateFormat(GetSelectedEventRegistrations.EventDate2, "mm/dd/yy")#></cfif><cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPPoints#></cfif>
				<cfif GetSelectedEventRegistrations.RegisterForEventDate4 EQ 1 and GetSelectedEventRegistrations.AttendedEventDate4 EQ 1><cfif LEN(Variables.EventDates) EQ 0><cfset EventDates = #DateFormat(GetSelectedEventRegistrations.EventDate3, "mm/dd/yy")#><cfelse><cfset EventDates = #Variables.EventDates# & ", " & #DateFormat(GetSelectedEventRegistrations.EventDate3, "mm/dd/yy")#></cfif><cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPPoints#></cfif>
				<cfif GetSelectedEventRegistrations.RegisterForEventDate5 EQ 1 and GetSelectedEventRegistrations.AttendedEventDate5 EQ 1><cfif LEN(Variables.EventDates) EQ 0><cfset EventDates = #DateFormat(GetSelectedEventRegistrations.EventDate4, "mm/dd/yy")#><cfelse><cfset EventDates = #Variables.EventDates# & ", " & #DateFormat(GetSelectedEventRegistrations.EventDate4, "mm/dd/yy")#></cfif><cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPPoints#></cfif>
				<cfif GetSelectedEventRegistrations.RegisterForEventDate6 EQ 1 and GetSelectedEventRegistrations.AttendedEventDate6 EQ 1><cfif LEN(Variables.EventDates) EQ 0><cfset EventDates = #DateFormat(GetSelectedEventRegistrations.EventDate5, "mm/dd/yy")#><cfelse><cfset EventDates = #Variables.EventDates# & ", " & #DateFormat(GetSelectedEventRegistrations.EventDate5, "mm/dd/yy")#></cfif><cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPPoints#></cfif>

				<cfset ParticipantName = #GetSelectedEventRegistrations.FName# & " " & #GetSelectedEventRegistrations.LName#>
				<cfset ParticipantFilename = #Replace(Variables.ParticipantName, " ", "", "all")#>
				<cfset ParticipantFilename = #Replace(Variables.ParticipantFilename, ".", "", "all")#>
				<cfset PGPEarned = "PGP Earned: " & #NumberFormat(Variables.ParticipantNumberOfPGPCertificatePoints, "99.9")#>
				<cfset CertificateCompletedFile = #Variables.CertificateExportTemplateDir# & #FORM.EventID# & "-" & #Variables.ParticipantFilename# & ".pdf">

				<cfscript>
					PDFCompletedCertificate = CreateObject("java", "java.io.FileOutputStream").init(CertificateCompletedFile);
					PDFMasterCertificateTemplate = CreateObject("java", "com.itextpdf.text.pdf.PdfReader").init(CertificateMasterTemplate);
					PDFStamper = CreateObject("java", "com.itextpdf.text.pdf.PdfStamper").init(PDFMasterCertificateTemplate, PDFCompletedCertificate);
					PDFStamper.setFormFlattening(true);
					PDFFormFields = PDFStamper.getAcroFields();
					PDFFormFields.setField("PGPEarned", Variables.PGPEarned);
					PDFFormFields.setField("ParticipantName", Variables.ParticipantName);
					PDFFormFields.setField("EventTitle", GetSelectedEventRegistrations.ShortTitle);
					PDFFormFields.setField("EventDate", Variables.EventDates);
					PDFFormFields.setField("SignDate", DateFormat(Now(), "mm/dd/yyyy"));
					PDFStamper.close();
				</cfscript>

				<cfset ParticipantInfo = StructNew()>
				<cfset ParticipantInfo.FName = #GetSelectedEventRegistrations.Fname#>
				<cfset ParticipantInfo.LName = #GetSelectedEventRegistrations.Lname#>
				<cfset ParticipantInfo.Email = #GetSelectedEventRegistrations.Email#>
				<cfset ParticipantInfo.EventShortTitle = #GetSelectedEventRegistrations.ShortTitle#>
				<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
				<cfset ParticipantInfo.NumberPGPPoints = #NumberFormat(Variables.ParticipantNumberOfPGPCertificatePoints, "99.9")#>
				<cfset ParticipantInfo.PGPCertificateFilename = #Variables.CertificateCompletedFile#>
				<cfset temp = #SendEMailCFC.SendPGPCertificateToIndividual(rc, Variables.ParticipantInfo)#>
			</cfloop>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=SentPGPCertificates&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="listeventexpenses" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated
			From p_EventRegistration_ExpenseList
			Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			Order by Expense_Name ASC
		</cfquery>

	</cffunction>

	<cffunction name="enterexpenses" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("URL.UserAction")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="Session.getAvailableEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_ExpenseList.Expense_Name, p_EventRegistration_EventExpenses.Cost_Amount, p_EventRegistration_EventExpenses.TContent_ID, p_EventRegistration_EventExpenses.Expense_ID
				FROM p_EventRegistration_ExpenseList INNER JOIN p_EventRegistration_EventExpenses ON p_EventRegistration_EventExpenses.Expense_ID = p_EventRegistration_ExpenseList.TContent_ID
				Where p_EventRegistration_EventExpenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_EventExpenses.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="Session.getAvailableExpenseList" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Expense_Name
				From p_EventRegistration_ExpenseList
				Where Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by Expense_Name ASC
			</cfquery>
		<cfelseif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("URL.UserAction") and not isDefined("URL.EventRecID")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="Session.getAvailableEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_ExpenseList.Expense_Name, p_EventRegistration_EventExpenses.Cost_Amount, p_EventRegistration_EventExpenses.TContent_ID, p_EventRegistration_EventExpenses.Expense_ID
				FROM p_EventRegistration_ExpenseList INNER JOIN p_EventRegistration_EventExpenses ON p_EventRegistration_EventExpenses.Expense_ID = p_EventRegistration_ExpenseList.TContent_ID
				Where p_EventRegistration_EventExpenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_EventExpenses.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="Session.getAvailableExpenseList" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Expense_Name
				From p_EventRegistration_ExpenseList
				Where Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by Expense_Name ASC
			</cfquery>
		<cfelseif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("URL.UserAction") and isDefined("URL.EventRecID")>
			<cfswitch expression="#URL.UserAction#">
				<cfcase value="UpdateExpense">
					<cfquery name="Session.getSelectedEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_ExpenseList.Expense_Name, p_EventRegistration_EventExpenses.Cost_Amount, p_EventRegistration_EventExpenses.TContent_ID, p_EventRegistration_EventExpenses.Expense_ID
						FROM p_EventRegistration_ExpenseList INNER JOIN p_EventRegistration_EventExpenses ON p_EventRegistration_EventExpenses.Expense_ID = p_EventRegistration_ExpenseList.TContent_ID
						Where p_EventRegistration_EventExpenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_EventExpenses.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							p_EventRegistration_EventExpenses.TContent_ID = <cfqueryparam value="#URL.EventRecID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfcase>
				<cfcase value="DeleteExpense">
					<cfquery name="DeleteEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Delete from p_EventRegistration_EventExpenses
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							TContent_ID = <cfqueryparam value="#URL.EventRecID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterexpenses&UserAction=DeleteExpenses&Successful=True&EventID=#URL.EventID#" addtoken="false">
				</cfcase>
			</cfswitch>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and isDefined("FORM.EventRecID")>
			<cfif FORM.UserAction EQ "Generate Profit/Loss Report">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
				<cfset temp = StructDelete(Session, "getAvailableEventExpenses")>
				<cfset temp = StructDelete(Session, "getSelectedEventExpenses")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.generateprofitlossreport&EventID=#URL.EventID#" addtoken="false">
			</cfif>
			<cfquery name="UpdateEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_EventRegistration_EventExpenses
				Set Expense_ID = <cfqueryparam value="#FORM.ExpenseID#" cfsqltype="cf_sql_integer">,
					Cost_Amount = <cfqueryparam value="#FORM.ExpenseAmount#" cfsqltype="cf_sql_integer">
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					Event_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
					TContent_ID = <cfqueryparam value="#URL.EventRecID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterexpenses&UserAction=ModifyExpenses&Successful=True&EventID=#URL.EventID#" addtoken="false">
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and not isDefined("FORM.EventRecID")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>

			<cfif FORM.UserAction EQ "Generate Profit/Loss Report">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
				<cfset temp = StructDelete(Session, "getAvailableEventExpenses")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.generateprofitlossreport&EventID=#URL.EventID#" addtoken="false">
			</cfif>

			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
				<cfset temp = StructDelete(Session, "getAvailableEventExpenses")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>

			<cfif FORM.ExpenseID EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select one of the Expenses from the DropDown Box. If all expenses have been entered, simply click the button 'Generate Profit/Loss Report'"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterexpenses&SiteID=#rc.$.siteConfig('siteID')#&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			</cfif>

			<cfquery name="InsertEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				insert into p_EventRegistration_EventExpenses(Site_ID, Event_ID, Expense_ID, Cost_Amount, dateCreated, lastUpdated, lastUpdateBy)
				Values(
					<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#FORM.ExpenseID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#FORM.ExpenseAmount#" cfsqltype="cf_sql_float">,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterexpenses&UserAction=EnterExpenses&Successful=True&EventID=#FORM.EventID#" addtoken="false">
		<cfelse>

		</cfif>

	</cffunction>

	<cffunction name="generateprofitlossreport" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="Session.GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.TContent_ID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.AttendeePrice, tusers.Fname, tusers.Lname, tusers.Email, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
					p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  and
					p_EventRegistration_UserRegistrations.AttendeePriceVerified = <cfqueryparam value="0" cfsqltype="cf_sql_bit">) and
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
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and not isDefined("URL.userAction")>
			<cfset Participant = StructNew()>
			<cfloop list="#FORM.fieldnames#" index="i" delimiters=",">
				<cfif ListContains(i, "Participants", "_")>
					<cfset Participants[i] = StructNew()>
					<cfset Participants[i]['RecordID'] = #ListLast(i, "_")#>
					<cfset Participants[i]['Amount'] = #FORM[i]#>
				</cfif>
			</cfloop>

			<cfloop collection=#Variables.Participants# item="RecNo">
				<cfquery name="UpdateAttendeePrice" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_UserRegistrations
					Set AttendeePrice = <cfqueryparam value="#Variables.Participants[RecNo]['Amount']#" cfsqltype="cf_sql_money">,
						AttendeePriceVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Where TContent_ID = <cfqueryparam value="#Variables.Participants[RecNo]['RecordID']#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfloop>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.generateprofitlossreport&UserAction=ShowReport&EventID=#FORM.EventID#" addtoken="false">
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and isDefined("URL.UserAction")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="Session.getSelectedEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_ExpenseList.Expense_Name, p_EventRegistration_EventExpenses.Cost_Amount, p_EventRegistration_EventExpenses.TContent_ID, p_EventRegistration_EventExpenses.Expense_ID
				FROM p_EventRegistration_ExpenseList INNER JOIN p_EventRegistration_EventExpenses ON p_EventRegistration_EventExpenses.Expense_ID = p_EventRegistration_ExpenseList.TContent_ID
				Where p_EventRegistration_EventExpenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_EventExpenses.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="Session.GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.TContent_ID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.AttendeePrice, tusers.Fname, tusers.Lname, tusers.Email, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
					p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					p_EventRegistration_UserRegistrations.AttendeePriceVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) and
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
		</cfif>
	</cffunction>

	<cffunction name="getAllEventExpenses" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrExpenses = ArrayNew(1)>
		<cfquery name="getExpenses" dbtype="Query">
			Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated
			From Session.getEventExpenses
			<cfif Arguments.sidx NEQ "">
				Order By #Arguments.sidx# #Arguments.sord#
			<cfelse>
				Order by Group_Name #Arguments.sord#
			</cfif>
		</cfquery>

		<!--- Calculate the Start Position for the loop query. So, if you are on 1st page and want to display 4 rows per page, for first page you start at: (1-1)*4+1 = 1.
				If you go to page 2, you start at (2-)1*4+1 = 5 --->
		<cfset start = ((arguments.page-1)*arguments.rows)+1>

		<!--- Calculate the end row for the query. So on the first page you go from row 1 to row 4. --->
		<cfset end = (start-1) + arguments.rows>

		<!--- When building the array --->
		<cfset i = 1>

		<cfloop query="getExpenses" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrExpenses[i] = [#TContent_ID#,#Expense_Name#,#strActive#,#dateCreated#,#lastUpdated#]>
			<cfset i = i + 1>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getExpenses.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getExpenses.recordcount#,rows=arrExpenses}>
		<cfreturn stcReturn>
	</cffunction>

	<cffunction name="addeventexpense" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormData = #StructCopy(FORM)#>
			<cfset Session.FormErrors = #ArrayNew()#>

			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.listeventexpenses" addtoken="false">
			</cfif>

			<cfif FORM.ExpenseActive EQ "----">
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="Please select one of the options as to whether this expense is is active or not."};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addeventexpense&FormRetry=True">
			</cfif>
			<cfquery name="insertEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Insert into p_EventRegistration_ExpenseList(Expense_Name, dateCreated, lastUpdated, lastUpdateBy, Active, Site_ID)
				Values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ExpenseName#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.userid#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ExpenseActive#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				)
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.listeventexpenses&UserAction=ExpenseCreatead&Successful=True">
		</cfif>
	</cffunction>

	<cffunction name="editeventexpense" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif not isDefined("Session.FormErrors")>
					<cfset Session.FormErrors = #ArrayNew()#>
				</cfif>
				<cfquery name="Session.getSelectedExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy
					From p_EventRegistration_ExpenseList
					Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
						TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ExpenseID#">
				</cfquery>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormData = #StructCopy(FORM)#>
			<cfset Session.FormErrors = #ArrayNew()#>

			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.listeventexpenses" addtoken="false">
			</cfif>

			<cfif FORM.ExpenseActive EQ "----">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="Please select one of the options as to whether this expense is is active or not."};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.editeventexpense&FormRetry=True">
			</cfif>

			<cfquery name="updateOrganizationGroup" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_EventRegistration_ExpenseList
				Set Expense_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ExpenseName#">,
					lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
					Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ExpenseActive#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.ExpenseID#">
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.listeventexpenses&UserAction=ExpenseUpdated&Successful=True">
		</cfif>
	</cffunction>

	<cffunction name="updateevent_review" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="Session.getSelectedMealProvider" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, DeliveryInfo, GuaranteeInformation, AdditionalNotes
				From p_EventRegistration_Caterers
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#Session.getSelectedEvent.MealProvidedBy#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="Session.getSelectedLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#Session.getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="Session.getSelectedRoomInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select RoomName, Capacity, RoomFees
				From p_EventRegistration_FacilityRooms
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#Session.getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> and
					Facility_ID = <cfqueryparam value="#Session.getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfelseif isDefined("FORM.FormSubmit")>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getSelectedMealProvider")>
				<cfset temp = StructDelete(Session, "getSelectedLocation")>
				<cfset temp = StructDelete(Session, "getSelectedRoomInfo")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
			<cfif FORM.UserAction EQ "Submit Changes">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getSelectedMealProvider")>
				<cfset temp = StructDelete(Session, "getSelectedLocation")>
				<cfset temp = StructDelete(Session, "getSelectedRoomInfo")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>

		</cfif>
	</cffunction>

	<cffunction name="updateevent_acceptregistrations" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>
		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.AcceptRegistrations EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to accept registrations for this event or not."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_acceptregistrations&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set AcceptRegistrations = <cfqueryparam value="#FORM.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_locationinfo" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID") and not isDefined("URL.SelectRoom")>
			<cfquery name="Session.getAllLocations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID") and isDefined("URL.SelectRoom")>
			<cfquery name="Session.getAllLocationRooms" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, RoomName, Capacity, RoomFees
				From p_EventRegistration_FacilityRooms
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					Facility_ID = <cfqueryparam value="#Session.getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section" and not isDefined("URL.SelectRoom")>
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.LocationID EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the available locations to hold this event."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_locationinfo&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_locationinfo&SelectRoom=True&EventID=#URL.EventID#">
			<cfelseif FORM.UserAction EQ "Update Event Section" and isDefined("URL.SelectRoom")>
				<cfif FORM.LocationRoomID EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the available location rooms to hold this event."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_locationinfo&FormRetry=True&EventID=#URL.EventID#&SelectRoom=True">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set LocationID = <cfqueryparam value="#Session.FormData.LocationID#" cfsqltype="cf_sql_integer">,
						LocationRoomID = <cfqueryparam value="#FORM.LocationRoomID#" cfsqltype="cf_sql_integer">,
						MaxParticipants = <cfqueryparam value="#FORM.RoomMaxParticipants#" cfsqltype="cf_sql_integer">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_webinar" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.WebinarAvailable EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to accept registrations for this event or not."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_webinar&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set WebinarAvailable = <cfqueryparam value="#FORM.WebinarAvailable#" cfsqltype="cf_sql_bit">,
						WebinarConnectInfo = <cfqueryparam value="#FORM.WebinarConnectInfo#" cfsqltype="cf_sql_varchar">,
						WebinarMemberCost = <cfqueryparam value="#FORM.WebinarMemberCost#" cfsqltype="cf_sql_double">,
						WebinarNonMemberCost = <cfqueryparam value="#FORM.WebinarNonMemberCost#" cfsqltype="cf_sql_double">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_videoconference" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.AllowVideoConference EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to accept registrations for this event or not."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_videoconference&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set AllowVideoConference = <cfqueryparam value="#FORM.AllowVideoConference#" cfsqltype="cf_sql_bit">,
						VideoConferenceInfo = <cfqueryparam value="#FORM.VideoConferenceInfo#" cfsqltype="cf_sql_varchar">,
						VideoConferenceCost = <cfqueryparam value="#FORM.VideoConferenceCost#" cfsqltype="cf_sql_double">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_pgps" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.PGPAvailable EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to offer PGP Certificates to participants who completed this event or not."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_pgps&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set PGPAvailable = <cfqueryparam value="#FORM.PGPAvailable#" cfsqltype="cf_sql_bit">,
						PGPPoints = <cfqueryparam value="#FORM.PGPPoints#" cfsqltype="cf_sql_decimal">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_mealinfo" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>
			<cfquery name="Session.getMealProviders" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName
				From p_EventRegistration_Caterers
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#Session.getSelectedEvent.MealProvidedBy#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.MealProvided EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to offer a meal to participants of this event."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_mealinfo&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set MealProvided = <cfqueryparam value="#FORM.MealProvided#" cfsqltype="cf_sql_bit">,
						MealProvidedBy = <cfqueryparam value="#FORM.MealProvidedBy#" cfsqltype="cf_sql_integer">,
						MealCost_Estimated = <cfqueryparam value="#FORM.MealCost_Estimated#" cfsqltype="cf_sql_decimal">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_specialpricing" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.ViewSpecialPricing EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to offer a special price if requirements are met."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_speicalpricing&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set ViewSpecialPricing = <cfqueryparam value="#FORM.ViewSpecialPricing#" cfsqltype="cf_sql_bit">,
						SpecialMemberCost = <cfqueryparam value="#FORM.SpecialMemberCost#" cfsqltype="cf_sql_decimal">,
						SpecialNonMemberCost = <cfqueryparam value="#FORM.SpecialNonMemberCost#" cfsqltype="cf_sql_decimal">,
						SpecialPriceRequrements = <cfqueryparam value="#FORM.SpecialPriceRequirements#" cfsqltype="cf_sql_varchar">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_earlybird" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.EarlyBird_RegistrationAvailable EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to offer a early bird registration discount for this event."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_earlybird&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set EarlyBird_RegistrationAvailable = <cfqueryparam value="#FORM.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
						EarlyBird_RegistrationDeadline = <cfqueryparam value="#FORM.EarlyBird_RegistrationDeadline#" cfsqltype="cf_sql_timestamp">,
						EarlyBird_MemberCost = <cfqueryparam value="#FORM.EarlyBird_MemberCost#" cfsqltype="cf_sql_decimal">,
						EarlyBird_NonMemberCost = <cfqueryparam value="#FORM.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_decimal">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_pricing" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set MemberCost = <cfqueryparam value="#FORM.MemberCost#" cfsqltype="cf_sql_decimal">,
						NonMemberCost = <cfqueryparam value="#FORM.NonMemberCost#" cfsqltype="cf_sql_decimal">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_featured" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.EventFeatured EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to feature this event on the front page or not."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_featured&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set EventFeatured = <cfqueryparam value="#FORM.EventFeatured#" cfsqltype="cf_sql_bit">,
						Featured_StartDate = <cfqueryparam value="#FORM.Featured_StartDate#" cfsqltype="cf_sql_timestamp">,
						Featured_EndDate = <cfqueryparam value="#FORM.Featured_EndDate#" cfsqltype="cf_sql_timestamp">,
						Featured_SortOrder = <cfqueryparam value="#FORM.Featured_SortOrder#" cfsqltype="cf_sql_integer">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_descriptions" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set ShortTitle = <cfqueryparam value="#FORM.ShortTitle#" cfsqltype="cf_sql_varchar">,
						LongDescription = <cfqueryparam value="#FORM.LongDescription#" cfsqltype="cf_sql_varchar">,
						EventAgenda = <cfqueryparam value="#FORM.EventAgenda#" cfsqltype="cf_sql_varchar">,
						EventTargetAudience = <cfqueryparam value="#FORM.EventTargetAudience#" cfsqltype="cf_sql_varchar">,
						EventStrategies = <cfqueryparam value="#FORM.EventStrategies#" cfsqltype="cf_sql_varchar">,
						EventSpecialInstructions = <cfqueryparam value="#FORM.EventSpecialInstructions#" cfsqltype="cf_sql_varchar">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_eventtimes" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set Registration_Deadline = <cfqueryparam value="#FORM.ShortTitle#" cfsqltype="cf_sql_timestamp">,
						Registration_BeginTime = <cfqueryparam value="#FORM.LongDescription#" cfsqltype="cf_sql_timestamp">,
						Event_StartTime = <cfqueryparam value="#FORM.EventAgenda#" cfsqltype="cf_sql_timestamp">,
						Event_EndTime = <cfqueryparam value="#FORM.EventTargetAudience#" cfsqltype="cf_sql_timestamp">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_eventdates" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set EventDate = <cfqueryparam value="#FORM.EventDate#" cfsqltype="cf_sql_date">,
						EventDate1 = <cfqueryparam value="#FORM.EventDate1#" cfsqltype="cf_sql_date">,
						EventDate2 = <cfqueryparam value="#FORM.EventDate2#" cfsqltype="cf_sql_date">,
						EventDate3 = <cfqueryparam value="#FORM.EventDate3#" cfsqltype="cf_sql_date">,
						EventDate4 = <cfqueryparam value="#FORM.EventDate4#" cfsqltype="cf_sql_date">,
						EventDate5 = <cfqueryparam value="#FORM.EventDate5#" cfsqltype="cf_sql_date">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="emaileventlisting" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit")>
			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="GetUpComingEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID, ShortTitle, EventDate, LongDescription
						From p_EventRegistration_Events
						Where DateDiff("d", Now(), Registration_Deadline) >= 1
						Order by EventDate ASC
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="GetUpComingEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID, ShortTitle, EventDate, LongDescription
						From p_EventRegistration_Events
						Where DateDiff("d", GETUTCDATE(), Registration_Deadline) >= 1
						Order by EventDate ASC
					</cfquery>
				</cfcase>
			</cfswitch>

			<cfset Session.EmailMarketing = #StructNew()#>
			<cfset Session.EmailMarketing.MasterTemplate = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/EventUpcomingList.jrxml")#>
			<cfset Session.EmailMarketing.ReportExportDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")#>
			<cfset Session.EmailMarketing.WebExportDir = "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/">
			<cfset Session.EmailMarketing.CompletedFile = #Session.EmailMarketing.ReportExportDir# & #DateFormat(Now(), "mm_dd_yyyy")# & "EmailMarketingListEvents.pdf">
			<cfset Session.EmailMarketing.WebExportCompletedFile = "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/" & #DateFormat(Now(), "mm_dd_yyyy")# & "EmailMarketingListEvents.pdf">
			<cfset Session.EmailMarketing.QueryResults = #GetUpComingEvents#>

		<cfelseif isDefined("FORM.FormSubmit")>
			<cfset Session.FormData = #StructCopy(FORM)#>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false"></cfif>
			<cfif FORM.WhoToSendTo EQ "----">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="Please select who to send the upcoming event listing to."};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emaileventlisting&FormRetry=True">
			<cfelse>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfif FORM.WhoToSendTo EQ 0>
					<cfset Temp = SendEmailCFC.SendEmailWithUpComingEventListing(rc, Session.Mura.UserID)>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailUpComingEvents&Successful=True" addtoken="false">
				<cfelseif FORM.WhoToSendTo EQ 1>
					<cfset Temp = SendEmailCFC.SendEmailWithUpComingEventListing(rc, "MailingLists")>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailUpComingEvents&Successful=True" addtoken="false">
				</cfif>
			</cfif>



		</cfif>
	</cffunction>
</cfcomponent>