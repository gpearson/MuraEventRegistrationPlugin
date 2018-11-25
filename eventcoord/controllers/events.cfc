<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset PriorDate = #CreateDate(2015, 07, 01)#>
		<cfquery name="Session.getAvailableEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, ShortTitle, EventDate, LongDescription, PGPAvailable, MemberCost, NonMemberCost
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				EventDate >= <cfqueryparam value="#Variables.PriorDate#" cfsqltype="cf_sql_date"> and
				EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			Order by EventDate DESC
		</cfquery>

	</cffunction>

	<cffunction name="addevent" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
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
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
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
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfif FORM.LocationRoomID EQ "----">
				<cfscript>
					errormsg = {property="MealProvidedBy",message="Please Select a Room at the Facility you selected where this event will be held in"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step3&PerformAction=Step3&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
			</cfif>
			<cfif isDefined("FORM.LocationRoomID")><cfset Session.UserSuppliedInfo.LocationRoomID = #FORM.LocationRoomID#></cfif>
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
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.UserSuppliedInfo.MaxRoomParticipants = #FORM.RoomMaxParticipants#>

			<cfif LEN(FORM.RoomMaxParticipants) EQ 0>
				<cfscript>
					errormsg = {property="MealProvidedBy",message="Please Enter the maximum number of participants for this event or workshop"};
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
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addevent_review" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>

		<cfelseif isDefined("FORM.formSubmit")>

		</cfif>
	</cffunction>

</cfcomponent>