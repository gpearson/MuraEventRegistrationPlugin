/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
	</cffunction>

	<cffunction name="addevent" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif not isDefined("Session.UserSuppliedInfo")>
					<cfset Session.UserSuppliedInfo = StructNew()>
					<cfset Session.UserSuppliedInfo.NewRecNo = 0>
				</cfif>
			</cflock>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif isDefined("FORM.AcceptRegistrations")><cfset Session.UserSuppliedInfo.AcceptRegistrations = #FORM.AcceptRegistrations#></cfif>
				<cfif isDefined("FORM.Facilitator")><cfset Session.UserSuppliedInfo.Facilitator = #FORM.Facilitator#></cfif>
				<cfif isDefined("FORM.EventDate")><cfset Session.UserSuppliedInfo.EventDate = #FORM.EventDate#></cfif>
				<cfif isDefined("FORM.EventSpanDates")><cfset Session.UserSuppliedInfo.EventSpanDates = #FORM.EventSpanDates#></cfif>
				<cfif isDefined("FORM.Registration_Deadline")><cfset Session.UserSuppliedInfo.Registration_Deadline = #FORM.Registration_Deadline#></cfif>
				<cfif isDefined("FORM.Registration_BeginTime")><cfset Session.UserSuppliedInfo.Registration_BeginTime = #FORM.Registration_BeginTime#></cfif>
				<cfif isDefined("FORM.Event_StartTime")><cfset Session.UserSuppliedInfo.Event_StartTime = #FORM.Event_StartTime#><cfset Session.UserSuppliedInfo.Registration_EndTime = #FORM.Event_StartTime#></cfif>
				<cfif isDefined("FORM.Event_EndTime")><cfset Session.UserSuppliedInfo.Event_EndTime = #FORM.Event_EndTime#></cfif>
				<cfif isDefined("FORM.ShortTitle")><cfset Session.UserSuppliedInfo.ShortTitle = #FORM.ShortTitle#></cfif>
				<cfif isDefined("FORM.LongDescription")><cfset Session.UserSuppliedInfo.LongDescription = #FORM.LongDescription#></cfif>
				<cfif isDefined("FORM.EventFeatured")><cfset Session.UserSuppliedInfo.EventFeatured = #FORM.EventFeatured#></cfif>
				<cfif isDefined("FORM.EarlyBird_RegistrationAvailable")><cfset Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable = #FORM.EarlyBird_RegistrationAvailable#></cfif>
				<cfif isDefined("FORM.ViewSpecialPricing")><cfset Session.UserSuppliedInfo.ViewSpecialPricing = #FORM.ViewSpecialPricing#></cfif>
				<cfif isDefined("FORM.PGPAvailable")><cfset Session.UserSuppliedInfo.PGPAvailable = #FORM.PGPAvailable#></cfif>
				<cfif isDefined("FORM.MealProvided")><cfset Session.UserSuppliedInfo.MealProvided = #FORM.MealProvided#></cfif>
				<cfif isDefined("FORM.AllowVideoConference")><cfset Session.UserSuppliedInfo.AllowVideoConference = #FORM.AllowVideoConference#></cfif>
				<cfif isDefined("FORM.WebinarEvent")><cfset Session.UserSuppliedInfo.WebinarEvent = #FORM.WebinarEvent#></cfif>
				<cfif isDefined("FORM.PostEventToFB")><cfset Session.UserSuppliedInfo.PostEventToFB = #FORM.PostEventToFB#></cfif>
				<cfif isDefined("FORM.LocationType")><cfset Session.UserSuppliedInfo.LocationType = #FORM.LocationType#></cfif>
			</cflock>
			<cfif not isNumericDate(Session.UserSuppliedInfo.EventDate)>
				<cfscript>
					eventdate = {property="EventDate",message="Event Date is not in correct date format"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			</cfif>
			<cfif not isNumericDate(Session.UserSuppliedInfo.EventDate)>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Registration Deadline is not in correct date format"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			</cfif>
			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.addevent&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.addevent_step2&PerformAction=Step2&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>
		<cfelse>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif not isDefined("Session.UserSuppliedInfo")>
					<cfset Session.UserSuppliedInfo = StructNew()>
					<cfset Session.UserSuppliedInfo.NewRecNo = 0>
				</cfif>
			</cflock>
		</cfif>
	</cffunction>
	<cffunction name="addevent_step2" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<!--- Clear out the Array from Previous Submissions --->
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif isDefined("FORM.EventDate1")><cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate1#></cfif>
				<cfif isDefined("FORM.EventDate2")><cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate2#></cfif>
				<cfif isDefined("FORM.EventDate3")><cfset Session.UserSuppliedInfo.EventDate3 = #FORM.EventDate3#></cfif>
				<cfif isDefined("FORM.EventDate4")><cfset Session.UserSuppliedInfo.EventDate4 = #FORM.EventDate4#></cfif>
				<cfif isDefined("FORM.EventDate5")><cfset Session.UserSuppliedInfo.EventDate5 = #FORM.EventDate5#></cfif>
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
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.addevent_step2&PerformAction=Step2&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.addevent_step3&PerformAction=Step3&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>
	<cffunction name="addevent_step3" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif isDefined("FORM.LocationRoomID")>
					<cfset Session.UserSuppliedInfo.LocationRoomID = #FORM.LocationRoomID#>
					<cfif FORM.LocationRoomID EQ 0>
						<cfscript>
							errormsg = {property="LocationRoomID",message="Please Select a Room for this event"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cfif>
				</cfif>
				<cfif isDefined("FORM.EventDocument1")><cfset Session.UserSuppliedInfo.EventDocument1 = #FORM.EventDocument1#></cfif>
				<cfif isDefined("FORM.EventDocument2")><cfset Session.UserSuppliedInfo.EventDocument2 = #FORM.EventDocument2#></cfif>
				<cfif isDefined("FORM.EventDocument3")><cfset Session.UserSuppliedInfo.EventDocument3 = #FORM.EventDocument3#></cfif>
				<cfif isDefined("FORM.EventDocument4")><cfset Session.UserSuppliedInfo.EventDocument4 = #FORM.EventDocument4#></cfif>
				<cfif isDefined("FORM.EventDocument5")><cfset Session.UserSuppliedInfo.EventDocument5 = #FORM.EventDocument5#></cfif>
				<cfif isDefined("FORM.Presenters")><cfset Session.UserSuppliedInfo.Presenters = #FORM.Presenters#></cfif>
				<cfif ArrayLen(Session.FormErrors)>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.addevent_step3&PerformAction=Step3&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
				<cfelse>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.addevent_step4&PerformAction=Step4&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
				</cfif>
			</cflock>
		</cfif>
	</cffunction>
	<cffunction name="addevent_step4" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif isDefined("FORM.RoomMaxParticipants")><cfset Session.UserSuppliedInfo.RoomMaxParticipants = #FORM.RoomMaxParticipants#></cfif>
			</cflock>

			<cfif not isNumeric(FORM.RoomMaxParticipants)>
				<cfscript>
					errormsg = {property="RoomMaxParticipants",message="Please enter a number for Maximum Participants for this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelseif LEN(FORM.RoomMaxParticipants) EQ 0>
				<cfscript>
					errormsg = {property="RoomMaxParticipants",message="Please enter atleast 1 Participant for this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelseif FORM.RoomMaxParticipants EQ 0>
				<cfscript>
					errormsg = {property="RoomMaxParticipants",message="Please enter atleast 1 Participant for this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelse>
				<cfset Session.UserSuppliedInfo.RoomMaxParticipants = #FORM.RoomMaxParticipants#>
			</cfif>
			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.addevent_step4&PerformAction=Step4&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.addevent_review&PerformAction=Step5&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="addevent_review" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
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

			<!--- Create Date Object from User Inputted Time from Registration End Time --->
			<cfset EventRegistrationEndTimeHours = #ListFirst(Session.UserSuppliedInfo.Registration_EndTime, ":")#>
			<cfset EventRegistrationEndTimeMinutes = #Left(ListLast(Session.UserSuppliedInfo.Registration_EndTime, ":"), 2)#>
			<cfset EventRegistrationEndTimeAMPM = #Right(ListLast(Session.UserSuppliedInfo.Registration_EndTime, ":"), 2)#>
			<cfif EventRegistrationEndTimeAMPM EQ "PM">
				<cfswitch expression="#Variables.EventRegistrationEndTimeHours#">
					<cfcase value="12">
						<cfset EventRegistrationEndTimeHours = #Variables.EventRegistrationEndTimeHours#>
					</cfcase>
					<cfdefaultcase>
						<cfset EventRegistrationEndTimeHours = #Variables.EventRegistrationEndTimeHours# + 12>
					</cfdefaultcase>
				</cfswitch>
			</cfif>
			<cfset EventRegistrationEndTimeObject = #CreateTime(Variables.EventRegistrationEndTimeHours, Variables.EventRegistrationEndTimeMinutes, 0)#>

			<cftry>
				<cfquery name="insertNewEvent" result="insertNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into eEvents(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_EndTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active)
					Values ("#rc.$.siteConfig('siteID')#", "#Session.UserSuppliedInfo.ShortTitle#", #CreateDate(ListLast(Session.UserSuppliedInfo.EventDate, "/"), ListFirst(Session.UserSuppliedInfo.EventDate, "/"), ListGetAt(Session.UserSuppliedInfo.EventDate, 2, "/"))#, "#Session.UserSuppliedInfo.LongDescription#", #Variables.EventStartTimeObject#, #Variables.EventEndTimeObject#, #CreateDate(ListLast(Session.UserSuppliedInfo.Registration_Deadline, "/"), ListFirst(Session.UserSuppliedInfo.Registration_Deadline, "/"), ListGetAt(Session.UserSuppliedInfo.Registration_Deadline, 2, "/"))#, #Variables.EventRegistrationEndTimeObject#, #Session.UserSuppliedInfo.EventFeatured#, #Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable#, #Session.UserSuppliedInfo.ViewSpecialPricing#, #Session.UserSuppliedInfo.PGPAvailable#, #Session.UserSuppliedInfo.MealProvided#, #Session.UserSuppliedInfo.AllowVideoConference#, #Session.UserSuppliedInfo.AcceptRegistrations#, "#Session.UserSuppliedInfo.Facilitator#", #Now()#, #Session.UserSuppliedInfo.RoomMaxParticipants#, #FORM.Active# )
				</cfquery>

				<cfquery name="updateEventLocationInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eEvents
					Set LocationType = '#Session.UserSuppliedInfo.LocationType#',
						LocationID = #Session.UserSuppliedInfo.LocationID#,
						LocationRoomID = #Session.UserSuppliedInfo.LocationRoomID#,
						MemberCost = "#NumberFormat(Session.UserSuppliedInfo.MemberCost, '9999.99')#",
						NonMemberCost = "#NumberFormat(Session.UserSuppliedInfo.NonMemberCost, '9999.99')#"
					Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfif isDefined("Session.UserSuppliedInfo.EventDate1")>
					<cfif #isDate(Session.UserSuppliedInfo.EventDate1)# EQ 1>
						<cfquery name="updateEventDate1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDate1 = #CreateDate(ListLast(Session.UserSuppliedInfo.EventDate1, "/"), ListFirst(Session.UserSuppliedInfo.EventDate1, "/"), ListGetAt(Session.UserSuppliedInfo.EventDate1, 2, "/"))#
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("Session.UserSuppliedInfo.EventDate2")>
					<cfif #isDate(Session.UserSuppliedInfo.EventDate2)# EQ 1>
						<cfquery name="updateEventDate2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDate2 = #CreateDate(ListLast(Session.UserSuppliedInfo.EventDate2, "/"), ListFirst(Session.UserSuppliedInfo.EventDate2, "/"), ListGetAt(Session.UserSuppliedInfo.EventDate2, 2, "/"))#
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("Session.UserSuppliedInfo.EventDate3")>
					<cfif #isDate(Session.UserSuppliedInfo.EventDate3)# EQ 1>
						<cfquery name="updateEventDate3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDate3 = #CreateDate(ListLast(Session.UserSuppliedInfo.EventDate3, "/"), ListFirst(Session.UserSuppliedInfo.EventDate3, "/"), ListGetAt(Session.UserSuppliedInfo.EventDate3, 2, "/"))#
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("Session.UserSuppliedInfo.EventDate4")>
					<cfif #isDate(Session.UserSuppliedInfo.EventDate4)# EQ 1>
						<cfquery name="updateEventDate4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDate4 = #CreateDate(ListLast(Session.UserSuppliedInfo.EventDate4, "/"), ListFirst(Session.UserSuppliedInfo.EventDate4, "/"), ListGetAt(Session.UserSuppliedInfo.EventDate4, 2, "/"))#
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("Session.UserSuppliedInfo.EventDate5")>
					<cfif #isDate(Session.UserSuppliedInfo.EventDate5)# EQ 1>
						<cfquery name="updateEventDate5" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDate5 = #CreateDate(ListLast(Session.UserSuppliedInfo.EventDate5, "/"), ListFirst(Session.UserSuppliedInfo.EventDate5, "/"), ListGetAt(Session.UserSuppliedInfo.EventDate5, 2, "/"))#
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("Session.UserSuppliedInfo.EventAgenda")>
					<cfif LEN(Session.UserSuppliedInfo.EventAgenda)>
						<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventAgenda = <cfqueryparam value="#Session.UserSuppliedInfo.EventAgenda#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("Session.UserSuppliedInfo.EventTargetAudience")>
					<cfif LEN(Session.UserSuppliedInfo.EventTargetAudience)>
						<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventTargetAudience = <cfqueryparam value="#Session.UserSuppliedInfo.EventTargetAudience#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("Session.UserSuppliedInfo.EventStrategies")>
					<cfif LEN(Session.UserSuppliedInfo.EventStrategies)>
						<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventStrategies = <cfqueryparam value="#Session.UserSuppliedInfo.EventStrategies#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif isDefined("Session.UserSuppliedInfo.EventSpecialInstructions")>
					<cfif LEN(Session.UserSuppliedInfo.EventSpecialInstructions)>
						<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventSpecialInstructions = <cfqueryparam value="#Session.UserSuppliedInfo.EventSpecialInstructions#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				</cfif>

				<cfif Session.UserSuppliedInfo.EventFeatured EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set Featured_StartDate = #CreateDate(ListLast(Session.UserSuppliedInfo.Featured_StartDate, "/"), ListFirst(Session.UserSuppliedInfo.Featured_StartDate, "/"), ListGetAt(Session.UserSuppliedInfo.Featured_StartDate, 2, "/"))#,
							Featured_EndDate = #CreateDate(ListLast(Session.UserSuppliedInfo.Featured_EndDate, "/"), ListFirst(Session.UserSuppliedInfo.Featured_EndDate, "/"), ListGetAt(Session.UserSuppliedInfo.Featured_EndDate, 2, "/"))#,
							Featured_SortOrder = <cfqueryparam value="#Session.UserSuppliedInfo.Featured_SortOrder#" cfsqltype="cf_sql_integer">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set EarlyBird_RegistrationAvailable = <cfqueryparam value="#Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
							EarlyBird_RegistrationDeadline = #CreateDate(ListLast(Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline, "/"), ListFirst(Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline, "/"), ListGetAt(Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline, 2, "/"))#,
							EarlyBird_MemberCost = "#Session.UserSuppliedInfo.EarlyBird_MemberCost#",
							EarlyBird_NonMemberCost = "#Session.UserSuppliedInfo.EarlyBird_NonMemberCost#"
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set ViewSpecialPricing = <cfqueryparam value="#Session.UserSuppliedInfo.ViewSpecialPricing#" cfsqltype="cf_sql_bit">,
							SpecialMemberCost = "#Session.UserSuppliedInfo.SpecialMemberCost#",
							SpecialNonMemberCost = "#Session.UserSuppliedInfo.SpecialNonMemberCost#",
							SpecialPriceRequirements = "#Session.UserSuppliedInfo.SpecialPriceRequirements#"
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set PGPAvailable = <cfqueryparam value="#Session.UserSuppliedInfo.PGPAvailable#" cfsqltype="cf_sql_bit">,
							PGPPoints = <cfqueryparam value="#Session.UserSuppliedInfo.PGPPoints#" cfsqltype="cf_sql_DECIMAL">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set MealCost_Estimated = <cfqueryparam value="#Session.UserSuppliedInfo.MealCost_Estimated#" cfsqltype="CF_SQL_MONEY">,
							MealProvidedBy = <cfqueryparam value="#Session.UserSuppliedInfo.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set AllowVideoConference = <cfqueryparam value="#Session.UserSuppliedInfo.AllowVideoConference#" cfsqltype="cf_sql_bit">,
							VideoConferenceInfo = <cfqueryparam value="#Session.UserSuppliedInfo.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
							VideoConferenceCost = <cfqueryparam value="#Session.UserSuppliedInfo.VideoConferenceCost#" cfsqltype="CF_SQL_MONEY">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1>
					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set WebinarAvailable = <cfqueryparam value="#Session.UserSuppliedInfo.WebinarEvent#" cfsqltype="cf_sql_bit">,
							WebinarConnectInfo = <cfqueryparam value="#Session.UserSuppliedInfo.WebinarConnectWebInfo#" cfsqltype="CF_SQL_VARCHAR">,
							WebinarMemberCost = <cfqueryparam value="#Session.UserSuppliedInfo.WebinarMemberCost#" cfsqltype="CF_SQL_MONEY">,
							WebinarNonMemberCost = <cfqueryparam value="#Session.UserSuppliedInfo.WebinarNonMemberCost#" cfsqltype="CF_SQL_MONEY">
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfif LEN(Session.UserSuppliedInfo.Registration_BeginTime) GT 3>
					<!--- Create Date Object from User Inputted Time from Registration End Time --->
					<cfset EventRegistrationBeginTimeHours = #ListFirst(Session.UserSuppliedInfo.Registration_BeginTime, ":")#>
					<cfset EventRegistrationBeginTimeMinutes = #Left(ListLast(Session.UserSuppliedInfo.Registration_BeginTime, ":"), 2)#>
					<cfset EventRegistrationBeginTimeAMPM = #Right(ListLast(Session.UserSuppliedInfo.Registration_BeginTime, ":"), 2)#>
					<cfif EventRegistrationBeginTimeAMPM EQ "PM">
						<cfswitch expression="#Variables.EventRegistrationBeginTimeHours#">
							<cfcase value="12">
								<cfset EventRegistrationBeginTimeHours = #Variables.EventRegistrationBeginTimeHours#>
							</cfcase>
							<cfdefaultcase>
								<cfset EventRegistrationBeginTimeHours = #Variables.EventRegistrationBeginTimeHours# + 12>
							</cfdefaultcase>
						</cfswitch>
					</cfif>
					<cfset EventRegistrationBeginTimeObject = #CreateTime(Variables.EventRegistrationBeginTimeHours, Variables.EventRegistrationBeginTimeMinutes, 0)#>

					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set Registration_BeginTime = #Variables.EventRegistrationBeginTimeObject#
						Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>

				<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eEvents
					Set AcceptRegistrations = <cfqueryparam value="#FORM.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
						lastUpdated = #Now()#,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfcatch type="Database">
					<cfdump var="#CFCATCH#"><cfabort>
				</cfcatch>
			</cftry>

			<cfif Session.UserSuppliedInfo.PostEventToFB EQ 1>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.FB.RedirectURI = "http://#cgi.server_name#/plugins/EventRegistration/?EventRegistrationaction=admin:events.publishtofb&compactDisplay=false&EventID=#insertNewEvent.GENERATED_KEY#&PerformAction=AutomaticPost">
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.publishtofb&SiteID=#rc.$.siteConfig('siteID')#&EventID=#insertNewEvent.GENERATED_KEY#&AutomaticPost=True" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "UserSuppliedInfo", "True")#>
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=AddedEvent&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_review" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit") and not isDefined("URL.EventStatus")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetSelectedEvent.RecordCount EQ 0>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.UserSuppliedInfo = StructNew()>

					<!--- Different Group Areas a User can change on the Event --->
					<cfset Session.UserSuppliedInfo.GroupAreas = #StructNew()#>
					<cfset Session.UserSuppliedInfo.GroupAreas.Dates = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.Description = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.Details = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.Speakers = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.Pricing = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.SpecialPricing = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.Featured = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.EarlyBird = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.PGP = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.Meals = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.IVC = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.MeetingRooms = false>
					<cfset Session.UserSuppliedInfo.GroupAreas.Registrations = false>

					<cfset Session.UserSuppliedInfo.RecNo = #GetSelectedEvent.TContent_ID#>
					<cfset Session.UserSuppliedInfo.ShortTitle = #GetSelectedEvent.ShortTitle#>
					<cfset Session.UserSuppliedInfo.EventDate = #GetSelectedEvent.EventDate#>
					<cfset Session.UserSuppliedInfo.EventDate1 = #GetSelectedEvent.EventDate1#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #GetSelectedEvent.EventDate2#>
					<cfset Session.UserSuppliedInfo.EventDate3 = #GetSelectedEvent.EventDate3#>
					<cfset Session.UserSuppliedInfo.EventDate4 = #GetSelectedEvent.EventDate4#>
					<cfset Session.UserSuppliedInfo.EventDate5 = #GetSelectedEvent.EventDate5#>
					<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4) or LEN(GetSelectedEvent.EventDate5)>
						<cfset Session.UserSuppliedInfo.EventSpanDates = 1>
					<cfelse>
						<cfset Session.UserSuppliedInfo.EventSpanDates = 0>
					</cfif>
					<cfset Session.UserSuppliedInfo.LongDescription = #GetSelectedEvent.LongDescription#>
					<cfset Session.UserSuppliedInfo.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
					<cfset Session.UserSuppliedInfo.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
					<cfset Session.UserSuppliedInfo.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
					<cfset Session.UserSuppliedInfo.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
					<cfset Session.UserSuppliedInfo.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
					<cfset Session.UserSuppliedInfo.EventFeatured = #GetSelectedEvent.EventFeatured#>
					<cfset Session.UserSuppliedInfo.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
					<cfset Session.UserSuppliedInfo.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
					<cfset Session.UserSuppliedInfo.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
					<cfset Session.UserSuppliedInfo.MemberCost = #GetSelectedEvent.MemberCost#>
					<cfset Session.UserSuppliedInfo.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
					<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
					<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
					<cfset Session.UserSuppliedInfo.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
					<cfset Session.UserSuppliedInfo.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
					<cfset Session.UserSuppliedInfo.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
					<cfset Session.UserSuppliedInfo.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
					<cfset Session.UserSuppliedInfo.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
					<cfset Session.UserSuppliedInfo.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
					<cfset Session.UserSuppliedInfo.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
					<cfset Session.UserSuppliedInfo.PGPPoints = #GetSelectedEvent.PGPPoints#>
					<cfset Session.UserSuppliedInfo.MealProvided = #GetSelectedEvent.MealProvided#>
					<cfset Session.UserSuppliedInfo.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
					<cfset Session.UserSuppliedInfo.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
					<cfset Session.UserSuppliedInfo.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
					<cfset Session.UserSuppliedInfo.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
					<cfset Session.UserSuppliedInfo.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
					<cfset Session.UserSuppliedInfo.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
					<cfset Session.UserSuppliedInfo.EventAgenda = #GetSelectedEvent.EventAgenda#>
					<cfset Session.UserSuppliedInfo.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
					<cfset Session.UserSuppliedInfo.EventStrategies = #GetSelectedEvent.EventStrategies#>
					<cfset Session.UserSuppliedInfo.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
					<cfset Session.UserSuppliedInfo.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
					<cfset Session.UserSuppliedInfo.LocationType = #GetSelectedEvent.LocationType#>
					<cfset Session.UserSuppliedInfo.LocationID = #GetSelectedEvent.LocationID#>
					<cfset Session.UserSuppliedInfo.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
					<cfset Session.UserSuppliedInfo.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
					<cfset Session.UserSuppliedInfo.Presenters = #GetSelectedEvent.Presenters#>
					<cfset Session.UserSuppliedInfo.Facilitator = #GetSelectedEvent.Facilitator#>
					<cfset Session.UserSuppliedInfo.dateCreated = #GetSelectedEvent.dateCreated#>
					<cfset Session.UserSuppliedInfo.lastUpdated = #GetSelectedEvent.lastUpdated#>
					<cfset Session.UserSuppliedInfo.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
				</cflock>
			</cfif>
		<cfelseif isDefined("URL.EventID") and isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif Session.UserSuppliedInfo.GroupAreas.Dates EQ true>
				<cfset EventDate = #DateFormat(Session.UserSuppliedInfo.EventDate, "mm/dd/yyyy")#>
				<cfset RegistrationDeadline = #DateFormat(Session.UserSuppliedInfo.Registration_Deadline, "mm/dd/yyyy")#>

				<!--- Create Date Object from User Inputted Time from Event Start Time --->
				<cfset EventStartTime = #TimeFormat(Session.UserSuppliedInfo.Event_StartTime, "hh:mm tt")#>
				<cfset EventStartTimeHours = #ListFirst(EventStartTime, ":")#>
				<cfset EventStartTimeMinutes = #Left(ListLast(EventStartTime, ":"), 2)#>
				<cfset EventStartTimeAMPM = #Right(ListLast(EventStartTime, ":"), 2)#>
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
				<cfset EventEndTime = #TimeFormat(Session.UserSuppliedInfo.Event_EndTime, "hh:mm tt")#>
				<cfset EventEndTimeHours = #ListFirst(EventEndTime, ":")#>
				<cfset EventEndTimeMinutes = #Left(ListLast(EventEndTime, ":"), 2)#>
				<cfset EventEndTimeAMPM = #Right(ListLast(EventEndTime, ":"), 2)#>
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

				<!--- Create Date Object from User Inputted Time from Registration End Time --->
				<cfset EventRegistrationEndTime = #TimeFormat(Session.UserSuppliedInfo.Registration_EndTime, "hh:mm tt")#>
				<cfset EventRegistrationEndTimeHours = #ListFirst(EventRegistrationEndTime, ":")#>
				<cfset EventRegistrationEndTimeMinutes = #Left(ListLast(EventRegistrationEndTime, ":"), 2)#>
				<cfset EventRegistrationEndTimeAMPM = #Right(ListLast(EventRegistrationEndTime, ":"), 2)#>
				<cfif EventRegistrationEndTimeAMPM EQ "PM">
					<cfswitch expression="#Variables.EventRegistrationEndTimeHours#">
						<cfcase value="12">
							<cfset EventRegistrationEndTimeHours = #Variables.EventRegistrationEndTimeHours#>
						</cfcase>
						<cfdefaultcase>
							<cfset EventRegistrationEndTimeHours = #Variables.EventRegistrationEndTimeHours# + 12>
						</cfdefaultcase>
					</cfswitch>
				</cfif>
				<cfset EventRegistrationEndTimeObject = #CreateTime(Variables.EventRegistrationEndTimeHours, Variables.EventRegistrationEndTimeMinutes, 0)#>

				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set EventDate = <cfqueryparam value="#CreateDate(ListLast(Variables.EventDate, '/'), ListFirst(Variables.EventDate, '/'), ListGetAt(Variables.EventDate, 2, '/'))#" cfsqltype="cf_sql_date">,
							Registration_Deadline = <cfqueryparam value="#CreateDate(ListLast(Variables.RegistrationDeadline, '/'), ListFirst(Variables.RegistrationDeadline, '/'), ListGetAt(Variables.RegistrationDeadline, 2, '/'))#" cfsqltype="cf_sql_date">,
							Event_StartTime = <cfqueryparam value="#Session.UserSuppliedInfo.Event_StartTime#" cfsqltype="cf_sql_time">,
							Event_EndTime = <cfqueryparam value="#Session.UserSuppliedInfo.Event_EndTime#" cfsqltype="cf_sql_time">,
							Registration_EndTime = #Variables.EventRegistrationEndTimeObject#,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfif LEN(Session.UserSuppliedInfo.Registration_BeginTime) GT 3>
						<cfset EventRegistrationBeginTime = #TimeFormat(Session.UserSuppliedInfo.Registration_BeginTime, "hh:mm tt")#>
						<!--- Create Date Object from User Inputted Time from Registration End Time --->
						<cfset EventRegistrationBeginTimeHours = #ListFirst(EventRegistrationBeginTime, ":")#>
						<cfset EventRegistrationBeginTimeMinutes = #Left(ListLast(EventRegistrationBeginTime, ":"), 2)#>
						<cfset EventRegistrationBeginTimeAMPM = #Right(ListLast(EventRegistrationBeginTime, ":"), 2)#>
						<cfif EventRegistrationBeginTimeAMPM EQ "PM">
							<cfswitch expression="#Variables.EventRegistrationBeginTimeHours#">
								<cfcase value="12">
									<cfset EventRegistrationBeginTimeHours = #Variables.EventRegistrationBeginTimeHours#>
								</cfcase>
								<cfdefaultcase>
									<cfset EventRegistrationBeginTimeHours = #Variables.EventRegistrationBeginTimeHours# + 12>
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<cfset EventRegistrationBeginTimeObject = #CreateTime(Variables.EventRegistrationBeginTimeHours, Variables.EventRegistrationBeginTimeMinutes, 0)#>

						<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set Registration_BeginTime = #Variables.EventRegistrationBeginTimeObject#
							Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif Session.UserSuppliedInfo.EventSpanDates EQ 0>
						<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDate1 = null,
								EventDate2 = null,
								EventDate3 = null,
								EventDate4 = null,
								lastUpdated = #Now()#,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
						</cfquery>
					<cfelseif Session.UserSuppliedInfo.EventSpanDates EQ 1>
						<cfif Len("Session.UserSuppliedInfo.EventDate1")>
							<cfif #isDate(Session.UserSuppliedInfo.EventDate1)# EQ 1>
								<cfset EventDate1 = #DateFormat(Session.UserSuppliedInfo.EventDate1, "mm/dd/yyyy")#>
								<cfquery name="updateEventDate1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update eEvents
									Set EventDate1 = #CreateDate(ListLast(Variables.EventDate1, "/"), ListFirst(Variables.EventDate1, "/"), ListGetAt(Variables.EventDate1, 2, "/"))#
									Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
						</cfif>

						<cfif isDefined("Session.UserSuppliedInfo.EventDate2")>
							<cfif #isDate(Session.UserSuppliedInfo.EventDate2)# EQ 1>
								<cfset EventDate2 = #DateFormat(Session.UserSuppliedInfo.EventDate2, "mm/dd/yyyy")#>
								<cfquery name="updateEventDate2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update eEvents
									Set EventDate2 = #CreateDate(ListLast(Variables.EventDate2, "/"), ListFirst(Variables.EventDate2, "/"), ListGetAt(Variables.EventDate2, 2, "/"))#
									Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
						</cfif>

						<cfif isDefined("Session.UserSuppliedInfo.EventDate3")>
							<cfif #isDate(Session.UserSuppliedInfo.EventDate3)# EQ 1>
								<cfset EventDate3 = #DateFormat(Session.UserSuppliedInfo.EventDate3, "mm/dd/yyyy")#>
								<cfquery name="updateEventDate3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update eEvents
									Set EventDate3 = #CreateDate(ListLast(Variables.EventDate3, "/"), ListFirst(Variables.EventDate3, "/"), ListGetAt(Variables.EventDate3, 2, "/"))#
									Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
						</cfif>

						<cfif isDefined("Session.UserSuppliedInfo.EventDate4")>
							<cfif #isDate(Session.UserSuppliedInfo.EventDate4)# EQ 1>
								<cfset EventDate4 = #DateFormat(Session.UserSuppliedInfo.EventDate4, "mm/dd/yyyy")#>
								<cfquery name="updateEventDate4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update eEvents
									Set EventDate4 = #CreateDate(ListLast(Variables.EventDate4, "/"), ListFirst(Variables.EventDate4, "/"), ListGetAt(Variables.EventDate4, 2, "/"))#
									Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
						</cfif>
					</cfif>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.Description EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set ShortTitle = <cfqueryparam value="#Session.UserSuppliedInfo.ShortTitle#" cfsqltype="cf_sql_varchar">,
							LongDescription = <cfqueryparam value="#Session.UserSuppliedInfo.LongDescription#" cfsqltype="cf_sql_varchar">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.Details EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfif isDefined("Session.UserSuppliedInfo.EventAgenda")>
						<cfif LEN(Session.UserSuppliedInfo.EventAgenda)>
							<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventAgenda = <cfqueryparam value="#Session.UserSuppliedInfo.EventAgenda#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventTargetAudience")>
						<cfif LEN(Session.UserSuppliedInfo.EventTargetAudience)>
							<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventTargetAudience = <cfqueryparam value="#Session.UserSuppliedInfo.EventTargetAudience#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventStrategies")>
						<cfif LEN(Session.UserSuppliedInfo.EventStrategies)>
							<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventStrategies = <cfqueryparam value="#Session.UserSuppliedInfo.EventStrategies#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventSpecialInstructions")>
						<cfif LEN(Session.UserSuppliedInfo.EventSpecialInstructions)>
							<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventSpecialInstructions = <cfqueryparam value="#Session.UserSuppliedInfo.EventSpecialInstructions#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.Speakers EQ true>

			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.Pricing EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set MemberCost = <cfqueryparam value="#Session.UserSuppliedInfo.MemberCost#" cfsqltype="cf_sql_money">,
							NonMemberCost = <cfqueryparam value="#Session.UserSuppliedInfo.NonMemberCost#" cfsqltype="cf_sql_money">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.SpecialPricing EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set ViewSpecialPricing = <cfqueryparam value="#Session.UserSuppliedInfo.ViewSpecialPricing#" cfsqltype="cf_sql_bit">,
							SpecialMemberCost = "#Session.UserSuppliedInfo.SpecialMemberCost#",
							SpecialNonMemberCost = "#Session.UserSuppliedInfo.SpecialNonMemberCost#",
							SpecialPriceRequirements = "#Session.UserSuppliedInfo.SpecialPriceRequirements#",
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.Featured EQ true>
				<cfset FeaturedStartDate = #DateFormat(Session.UserSuppliedInfo.Featured_StartDate, "mm/dd/yyyy")#>
				<cfset FeaturedEndDate = #DateFormat(Session.UserSuppliedInfo.Featured_EndDate, "mm/dd/yyyy")#>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set EventFeatured = <cfqueryparam value="#Session.UserSuppliedInfo.EventFeatured#" cfsqltype="cf_sql_bit">,
							Featured_StartDate = #CreateDate(ListLast(Variables.FeaturedStartDate, "/"), ListFirst(Variables.FeaturedStartDate, "/"), ListGetAt(Variables.FeaturedStartDate, 2, "/"))#,
							Featured_EndDate = #CreateDate(ListLast(Variables.FeaturedEndDate, "/"), ListFirst(Variables.FeaturedEndDate, "/"), ListGetAt(Variables.FeaturedEndDate, 2, "/"))#,
							Featured_SortOrder = <cfqueryparam value="#Session.UserSuppliedInfo.Featured_SortOrder#" cfsqltype="cf_sql_integer">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.EarlyBird EQ true>
				<cfset RegistrationDeadline = #DateFormat(Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline, "mm/dd/yyyy")#>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set EarlyBird_RegistrationAvailable = <cfqueryparam value="#Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
							EarlyBird_RegistrationDeadline = #CreateDate(ListLast(Variables.RegistrationDeadline, "/"), ListFirst(Variables.RegistrationDeadline, "/"), ListGetAt(Variables.RegistrationDeadline, 2, "/"))#,
							EarlyBird_MemberCost = "#Session.UserSuppliedInfo.EarlyBird_MemberCost#",
							EarlyBird_NonMemberCost = "#Session.UserSuppliedInfo.EarlyBird_NonMemberCost#",
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.PGP EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set PGPAvailable = <cfqueryparam value="#Session.UserSuppliedInfo.PGPAvailable#" cfsqltype="cf_sql_bit">,
							PGPPoints = <cfqueryparam value="#Session.UserSuppliedInfo.PGPPoints#" cfsqltype="cf_sql_DECIMAL">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.Meals EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set MealProvided = <cfqueryparam value="#Session.UserSuppliedInfo.MealProvided#" cfsqltype="cf_sql_bit">,
							MealCost_Estimated = <cfqueryparam value="#Session.UserSuppliedInfo.MealCost_Estimated#" cfsqltype="CF_SQL_MONEY">,
							MealProvidedBy = <cfqueryparam value="#Session.UserSuppliedInfo.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.IVC EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set AllowVideoConference = <cfqueryparam value="#Session.UserSuppliedInfo.AllowVideoConference#" cfsqltype="cf_sql_bit">,
							VideoConferenceInfo = <cfqueryparam value="#Session.UserSuppliedInfo.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
							VideoConferenceCost = <cfqueryparam value="#Session.UserSuppliedInfo.VideoConferenceCost#" cfsqltype="CF_SQL_MONEY">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.MeetingRooms EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set LocationType = <cfqueryparam value="#Session.UserSuppliedInfo.LocationType#" cfsqltype="cf_sql_varchar">,
							LocationID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationID#" cfsqltype="cf_sql_integer">,
							LocationRoomID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationRoomID#" cfsqltype="cf_sql_integer">,
							MaxParticipants = <cfqueryparam value="#Session.UserSuppliedInfo.RoomMaxParticipants#" cfsqltype="cf_sql_integer">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.AcceptRegistrations NEQ FORM.AcceptRegistrations>
				<cfset Session.UserSuppliedInfo.GroupAreas.Registrations = true>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.Registrations EQ true>
				<cftry>
					<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set AcceptRegistrations = <cfqueryparam value="#FORM.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
			</cfif>

			<cfif Session.UserSuppliedInfo.GroupAreas.Dates eq true or Session.UserSuppliedInfo.GroupAreas.Description eq true or
				Session.UserSuppliedInfo.GroupAreas.Details eq true or Session.UserSuppliedInfo.GroupAreas.Speakers eq true or
				Session.UserSuppliedInfo.GroupAreas.Pricing eq true or Session.UserSuppliedInfo.GroupAreas.SpecialPricing eq true or
				Session.UserSuppliedInfo.GroupAreas.EarlyBird eq true or Session.UserSuppliedInfo.GroupAreas.PGP eq true or
				Session.UserSuppliedInfo.GroupAreas.Meals eq true or Session.UserSuppliedInfo.GroupAreas.IVC eq true or
				Session.UserSuppliedInfo.GroupAreas.MeetingRooms eq true or Session.UserSuppliedInfo.GroupAreas.Registrations eq true>

				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "UserSuppliedInfo", "True")#>
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=UpdatedEvent&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "UserSuppliedInfo", "True")#>
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>
		<cfelse>

		</cfif>
	</cffunction>

	<cffunction name="updateevent_datetime" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("Session.UserSuppliedInfo.RecNo")>

		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo.EventDate = #FORM.EventDate#>
				<cfset Session.UserSuppliedInfo.Registration_Deadline = #FORM.Registration_Deadline#>
				<cfset Session.UserSuppliedInfo.Registration_BeginTime = #FORM.Registration_BeginTime#>
				<cfset Session.UserSuppliedInfo.Event_StartTime = #FORM.Event_StartTime#>
				<cfset Session.UserSuppliedInfo.Event_EndTime = #FORM.Event_EndTime#>
				<cfset Session.UserSuppliedInfo.EventSpanDates = #FORM.EventSpanDates#>
			</cflock>

			<cfif FORM.EventSpanDates EQ 0>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.UserSuppliedInfo.EventDate1 = "">
					<cfset Session.UserSuppliedInfo.EventDate2 = "">
					<cfset Session.UserSuppliedInfo.EventDate3 = "">
					<cfset Session.UserSuppliedInfo.EventDate4 = "">
				</cflock>

				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
				</cflock>
				<cfset Session.UserSuppliedInfo.GroupAreas.Dates = true>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelseif FORM.EventSpanDates EQ 1>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.FormErrors = #ArrayNew()#>
				</cflock>
				<cfif not isDefined("FORM.EventDate1")>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_datetime&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
				</cfif>
				<cfif LEN(FORM.EventDate1) EQ 0 AND LEN(FORM.EventDate2) EQ 0 AND LEN(FORM.EventDate3) EQ 0 AND LEN(FORM.EventDate4) EQ 0>
					<cfscript>
						errormsg = {property="EventDate1",message="Please Select additional date for event, or change Span Dates to No"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfscript>
						errormsg = {property="EventDate2",message="Please Select additional date for event, or change Span Dates to No"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfscript>
						errormsg = {property="EventDate3",message="Please Select additional date for event, or change Span Dates to No"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfscript>
						errormsg = {property="EventDate4",message="Please Select additional date for event, or change Span Dates to No"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_datetime&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
				</cfif>

				<cfif LEN(FORM.EventDate1) EQ 0 AND LEN(FORM.EventDate2) GT 0 AND LEN(FORM.EventDate3) EQ 0 AND LEN(FORM.EventDate4) EQ 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate2#>
					<cfset FORM.EventDate1 = #FORM.EventDate2#>
				</cfif>

				<cfif LEN(FORM.EventDate1) EQ 0 AND LEN(FORM.EventDate2) EQ 0 AND LEN(FORM.EventDate3) GT 0 AND LEN(FORM.EventDate4) EQ 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate3#>
					<cfset FORM.EventDate1 = #FORM.EventDate3#>
				</cfif>

				<cfif LEN(FORM.EventDate1) EQ 0 AND LEN(FORM.EventDate2) EQ 0 AND LEN(FORM.EventDate3) EQ 0 AND LEN(FORM.EventDate4) GT 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate4#>
					<cfset FORM.EventDate1 = #FORM.EventDate4#>
				</cfif>

				<cfif LEN(FORM.EventDate1) EQ 0 AND LEN(FORM.EventDate2) GT 0 AND LEN(FORM.EventDate3) GT 0 AND LEN(FORM.EventDate4) EQ 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate2#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate3#>
					<cfset FORM.EventDate1 = #FORM.EventDate2#>
				</cfif>

				<cfif LEN(FORM.EventDate1) EQ 0 AND LEN(FORM.EventDate2) EQ 0 AND LEN(FORM.EventDate3) GT 0 AND LEN(FORM.EventDate4) GT 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate3#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate4#>
					<cfset FORM.EventDate1 = #FORM.EventDate3#>
				</cfif>

				<cfif LEN(FORM.EventDate1) EQ 0 AND LEN(FORM.EventDate2) GT 0 AND LEN(FORM.EventDate3) EQ 0 AND LEN(FORM.EventDate4) GT 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate2#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate4#>
					<cfset FORM.EventDate1 = #FORM.EventDate2#>
				</cfif>

				<cfif LEN(FORM.EventDate1) EQ 0 AND LEN(FORM.EventDate2) GT 0 AND LEN(FORM.EventDate3) GT 0 AND LEN(FORM.EventDate4) GT 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate2#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate3#>
					<cfset Session.UserSuppliedInfo.EventDate3 = #FORM.EventDate4#>
					<cfset FORM.EventDate1 = #FORM.EventDate2#>
				</cfif>

				<cfif LEN(FORM.EventDate1) GT 0 AND LEN(FORM.EventDate2) GT 0 AND LEN(FORM.EventDate3) EQ 0 AND LEN(FORM.EventDate4) EQ 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate1#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate2#>
				</cfif>

				<cfif LEN(FORM.EventDate1) GT 0 AND LEN(FORM.EventDate2) GT 0 AND LEN(FORM.EventDate3) GT 0 AND LEN(FORM.EventDate4) EQ 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate1#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate2#>
					<cfset Session.UserSuppliedInfo.EventDate3 = #FORM.EventDate3#>
				</cfif>

				<cfif LEN(FORM.EventDate1) GT 0 AND LEN(FORM.EventDate2) GT 0 AND LEN(FORM.EventDate3) GT 0 AND LEN(FORM.EventDate4) GT 0>
					<cfset Session.UserSuppliedInfo.EventDate1 = #FORM.EventDate1#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #FORM.EventDate2#>
					<cfset Session.UserSuppliedInfo.EventDate3 = #FORM.EventDate3#>
					<cfset Session.UserSuppliedInfo.EventDate4 = #FORM.EventDate4#>
				</cfif>

				<cfif ArrayLen(Session.FormErrors)>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_datetime&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
				<cfelse>
					<cflock timeout="60" scope="Session" type="Exclusive">
						<cfset temp = #StructDelete(Session, "FormData", "True")#>
						<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
						<cfset Session.UserSuppliedInfo.GroupAreas.Dates = true>
					</cflock>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_description" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif LEN(FORM.ShortTitle) EQ 0>
				<cfset Session.UserSuppliedInfo.ShortTitle = #FORM.ShortTitle#>
				<cfscript>
					errormsg = {property="ShortTitle",message="Please Enter a Short Title for this Event"};
					arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
			<cfelse>
				<cfset Session.UserSuppliedInfo.ShortTitle = #FORM.ShortTitle#>
			</cfif>
			<cfif LEN(FORM.LongDescription) EQ 0>
				<cfset Session.UserSuppliedInfo.LongDescription = #FORM.LongDescription#>
				<cfscript>
					errormsg = {property="LongDescription",message="Please Enter a Description for this Event"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelse>
				<cfset Session.UserSuppliedInfo.LongDescription = #FORM.LongDescription#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_description&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.Description = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_details" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif LEN(FORM.EventAgenda)>
				<cfset Session.UserSuppliedInfo.EventAgenda = #FORM.EventAgenda#>
			</cfif>

			<cfif LEN(FORM.EventTargetAudience)>
				<cfset Session.UserSuppliedInfo.EventTargetAudience = #FORM.EventTargetAudience#>
			</cfif>

			<cfif LEN(FORM.EventStrategies)>
				<cfset Session.UserSuppliedInfo.EventStrategies = #FORM.EventStrategies#>
			</cfif>

			<cfif LEN(FORM.EventSpecialInstructions)>
				<cfset Session.UserSuppliedInfo.EventSpecialInstructions = #FORM.EventSpecialInstructions#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_details&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.Details = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_pricing" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif LEN(FORM.MemberCost) EQ 0>
				<cfset Session.UserSuppliedInfo.MemberCost = 0>
			<cfelse>
				<cfset Session.UserSuppliedInfo.MemberCost = #FORM.MemberCost#>
			</cfif>

			<cfif LEN(FORM.NonMemberCost) EQ 0>
				<cfset Session.UserSuppliedInfo.NonMemberCost = 0>
			<cfelse>
				<cfset Session.UserSuppliedInfo.NonMemberCost = #FORM.NonMemberCost#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_pricing&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.Pricing = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_specialprice" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif FORM.ViewSpecialPricing EQ 1 and LEN(FORM.SpecialPriceRequirements) EQ 0>
				<cfscript>
					errormsg = {property="SpecialPriceRequirements",message="Please Enter Special Requirements for Special Pricing of this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			</cfif>

			<cfif LEN(FORM.ViewSpecialPricing)>
				<cfset Session.UserSuppliedInfo.ViewSpecialPricing = #FORM.ViewSpecialPricing#>
			</cfif>

			<cfif LEN(FORM.SpecialMemberCost)>
				<cfset Session.UserSuppliedInfo.SpecialMemberCost = #FORM.SpecialMemberCost#>
			</cfif>

			<cfif LEN(FORM.SpecialNonMemberCost)>
				<cfset Session.UserSuppliedInfo.SpecialNonMemberCost = #FORM.SpecialNonMemberCost#>
			</cfif>

			<cfif LEN(FORM.SpecialPriceRequirements)>
				<cfset Session.UserSuppliedInfo.SpecialPriceRequirements = #FORM.SpecialPriceRequirements#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_specialprice&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.SpecialPricing = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_featured" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif FORM.EventFeatured EQ 1 and not isDefined("FORM.Featured_StartDate") and not isDefined("FORM.Featured_EndDate")>
				<cfif not isDefined("FORM.Featured_StartDate")>
					<cfscript>
						errormsg = {property="Featured_StartDate",message="Please Enter Start Date for this event to be featured."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cfif>

				<cfif not isDefined("FORM.Featured_EndDate")>
					<cfscript>
						errormsg = {property="Featured_EndDate",message="Please Enter Ending Date for this event to be featured."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cfif>
			<cfelseif FORM.EventFeatured EQ 1 and isDefined("FORM.Featured_StartDate") and isDefined("FORM.Featured_EndDate")>
				<cfif LEN(FORM.Featured_StartDate)>
					<cfset Session.UserSuppliedInfo.Featured_StartDate = #FORM.Featured_StartDate#>
				<cfelse>
					<cfscript>
						errormsg = {property="Featured_StartDate",message="Please Enter Start Date for this event to be featured."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cfif>

				<cfif LEN(FORM.Featured_EndDate)>
					<cfset Session.UserSuppliedInfo.Featured_EndDate = #FORM.Featured_EndDate#>
				<cfelse>
					<cfscript>
						errormsg = {property="Featured_EndDate",message="Please Enter Ending Date for this event to be featured."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cfif>
				<cfset Session.UserSuppliedInfo.EventFeatured = #FORM.EventFeatured#>
			<cfelse>
				<cfset Session.UserSuppliedInfo.EventFeatured = #FORM.EventFeatured#>
				<cfset Session.UserSuppliedInfo.Featured_EndDate = #FORM.Featured_EndDate#>
				<cfset Session.UserSuppliedInfo.Featured_StartDate = #FORM.Featured_StartDate#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_featured&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.Featured = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_earlybirdinfo" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable = #FORM.EarlyBird_RegistrationAvailable#>

			<cfif FORM.EarlyBird_RegistrationAvailable EQ 1 and not isDefined("FORM.EarlyBird_RegistrationDeadline")>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_earlybirdinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelseif FORM.EarlyBird_RegistrationAvailable EQ 1 and not isDefined("FORM.EarlyBird_MemberCost")>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_earlybirdinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelseif FORM.EarlyBird_RegistrationAvailable EQ 1 and not isDefined("FORM.EarlyBird_NonMemberCost")>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_earlybirdinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>

			<cfif FORM.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_RegistrationDeadline) EQ 0>
				<cfscript>
					errormsg = {property="EarlyBird_RegistrationDeadline",message="Please Enter Deadline Date for Early Bird Registrations."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelseif FORM.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_MemberCost) EQ 0>
				<cfscript>
					errormsg = {property="EarlyBird_MemberCost",message="Please Enter Amount to attend for Early Bird Registrations"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelseif FORM.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_NonMemberCost) EQ 0>
				<cfscript>
					errormsg = {property="EarlyBird_NonMemberCost",message="Please Enter Amount to attend for Early Bird Registrations"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelse>
				<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = #FORM.EarlyBird_RegistrationDeadline#>
				<cfset Session.UserSuppliedInfo.EarlyBird_MemberCost = #FORM.EarlyBird_MemberCost#>
				<cfset Session.UserSuppliedInfo.EarlyBird_NonMemberCost = #FORM.EarlyBird_NonMemberCost#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_earlybirdinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.EarlyBird = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_pgppoints" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif FORM.PGPAvailable EQ 0>
				<cfset Session.UserSuppliedInfo.PGPAvailable = #FORM.PGPAvailable#>
				<cfset Session.UserSuppliedInfo.PGPPoints = "">
			</cfif>

			<cfif FORM.PGPAvailable EQ 1 and not isDefined("FORM.PGPPoints")>
				<cfset Session.UserSuppliedInfo.PGPAvailable = #FORM.PGPAvailable#>
				<cfscript>
					errormsg = {property="PGPPoints",message="PGP Points are available; However no PGP Points were entered. How many Points will be awarded for this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelseif FORM.PGPAvailable EQ 1 and LEN(FORM.PGPPoints) EQ 0>
				<cfset Session.UserSuppliedInfo.PGPAvailable = #FORM.PGPAvailable#>
				<cfscript>
					errormsg = {property="PGPPoints",message="PGP Points are available; However no PGP Points were entered. How many Points will be awarded for this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelseif FORM.PGPAvailable EQ 1 and FORM.PGPPoints EQ Trim("0.00")>
				<cfset Session.UserSuppliedInfo.PGPAvailable = #FORM.PGPAvailable#>
				<cfscript>
					errormsg = {property="PGPPoints",message="PGP Points are available; However 0.00 PGP Points were entered. How many Points will be awarded for this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelse>
				<cfset Session.UserSuppliedInfo.PGPAvailable = #FORM.PGPAvailable#>
				<cfset Session.UserSuppliedInfo.PGPPoints = #FORM.PGPPoints#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_pgppoints&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.PGP = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_mealinfo" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif FORM.MealProvided EQ 0>
				<cfset Session.UserSuppliedInfo.MealProvided = #FORM.MealProvided#>
				<cfset Session.UserSuppliedInfo.MealCost_Estimated = 0>
				<cfset Session.UserSuppliedInfo.MealProvidedBy = "No Meal Provided">
			</cfif>

			<cfif FORM.MealProvided EQ 1 and FORM.MealProvidedBy EQ 0>
				<cfset Session.UserSuppliedInfo.MealProvided = #FORM.MealProvided#>
				<cfset Session.UserSuppliedInfo.MealCost_Estimated = 0>
				<cfset Session.UserSuppliedInfo.MealProvidedBy = #FORM.MealProvidedBy#>
			<cfelse>
				<cfset Session.UserSuppliedInfo.MealProvided = #FORM.MealProvided#>
				<cfset Session.UserSuppliedInfo.MealCost_Estimated = #FORM.MealCost_Estimated#>
				<cfset Session.UserSuppliedInfo.MealProvidedBy = #FORM.MealProvidedBy#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_mealinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.Meals = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_ivcinfo" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif FORM.AllowVideoConference EQ 0>
				<cfset Session.UserSuppliedInfo.AllowVideoConference = #FORM.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.VideoConferenceInfo = "">
				<cfset Session.UserSuppliedInfo.VideoConferenceCost = 0>
			<cfelseif FORM.AllowVideoConference EQ 1 and LEN(FORM.VideoConferenceInfo) EQ 0>
				<cfset Session.UserSuppliedInfo.AllowVideoConference = #FORM.AllowVideoConference#>
				<cfscript>
					errormsg = {property="VideoConferenceInfo",message="Please add Information for users regarding this option to this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelseif FORM.AllowVideoConference EQ 1 and LEN(FORM.VideoConferenceInfo) GT 0 and TRIM(FORM.VideoConferenceCost) EQ "0.00">
				<cfset Session.UserSuppliedInfo.AllowVideoConference = #FORM.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.VideoConferenceInfo = #FORM.VideoConferenceInfo#>
				<cfset Session.UserSuppliedInfo.VideoConferenceCost = 0>
				<cfscript>
					errormsg = {property="VideoConferenceCost",message="Current Cost is $0.00; Ideal Amount is 350% higher than Member Cost to Attend."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
			<cfelse>
				<cfset Session.UserSuppliedInfo.AllowVideoConference = #FORM.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.VideoConferenceInfo = #FORM.VideoConferenceInfo#>
				<cfset Session.UserSuppliedInfo.VideoConferenceCost = #FORM.VideoConferenceCost#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_ivcinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.IVC = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_facilityinfo" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>

			<cfif FORM.FormStep EQ 1>
				<cfset Session.UserSuppliedInfo.LocationType = #FORM.LocationType#>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_facilityinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update&FormStep=1" addtoken="false">
			<cfelseif FORM.FormStep EQ 2>
				<cfif FORM.LocationID EQ 0>
					<cfscript>
						errormsg = {property="LocationID",message="Please Select Location for this event to be held."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_facilityinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update&FormStep=1" addtoken="false">
				</cfif>
				<cfset Session.UserSuppliedInfo.LocationID = #FORM.LocationID#>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_facilityinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update&FormStep=2" addtoken="false">
			<cfelseif FORM.FormStep EQ 3>
				<cfif not isDefined("FORM.LocationRoomID")>
					<cfscript>
						errormsg = {property="LocationRoomID",message="Please Select a Room for this event to be held."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_facilityinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update&FormStep=2" addtoken="false">
				</cfif>
				<cfif FORM.LocationRoomID EQ 0>
					<cfset Session.UserSuppliedInfo.LocationRoomID = #FORM.LocationRoomID#>
					<cfscript>
						errormsg = {property="LocationRoomID",message="Please Select a Room for this event to be held."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_facilityinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update&FormStep=2" addtoken="false">
				<cfelse>
					<cfset Session.UserSuppliedInfo.LocationRoomID = #FORM.LocationRoomID#>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_facilityinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update&FormStep=3" addtoken="false">
				</cfif>
			<cfelseif FORM.FormStep EQ 4>
				<cfif FORM.RoomMaxParticipants EQ 0>
					<cfscript>
						errormsg = {property="RoomMaxParticipants",message="It does not make sense to have an event with 0 participants? Please correct this field."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_facilityinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update&FormStep=3" addtoken="false">
				<cfelse>
					<cfset Session.UserSuppliedInfo.RoomMaxParticipants = #FORM.RoomMaxParticipants#>
				</cfif>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_facilityinfo&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset temp = #StructDelete(Session, "FormData", "True")#>
					<cfset temp = #StructDelete(Session, "FormErrors", "True")#>
					<cfset Session.UserSuppliedInfo.GroupAreas.MeetingRooms = true>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.updateevent_review&EventID=#Session.UserSuppliedInfo.RecNo#&EventStatus=Update" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="copypriorevent" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("URL.EventStatus")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetSelectedEvent.RecordCount EQ 0>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.UserSuppliedInfo = StructNew()>
					<cfset Session.UserSuppliedInfo.RecNo = #GetSelectedEvent.TContent_ID#>
					<cfset Session.UserSuppliedInfo.ShortTitle = #GetSelectedEvent.ShortTitle#>
					<cfset Session.UserSuppliedInfo.EventDate = #GetSelectedEvent.EventDate#>
					<cfset Session.UserSuppliedInfo.EventDate1 = #GetSelectedEvent.EventDate1#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #GetSelectedEvent.EventDate2#>
					<cfset Session.UserSuppliedInfo.EventDate3 = #GetSelectedEvent.EventDate3#>
					<cfset Session.UserSuppliedInfo.EventDate4 = #GetSelectedEvent.EventDate4#>
					<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4)>
						<cfset Session.UserSuppliedInfo.EventSpanDates = 1>
					<cfelse>
						<cfset Session.UserSuppliedInfo.EventSpanDates = 0>
					</cfif>
					<cfset Session.UserSuppliedInfo.LongDescription = #GetSelectedEvent.LongDescription#>
					<cfset Session.UserSuppliedInfo.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
					<cfset Session.UserSuppliedInfo.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
					<cfset Session.UserSuppliedInfo.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
					<cfset Session.UserSuppliedInfo.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
					<cfset Session.UserSuppliedInfo.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
					<cfset Session.UserSuppliedInfo.EventFeatured = #GetSelectedEvent.EventFeatured#>
					<cfset Session.UserSuppliedInfo.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
					<cfset Session.UserSuppliedInfo.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
					<cfset Session.UserSuppliedInfo.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
					<cfset Session.UserSuppliedInfo.MemberCost = #GetSelectedEvent.MemberCost#>
					<cfset Session.UserSuppliedInfo.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
					<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
					<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
					<cfset Session.UserSuppliedInfo.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
					<cfset Session.UserSuppliedInfo.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
					<cfset Session.UserSuppliedInfo.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
					<cfset Session.UserSuppliedInfo.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
					<cfset Session.UserSuppliedInfo.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
					<cfset Session.UserSuppliedInfo.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
					<cfset Session.UserSuppliedInfo.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
					<cfset Session.UserSuppliedInfo.PGPPoints = #GetSelectedEvent.PGPPoints#>
					<cfset Session.UserSuppliedInfo.MealProvided = #GetSelectedEvent.MealProvided#>
					<cfset Session.UserSuppliedInfo.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
					<cfset Session.UserSuppliedInfo.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
					<cfset Session.UserSuppliedInfo.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
					<cfset Session.UserSuppliedInfo.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
					<cfset Session.UserSuppliedInfo.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
					<cfset Session.UserSuppliedInfo.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
					<cfset Session.UserSuppliedInfo.EventAgenda = #GetSelectedEvent.EventAgenda#>
					<cfset Session.UserSuppliedInfo.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
					<cfset Session.UserSuppliedInfo.EventStrategies = #GetSelectedEvent.EventStrategies#>
					<cfset Session.UserSuppliedInfo.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
					<cfset Session.UserSuppliedInfo.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
					<cfset Session.UserSuppliedInfo.LocationType = #GetSelectedEvent.LocationType#>
					<cfset Session.UserSuppliedInfo.LocationID = #GetSelectedEvent.LocationID#>
					<cfset Session.UserSuppliedInfo.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
					<cfset Session.UserSuppliedInfo.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
					<cfset Session.UserSuppliedInfo.Presenters = #GetSelectedEvent.Presenters#>
					<cfset Session.UserSuppliedInfo.Facilitator = #GetSelectedEvent.Facilitator#>
					<cfset Session.UserSuppliedInfo.dateCreated = #GetSelectedEvent.dateCreated#>
					<cfset Session.UserSuppliedInfo.lastUpdated = #GetSelectedEvent.lastUpdated#>
					<cfset Session.UserSuppliedInfo.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
				</cflock>
			</cfif>
		<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
			<cfif isDefined("FORM.FormSubmit") and isDefined("FORM.PerformAction")>
				<!--- Create Date Object from User Inputted Time from Event Start Time --->
				<cfset EventStartTime = #TimeFormat(Session.UserSuppliedInfo.Event_StartTime, "hh:mm tt")#>
				<cfset EventStartTimeHours = #ListFirst(EventStartTime, ":")#>
				<cfset EventStartTimeMinutes = #Left(ListLast(EventStartTime, ":"), 2)#>
				<cfset EventStartTimeAMPM = #Right(ListLast(EventStartTime, ":"), 2)#>
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
				<cfset EventEndTime = #TimeFormat(Session.UserSuppliedInfo.Event_EndTime, "hh:mm tt")#>
				<cfset EventEndTimeHours = #ListFirst(EventEndTime, ":")#>
				<cfset EventEndTimeMinutes = #Left(ListLast(EventEndTime, ":"), 2)#>
				<cfset EventEndTimeAMPM = #Right(ListLast(EventEndTime, ":"), 2)#>
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

				<!--- Create Date Object from User Inputted Time from Registration End Time --->
				<cfset EventRegistrationEndTime = #TimeFormat(Session.UserSuppliedInfo.Registration_EndTime, "hh:mm tt")#>
				<cfset EventRegistrationEndTimeHours = #ListFirst(EventRegistrationEndTime, ":")#>
				<cfset EventRegistrationEndTimeMinutes = #Left(ListLast(EventRegistrationEndTime, ":"), 2)#>
				<cfset EventRegistrationEndTimeAMPM = #Right(ListLast(EventRegistrationEndTime, ":"), 2)#>
				<cfif EventRegistrationEndTimeAMPM EQ "PM">
					<cfswitch expression="#Variables.EventRegistrationEndTimeHours#">
						<cfcase value="12">
							<cfset EventRegistrationEndTimeHours = #Variables.EventRegistrationEndTimeHours#>
						</cfcase>
						<cfdefaultcase>
							<cfset EventRegistrationEndTimeHours = #Variables.EventRegistrationEndTimeHours# + 12>
						</cfdefaultcase>
					</cfswitch>
				</cfif>
				<cfset EventRegistrationEndTimeObject = #CreateTime(Variables.EventRegistrationEndTimeHours, Variables.EventRegistrationEndTimeMinutes, 0)#>

				<cfset EventDate = #DateFormat(Session.UserSuppliedInfo.EventDate, "mm/dd/yyyy")#>
				<cfset RegistrationDeadline = #DateFormat(Session.UserSuppliedInfo.Registration_Deadline, "mm/dd/yyyy")#>
				<cfset Session.UserSuppliedInfo.ShortTitle = #Session.UserSuppliedInfo.ShortTitle# & " - Copied">

				<cftry>
					<cfquery name="insertCopiedEvent" result="insertCopiedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into eEvents(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_EndTime, EventFeatured, MemberCost, NonMemberCost, EarlyBird_RegistrationAvailable, ViewSpecialPricing, PGPAvailable, MealProvided, AllowVideoConference, AcceptRegistrations, LocationType, LocationID, LocationRoomID, MaxParticipants, Facilitator, dateCreated)
						Values ("#rc.$.siteConfig('siteID')#", "#Session.UserSuppliedInfo.ShortTitle#", #CreateDate(ListLast(Variables.EventDate, "/"), ListFirst(Variables.EventDate, "/"), ListGetAt(Variables.EventDate, 2, "/"))#, "#Session.UserSuppliedInfo.LongDescription#", #Variables.EventStartTimeObject#, #Variables.EventEndTimeObject#, #CreateDate(ListLast(Variables.RegistrationDeadline, "/"), ListFirst(Variables.RegistrationDeadline, "/"), ListGetAt(Variables.RegistrationDeadline, 2, "/"))#, #Variables.EventRegistrationEndTimeObject#, #Session.UserSuppliedInfo.EventFeatured#, "#Session.UserSuppliedInfo.MemberCost#", "#Session.UserSuppliedInfo.NonMemberCost#", #Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable#, #Session.UserSuppliedInfo.ViewSpecialPricing#, #Session.UserSuppliedInfo.PGPAvailable#, #Session.UserSuppliedInfo.MealProvided#, #Session.UserSuppliedInfo.AllowVideoConference#, #Session.UserSuppliedInfo.AcceptRegistrations#, "#Session.UserSuppliedInfo.LocationType#", #Session.UserSuppliedInfo.LocationID#, #Session.UserSuppliedInfo.LocationRoomID#, #Session.UserSuppliedInfo.RoomMaxParticipants#, "#Session.UserSuppliedInfo.Facilitator#", #Now()# )
					</cfquery>

					<cfif isDefined("Session.UserSuppliedInfo.EventDate1")>
						<cfif #isDate(Session.UserSuppliedInfo.EventDate1)# EQ 1>
							<cfset EventDate1 = #DateFormat(Session.UserSuppliedInfo.EventDate1, "mm/dd/yyyy")#>
							<cfquery name="updateEventDate1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventDate1 = #CreateDate(ListLast(Variables.EventDate1, "/"), ListFirst(Variables.EventDate1, "/"), ListGetAt(Variables.EventDate1, 2, "/"))#
								Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventDate2")>
						<cfif #isDate(Session.UserSuppliedInfo.EventDate2)# EQ 1>
							<cfset EventDate2 = #DateFormat(Session.UserSuppliedInfo.EventDate2, "mm/dd/yyyy")#>
							<cfquery name="updateEventDate2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventDate2 = #CreateDate(ListLast(Variables.EventDate2, "/"), ListFirst(Variables.EventDate2, "/"), ListGetAt(Variables.EventDate2, 2, "/"))#
								Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventDate3")>
						<cfif #isDate(Session.UserSuppliedInfo.EventDate3)# EQ 1>
							<cfset EventDate3 = #DateFormat(Session.UserSuppliedInfo.EventDate3, "mm/dd/yyyy")#>
							<cfquery name="updateEventDate3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventDate3 = #CreateDate(ListLast(Variables.EventDate3, "/"), ListFirst(Variables.EventDate3, "/"), ListGetAt(Variables.EventDate3, 2, "/"))#
								Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventDate4")>
						<cfif #isDate(Session.UserSuppliedInfo.EventDate4)# EQ 1>
							<cfset EventDate4 = #DateFormat(Session.UserSuppliedInfo.EventDate4, "mm/dd/yyyy")#>
							<cfquery name="updateEventDate4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventDate4 = #CreateDate(ListLast(Variables.EventDate4, "/"), ListFirst(Variables.EventDate4, "/"), ListGetAt(Variables.EventDate4, 2, "/"))#
								Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventAgenda")>
						<cfif LEN(Session.UserSuppliedInfo.EventAgenda)>
							<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventAgenda = <cfqueryparam value="#Session.UserSuppliedInfo.EventAgenda#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventTargetAudience")>
						<cfif LEN(Session.UserSuppliedInfo.EventTargetAudience)>
							<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventTargetAudience = <cfqueryparam value="#Session.UserSuppliedInfo.EventTargetAudience#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventStrategies")>
						<cfif LEN(Session.UserSuppliedInfo.EventStrategies)>
							<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventStrategies = <cfqueryparam value="#Session.UserSuppliedInfo.EventStrategies#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.EventSpecialInstructions")>
						<cfif LEN(Session.UserSuppliedInfo.EventSpecialInstructions)>
							<cfquery name="updateEventAgenda" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventSpecialInstructions = <cfqueryparam value="#Session.UserSuppliedInfo.EventSpecialInstructions#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>
					</cfif>

					<cfif Session.UserSuppliedInfo.EventFeatured EQ 1>
						<cfset FeaturedStartDate = #DateFormat(Session.UserSuppliedInfo.Featured_StartDate, "mm/dd/yyyy")#>
						<cfset FeaturedEndDate = #DateFormat(Session.UserSuppliedInfo.Featured_EndDate, "mm/dd/yyyy")#>
						<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set Featured_StartDate = #CreateDate(ListLast(Variables.FeaturedStartDate, "/"), ListFirst(Variables.FeaturedStartDate, "/"), ListGetAt(Variables.FeaturedStartDate, 2, "/"))#,
								Featured_EndDate = #CreateDate(ListLast(Variables.FeaturedEndDate, "/"), ListFirst(Variables.FeaturedEndDate, "/"), ListGetAt(Variables.FeaturedEndDate, 2, "/"))#,
								Featured_SortOrder = <cfqueryparam value="#Session.UserSuppliedInfo.Featured_SortOrder#" cfsqltype="cf_sql_integer">
							Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1>
						<cfset RegistrationDeadline = #DateFormat(Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline, "mm/dd/yyyy")#>
						<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EarlyBird_RegistrationAvailable = <cfqueryparam value="#Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
								EarlyBird_RegistrationDeadline = #CreateDate(ListLast(Variables.RegistrationDeadline, "/"), ListFirst(Variables.RegistrationDeadline, "/"), ListGetAt(Variables.RegistrationDeadline, 2, "/"))#,
								EarlyBird_MemberCost = "#Session.UserSuppliedInfo.EarlyBird_MemberCost#",
								EarlyBird_NonMemberCost = "#Session.UserSuppliedInfo.EarlyBird_NonMemberCost#"
							Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1>
						<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set ViewSpecialPricing = <cfqueryparam value="#Session.UserSuppliedInfo.ViewSpecialPricing#" cfsqltype="cf_sql_bit">,
								SpecialMemberCost = "#Session.UserSuppliedInfo.SpecialMemberCost#",
								SpecialNonMemberCost = "#Session.UserSuppliedInfo.SpecialNonMemberCost#",
								SpecialPriceRequirements = "#Session.UserSuppliedInfo.SpecialPriceRequirements#"
							Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1>
						<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set PGPAvailable = <cfqueryparam value="#Session.UserSuppliedInfo.PGPAvailable#" cfsqltype="cf_sql_bit">,
								PGPPoints = <cfqueryparam value="#Session.UserSuppliedInfo.PGPPoints#" cfsqltype="cf_sql_DECIMAL">
							Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
						<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set MealCost_Estimated = <cfqueryparam value="#Session.UserSuppliedInfo.MealCost_Estimated#" cfsqltype="CF_SQL_MONEY">,
								MealProvidedBy = <cfqueryparam value="#Session.UserSuppliedInfo.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">
							Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1>
						<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set AllowVideoConference = <cfqueryparam value="#Session.UserSuppliedInfo.AllowVideoConference#" cfsqltype="cf_sql_bit">,
								VideoConferenceInfo = <cfqueryparam value="#Session.UserSuppliedInfo.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
								VideoConferenceCost = <cfqueryparam value="#Session.UserSuppliedInfo.VideoConferenceCost#" cfsqltype="CF_SQL_MONEY">
							Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif LEN(Session.UserSuppliedInfo.Registration_BeginTime) GT 3>
						<cfset EventRegistrationBeginTime = #TimeFormat(Session.UserSuppliedInfo.Registration_BeginTime, "hh:mm tt")#>
						<!--- Create Date Object from User Inputted Time from Registration End Time --->
						<cfset EventRegistrationBeginTimeHours = #ListFirst(EventRegistrationBeginTime, ":")#>
						<cfset EventRegistrationBeginTimeMinutes = #Left(ListLast(EventRegistrationBeginTime, ":"), 2)#>
						<cfset EventRegistrationBeginTimeAMPM = #Right(ListLast(EventRegistrationBeginTime, ":"), 2)#>
						<cfif EventRegistrationBeginTimeAMPM EQ "PM">
							<cfswitch expression="#Variables.EventRegistrationBeginTimeHours#">
								<cfcase value="12">
									<cfset EventRegistrationBeginTimeHours = #Variables.EventRegistrationBeginTimeHours#>
								</cfcase>
								<cfdefaultcase>
									<cfset EventRegistrationBeginTimeHours = #Variables.EventRegistrationBeginTimeHours# + 12>
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<cfset EventRegistrationBeginTimeObject = #CreateTime(Variables.EventRegistrationBeginTimeHours, Variables.EventRegistrationBeginTimeMinutes, 0)#>

						<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set Registration_BeginTime = #Variables.EventRegistrationBeginTimeObject#
							Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eEvents
						Set AcceptRegistrations = <cfqueryparam value="#Session.UserSuppliedInfo.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
						Where TContent_ID = <cfqueryparam value="#insertCopiedEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfcatch type="Database">
						<cfdump var="#CFCATCH#"><cfabort>
					</cfcatch>
				</cftry>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=EventCopied&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>
		<cfelse>
		</cfif>
	</cffunction>

	<cffunction name="cancelevent" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
		<cfset Session.FormData = StructNew()>
		<cfset Session.FormData.PluginInfo = StructNew()>
		<cfset Session.FormData.PluginInfo.DataSource = #rc.$.globalConfig('datasource')#>
		<cfset Session.FormData.PluginInfo.DBUsername = #rc.$.globalConfig('dbusername')#>
		<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
		<cfset Session.FormData.PluginInfo.PackageName = #rc.pc.getPackage()#>

		<cfif isDefined("URL.EventID") and not isDefined("URL.EventStatus")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(RegistrationID) as NumRegistrations
				From eRegistrations
				Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetSelectedEventRegistrations.RecordCount>
				<cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.NumRegistrations#>
			<cfelse>
				<cfset Session.EventNumberRegistrations = 0>
			</cfif>
			<cfif GetSelectedEvent.RecordCount EQ 0>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.UserSuppliedInfo = StructNew()>
					<cfset Session.UserSuppliedInfo.RecNo = #GetSelectedEvent.TContent_ID#>
					<cfset Session.UserSuppliedInfo.ShortTitle = #GetSelectedEvent.ShortTitle#>
					<cfset Session.UserSuppliedInfo.EventDate = #GetSelectedEvent.EventDate#>
					<cfset Session.UserSuppliedInfo.EventDate1 = #GetSelectedEvent.EventDate1#>
					<cfset Session.UserSuppliedInfo.EventDate2 = #GetSelectedEvent.EventDate2#>
					<cfset Session.UserSuppliedInfo.EventDate3 = #GetSelectedEvent.EventDate3#>
					<cfset Session.UserSuppliedInfo.EventDate4 = #GetSelectedEvent.EventDate4#>
					<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4)>
						<cfset Session.UserSuppliedInfo.EventSpanDates = 1>
					<cfelse>
						<cfset Session.UserSuppliedInfo.EventSpanDates = 0>
					</cfif>
					<cfset Session.UserSuppliedInfo.LongDescription = #GetSelectedEvent.LongDescription#>
					<cfset Session.UserSuppliedInfo.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
					<cfset Session.UserSuppliedInfo.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
					<cfset Session.UserSuppliedInfo.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
					<cfset Session.UserSuppliedInfo.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
					<cfset Session.UserSuppliedInfo.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
					<cfset Session.UserSuppliedInfo.EventFeatured = #GetSelectedEvent.EventFeatured#>
					<cfset Session.UserSuppliedInfo.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
					<cfset Session.UserSuppliedInfo.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
					<cfset Session.UserSuppliedInfo.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
					<cfset Session.UserSuppliedInfo.MemberCost = #GetSelectedEvent.MemberCost#>
					<cfset Session.UserSuppliedInfo.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
					<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
					<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
					<cfset Session.UserSuppliedInfo.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
					<cfset Session.UserSuppliedInfo.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
					<cfset Session.UserSuppliedInfo.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
					<cfset Session.UserSuppliedInfo.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
					<cfset Session.UserSuppliedInfo.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
					<cfset Session.UserSuppliedInfo.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
					<cfset Session.UserSuppliedInfo.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
					<cfset Session.UserSuppliedInfo.PGPPoints = #GetSelectedEvent.PGPPoints#>
					<cfset Session.UserSuppliedInfo.MealProvided = #GetSelectedEvent.MealProvided#>
					<cfset Session.UserSuppliedInfo.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
					<cfset Session.UserSuppliedInfo.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
					<cfset Session.UserSuppliedInfo.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
					<cfset Session.UserSuppliedInfo.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
					<cfset Session.UserSuppliedInfo.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
					<cfset Session.UserSuppliedInfo.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
					<cfset Session.UserSuppliedInfo.EventAgenda = #GetSelectedEvent.EventAgenda#>
					<cfset Session.UserSuppliedInfo.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
					<cfset Session.UserSuppliedInfo.EventStrategies = #GetSelectedEvent.EventStrategies#>
					<cfset Session.UserSuppliedInfo.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
					<cfset Session.UserSuppliedInfo.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
					<cfset Session.UserSuppliedInfo.LocationType = #GetSelectedEvent.LocationType#>
					<cfset Session.UserSuppliedInfo.LocationID = #GetSelectedEvent.LocationID#>
					<cfset Session.UserSuppliedInfo.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
					<cfset Session.UserSuppliedInfo.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
					<cfset Session.UserSuppliedInfo.Presenters = #GetSelectedEvent.Presenters#>
					<cfset Session.UserSuppliedInfo.Facilitator = #GetSelectedEvent.Facilitator#>
					<cfset Session.UserSuppliedInfo.dateCreated = #GetSelectedEvent.dateCreated#>
					<cfset Session.UserSuppliedInfo.lastUpdated = #GetSelectedEvent.lastUpdated#>
					<cfset Session.UserSuppliedInfo.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
					<cfset Session.UserSuppliedInfo.Active = #GetSelectedEvent.Active#>
					<cfset Session.UserSuppliedInfo.WebinarAvailable = #GetSelectedEvent.WebinarAvailable#>
					<cfset Session.UserSuppliedInfo.WebinarConnectInfo = #GetSelectedEvent.WebinarConnectInfo#>
					<cfset Session.UserSuppliedInfo.WebinarMemberCost = #GetSelectedEvent.WebinarMemberCost#>
					<cfset Session.UserSuppliedInfo.WebinarNonMemberCost = #GetSelectedEvent.WebinarNonMemberCost#>
				</cflock>
			</cfif>
		<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
			<cfif isDefined("FORM.CancelEvent")>
				<cfif FORM.CancelEvent EQ "True">
					<cftry>
						<cfquery name="checkNumberRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select RegistrationID, User_ID
							From eRegistrations
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>

						<cfif checkNumberRegistrations.RecordCount EQ 0>
							<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set Active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
									EventCancelled = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
						<cfelse>
							<cfquery name="updateEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set Active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
									EventCancelled = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>

							<cfloop query="checkNumberRegistrations">
								<cfset Variables.Info = StructNew()>
								<cfset Variables.Info.RegistrationID = #checkNumberRegistrations.RegistrationID#>
								<cfset Variables.Info.UserID = #checkNumberRegistrations.User_ID#>
								<cfset Temp = SendEmailCFC.SendEventCancellationToSingleParticipant(Variables.Info)>
							</cfloop>
						</cfif>
						<cfcatch type="any">
							<cfdump var="#CFCATCH#"><cfabort>
						</cfcatch>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=EventCancelled&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
					</cftry>
				</cfif>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="geteventinfo" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID")>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From eEvents
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(TContent_ID) as CurrentNumberofRegistrations
				From eRegistrations
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, GeoCode_Latitude, GeoCode_Longitude, GeoCode_StateLongName
				From eFacility
				Where FacilityType = <cfqueryparam value="#getSelectedEvent.LocationType#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select RoomName, Capacity
				From eFacilityRooms
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
		</cfif>
	</cffunction>

	<cffunction name="emailregistered" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost,
					EventDoc_FileNameOne, EventDoc_FileTypeOne, EventDoc_FileNameTwo, EventDoc_FileTypeTwo, EventDoc_FileNameThree, EventDoc_FileTypeThree,
					EventDoc_FileNameFour, EventDoc_FileTypeFour, EventDoc_FileNameFive, EventDoc_FileTypeFive
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(RegistrationID) as NumRegistrations
				From eRegistrations
				Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetSelectedEventRegistrations.RecordCount>
				<cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.NumRegistrations#>
			<cfelse>
				<cfset Session.EventNumberRegistrations = 0>
			</cfif>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.RecNo = #GetSelectedEvent.TContent_ID#>
				<cfset Session.UserSuppliedInfo.ShortTitle = #GetSelectedEvent.ShortTitle#>
				<cfset Session.UserSuppliedInfo.EventDate = #GetSelectedEvent.EventDate#>
				<cfset Session.UserSuppliedInfo.EventDate1 = #GetSelectedEvent.EventDate1#>
				<cfset Session.UserSuppliedInfo.EventDate2 = #GetSelectedEvent.EventDate2#>
				<cfset Session.UserSuppliedInfo.EventDate3 = #GetSelectedEvent.EventDate3#>
				<cfset Session.UserSuppliedInfo.EventDate4 = #GetSelectedEvent.EventDate4#>
				<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4)>
					<cfset Session.UserSuppliedInfo.EventSpanDates = 1>
				<cfelse>
					<cfset Session.UserSuppliedInfo.EventSpanDates = 0>
				</cfif>
				<cfset Session.UserSuppliedInfo.LongDescription = #GetSelectedEvent.LongDescription#>
				<cfset Session.UserSuppliedInfo.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
				<cfset Session.UserSuppliedInfo.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
				<cfset Session.UserSuppliedInfo.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
				<cfset Session.UserSuppliedInfo.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
				<cfset Session.UserSuppliedInfo.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
				<cfset Session.UserSuppliedInfo.EventFeatured = #GetSelectedEvent.EventFeatured#>
				<cfset Session.UserSuppliedInfo.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
				<cfset Session.UserSuppliedInfo.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
				<cfset Session.UserSuppliedInfo.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
				<cfset Session.UserSuppliedInfo.MemberCost = #GetSelectedEvent.MemberCost#>
				<cfset Session.UserSuppliedInfo.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
				<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
				<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
				<cfset Session.UserSuppliedInfo.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
				<cfset Session.UserSuppliedInfo.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
				<cfset Session.UserSuppliedInfo.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
				<cfset Session.UserSuppliedInfo.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
				<cfset Session.UserSuppliedInfo.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
				<cfset Session.UserSuppliedInfo.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
				<cfset Session.UserSuppliedInfo.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
				<cfset Session.UserSuppliedInfo.PGPPoints = #GetSelectedEvent.PGPPoints#>
				<cfset Session.UserSuppliedInfo.MealProvided = #GetSelectedEvent.MealProvided#>
				<cfset Session.UserSuppliedInfo.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
				<cfset Session.UserSuppliedInfo.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
				<cfset Session.UserSuppliedInfo.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
				<cfset Session.UserSuppliedInfo.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
				<cfset Session.UserSuppliedInfo.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
				<cfset Session.UserSuppliedInfo.EventAgenda = #GetSelectedEvent.EventAgenda#>
				<cfset Session.UserSuppliedInfo.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
				<cfset Session.UserSuppliedInfo.EventStrategies = #GetSelectedEvent.EventStrategies#>
				<cfset Session.UserSuppliedInfo.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
				<cfset Session.UserSuppliedInfo.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
				<cfset Session.UserSuppliedInfo.LocationType = #GetSelectedEvent.LocationType#>
				<cfset Session.UserSuppliedInfo.LocationID = #GetSelectedEvent.LocationID#>
				<cfset Session.UserSuppliedInfo.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
				<cfset Session.UserSuppliedInfo.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
				<cfset Session.UserSuppliedInfo.Presenters = #GetSelectedEvent.Presenters#>
				<cfset Session.UserSuppliedInfo.Facilitator = #GetSelectedEvent.Facilitator#>
				<cfset Session.UserSuppliedInfo.dateCreated = #GetSelectedEvent.dateCreated#>
				<cfset Session.UserSuppliedInfo.lastUpdated = #GetSelectedEvent.lastUpdated#>
				<cfset Session.UserSuppliedInfo.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
				<cfset Session.UserSuppliedInfo.Active = #GetSelectedEvent.Active#>
				<cfset Session.UserSuppliedInfo.WebinarAvailable = #GetSelectedEvent.WebinarAvailable#>
				<cfset Session.UserSuppliedInfo.WebinarConnectInfo = #GetSelectedEvent.WebinarConnectInfo#>
				<cfset Session.UserSuppliedInfo.WebinarMemberCost = #GetSelectedEvent.WebinarMemberCost#>
				<cfset Session.UserSuppliedInfo.WebinarNonMemberCost = #GetSelectedEvent.WebinarNonMemberCost#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameOne = #GetSelectedEvent.EventDoc_FileNameOne#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameTwo = #GetSelectedEvent.EventDoc_FileNameTwo#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameThree = #GetSelectedEvent.EventDoc_FileNameThree#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameFour =  #GetSelectedEvent.EventDoc_FileNameFour#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameFive = #GetSelectedEvent.EventDoc_FileNameFive#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeOne = #GetSelectedEvent.EventDoc_FileTypeOne#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeTwo = #GetSelectedEvent.EventDoc_FileTypeTwo#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeThree = #GetSelectedEvent.EventDoc_FileTypeThree#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeFour = #GetSelectedEvent.EventDoc_FileTypeFour#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeFive = #GetSelectedEvent.EventDoc_FileTypeFive#>
			</cflock>
		</cfif>

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif not isDefined("Session.UserSuppliedInfo")>
					<cfset Session.UserSuppliedInfo = StructNew()>
					<cfset Session.UserSuppliedInfo.NewRecNo = 0>
				</cfif>
			</cflock>

			<cfif LEN(FORM.EmailMsg) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Enter some text for the participants to ready about this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.emailregistered&SiteID=#rc.$.siteConfig('siteID')#&EventID=#Session.UserSuppliedInfo.RecNo#" addtoken="false">
			</cfif>

			<cfquery name="GetRegisteredUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select eRegistrations.RegistrationID, eRegistrations.Site_ID, eRegistrations.RegistrationDate, eRegistrations.EventID, eRegistrations.RequestsMeal, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice,
					eRegistrations.OnWaitingList, eRegistrations.Comments, eRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email
				FROM eRegistrations INNER JOIN tusers ON tusers.UserID = eRegistrations.User_ID
				WHERE eRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					eRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, EventDoc_FileNameOne, EventDoc_FileTypeOne, EventDoc_FileNameTwo, EventDoc_FileTypeTwo, EventDoc_FileNameThree, EventDoc_FileTypeThree,
					EventDoc_FileNameFour, EventDoc_FileTypeFour, EventDoc_FileNameFive, EventDoc_FileTypeFive
				From eEvents
				Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

			<cfif GetRegisteredUsersForEvent.RecordCount>
				<cfif Len(FORM.FirstDocumentToSend) EQ 0 and LEN(Form.SecondDocumentToSend) EQ 0 and LEN(Form.ThirdDocumentToSend) EQ 0 and LEN(Form.FourthDocumentToSend) EQ 0 and LEN(Form.FifthDocumentToSend) EQ 0>
					<cfloop query="GetRegisteredUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetRegisteredUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetRegisteredUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetRegisteredUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
						<cfset ParticipantInfo.DocLinksInEmail = #FORM.IncludeFileLinks#>
						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(Variables.ParticipantInfo)#>
					</cfloop>
				<cfelse>
					<cfif isDefined("FORM.FirstDocumentToSend")>
						<cfif LEN(FORM.FirstDocumentToSend)>
							<cffile action="upload" fileField="FORM.FirstDocumentToSend" result="EventDocumentOne" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
							<cfset NewServerFileOne = #Replace(Variables.EventDocumentOne.ServerFile, " ", "_", "ALL")#>
							<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentOne.ServerFile#" Destination="#Variables.NewServerFileOne#">
							<cfdirectory action="list" directory="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#" name="DoesDirectoryExists">
							<cfif DoesDirectoryExists.RecordCount EQ 0>
								<cfdirectory action="Create" directory="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#">
							</cfif>
							<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileOne#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileOne#">
							<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventDoc_FileNameOne = <cfqueryparam value="#Variables.NewServerFileOne#" cfsqltype="cf_sql_varchar">,
									EventDoc_FileTypeOne = <cfqueryparam value="#Variables.EventDocumentOne.ContentType#/#Variables.EventDocumentOne.ContentSubType#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfset EmailMessageWithFileOne = True>
						</cfif>
					</cfif>
					<cfif isDefined("FORM.SecondDocumentToSend")>
						<cfif LEN(FORM.SecondDocumentToSend)>
						<cffile action="upload" fileField="FORM.SecondDocumentToSend" result="EventDocumentTwo" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileTwo = #Replace(Variables.EventDocumentTwo.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentTwo.ServerFile#" Destination="#Variables.NewServerFileTwo#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileTwo#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileTwo#">
						<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDoc_FileNameTwo = <cfqueryparam value="#Variables.NewServerFileTwo#" cfsqltype="cf_sql_varchar">,
								EventDoc_FileTypeTwo = <cfqueryparam value="#Variables.EventDocumentTwo.ContentType#/#Variables.EventDocumentTwo.ContentSubType#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EmailMessageWithFileTwo = True>
						</cfif>
					</cfif>
					<cfif isDefined("FORM.ThirdDocumentToSend")>
						<cfif LEN(FORM.ThirdDocumentToSend)>
						<cffile action="upload" fileField="FORM.ThirdDocumentToSend" result="EventDocumentThree" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileThree = #Replace(Variables.EventDocumentThree.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentThree.ServerFile#" Destination="#Variables.NewServerFileThree#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileThree#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileThree#">
						<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDoc_FileNameThree = <cfqueryparam value="#Variables.NewServerFileThree#" cfsqltype="cf_sql_varchar">,
								EventDoc_FileTypeThree = <cfqueryparam value="#Variables.EventDocumentThree.ContentType#/#Variables.EventDocumentThree.ContentSubType#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EmailMessageWithFileThree = True>
						</cfif>
					</cfif>
					<cfif isDefined("FORM.FourthDocumentToSend")>
						<cfif LEN(FORM.FourthDocumentToSend)>
						<cffile action="upload" fileField="FORM.FourthDocumentToSend" result="EventDocumentFour" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileFour = #Replace(Variables.EventDocumentFour.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentFour.ServerFile#" Destination="#Variables.NewServerFileFour#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileFour#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileFour#">
						<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDoc_FileNameFour = <cfqueryparam value="#Variables.NewServerFileFour#" cfsqltype="cf_sql_varchar">,
								EventDoc_FileTypeFour = <cfqueryparam value="#Variables.EventDocumentFour.ContentType#/#Variables.EventDocumentFour.ContentSubType#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EmailMessageWithFileFour = True>
						</cfif>
					</cfif>
					<cfif isDefined("FORM.FifthDocumentToSend")>
						<cfif LEN(FORM.FifthDocumentToSend)>
						<cffile action="upload" fileField="FORM.FifthDocumentToSend" result="EventDocumentFive" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileFive = #Replace(Variables.EventDocumentFive.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentFive.ServerFile#" Destination="#Variables.NewServerFileFive#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileFive#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileFive#">
						<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDoc_FileNameFive = <cfqueryparam value="#Variables.NewServerFileFive#" cfsqltype="cf_sql_varchar">,
								EventDoc_FileTypeFive = <cfqueryparam value="#Variables.EventDocumentFive.ContentType#/#Variables.EventDocumentFive.ContentSubType#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EmailMessageWithFileFive = True>
						</cfif>
					</cfif>
					<cfloop query="GetRegisteredUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetRegisteredUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetRegisteredUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetRegisteredUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
						<cfset ParticipantInfo.DocLinksInEmail = #FORM.IncludeFileLinks#>
						<cfset ParticipantInfo.PackageName = #rc.pc.getPackage()#>
						<cfset ParticipantInfo.EventID = #GetRegisteredUsersForEvent.EventID#>

						<cfif isDefined("Variables.EmailMessageWithFileOne") or LEN(GetSelectedEvent.EventDoc_FileNameOne)>
							<cfset ParticipantInfo.EmailFileOne = True>
							<cfif isDefined("Variables.EmailMessageWithFileOne")>
								<cfset ParticipantInfo.EmailFileLocOne = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileOne#>
								<cfset ParticipantInfo.EmailFileNameOne = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileOne#>
								<cfset ParticipantInfo.EmailFileTypeOne = #Variables.EventDocumentOne.ContentType# & "/" & #Variables.EventDocumentOne.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocOne = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameOne#>
								<cfset ParticipantInfo.EmailFileNameOne = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameOne#>
								<cfset ParticipantInfo.EmailFileTypeOne = #GetSelectedEvent.EventDoc_FileTypeOne#>
							</cfif>
						</cfif>
						<cfif isDefined("Variables.EmailMessageWithFileTwo")  or LEN(GetSelectedEvent.EventDoc_FileNameTwo)><cfset ParticipantInfo.EmailFileTwo = True>
							<cfif isDefined("Variables.EmailMessageWithFileTwo")>
								<cfset ParticipantInfo.EmailFileLocTwo = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileTwo#>
								<cfset ParticipantInfo.EmailFileNameTwo = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileTwo#>
								<cfset ParticipantInfo.EmailFileTypeTwo = #Variables.EventDocumentTwo.ContentType# & "/" & #Variables.EventDocumentTwo.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocTwo = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameTwo#>
								<cfset ParticipantInfo.EmailFileNameTwo = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameTwo#>
								<cfset ParticipantInfo.EmailFileTypeTwo = #GetSelectedEvent.EventDoc_FileTypeTwo#>
							</cfif>
						</cfif>
						<cfif isDefined("Variables.EmailMessageWithFileThree")  or LEN(GetSelectedEvent.EventDoc_FileNameThree)><cfset ParticipantInfo.EmailFileThree = True>
							<cfif isDefined("Variables.EmailMessageWithFileThree")>
								<cfset ParticipantInfo.EmailFileLocThree = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileThree#>
								<cfset ParticipantInfo.EmailFileNameThree = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileThree#>
								<cfset ParticipantInfo.EmailFileTypeThree = #Variables.EventDocumentThree.ContentType# & "/" & #Variables.EventDocumentThree.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocThree = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameThree#>
								<cfset ParticipantInfo.EmailFileNameThree = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameThree#>
								<cfset ParticipantInfo.EmailFileTypeThree = #GetSelectedEvent.EventDoc_FileTypeThree#>
							</cfif>
						</cfif>
						<cfif isDefined("Variables.EmailMessageWithFileFour")  or LEN(GetSelectedEvent.EventDoc_FileNameFour)><cfset ParticipantInfo.EmailFileFour = True>
						<cfif isDefined("Variables.EmailMessageWithFileFour")>
								<cfset ParticipantInfo.EmailFileLocFour = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileFour#>
								<cfset ParticipantInfo.EmailFileNameFour = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileFour#>
								<cfset ParticipantInfo.EmailFileTypeFour = #Variables.EventDocumentFour.ContentType# & "/" & #Variables.EventDocumentFour.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocFour = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameFour#>
								<cfset ParticipantInfo.EmailFileNameFour = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameFour#>
								<cfset ParticipantInfo.EmailFileTypeFour = #GetSelectedEvent.EventDoc_FileTypeFour#>
							</cfif>
						</cfif>
						<cfif isDefined("Variables.EmailMessageWithFileFive")  or LEN(GetSelectedEvent.EventDoc_FileNameFive)><cfset ParticipantInfo.EmailFileFive = True>
							<cfif isDefined("Variables.EmailMessageWithFileFive")>
								<cfset ParticipantInfo.EmailFileLocFive = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileFive#>
								<cfset ParticipantInfo.EmailFileNameFive = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileFive#>
								<cfset ParticipantInfo.EmailFileTypeFive = #Variables.EventDocumentFive.ContentType# & "/" & #Variables.EventDocumentFive.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocFive = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameFive#>
								<cfset ParticipantInfo.EmailFileNameFive = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameFive#>
								<cfset ParticipantInfo.EmailFileTypeFive = #GetSelectedEvent.EventDoc_FileTypeFive#>
							</cfif>
						</cfif>
						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(Variables.ParticipantInfo)#>
					</cfloop>
				</cfif>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=RegistrationsSent&SiteID=#rc.$.siteConfig('siteID')#&Successful=true&EventID=#GetRegisteredUsersForEvent.EventID#" addtoken="false">
			<cfelseif GetRegisteredUsersForEvent.RecordCount EQ 0>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=NoRegistrations&SiteID=#rc.$.siteConfig('siteID')#&Successful=false&EventID=#GetRegisteredUsersForEvent.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="registeruserforevent" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
		<cfset Session.FormData = StructNew()>
		<cfset Session.FormData.PluginInfo = StructNew()>
		<cfset Session.FormData.PluginInfo.DataSource = #rc.$.globalConfig('datasource')#>
		<cfset Session.FormData.PluginInfo.DBUsername = #rc.$.globalConfig('dbusername')#>
		<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
		<cfset Session.FormData.PluginInfo.PackageName = #rc.pc.getPackage()#>

		<cfif not isDefined("URL.EventStatus") and isDefined("URL.EventID")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.PickedEvent = StructNew()>
				<cfset Session.UserSuppliedInfo.PickedEvent.RecNo = #GetSelectedEvent.TContent_ID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.ShortTitle = #GetSelectedEvent.ShortTitle#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate = #GetSelectedEvent.EventDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate1 = #GetSelectedEvent.EventDate1#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate2 = #GetSelectedEvent.EventDate2#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate3 = #GetSelectedEvent.EventDate3#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate4 = #GetSelectedEvent.EventDate4#>
				<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4)>
					<cfset Session.UserSuppliedInfo.PickedEvent.EventSpanDates = 1>
				<cfelse>
					<cfset Session.UserSuppliedInfo.PickedEvent.EventSpanDates = 0>
				</cfif>
				<cfset Session.UserSuppliedInfo.PickedEvent.LongDescription = #GetSelectedEvent.LongDescription#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventFeatured = #GetSelectedEvent.EventFeatured#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MemberCost = #GetSelectedEvent.MemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
				<cfset Session.UserSuppliedInfo.PickedEvent.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.PGPPoints = #GetSelectedEvent.PGPPoints#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealProvided = #GetSelectedEvent.MealProvided#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.PickedEvent.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
				<cfset Session.UserSuppliedInfo.PickedEvent.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventAgenda = #GetSelectedEvent.EventAgenda#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventStrategies = #GetSelectedEvent.EventStrategies#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationType = #GetSelectedEvent.LocationType#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationID = #GetSelectedEvent.LocationID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Presenters = #GetSelectedEvent.Presenters#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Facilitator = #GetSelectedEvent.Facilitator#>
				<cfset Session.UserSuppliedInfo.PickedEvent.dateCreated = #GetSelectedEvent.dateCreated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.lastUpdated = #GetSelectedEvent.lastUpdated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Active = #GetSelectedEvent.Active#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarAvailable = #GetSelectedEvent.WebinarAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarConnectInfo = #GetSelectedEvent.WebinarConnectInfo#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarMemberCost = #GetSelectedEvent.WebinarMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarNonMemberCost = #GetSelectedEvent.WebinarNonMemberCost#>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfswitch expression="#FORM.PerformAction#">
				<cfcase value="ListParticipantsInOrganization">
					<cfset Session.UserSuppliedInfo.Registration = #StructCopy(FORM)#>
					<cfquery name="GetSelectedAccountsWithinOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID, Fname, Lname, Email
						From tusers
						Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							Email LIKE '%#FORM.DistrictName#%'
						Order by Lname, Fname
					</cfquery>
					<cfquery name="GetOrganizationMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select OrganizationName, StateDOE_IDNumber, StateDOE_State, Active
						From eMembership
						Where OrganizationDomainName = <cfqueryparam value="#FORM.DistrictName#" cfsqltype="cf_sql_varchar"> and
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfset Session.UserSuppliedInfo.EventRegistration = #StructNew()#>
					<cfset Session.UserSuppliedInfo.EventRegistration.SelectedOrganization = #StructCopy(GetSelectedAccountsWithinOrganization)#>
					<cfset Session.UserSuppliedInfo.EventRegistration.NumberOfUserAccountsWithinOrganization = #GetSelectedAccountsWithinOrganization.RecordCount#>
					<cfset Session.UserSuppliedInfo.EventRegistration.Step1 = #StructCopy(FORM)#>
					<cfset Session.UserSuppliedInfo.EventRegistration.Step1.OrganizationName = #GetOrganizationMembership.OrganizationName#>
					<cfset Session.UserSuppliedInfo.EventRegistration.Step1.Membership = #GetOrganizationMembership.Active#>
				</cfcase>
				<cfcase value="RegisterParticipantsToEventWithAccounts">
					<cfset Session.UserSuppliedInfo.EventRegistration.Step2 = #StructCopy(FORM)#>
				</cfcase>
				<cfcase value="RegisterParticipantsToEvent">
					<cfif StructKeyExists(Session.UserSuppliedInfo.EventRegistration, "Step2")>
						<cfif StructKeyExists(Session.UserSuppliedInfo.EventRegistration.Step2, "ParticipantEmployee")>
							<cfloop list="#Session.UserSuppliedInfo.EventRegistration.Step2.ParticipantEmployee#" delimiters="," index="i">
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#i#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #Session.UserSuppliedInfo.EventRegistration.Step2.RegisterParticipantStayForMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #Session.UserSuppliedInfo.EventRegistration.Step2.RegisterParticipantWebinarOption#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							</cfloop>
						</cfif>
					</cfif>

					<cfif LEN(FORM.Participant1FirstName) EQ 0 AND LEN(FORM.Participant1LastName) EQ 0 AND LEN(FORM.Participant1EmailAddress) EQ 0 AND
						LEN(FORM.Participant2FirstName) EQ 0 AND LEN(FORM.Participant2LastName) EQ 0 AND LEN(FORM.Participant2EmailAddress) EQ 0 AND
						LEN(FORM.Participant3FirstName) EQ 0 AND LEN(FORM.Participant3LastName) EQ 0 AND LEN(FORM.Participant3EmailAddress) EQ 0 AND
						LEN(FORM.Participant4FirstName) EQ 0 AND LEN(FORM.Participant4LastName) EQ 0 AND LEN(FORM.Participant4EmailAddress) EQ 0 AND
						LEN(FORM.Participant5FirstName) EQ 0 AND LEN(FORM.Participant5LastName) EQ 0 AND LEN(FORM.Participant5EmailAddress) EQ 0 AND
						LEN(FORM.Participant6FirstName) EQ 0 AND LEN(FORM.Participant6LastName) EQ 0 AND LEN(FORM.Participant6EmailAddress) EQ 0 AND
						not StructKeyExists(Session.UserSuppliedInfo.EventRegistration.Step2, "ParticipantEmployee")>
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Enter atleast 1 Participant who will be attending this event."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.registeruserforevent&SiteID=#rc.$.siteConfig('siteID')#&EventID=#Session.UserSuppliedInfo.PickedEvent.RecNo#&EventStatus=RegisterParticipantsToEvent" addtoken="false">
					<cfelse>
						<cfif LEN(FORM.Participant1FirstName) and LEN(FORM.Participant1LastName) AND LEN(FORM.Participant1EmailAddress)>
							<!--- Check User Exists in Database --->
							<cfquery name="CheckAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname, Email
								From tusers
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									UserName = <cfqueryparam value="#Form.Participant1EmailAddress#" cfsqltype="cf_sql_varchar">
								Order by Lname, Fname
							</cfquery>
							<cfif CheckAccount.RecordCount EQ 0>
								<!--- Initiates the User Bean --->
								<cfset NewUser = #Application.userManager.readByUsername(form.Participant1EmailAddress, rc.$.siteConfig('siteID'))#>
								<cfset NewUser.setInActive(1)>
								<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
								<cfset NewUser.setFname(FORM.Participant1FirstName)>
								<cfset NewUser.setLname(FORM.Participant1LastName)>
								<cfset NewUser.setUsername(FORM.Participant1EmailAddress)>
								<cfset NewUser.setEmail(FORM.Participant1EmailAddress)>
								<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
								<cfset NewUserAccountID = #Variables.AddNewAccount.GetUserID()#>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#Variables.NewUserAccountID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant1WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant1WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							<cfelse>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#CheckAccount.UserID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant1WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant1WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
						<cfif LEN(FORM.Participant2FirstName) and LEN(FORM.Participant2LastName) AND LEN(FORM.Participant2EmailAddress)>
							<!--- Check User Exists in Database --->
							<cfquery name="CheckAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname, Email
								From tusers
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									UserName = <cfqueryparam value="#Form.Participant2EmailAddress#" cfsqltype="cf_sql_varchar">
								Order by Lname, Fname
							</cfquery>
							<cfif CheckAccount.RecordCount EQ 0>
								<!--- Initiates the User Bean --->
								<cfset NewUser = #Application.userManager.readByUsername(form.Participant2EmailAddress, rc.$.siteConfig('siteID'))#>
								<cfset NewUser.setInActive(1)>
								<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
								<cfset NewUser.setFname(FORM.Participant2FirstName)>
								<cfset NewUser.setLname(FORM.Participant2LastName)>
								<cfset NewUser.setUsername(FORM.Participant2EmailAddress)>
								<cfset NewUser.setEmail(FORM.Participant2EmailAddress)>
								<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
								<cfset NewUserAccountID = #Variables.AddNewAccount.GetUserID()#>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#Variables.NewUserAccountID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant2WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant2WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							<cfelse>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#CheckAccount.UserID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant2WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant2WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
						<cfif LEN(FORM.Participant3FirstName) and LEN(FORM.Participant3LastName) AND LEN(FORM.Participant3EmailAddress)>
							<!--- Check User Exists in Database --->
							<cfquery name="CheckAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname, Email
								From tusers
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									UserName = <cfqueryparam value="#Form.Participant3EmailAddress#" cfsqltype="cf_sql_varchar">
								Order by Lname, Fname
							</cfquery>
							<cfif CheckAccount.RecordCount EQ 0>
								<!--- Initiates the User Bean --->
								<cfset NewUser = #Application.userManager.readByUsername(form.Participant3EmailAddress, rc.$.siteConfig('siteID'))#>
								<cfset NewUser.setInActive(1)>
								<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
								<cfset NewUser.setFname(FORM.Participant3FirstName)>
								<cfset NewUser.setLname(FORM.Participant3LastName)>
								<cfset NewUser.setUsername(FORM.Participant3EmailAddress)>
								<cfset NewUser.setEmail(FORM.Participant3EmailAddress)>
								<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
								<cfset NewUserAccountID = #Variables.AddNewAccount.GetUserID()#>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#Variables.NewUserAccountID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant3WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant3WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							<cfelse>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#CheckAccount.UserID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant3WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant3WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
						<cfif LEN(FORM.Participant4FirstName) and LEN(FORM.Participant4LastName) AND LEN(FORM.Participant4EmailAddress)>
							<!--- Check User Exists in Database --->
							<cfquery name="CheckAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname, Email
								From tusers
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									UserName = <cfqueryparam value="#Form.Participant4EmailAddress#" cfsqltype="cf_sql_varchar">
								Order by Lname, Fname
							</cfquery>
							<cfif CheckAccount.RecordCount EQ 0>
								<!--- Initiates the User Bean --->
								<cfset NewUser = #Application.userManager.readByUsername(form.Participant4EmailAddress, rc.$.siteConfig('siteID'))#>
								<cfset NewUser.setInActive(1)>
								<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
								<cfset NewUser.setFname(FORM.Participant4FirstName)>
								<cfset NewUser.setLname(FORM.Participant4LastName)>
								<cfset NewUser.setUsername(FORM.Participant4EmailAddress)>
								<cfset NewUser.setEmail(FORM.Participant4EmailAddress)>
								<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
								<cfset NewUserAccountID = #Variables.AddNewAccount.GetUserID()#>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#Variables.NewUserAccountID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant4WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant4WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							<cfelse>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#CheckAccount.UserID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant4WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant4WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
						<cfif LEN(FORM.Participant5FirstName) and LEN(FORM.Participant5LastName) AND LEN(FORM.Participant5EmailAddress)>
							<!--- Check User Exists in Database --->
							<cfquery name="CheckAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname, Email
								From tusers
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									UserName = <cfqueryparam value="#Form.Participant5EmailAddress#" cfsqltype="cf_sql_varchar">
								Order by Lname, Fname
							</cfquery>
							<cfif CheckAccount.RecordCount EQ 0>
								<!--- Initiates the User Bean --->
								<cfset NewUser = #Application.userManager.readByUsername(form.Participant5EmailAddress, rc.$.siteConfig('siteID'))#>
								<cfset NewUser.setInActive(1)>
								<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
								<cfset NewUser.setFname(FORM.Participant5FirstName)>
								<cfset NewUser.setLname(FORM.Participant5LastName)>
								<cfset NewUser.setUsername(FORM.Participant5EmailAddress)>
								<cfset NewUser.setEmail(FORM.Participant5EmailAddress)>
								<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
								<cfset NewUserAccountID = #Variables.AddNewAccount.GetUserID()#>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#Variables.NewUserAccountID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant5WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant5WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							<cfelse>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#CheckAccount.UserID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant5WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant5WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
						<cfif LEN(FORM.Participant6FirstName) and LEN(FORM.Participant6LastName) AND LEN(FORM.Participant6EmailAddress)>
							<!--- Check User Exists in Database --->
							<cfquery name="CheckAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname, Email
								From tusers
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									UserName = <cfqueryparam value="#Form.Participant6EmailAddress#" cfsqltype="cf_sql_varchar">
								Order by Lname, Fname
							</cfquery>
							<cfif CheckAccount.RecordCount EQ 0>
								<!--- Initiates the User Bean --->
								<cfset NewUser = #Application.userManager.readByUsername(form.Participant6EmailAddress, rc.$.siteConfig('siteID'))#>
								<cfset NewUser.setInActive(1)>
								<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
								<cfset NewUser.setFname(FORM.Participant6FirstName)>
								<cfset NewUser.setLname(FORM.Participant6LastName)>
								<cfset NewUser.setUsername(FORM.Participant6EmailAddress)>
								<cfset NewUser.setEmail(FORM.Participant6EmailAddress)>
								<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
								<cfset NewUserAccountID = #Variables.AddNewAccount.GetUserID()#>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#Variables.NewUserAccountID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant6WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant6WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#Variables.NewUserAccountID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							<cfelse>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
										EventID = #Session.UserSuppliedInfo.PickedEvent.RecNo#
								</cfquery>
								<cfif CheckRegisteredAlready.RecordCount EQ 0>
									<cfquery name="InsertRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, RegistrationIPAddr, RegisterByUserID)
										Values("#rc.$.siteConfig('siteID')#", "#Variables.RegistrationUUID#", #Now()#, "#CheckAccount.UserID#", #Session.UserSuppliedInfo.PickedEvent.RecNo#, "#CGI.Remote_Addr#", "#Session.Mura.UserID#")
									</cfquery>
									<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = #FORM.Participant6WantsMeal#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = #FORM.Participant6WantsWebinar#
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfif Session.UserSuppliedInfo.EventRegistration.Step1.Membership EQ 1>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.MemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									<cfelse>
										<cfif Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable EQ 1>
											<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost#>
											<cfelse>
												<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
											</cfif>
										<cfelse>
											<cfset AttendeePrice = #Session.UserSuppliedInfo.PickedEvent.NonMemberCost#>
										</cfif>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set AttendeePrice = "#Variables.AttendeePrice#"
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
									</cfif>
									<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
											and OnWaitingList = 0
									</cfquery>
									<cfif GetEventRegistered.RecordCount LTE Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									<cfelse>
										<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set OnWaitingList = 1
											Where RegistrationID = "#Variables.RegistrationUUID#"
										</cfquery>
										<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
											<cfquery name="GetRegistrationRecordID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID
												From eRegistrations
												Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
													User_ID = <cfqueryparam value="#CheckAccount.UserID#" cfsqltype="cf_sql_varchar"> and
													RegistrationID = "#Variables.RegistrationUUID#"
											</cfquery>
											<cfset temp = #Variables.SendEmailCFC.SendEventWaitingListToSingleParticipant(GetRegistrationRecordID.TContent_ID)#>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
						<cfif Session.UserSuppliedInfo.EventRegistration.Step1.EmailConfirmations EQ 1>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=ParticipantsRegistered&SiteID=#rc.$.siteConfig('siteID')#&EmailConfirmation=true&Successful=true" addtoken="false">
						<cfelse>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=ParticipantsRegistered&SiteID=#rc.$.siteConfig('siteID')#&EmailConfirmation=false&Successful=true" addtoken="false">
						</cfif>
					</cfif>
				</cfcase>
			</cfswitch>
		</cfif>
	</cffunction>

	<cffunction name="deregisteruserforevent" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.PickedEvent = StructNew()>
				<cfset Session.UserSuppliedInfo.PickedEvent.RecNo = #GetSelectedEvent.TContent_ID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.ShortTitle = #GetSelectedEvent.ShortTitle#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate = #GetSelectedEvent.EventDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate1 = #GetSelectedEvent.EventDate1#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate2 = #GetSelectedEvent.EventDate2#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate3 = #GetSelectedEvent.EventDate3#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate4 = #GetSelectedEvent.EventDate4#>
				<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4)>
					<cfset Session.UserSuppliedInfo.PickedEvent.EventSpanDates = 1>
				<cfelse>
					<cfset Session.UserSuppliedInfo.PickedEvent.EventSpanDates = 0>
				</cfif>
				<cfset Session.UserSuppliedInfo.PickedEvent.LongDescription = #GetSelectedEvent.LongDescription#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventFeatured = #GetSelectedEvent.EventFeatured#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MemberCost = #GetSelectedEvent.MemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
				<cfset Session.UserSuppliedInfo.PickedEvent.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.PGPPoints = #GetSelectedEvent.PGPPoints#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealProvided = #GetSelectedEvent.MealProvided#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.PickedEvent.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
				<cfset Session.UserSuppliedInfo.PickedEvent.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventAgenda = #GetSelectedEvent.EventAgenda#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventStrategies = #GetSelectedEvent.EventStrategies#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationType = #GetSelectedEvent.LocationType#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationID = #GetSelectedEvent.LocationID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Presenters = #GetSelectedEvent.Presenters#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Facilitator = #GetSelectedEvent.Facilitator#>
				<cfset Session.UserSuppliedInfo.PickedEvent.dateCreated = #GetSelectedEvent.dateCreated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.lastUpdated = #GetSelectedEvent.lastUpdated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Active = #GetSelectedEvent.Active#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarAvailable = #GetSelectedEvent.WebinarAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarConnectInfo = #GetSelectedEvent.WebinarConnectInfo#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarMemberCost = #GetSelectedEvent.WebinarMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarNonMemberCost = #GetSelectedEvent.WebinarNonMemberCost#>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and isDefined("FORM.PerformAction")>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset Session.FormData = StructNew()>
			<cfset Session.FormData.PluginInfo = StructNew()>
			<cfset Session.FormData.PluginInfo.DataSource = #rc.$.globalConfig('datasource')#>
			<cfset Session.FormData.PluginInfo.DBUsername = #rc.$.globalConfig('dbusername')#>
			<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
			<cfset Session.FormData.PluginInfo.PackageName = #rc.pc.getPackage()#>

			<cfif not isDefined("FORM.RemoveParticipants")>
				<cfscript>
					errormsg = {property="RemoveParticipants",message="Please Select the participant you would like to remove from this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.deregisteruserforevent&SiteID=#rc.$.siteConfig('siteID')#&EventID=#Session.UserSuppliedInfo.RecNo#" addtoken="false">
			<cfelse>
				<cfif ListLen(FORM.RemoveParticipants) GTE 2>
					<cfloop list="#FORM.RemoveParticipants#" index="i" delimiters=",">
						<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select RegistrationID, RegistrationDate, User_ID, EventID, RequestsMeal, IVCParticipant, AttendeePrice, AttendedEvent, Comments, WebinarParticipant
							From eRegistrations
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								User_ID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.RegistrationID = #GetSelectedRegistration.RegistrationID#>
						<cfset ParticipantInfo.FormData = StructNew()>
						<cfset ParticipantInfo.FormData.Datasource = #rc.$.globalConfig('datasource')#>
						<cfset ParticipantInfo.FormData.DBUserName = #rc.$.globalConfig('dbusername')#>
						<cfset ParticipantInfo.FormData.DBPassword = #rc.$.globalConfig('dbpassword')#>
						<cfset ParticipantInfo.FormData.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
						<cfset ParticipantInfo.FormData.SiteID = #rc.$.siteConfig('siteID')#>
						<cfif FORM.SendEmailConfirmation EQ 1>
							<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(Variables.ParticipantInfo)#>
						<cfelse>
							<cfquery name="DeleteRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
								Delete from eRegistrations
								Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
					</cfloop>
				<cfelseif ListLen(FORM.RemoveParticipants) EQ 1>
					<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select RegistrationID, RegistrationDate, User_ID, EventID, RequestsMeal, IVCParticipant, AttendeePrice, AttendedEvent, Comments, WebinarParticipant
						From eRegistrations
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							User_ID = <cfqueryparam value="#FORM.RemoveParticipants#" cfsqltype="cf_sql_varchar">
					</cfquery>

					<cfset ParticipantInfo = StructNew()>
					<cfset ParticipantInfo.FormData = StructNew()>
					<cfset ParticipantInfo.RegistrationID = #GetSelectedRegistration.RegistrationID#>
					<cfset ParticipantInfo.FormData.Datasource = #rc.$.globalConfig('datasource')#>
					<cfset ParticipantInfo.FormData.DBUserName = #rc.$.globalConfig('dbusername')#>
					<cfset ParticipantInfo.FormData.DBPassword = #rc.$.globalConfig('dbpassword')#>
					<cfset ParticipantInfo.FormData.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
					<cfset ParticipantInfo.FormData.SiteID = #rc.$.siteConfig('siteID')#>
					<cfif FORM.SendEmailConfirmation EQ 1>
						<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(Variables.ParticipantInfo)#>
					<cfelse>
						<cfquery name="DeleteRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Delete from eRegistrations
							Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
				</cfif>

				<!--- Let's Check to see how many people are registered for this event --->
				<cfquery name="GetEventRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID
					From eRegistrations
					Where EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer">
						and OnWaitingList = 0
				</cfquery>

				<cfif GetEventRegistered.RecordCount LT Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants>
					<!--- Let's check to see if anyone is on the waiting list and let's make them a participant --->
					<cfquery name="GetEventWaitingList" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select RegistrationID, RegistrationDate, User_ID, EventID, RequestsMeal, IVCParticipant, AttendeePrice, AttendedEvent, Comments, WebinarParticipant
						From eRegistrations
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer"> and
							OnWaitingList = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
						Order By RegistrationDate ASC
					</cfquery>
					<cfif GetEventWaitingList.RecordCount>
						<cfloop from="#GetEventRegistered.RecordCount#" to="#Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants#" step="1" index="LoopCount">
							<cfquery name="GetRegistrationToUpgrade" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID, RegistrationID, User_ID, EventID
								From eRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer"> and
									OnWaitingList = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Order By RegistrationDate ASC
								Limit 1
							</cfquery>
							<cfquery name="UpgradeRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eRegistrations
								Set OnWaitingList = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.UserSuppliedInfo.PickedEvent.RecNo#" cfsqltype="cf_sql_integer"> and
									RegistrationID = <cfqueryparam value="#GetRegistrationToUpgrade.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfset temp = #SendEMailCFC.SendNoticeToIndividualRegistrationRemovedFromWaitingList(GetRegistrationToUpgrade.TContent_ID)#>
						</cfloop>
					</cfif>
				</cfif>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&SiteID=#rc.$.siteConfig('siteID')#&Successful=true&EventID=#GetSelectedRegistration.EventID#&UserAction=RemoveParticipants" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="eventsigninparticipant" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="GetRegisteredUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT tusers.Fname, tusers.Lname, eRegistrations.User_ID
				FROM eRegistrations INNER JOIN tusers ON tusers.UserID = eRegistrations.User_ID
				WHERE eRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					eRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					eRegistrations.AttendedEvent = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.RegisteredParticipants = StructNew()>
				<cfset Session.UserSuppliedInfo.RegisteredParticipants = StructCopy(GetRegisteredUsersForEvent)>
				<cfset Session.UserSuppliedInfo.PickedEvent = StructNew()>
				<cfset Session.UserSuppliedInfo.PickedEvent.RecNo = #GetSelectedEvent.TContent_ID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.ShortTitle = #GetSelectedEvent.ShortTitle#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate = #GetSelectedEvent.EventDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate1 = #GetSelectedEvent.EventDate1#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate2 = #GetSelectedEvent.EventDate2#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate3 = #GetSelectedEvent.EventDate3#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate4 = #GetSelectedEvent.EventDate4#>
				<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4)>
					<cfset Session.UserSuppliedInfo.PickedEvent.EventSpanDates = 1>
				<cfelse>
					<cfset Session.UserSuppliedInfo.PickedEvent.EventSpanDates = 0>
				</cfif>
				<cfset Session.UserSuppliedInfo.PickedEvent.LongDescription = #GetSelectedEvent.LongDescription#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventFeatured = #GetSelectedEvent.EventFeatured#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MemberCost = #GetSelectedEvent.MemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
				<cfset Session.UserSuppliedInfo.PickedEvent.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.PGPPoints = #GetSelectedEvent.PGPPoints#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealProvided = #GetSelectedEvent.MealProvided#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.PickedEvent.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
				<cfset Session.UserSuppliedInfo.PickedEvent.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventAgenda = #GetSelectedEvent.EventAgenda#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventStrategies = #GetSelectedEvent.EventStrategies#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationType = #GetSelectedEvent.LocationType#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationID = #GetSelectedEvent.LocationID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Presenters = #GetSelectedEvent.Presenters#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Facilitator = #GetSelectedEvent.Facilitator#>
				<cfset Session.UserSuppliedInfo.PickedEvent.dateCreated = #GetSelectedEvent.dateCreated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.lastUpdated = #GetSelectedEvent.lastUpdated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Active = #GetSelectedEvent.Active#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarAvailable = #GetSelectedEvent.WebinarAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarConnectInfo = #GetSelectedEvent.WebinarConnectInfo#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarMemberCost = #GetSelectedEvent.WebinarMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarNonMemberCost = #GetSelectedEvent.WebinarNonMemberCost#>
			</cflock>


		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and isDefined("FORM.PerformAction")>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

			<cfif not isDefined("FORM.SignInParticipant")>
				<cfscript>
					errormsg = {property="SignInParticipant",message="Please Select the participant you would like to electronically signin to this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.eventsigninparticipant&EventID=#Session.UserSuppliedInfo.RecNo#" addtoken="false">
			<cfelse>
				<cfif ListLen(FORM.SignInParticipant) GTE 2>
					<cfloop list="#FORM.SignInParticipant#" index="i" delimiters=",">
						<cfquery name="UpdateParticipantAttendedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eRegistrations
							Set AttendedEvent = 1
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								User_ID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"> and
								EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>

						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FormData = StructNew()>
						<cfset ParticipantInfo.FormData.Datasource = #rc.$.globalConfig('datasource')#>
						<cfset ParticipantInfo.FormData.DBUserName = #rc.$.globalConfig('dbusername')#>
						<cfset ParticipantInfo.FormData.DBPassword = #rc.$.globalConfig('dbpassword')#>
						<cfset ParticipantInfo.FormData.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
						<cfset ParticipantInfo.FormData.SiteID = #rc.$.siteConfig('siteID')#>
					</cfloop>
				<cfelseif ListLen(FORM.SignInParticipant) EQ 1>
					<cfquery name="UpdateParticipantAttendedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eRegistrations
							Set AttendedEvent = 1
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								User_ID = <cfqueryparam value="#FORM.SignInParticipant#" cfsqltype="cf_sql_varchar"> and
								EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>

						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FormData = StructNew()>
						<cfset ParticipantInfo.FormData.Datasource = #rc.$.globalConfig('datasource')#>
						<cfset ParticipantInfo.FormData.DBUserName = #rc.$.globalConfig('dbusername')#>
						<cfset ParticipantInfo.FormData.DBPassword = #rc.$.globalConfig('dbpassword')#>
						<cfset ParticipantInfo.FormData.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
						<cfset ParticipantInfo.FormData.SiteID = #rc.$.siteConfig('siteID')#>
				</cfif>

				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.eventsigninparticipant&Successful=true&EventID=#URL.EventID#&UserAction=SignInParticipant" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="publishtofb" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and isDefined("URL.AutomaticPost")>
			<cfif URL.AutomaticPost EQ "True">
				<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
						Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
						EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
						EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
						ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
						MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
						AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
						LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
						WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
					From eEvents
					Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfquery name="GetFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					SELECT eFacility.FacilityName, eFacility.PhysicalAddress, eFacility.PhysicalCity, eFacility.PhysicalState, eFacility.PhysicalZipCode, eFacilityRooms.RoomName
					FROM eFacility INNER JOIN eFacilityRooms ON eFacilityRooms.Facility_ID = eFacility.TContent_ID
					WHERE eFacility.Active = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> AND eFacility.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						AND eFacilityRooms.TContent_ID = <cfqueryparam value="#GetSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfset Session.UserSuppliedInfo.FacilityInfo = #StructCopy(GetFacilityInformation)#>
			</cfif>
		<cfelseif not isDefined("Form.PerformAction") and isDefined("URL.EventID") and not isDefined("URL.PerformAction") and isDefined("URL.EventID")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(RegistrationID) as NumRegistrations
				From eRegistrations
				Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfif GetSelectedEventRegistrations.RecordCount>
				<cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.NumRegistrations#>
			<cfelse>
				<cfset Session.EventNumberRegistrations = 0>
			</cfif>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.PickedEvent = StructNew()>
				<cfset Session.UserSuppliedInfo.PickedEvent.RecNo = #GetSelectedEvent.TContent_ID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.ShortTitle = #GetSelectedEvent.ShortTitle#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate = #GetSelectedEvent.EventDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate1 = #GetSelectedEvent.EventDate1#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate2 = #GetSelectedEvent.EventDate2#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate3 = #GetSelectedEvent.EventDate3#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventDate4 = #GetSelectedEvent.EventDate4#>
				<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4)>
					<cfset Session.UserSuppliedInfo.PickedEvent.EventSpanDates = 1>
				<cfelse>
					<cfset Session.UserSuppliedInfo.PickedEvent.EventSpanDates = 0>
				</cfif>
				<cfset Session.UserSuppliedInfo.PickedEvent.LongDescription = #GetSelectedEvent.LongDescription#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventFeatured = #GetSelectedEvent.EventFeatured#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MemberCost = #GetSelectedEvent.MemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
				<cfset Session.UserSuppliedInfo.PickedEvent.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.PGPPoints = #GetSelectedEvent.PGPPoints#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealProvided = #GetSelectedEvent.MealProvided#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
				<cfset Session.UserSuppliedInfo.PickedEvent.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.PickedEvent.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
				<cfset Session.UserSuppliedInfo.PickedEvent.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventAgenda = #GetSelectedEvent.EventAgenda#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventStrategies = #GetSelectedEvent.EventStrategies#>
				<cfset Session.UserSuppliedInfo.PickedEvent.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationType = #GetSelectedEvent.LocationType#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationID = #GetSelectedEvent.LocationID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
				<cfset Session.UserSuppliedInfo.PickedEvent.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Presenters = #GetSelectedEvent.Presenters#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Facilitator = #GetSelectedEvent.Facilitator#>
				<cfset Session.UserSuppliedInfo.PickedEvent.dateCreated = #GetSelectedEvent.dateCreated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.lastUpdated = #GetSelectedEvent.lastUpdated#>
				<cfset Session.UserSuppliedInfo.PickedEvent.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
				<cfset Session.UserSuppliedInfo.PickedEvent.Active = #GetSelectedEvent.Active#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarAvailable = #GetSelectedEvent.WebinarAvailable#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarConnectInfo = #GetSelectedEvent.WebinarConnectInfo#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarMemberCost = #GetSelectedEvent.WebinarMemberCost#>
				<cfset Session.UserSuppliedInfo.PickedEvent.WebinarNonMemberCost = #GetSelectedEvent.WebinarNonMemberCost#>
			</cflock>
		<cfelseif isDefined("FORM.PerformAction") and isDefined("URL.EventID")>
			<cfswitch expression="#FORM.PerformAction#">
				<cfcase value="FacebookAuthenticate">
					<cfset Session.UserSuppliedInfo.FBPost = #StructCopy(FORM)#>
				</cfcase>
			</cfswitch>
		<cfelseif isDefined("URL.PerformAction") and isDefined("URL.EventID")>
			<cfswitch expression="#URL.PerformAction#">
				<cfcase value="PostMessageToFB">
				</cfcase>
			</cfswitch>
		</cfif>
	</cffunction>

	<cffunction name="emailattended" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost,
					EventDoc_FileNameOne, EventDoc_FileTypeOne, EventDoc_FileNameTwo, EventDoc_FileTypeTwo, EventDoc_FileNameThree, EventDoc_FileTypeThree,
					EventDoc_FileNameFour, EventDoc_FileTypeFour, EventDoc_FileNameFive, EventDoc_FileTypeFive
				From eEvents
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(RegistrationID) as NumRegistrations
				From eRegistrations
				Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and AttendedEvent = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif GetSelectedEventRegistrations.RecordCount>
				<cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.NumRegistrations#>
			<cfelse>
				<cfset Session.EventNumberRegistrations = 0>
			</cfif>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.RecNo = #GetSelectedEvent.TContent_ID#>
				<cfset Session.UserSuppliedInfo.ShortTitle = #GetSelectedEvent.ShortTitle#>
				<cfset Session.UserSuppliedInfo.EventDate = #GetSelectedEvent.EventDate#>
				<cfset Session.UserSuppliedInfo.EventDate1 = #GetSelectedEvent.EventDate1#>
				<cfset Session.UserSuppliedInfo.EventDate2 = #GetSelectedEvent.EventDate2#>
				<cfset Session.UserSuppliedInfo.EventDate3 = #GetSelectedEvent.EventDate3#>
				<cfset Session.UserSuppliedInfo.EventDate4 = #GetSelectedEvent.EventDate4#>
				<cfif LEN(GetSelectedEvent.EventDate1) or LEN(GetSelectedEvent.EventDate2) or LEN(GetSelectedEvent.EventDate3) or LEN(GetSelectedEvent.EventDate4)>
					<cfset Session.UserSuppliedInfo.EventSpanDates = 1>
				<cfelse>
					<cfset Session.UserSuppliedInfo.EventSpanDates = 0>
				</cfif>
				<cfset Session.UserSuppliedInfo.LongDescription = #GetSelectedEvent.LongDescription#>
				<cfset Session.UserSuppliedInfo.Event_StartTime = #GetSelectedEvent.Event_StartTime#>
				<cfset Session.UserSuppliedInfo.Event_EndTime = #GetSelectedEvent.Event_EndTime#>
				<cfset Session.UserSuppliedInfo.Registration_Deadline = #GetSelectedEvent.Registration_Deadline#>
				<cfset Session.UserSuppliedInfo.Registration_BeginTime = #GetSelectedEvent.Registration_BeginTime#>
				<cfset Session.UserSuppliedInfo.Registration_EndTime = #GetSelectedEvent.Registration_EndTime#>
				<cfset Session.UserSuppliedInfo.EventFeatured = #GetSelectedEvent.EventFeatured#>
				<cfset Session.UserSuppliedInfo.Featured_StartDate = #GetSelectedEvent.Featured_StartDate#>
				<cfset Session.UserSuppliedInfo.Featured_EndDate = #GetSelectedEvent.Featured_EndDate#>
				<cfset Session.UserSuppliedInfo.Featured_SortOrder = #GetSelectedEvent.Featured_SortOrder#>
				<cfset Session.UserSuppliedInfo.MemberCost = #GetSelectedEvent.MemberCost#>
				<cfset Session.UserSuppliedInfo.NonMemberCost = #GetSelectedEvent.NonMemberCost#>
				<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = #GetSelectedEvent.EarlyBird_RegistrationDeadline#>
				<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable = #GetSelectedEvent.EarlyBird_RegistrationAvailable#>
				<cfset Session.UserSuppliedInfo.EarlyBird_MemberCost = #GetSelectedEvent.EarlyBird_MemberCost#>
				<cfset Session.UserSuppliedInfo.EarlyBird_NonMemberCost = #GetSelectedEvent.EarlyBird_NonMemberCost#>
				<cfset Session.UserSuppliedInfo.ViewSpecialPricing = #GetSelectedEvent.ViewSpecialPricing#>
				<cfset Session.UserSuppliedInfo.SpecialMemberCost = #GetSelectedEvent.SpecialMemberCost#>
				<cfset Session.UserSuppliedInfo.SpecialNonMemberCost = #GetSelectedEvent.SpecialNonMemberCost#>
				<cfset Session.UserSuppliedInfo.SpecialPriceRequirements = #GetSelectedEvent.SpecialPriceRequirements#>
				<cfset Session.UserSuppliedInfo.PGPAvailable = #GetSelectedEvent.PGPAvailable#>
				<cfset Session.UserSuppliedInfo.PGPPoints = #GetSelectedEvent.PGPPoints#>
				<cfset Session.UserSuppliedInfo.MealProvided = #GetSelectedEvent.MealProvided#>
				<cfset Session.UserSuppliedInfo.MealProvidedBy = #GetSelectedEvent.MealProvidedBy#>
				<cfset Session.UserSuppliedInfo.MealCost_Estimated = #GetSelectedEvent.MealCost_Estimated#>
				<cfset Session.UserSuppliedInfo.AllowVideoConference = #GetSelectedEvent.AllowVideoConference#>
				<cfset Session.UserSuppliedInfo.VideoConferenceInfo = #GetSelectedEvent.VideoConferenceInfo#>
				<cfset Session.UserSuppliedInfo.VideoConferenceCost = #GetSelectedEvent.VideoConferenceCost#>
				<cfset Session.UserSuppliedInfo.AcceptRegistrations = #GetSelectedEvent.AcceptRegistrations#>
				<cfset Session.UserSuppliedInfo.EventAgenda = #GetSelectedEvent.EventAgenda#>
				<cfset Session.UserSuppliedInfo.EventTargetAudience = #GetSelectedEvent.EventTargetAudience#>
				<cfset Session.UserSuppliedInfo.EventStrategies = #GetSelectedEvent.EventStrategies#>
				<cfset Session.UserSuppliedInfo.EventSpecialInstructions = #GetSelectedEvent.EventSpecialInstructions#>
				<cfset Session.UserSuppliedInfo.Maxparticipants = #GetSelectedEvent.Maxparticipants#>
				<cfset Session.UserSuppliedInfo.LocationType = #GetSelectedEvent.LocationType#>
				<cfset Session.UserSuppliedInfo.LocationID = #GetSelectedEvent.LocationID#>
				<cfset Session.UserSuppliedInfo.LocationRoomID = #GetSelectedEvent.LocationRoomID#>
				<cfset Session.UserSuppliedInfo.RoomMaxParticipants = #GetSelectedEvent.MaxParticipants#>
				<cfset Session.UserSuppliedInfo.Presenters = #GetSelectedEvent.Presenters#>
				<cfset Session.UserSuppliedInfo.Facilitator = #GetSelectedEvent.Facilitator#>
				<cfset Session.UserSuppliedInfo.dateCreated = #GetSelectedEvent.dateCreated#>
				<cfset Session.UserSuppliedInfo.lastUpdated = #GetSelectedEvent.lastUpdated#>
				<cfset Session.UserSuppliedInfo.lastUpdateBy = #GetSelectedEvent.lastUpdateBy#>
				<cfset Session.UserSuppliedInfo.Active = #GetSelectedEvent.Active#>
				<cfset Session.UserSuppliedInfo.WebinarAvailable = #GetSelectedEvent.WebinarAvailable#>
				<cfset Session.UserSuppliedInfo.WebinarConnectInfo = #GetSelectedEvent.WebinarConnectInfo#>
				<cfset Session.UserSuppliedInfo.WebinarMemberCost = #GetSelectedEvent.WebinarMemberCost#>
				<cfset Session.UserSuppliedInfo.WebinarNonMemberCost = #GetSelectedEvent.WebinarNonMemberCost#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameOne = #GetSelectedEvent.EventDoc_FileNameOne#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameTwo = #GetSelectedEvent.EventDoc_FileNameTwo#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameThree = #GetSelectedEvent.EventDoc_FileNameThree#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameFour =  #GetSelectedEvent.EventDoc_FileNameFour#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileNameFive = #GetSelectedEvent.EventDoc_FileNameFive#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeOne = #GetSelectedEvent.EventDoc_FileTypeOne#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeTwo = #GetSelectedEvent.EventDoc_FileTypeTwo#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeThree = #GetSelectedEvent.EventDoc_FileTypeThree#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeFour = #GetSelectedEvent.EventDoc_FileTypeFour#>
				<cfset Session.UserSuppliedInfo.EventDoc_FileTypeFive = #GetSelectedEvent.EventDoc_FileTypeFive#>
			</cflock>
		</cfif>

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif not isDefined("Session.UserSuppliedInfo")>
					<cfset Session.UserSuppliedInfo = StructNew()>
					<cfset Session.UserSuppliedInfo.NewRecNo = 0>
				</cfif>
			</cflock>

			<cfif LEN(FORM.EmailMsg) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Enter some text for the participants to ready about this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.emailattended&SiteID=#rc.$.siteConfig('siteID')#&EventID=#Session.UserSuppliedInfo.RecNo#" addtoken="false">
			</cfif>

			<cfquery name="GetAttendedUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select eRegistrations.RegistrationID, eRegistrations.Site_ID, eRegistrations.RegistrationDate, eRegistrations.EventID, eRegistrations.RequestsMeal, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice,
					eRegistrations.OnWaitingList, eRegistrations.Comments, eRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email, eRegistrations.AttendedEvent
				FROM eRegistrations INNER JOIN tusers ON tusers.UserID = eRegistrations.User_ID
				WHERE eRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					eRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					eRegistrations.AttendedEvent = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription,
					Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
					EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost,
					EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints,
					MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost,
					AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Maxparticipants,
					LocationType, LocationID, LocationRoomID, MaxParticipants, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy, Active,
					WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, EventDoc_FileNameOne, EventDoc_FileTypeOne, EventDoc_FileNameTwo, EventDoc_FileTypeTwo, EventDoc_FileNameThree, EventDoc_FileTypeThree,
					EventDoc_FileNameFour, EventDoc_FileTypeFour, EventDoc_FileNameFive, EventDoc_FileTypeFive
				From eEvents
				Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

			<cfif GetAttendedUsersForEvent.RecordCount>
				<cfif Len(FORM.FirstDocumentToSend) EQ 0 and LEN(Form.SecondDocumentToSend) EQ 0 and LEN(Form.ThirdDocumentToSend) EQ 0 and LEN(Form.FourthDocumentToSend) EQ 0 and LEN(Form.FifthDocumentToSend) EQ 0>
					<cfloop query="GetAttendedUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetAttendedUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetAttendedUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetAttendedUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
						<cfset ParticipantInfo.DocLinksInEmail = #FORM.IncludeFileLinks#>
						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(Variables.ParticipantInfo)#>
					</cfloop>
				<cfelse>
					<cfif isDefined("FORM.FirstDocumentToSend")>
						<cfif LEN(FORM.FirstDocumentToSend)>
							<cffile action="upload" fileField="FORM.FirstDocumentToSend" result="EventDocumentOne" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
							<cfset NewServerFileOne = #Replace(Variables.EventDocumentOne.ServerFile, " ", "_", "ALL")#>
							<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentOne.ServerFile#" Destination="#Variables.NewServerFileOne#">
							<cfdirectory action="list" directory="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#" name="DoesDirectoryExists">
							<cfif DoesDirectoryExists.RecordCount EQ 0>
								<cfdirectory action="Create" directory="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#">
							</cfif>
							<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileOne#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileOne#">
							<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eEvents
								Set EventDoc_FileNameOne = <cfqueryparam value="#Variables.NewServerFileOne#" cfsqltype="cf_sql_varchar">,
									EventDoc_FileTypeOne = <cfqueryparam value="#Variables.EventDocumentOne.ContentType#/#Variables.EventDocumentOne.ContentSubType#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#GetRegisteredUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfset EmailMessageWithFileOne = True>
						</cfif>
					</cfif>
					<cfif isDefined("FORM.SecondDocumentToSend")>
						<cfif LEN(FORM.SecondDocumentToSend)>
						<cffile action="upload" fileField="FORM.SecondDocumentToSend" result="EventDocumentTwo" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileTwo = #Replace(Variables.EventDocumentTwo.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentTwo.ServerFile#" Destination="#Variables.NewServerFileTwo#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileTwo#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileTwo#">
						<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDoc_FileNameTwo = <cfqueryparam value="#Variables.NewServerFileTwo#" cfsqltype="cf_sql_varchar">,
								EventDoc_FileTypeTwo = <cfqueryparam value="#Variables.EventDocumentTwo.ContentType#/#Variables.EventDocumentTwo.ContentSubType#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#GetAttendedUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EmailMessageWithFileTwo = True>
						</cfif>
					</cfif>
					<cfif isDefined("FORM.ThirdDocumentToSend")>
						<cfif LEN(FORM.ThirdDocumentToSend)>
						<cffile action="upload" fileField="FORM.ThirdDocumentToSend" result="EventDocumentThree" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileThree = #Replace(Variables.EventDocumentThree.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentThree.ServerFile#" Destination="#Variables.NewServerFileThree#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileThree#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileThree#">
						<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDoc_FileNameThree = <cfqueryparam value="#Variables.NewServerFileThree#" cfsqltype="cf_sql_varchar">,
								EventDoc_FileTypeThree = <cfqueryparam value="#Variables.EventDocumentThree.ContentType#/#Variables.EventDocumentThree.ContentSubType#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#GetAttendedUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EmailMessageWithFileThree = True>
						</cfif>
					</cfif>
					<cfif isDefined("FORM.FourthDocumentToSend")>
						<cfif LEN(FORM.FourthDocumentToSend)>
						<cffile action="upload" fileField="FORM.FourthDocumentToSend" result="EventDocumentFour" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileFour = #Replace(Variables.EventDocumentFour.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentFour.ServerFile#" Destination="#Variables.NewServerFileFour#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileFour#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileFour#">
						<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDoc_FileNameFour = <cfqueryparam value="#Variables.NewServerFileFour#" cfsqltype="cf_sql_varchar">,
								EventDoc_FileTypeFour = <cfqueryparam value="#Variables.EventDocumentFour.ContentType#/#Variables.EventDocumentFour.ContentSubType#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#GetAttendedUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EmailMessageWithFileFour = True>
						</cfif>
					</cfif>
					<cfif isDefined("FORM.FifthDocumentToSend")>
						<cfif LEN(FORM.FifthDocumentToSend)>
						<cffile action="upload" fileField="FORM.FifthDocumentToSend" result="EventDocumentFive" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
						<cfset NewServerFileFive = #Replace(Variables.EventDocumentFive.ServerFile, " ", "_", "ALL")#>
						<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocumentFive.ServerFile#" Destination="#Variables.NewServerFileFive#">
						<cffile action="move" source="#GetTempDirectory()#/#Variables.NewServerFileFive#" Destination="#rc.pc.getFullPath()#/library/EventDocs/#GetSelectedEvent.TContent_ID#/#Variables.NewServerFileFive#">
						<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eEvents
							Set EventDoc_FileNameFive = <cfqueryparam value="#Variables.NewServerFileFive#" cfsqltype="cf_sql_varchar">,
								EventDoc_FileTypeFive = <cfqueryparam value="#Variables.EventDocumentFive.ContentType#/#Variables.EventDocumentFive.ContentSubType#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#GetAttendedUsersForEvent.EventID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EmailMessageWithFileFive = True>
						</cfif>
					</cfif>
					<cfloop query="GetAttendedUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetAttendedUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetAttendedUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetAttendedUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
						<cfset ParticipantInfo.DocLinksInEmail = #FORM.IncludeFileLinks#>
						<cfset ParticipantInfo.PackageName = #rc.pc.getPackage()#>
						<cfset ParticipantInfo.EventID = #GetAttendedUsersForEvent.EventID#>

						<cfif isDefined("Variables.EmailMessageWithFileOne") or LEN(GetSelectedEvent.EventDoc_FileNameOne)>
							<cfset ParticipantInfo.EmailFileOne = True>
							<cfif isDefined("Variables.EmailMessageWithFileOne")>
								<cfset ParticipantInfo.EmailFileLocOne = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileOne#>
								<cfset ParticipantInfo.EmailFileNameOne = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileOne#>
								<cfset ParticipantInfo.EmailFileTypeOne = #Variables.EventDocumentOne.ContentType# & "/" & #Variables.EventDocumentOne.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocOne = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameOne#>
								<cfset ParticipantInfo.EmailFileNameOne = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameOne#>
								<cfset ParticipantInfo.EmailFileTypeOne = #GetSelectedEvent.EventDoc_FileTypeOne#>
							</cfif>
						</cfif>
						<cfif isDefined("Variables.EmailMessageWithFileTwo")  or LEN(GetSelectedEvent.EventDoc_FileNameTwo)><cfset ParticipantInfo.EmailFileTwo = True>
							<cfif isDefined("Variables.EmailMessageWithFileTwo")>
								<cfset ParticipantInfo.EmailFileLocTwo = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileTwo#>
								<cfset ParticipantInfo.EmailFileNameTwo = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileTwo#>
								<cfset ParticipantInfo.EmailFileTypeTwo = #Variables.EventDocumentTwo.ContentType# & "/" & #Variables.EventDocumentTwo.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocTwo = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameTwo#>
								<cfset ParticipantInfo.EmailFileNameTwo = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameTwo#>
								<cfset ParticipantInfo.EmailFileTypeTwo = #GetSelectedEvent.EventDoc_FileTypeTwo#>
							</cfif>
						</cfif>
						<cfif isDefined("Variables.EmailMessageWithFileThree")  or LEN(GetSelectedEvent.EventDoc_FileNameThree)><cfset ParticipantInfo.EmailFileThree = True>
							<cfif isDefined("Variables.EmailMessageWithFileThree")>
								<cfset ParticipantInfo.EmailFileLocThree = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileThree#>
								<cfset ParticipantInfo.EmailFileNameThree = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileThree#>
								<cfset ParticipantInfo.EmailFileTypeThree = #Variables.EventDocumentThree.ContentType# & "/" & #Variables.EventDocumentThree.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocThree = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameThree#>
								<cfset ParticipantInfo.EmailFileNameThree = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameThree#>
								<cfset ParticipantInfo.EmailFileTypeThree = #GetSelectedEvent.EventDoc_FileTypeThree#>
							</cfif>
						</cfif>
						<cfif isDefined("Variables.EmailMessageWithFileFour")  or LEN(GetSelectedEvent.EventDoc_FileNameFour)><cfset ParticipantInfo.EmailFileFour = True>
						<cfif isDefined("Variables.EmailMessageWithFileFour")>
								<cfset ParticipantInfo.EmailFileLocFour = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileFour#>
								<cfset ParticipantInfo.EmailFileNameFour = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileFour#>
								<cfset ParticipantInfo.EmailFileTypeFour = #Variables.EventDocumentFour.ContentType# & "/" & #Variables.EventDocumentFour.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocFour = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameFour#>
								<cfset ParticipantInfo.EmailFileNameFour = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameFour#>
								<cfset ParticipantInfo.EmailFileTypeFour = #GetSelectedEvent.EventDoc_FileTypeFour#>
							</cfif>
						</cfif>
						<cfif isDefined("Variables.EmailMessageWithFileFive")  or LEN(GetSelectedEvent.EventDoc_FileNameFive)><cfset ParticipantInfo.EmailFileFive = True>
							<cfif isDefined("Variables.EmailMessageWithFileFive")>
								<cfset ParticipantInfo.EmailFileLocFive = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileFive#>
								<cfset ParticipantInfo.EmailFileNameFive = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #Variables.NewServerFileFive#>
								<cfset ParticipantInfo.EmailFileTypeFive = #Variables.EventDocumentFive.ContentType# & "/" & #Variables.EventDocumentFive.ContentSubType#>
							<cfelse>
								<cfset ParticipantInfo.EmailFileLocFive = #rc.pc.getFullPath()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameFive#>
								<cfset ParticipantInfo.EmailFileNameFive = #rc.pc.getPackage()# & "/library/EventDocs/" & #GetSelectedEvent.TContent_ID# & "/" & #GetSelectedEvent.EventDoc_FileNameFive#>
								<cfset ParticipantInfo.EmailFileTypeFive = #GetSelectedEvent.EventDoc_FileTypeFive#>
							</cfif>
						</cfif>
						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(Variables.ParticipantInfo)#>
					</cfloop>
				</cfif>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=RegistrationsSent&SiteID=#rc.$.siteConfig('siteID')#&Successful=true&EventID=#GetRegisteredUsersForEvent.EventID#" addtoken="false">
			<cfelseif GetAttendedUsersForEvent.RecordCount EQ 0>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&UserAction=NoRegistrations&SiteID=#rc.$.siteConfig('siteID')#&Successful=false&EventID=#GetRegisteredUsersForEvent.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>
