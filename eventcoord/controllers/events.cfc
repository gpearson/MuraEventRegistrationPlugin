<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset PriorYear = #Year(DateAdd('yyyy', -1, Now()))#>
		<cfset PriorDate = #Createdate(Variables.PriorYear, 7, 1)#>

		<!--- <cfset PriorDate = #DateAdd("m", -8, Now())#> --->
		<cfquery name="Session.getAvailableEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, PGPAvailable, MemberCost, NonMemberCost, Presenters, Active, EventCancelled, AcceptRegistrations, Registration_Deadline, MaxParticipants, EventInvoicesGenerated
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				EventDate >= <cfqueryparam value="#Variables.PriorDate#" cfsqltype="cf_sql_date">
			Order by EventDate DESC
		</cfquery>

		<cfquery name="Session.getSiteConfig" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select ProcessPayments_Stripe, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, Google_ReCaptchaSiteKey, Google_ReCaptchaSecretKey, SmartyStreets_Enabled, SmartyStreets_ApiID, SmartyStreets_APIToken
			From p_EventRegistration_SiteConfig
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif isDefined("Session.getFacilityInformation")><cfset temp = StructDelete(Session, "getFacilityInformation")></cfif>
		<cfif isDefined("Session.getFacilityRoomInfo")><cfset temp = StructDelete(Session, "getFacilityRoomInfo")></cfif>
		<cfif isDefined("Session.getFeaturedEvents")><cfset temp = StructDelete(Session, "getFeaturedEvents")></cfif>
		<cfif isDefined("Session.getNonFeaturedEvents")><cfset temp = StructDelete(Session, "getNonFeaturedEvents")></cfif>
		<cfif isDefined("Session.getSpecificFacilityRoomInfo")><cfset temp = StructDelete(Session, "getSpecificFacilityRoomInfo")></cfif>
		<cfif isDefined("Session.FormErrors")><cfset temp = StructDelete(Session, "FormErrors")></cfif>
	</cffunction>

	<cffunction name="addevent" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfif isDefined("FORM.formSubmit")>
			<cfif FORM.AddNewEventStep EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "UserSuppliedInfo")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" addtoken="false">
			</cfif>

			<cflock timeout="60" scope="Session" type="Exclusive"><cfset Session.FormErrors = #ArrayNew()#></cflock>

			<cfif not isDefined("FORM.EventSpanDates")><cfset FORM.EventSpanDates = 0><cfelse><cfset FORM.EventSpanDates = 1></cfif>
			<cfif not isDefined("FORM.EventFeatured")><cfset FORM.EventFeatured = 0><cfelse><cfset FORM.EventFeatured = 1></cfif>
			<cfif not isDefined("FORM.EarlyBird_RegistrationAvailable")><cfset FORM.EarlyBird_RegistrationAvailable = 0><cfelse><cfset FORM.EarlyBird_RegistrationAvailable = 1></cfif>
			<cfif not isDefined("FORM.ViewGroupPricing")><cfset FORM.ViewGroupPricing = 0><cfelse><cfset FORM.ViewGroupPricing = 1></cfif>
			<cfif not isDefined("FORM.PGPAvailable")><cfset FORM.PGPAvailable = 0><cfelse><cfset FORM.PGPAvailable = 1></cfif>
			<cfif not isDefined("FORM.AllowVideoConference")><cfset FORM.AllowVideoConference = 0><cfelse><cfset FORM.AllowVideoConference = 1></cfif>
			<cfif not isDefined("FORM.WebinarEvent")><cfset FORM.WebinarEvent = 0><cfelse><cfset FORM.WebinarEvent = 1></cfif>
			<cfif not isDefined("FORM.MealAvailable")><cfset FORM.MealAvailable = 0><cfelse><cfset FORM.MealAvailable = 1></cfif>
			<cfif not isDefined("FORM.PostEventToFB")><cfset FORM.PostEventToFB = 0><cfelse><cfset FORM.PostEventToFB = 1></cfif>
			<cfif not isDefined("FORM.EventBreakoutSessions")><cfset FORM.EventBreakoutSessions = 0><cfelse><cfset FORM.EventBreakoutSessions = 1></cfif>
			<cfif not isDefined("FORM.EventHaveSessions")><cfset FORM.EventHaveSessions = 0><cfelse><cfset FORM.EventHaveSessions = 1></cfif>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.FirstStep = #StructCopy(FORM)#>
			</cflock>
			<cfset Session.UserSuppliedInfo.FirstStep.LongDescription = #FORM.LongDescription#>
			<cfif not isNumericDate(FORM.EventDate)>
				<cfscript>
					eventdate = {property="EventDate",message="Event Date is not in correct date format"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			<cfelse>
				<cfset Session.UserSuppliedInfo.FirstStep.EventDate = #FORM.EventDate#>
			</cfif>

			<cfif not isNumericDate(FORM.Registration_Deadline)>
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Registration Deadline is not in correct date format"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			<cfelse>
				<cfset Session.UserSuppliedInfo.FirstStep.Registration_Deadline = #FORM.Registration_Deadline#>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent&FormRetry=True" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>
		<cfelseif not isDefined("FORM.formSubmit")>
			<!---
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
			--->
		</cfif>
	</cffunction>

	<cffunction name="addevent_step2" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfif not isDefined("Session.UserSuppliedInfo.FirstStep.WebinarEvent")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent" addtoken="false">
			</cfif>

			<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
				<cfquery name="Session.getFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, FacilityName
					From p_EventRegistration_Facility
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
					Order by FacilityName
				</cfquery>
			</cfif>
			<cfif Session.UserSuppliedInfo.FirstStep.MealAvailable EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
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
				<cfset Session.UserSuppliedInfo.SecondStep = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.LocationID EQ "----">
				<cfscript>
					errormsg = {property="MealProvidedBy",message="Please Select a Facility to hold this event. If a facility does not display in the Location dropdown, you first must add a facility to the system."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&FormRetry=True" addtoken="true">
			</cfif>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
					<cfif Session.UserSuppliedInfo.FirstStep.MealAvailable EQ 1>
						<cfif FORM.MealIncluded EQ "----">
							<cfscript>
								errormsg = {property="MealProvidedBy",message="Please Select if Participant's Meal is included in the Registration Fee or not for this event."};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
							<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&FormRetry=True" addtoken="false">
						<cfelse>
							<cfset Session.UserSuppliedInfo.SecondStep.MealIncluded = #FORM.MealIncluded#>
						</cfif>

						<cfif FORM.MealProvidedBy EQ 0>
							<cfscript>
								errormsg = {property="MealProvidedBy",message="Please Select a Caterer for this meal's event"};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
							<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&FormRetry=True" addtoken="false">
						<cfelse>
							<cfset Session.UserSuppliedInfo.SecondStep.MealProvidedBy = #FORM.MealProvidedBy#>
						</cfif>
					</cfif>
					<cfif FORM.LocationID EQ 0>
						<cfscript>
							errormsg = {property="LocationID",message="Please Select Facility where event will be held"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&FormRetry=True" addtoken="false">
					<cfelse>
						<cfset Session.UserSuppliedInfo.SecondStep.LocationID = #FORM.LocationID#>
					</cfif>
				</cfif>
			</cflock>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step3&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addevent_step3" returntype="any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getFacilityRoomInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select p_EventRegistration_Facility.FacilityName, p_EventRegistration_Facility.PhysicalAddress, p_EventRegistration_Facility.PhysicalCity, p_EventRegistration_Facility.PhysicalState, p_EventRegistration_Facility.PhysicalZipCode,
					p_EventRegistration_Facility.PhysicalZip4, p_EventRegistration_Facility.PrimaryVoiceNumber, p_EventRegistration_Facility.BusinessWebsite, p_EventRegistration_FacilityRooms.TContent_ID as RoomID, p_EventRegistration_FacilityRooms.RoomName, p_EventRegistration_FacilityRooms.Capacity, p_EventRegistration_FacilityRooms.RoomFees
				From p_EventRegistration_Facility INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.Facility_ID = p_EventRegistration_Facility.TContent_ID
				Where p_EventRegistration_Facility.TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.SecondStep.LocationID#" cfsqltype="cf_sql_integer"> and
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
			<cfset Session.UserSuppliedInfo.ThirdStep = #StructCopy(FORM)#>
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
				Where p_EventRegistration_FacilityRooms.TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.ThirdStep.LocationRoomID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_Facility.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfif FORM.AddNewEventStep EQ "Back to Step 3">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step3&FormRetry=True" addtoken="false">
			</cfif>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfparam default="0" name="FORM.AcceptRegistrations" type="boolean">

			<cfset Session.UserSuppliedInfo.FourthStep = #StructCopy(FORM)#>

			<cfif LEN(FORM.RoomMaxParticipants) EQ 0>
				<cfscript>
					errormsg = {property="MealProvidedBy",message="Please Enter the maximum number of participants for this event or workshop"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
			</cfif>

			<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
				<cfif FORM.RoomMaxParticipants GT Session.getSpecificFacilityRoomInfo.Capacity>
					<cfscript>
					errormsg = {property="MealProvidedBy",message="Maximum Participants enteres is greater than the Room Capacity this event will be held in."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&SiteID=#rc.$.siteConfig('siteID')#&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>
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
			<cfset Session.UserSuppliedInfo.FinalStep = #StructCopy(FORM)#>
			<cfset Session.UserSuppliedInfo.AddNewEventStep = #FORM.AddNewEventStep#>
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
				<cfif not isNumericDate(FORM.EventDate1) and LEN(FORM.EventDate1)>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="2nd Event Date is not in the correct date format."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif isDefined("FORM.EventDate2")>
				<cfif not isNumericDate(FORM.EventDate2) and LEN(FORM.EventDate2)>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="3rd Event Date is not in the correct date format."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif isDefined("FORM.EventDate3")>
				<cfif not isNumericDate(FORM.EventDate3) and LEN(FORM.EventDate3)>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="4th Event Date is not in the correct date format."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif isDefined("FORM.EventDate4")>
				<cfif not isNumericDate(FORM.EventDate4) and LEN(FORM.EventDate4)>
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
			<cfif FORM.EventFeatured EQ 1 AND LEN(FORM.Featured_StartDate) EQ 0 OR FORM.EventFeatured EQ 1 AND LEN(FORM.Featured_EndDate) EQ 0>
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

			<cfif FORM.EarlyBird_RegistrationAvailable EQ 1>
				<cfif FORM.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_RegistrationDeadline) EQ 0>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="To utilize the Early Bird Registration Feature a date is needed."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
				<cfif FORM.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_Member) EQ 0 OR FORM.EarlyBird_RegistrationAvailable EQ 1 and LEN(FORM.EarlyBird_NonMemberCost) EQ 0>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="To utilize the Early Bird Registration Feature you will need to enter the cost for members and non members if they register for the early bird deadline date."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.ViewGroupPricing EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select whether this event will offer Group pricing when participants have met the requirements for this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.ViewGroupPricing EQ 1>
				<cfif FORM.ViewGroupPricing EQ 1 and LEN(FORM.GroupPriceRequirements) LT 50>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please enter the requirements needed for participants to meet in order to receive this Group pricing for this event."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
				<cfif FORM.ViewGroupPricing EQ 1 and LEN(FORM.GroupMemberCost) EQ 0 or FORM.ViewGroupPricing EQ 1 and LEN(FORM.GroupNonMemberCost) EQ 0>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please enter the Group pricing amounts for Member and NonMember. To not use this feature you can simply change the value of View Group Pricing to 'No'"};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.PGPAvailable EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select whether this event will offer Professional Growth Point Certificate to those individuals who attended the entire event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.PGPAvailable EQ 1>
				<cfif FORM.PGPAvailable EQ 1 and LEN(FORM.PGPPoints) EQ 0>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please enter how many PGP Points you want to award the participants that successfully attended this event or workshop."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.MealAvailable EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select if this event or workshop will include a meal for the participants who attend this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.MealAvailable EQ 1>
				<cfif FORM.MealAvailable EQ 1 and FORM.MealProvidedBy EQ "----">
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please enter who will be providing the meal for this event or workshop. To not use this feature simply change the option of Meal Provided to 'No'"};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>

				<cfif FORM.MealAvailable EQ 1 and FORM.MealIncluded EQ "----">
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please enter if the meal is included in the registration price or not."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.AllowVideoConference EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select if this event or workshop will allow participants to connect with Distance Education Equipment (Polycom, Lifesize, Tangburg)."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.AllowVideoConference EQ 1>
				<cfif FORM.AllowVideoConference EQ 1 and LEN(FORM.VideoConferenceInfo) LT 50 or FORM.AllowVideoConference EQ 1 and LEN(FORM.VideoConferenceCost) EQ 0>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please enter information as to how the participant will connect to this event through the distance education equipment or enter the cost for the particpant to use this method to attend this event."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.WebinarEvent EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select if this event or workshop will only be allowed through a WebEx/Webinar availability."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.WebinarEvent EQ 1>
				<cfif FORM.WebinarEvent EQ 1 and LEN(FORM.WebinarConnectWebInfo) LT 50 or FORM.WebinarEvent EQ 1 and LEN(FORM.WebinarMemberCost) EQ 0 or FORM.WebinarEvent EQ 1 and LEN(FORM.WebinarNonMemberCost) EQ 0>
					<cfscript>
						eventdate = {property="Registration_Deadline",message="Please enter the necessary information to give particiants information on how to connect to this event as a webinar and/or the costs for a participant to utilize this option."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
				</cfif>
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

			<cfif FORM.EventHaveSessions EQ "----">
				<cfscript>
						eventdate = {property="Registration_Deadline",message="Please select whether this single event will have multiple sessions on the same day."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_review&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.EventHaveSessions EQ 1>
				<!--- Create Date Object from User Inputted Time from Event First Session Begin Time  --->
				<cfset EventSession1StartTimeHours = #ListFirst(FORM.EventSession1_StartTime, ":")#>
				<cfset EventSession1StartTimeMinutes = #Left(ListLast(FORM.EventSession1_StartTime, ":"), 2)#>
				<cfset EventSession1StartTimeAMPM = #Right(ListLast(FORM.EventSession1_StartTime, ":"), 2)#>
				<cfif EventSession1StartTimeAMPM EQ "PM">
					<cfswitch expression="#Variables.EventSession1StartTimeHours#">
						<cfcase value="12">
							<cfset EventSession1StartTimeHours = #Variables.EventSession1StartTimeHours#>
						</cfcase>
						<cfdefaultcase>
							<cfset EventSession1StartTimeHours = #Variables.EventSession1StartTimeHours# + 12>
						</cfdefaultcase>
					</cfswitch>
				</cfif>
				<cfset EventSession1StartTimeObject = #CreateTime(Variables.EventSession1StartTimeHours, Variables.EventSession1StartTimeMinutes, 0)#>

				<!--- Create Date Object from User Inputted Time from Event First Session End Time  --->
				<cfset EventSession1EndTimeHours = #ListFirst(FORM.EventSession1_EndTime, ":")#>
				<cfset EventSession1EndTimeMinutes = #Left(ListLast(FORM.EventSession1_EndTime, ":"), 2)#>
				<cfset EventSession1EndTimeAMPM = #Right(ListLast(FORM.EventSession1_EndTime, ":"), 2)#>
				<cfif EventSession1EndTimeAMPM EQ "PM">
					<cfswitch expression="#Variables.EventSession1EndTimeHours#">
						<cfcase value="12">
							<cfset EventSession1EndTimeHours = #Variables.EventSession1EndTimeHours#>
						</cfcase>
						<cfdefaultcase>
							<cfset EventSession1EndTimeHours = #Variables.EventSession1EndTimeHours# + 12>
						</cfdefaultcase>
					</cfswitch>
				</cfif>
				<cfset EventSession1EndTimeObject = #CreateTime(Variables.EventSession1EndTimeHours, Variables.EventSession1EndTimeMinutes, 0)#>

				<cfset EventSession2StartTimeHours = #ListFirst(FORM.EventSession2_StartTime, ":")#>
				<cfset EventSession2StartTimeMinutes = #Left(ListLast(FORM.EventSession2_StartTime, ":"), 2)#>
				<cfset EventSession2StartTimeAMPM = #Right(ListLast(FORM.EventSession2_StartTime, ":"), 2)#>
				<cfif EventSession2StartTimeAMPM EQ "PM">
					<cfswitch expression="#Variables.EventSession2StartTimeHours#">
						<cfcase value="12">
							<cfset EventSession2StartTimeHours = #Variables.EventSession2StartTimeHours#>
						</cfcase>
						<cfdefaultcase>
							<cfset EventSession2StartTimeHours = #Variables.EventSession2StartTimeHours# + 12>
						</cfdefaultcase>
					</cfswitch>
				</cfif>
				<cfset EventSession2StartTimeObject = #CreateTime(Variables.EventSession2StartTimeHours, Variables.EventSession2StartTimeMinutes, 0)#>

				<!--- Create Date Object from User Inputted Time from Event First Session End Time  --->
				<cfset EventSession2EndTimeHours = #ListFirst(FORM.EventSession2_EndTime, ":")#>
				<cfset EventSession2EndTimeMinutes = #Left(ListLast(FORM.EventSession2_EndTime, ":"), 2)#>
				<cfset EventSession2EndTimeAMPM = #Right(ListLast(FORM.EventSession2_EndTime, ":"), 2)#>
				<cfif EventSession2EndTimeAMPM EQ "PM">
					<cfswitch expression="#Variables.EventSession2EndTimeHours#">
						<cfcase value="12">
							<cfset EventSession2EndTimeHours = #Variables.EventSession2EndTimeHours#>
						</cfcase>
						<cfdefaultcase>
							<cfset EventSession2EndTimeHours = #Variables.EventSession2EndTimeHours# + 12>
						</cfdefaultcase>
					</cfswitch>
				</cfif>
				<cfset EventSession2EndTimeObject = #CreateTime(Variables.EventSession2EndTimeHours, Variables.EventSession2EndTimeMinutes, 0)#>

			</cfif>

			<!--- Create Date Object from User Inputted Time from Event Start Time --->
			<cfset EventStartTimeHours = #ListFirst(FORM.Event_StartTime, ":")#>
			<cfset EventStartTimeMinutes = #Left(ListLast(FORM.Event_StartTime, ":"), 2)#>
			<cfset EventStartTimeAMPM = #Right(ListLast(FORM.Event_StartTime, ":"), 2)#>
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
			<cfset EventEndTimeHours = #ListFirst(FORM.Event_EndTime, ":")#>
			<cfset EventEndTimeMinutes = #Left(ListLast(FORM.Event_EndTime, ":"), 2)#>
			<cfset EventEndTimeAMPM = #Right(ListLast(FORM.Event_EndTime, ":"), 2)#>
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
			<cfset RegistrationBeginTimeHours = #ListFirst(FORM.Registration_BeginTime, ":")#>
			<cfset RegistrationBeginTimeMinutes = #Left(ListLast(FORM.Registration_BeginTime, ":"), 2)#>
			<cfset RegistrationBeginTimeAMPM = #Right(ListLast(FORM.Registration_BeginTime, ":"), 2)#>
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
					Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, EarlyBird_RegistrationAvailable, ViewGroupPricing, PGPAvailable, MealAvailable, AllowVideoConference, AcceptRegistrations, Facilitator, dateCreated, MaxParticipants, Active, lastUpdated, lastUpdateBy, EventCancelled)
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
						<cfqueryparam value="#FORM.ViewGroupPricing#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#FORM.PGPAvailable#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#FORM.MealAvailable#" cfsqltype="cf_sql_bit">,
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
								MemberCost = <cfqueryparam value="#LSParseNumber(FORM.MemberCost, 'english (united states)')#" cfsqltype="cf_sql_money">,
								NonMemberCost = <cfqueryparam value="#LSParseNumber(FORM.NonMemberCost, 'english (united states)')#" cfsqltype="cf_sql_money">,
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
									EarlyBird_MemberCost = <cfqueryparam value="#LSParseNumber(FORM.EarlyBird_MemberCost, 'english (united states)')#" cfsqltype="cf_sql_money">,
									EarlyBird_NonMemberCost = <cfqueryparam value="#LSParseNumber(FORM.EarlyBird_NonMemberCost, 'english (united states)')#" cfsqltype="cf_sql_money">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif FORM.EventHaveSessions EQ 1>
							<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_Events
								Set EventHasDailySessions = <cfqueryparam value="#FORM.EventHaveSessions#" cfsqltype="cf_sql_bit">,
									Session1BeginTime = <cfqueryparam value="#Variables.EventSession1StartTimeObject#" cfsqltype="cf_sql_time">,
									Session1EndTime = <cfqueryparam value="#Variables.EventSession1EndTimeObject#" cfsqltype="cf_sql_time">,
									Session2BeginTime = <cfqueryparam value="#Variables.EventSession2StartTimeObject#" cfsqltype="cf_sql_time">,
									Session2EndTime = <cfqueryparam value="#Variables.EventSession2EndTimeObject#" cfsqltype="cf_sql_time">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif FORM.ViewGroupPricing EQ 1>
							<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_Events
								Set ViewGroupPricing = <cfqueryparam value="#FORM.ViewGroupPricing#" cfsqltype="cf_sql_bit">,
									GroupMemberCost = <cfqueryparam value="#LSParseNumber(FORM.GroupMemberCost, 'english (united states)')#" cfsqltype="cf_sql_money">,
									GroupNonMemberCost = <cfqueryparam value="#LSParseNumber(FORM.GroupNonMemberCost, 'english (united states)')#" cfsqltype="cf_sql_money">,
									GroupPriceRequirements = "#FORM.GroupPriceRequirements#",
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

						<cfif FORM.MealAvailable EQ 1>
							<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_Events
								Set MealProvidedBy = <cfqueryparam value="#FORM.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
									MealIncluded = <cfqueryparam value="#FORM.MealIncluded#" cfsqltype="CF_SQL_bit">,
									MealCost = <cfqueryparam value="#LSParseNumber(FORM.MealCost, 'english (united states)')#" cfsqltype="cf_sql_DECIMAL">,
									Meal_Notes = <cfqueryparam value="#FORM.MealInformation#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif FORM.AllowVideoConference EQ 1>
							<cfset FORM.VideoConferenceCost = #Right(FORM.VideoConferenceCost, LEN(FORM.VideoConferenceCost) - 1)#>
							<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_Events
								Set AllowVideoConference = <cfqueryparam value="#FORM.AllowVideoConference#" cfsqltype="cf_sql_bit">,
									VideoConferenceInfo = <cfqueryparam value="#FORM.VideoConferenceInfo#" cfsqltype="CF_SQL_VARCHAR">,
									VideoConferenceCost = <cfqueryparam value="#LSParseNumber(FORM.VideoConferenceCost, 'english (united states)')#" cfsqltype="cf_sql_DECIMAL">,
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
									WebinarMemberCost = <cfqueryparam value="#LSParseNumber(FORM.WebinarMemberCost, 'english (united states)')#" cfsqltype="cf_sql_DECIMAL">,
									WebinarNonMemberCost = <cfqueryparam value="#LSParseNumber(FORM.WebinarNonMemberCost, 'english (united states)')#" cfsqltype="cf_sql_DECIMAL">,
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
								MemberCost = <cfqueryparam value="#LSParseNumber(FORM.MemberCost, 'english (united states)')#" cfsqltype="cf_sql_money">,
								NonMemberCost = <cfqueryparam value="#LSParseNumber(FORM.NonMemberCost, 'english (united states)')#" cfsqltype="cf_sql_money">,
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

						<cfif FORM.ViewGroupPricing EQ 1>
							<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_Events
								Set ViewGroupPricing = <cfqueryparam value="#FORM.ViewGroupPricing#" cfsqltype="cf_sql_bit">,
									GroupMemberCost = "#FORM.GroupMemberCost#",
									GroupNonMemberCost = "#FORM.GroupNonMemberCost#",
									GroupPriceRequirements = "#FORM.GroupPriceRequirements#",
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

						<cfif FORM.MealAvailable EQ 1>
							<cfquery name="updateNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_Events
								Set MealProvidedBy = <cfqueryparam value="#FORM.MealProvidedBy#" cfsqltype="CF_SQL_INTEGER">,
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
					ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy,
					Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, PostedTo_Facebook, PostedTo_Twitter
				From p_EventRegistration_Events
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="CF_SQL_INTEGER"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
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
					ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy,
					Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, PostedTo_Facebook, PostedTo_Twitter
				From p_EventRegistration_Events
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="CF_SQL_INTEGER"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
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
						Insert into p_EventRegistration_Events(Site_ID,
						 ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime,
						  EventFeatured, EarlyBird_RegistrationAvailable, ViewGroupPricing, PGPAvailable, MealAvailable, MealIncluded, AllowVideoConference, AcceptRegistrations,
							 Facilitator, dateCreated, MaxParticipants, Active, lastUpdated, lastUpdateBy, EventCancelled, WebinarAvailable, PostedTo_Facebook, PostedTo_Twitter)
						Values (
							<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="Copy of #Session.getSelectedEvent.ShortTitle#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.getSelectedEvent.EventDate#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#Session.getSelectedEvent.LongDescription#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.getSelectedEvent.Event_StartTime#" cfsqltype="cf_sql_time">,
							<cfqueryparam value="#Session.getSelectedEvent.Event_EndTime#" cfsqltype="cf_sql_time">,
							<cfqueryparam value="#Session.getSelectedEvent.Registration_Deadline#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#Session.getSelectedEvent.Registration_BeginTime#" cfsqltype="cf_sql_time">,
							<cfqueryparam value="#Session.getSelectedEvent.Registration_EndTime#" cfsqltype="cf_sql_time">,
							<cfqueryparam value="#Session.getSelectedEvent.EventFeatured#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.ViewGroupPricing#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.PGPAvailable#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.MealAvailable#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.MealAvailable#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.getSelectedEvent.AllowVideoConference#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#Session.getSelectedEvent.MaxParticipants#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
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
							<cfif LEN(Session.getSelectedEvent.GroupMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set GroupMemberCost = <cfqueryparam value="#Session.getSelectedEvent.GroupMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.GroupNonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set GroupNonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.GroupNonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.GroupPriceRequirements)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set GroupPriceRequirements = <cfqueryparam value="#Session.getSelectedEvent.GroupPriceRequirements#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
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
							<cfif LEN(Session.getSelectedEvent.GroupMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set GroupMemberCost = <cfqueryparam value="#Session.getSelectedEvent.GroupMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.GroupNonMemberCost)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set GroupNonMemberCost = <cfqueryparam value="#Session.getSelectedEvent.GroupNonMemberCost#" cfsqltype="cf_sql_float"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif LEN(Session.getSelectedEvent.GroupPriceRequirements)>
								<cfquery name="updateEventInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_Events Set GroupPriceRequirements = <cfqueryparam value="#Session.getSelectedEvent.GroupPriceRequirements#" cfsqltype="cf_sql_varchar"> Where TContent_ID = <cfqueryparam value="#insertNewEvent.IdentityCol#" cfsqltype="cf_sql_integer">
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
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#insertNewEvent.GENERATED_KEY#" addtoken="false">
					</cfcase>
					<cfcase value="mssql">
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#insertNewEvent.IdentityCol#" addtoken="false">
					</cfcase>
				</cfswitch>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="registeruserforevent" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost,
					ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy,
					Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, PostedTo_Facebook, PostedTo_Twitter
				From p_EventRegistration_Events
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="CF_SQL_INTEGER"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="Session.getEventLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode
				From p_EventRegistration_Facility
				Where TContent_ID = <cfqueryparam value="#Session.getSelectedEvent.LocationID#" cfsqltype="CF_SQL_INTEGER"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="Session.GetMembershipOrganizations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
				From p_EventRegistration_Membership
				Order by OrganizationName
			</cfquery>
			<cfquery name="Session.CheckExistingSentEmailsForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select MsgBody, LinksToInclude, DocsToInclude
				From p_EventRegistration_EventEmailLog
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					EmailType = <cfqueryparam value="EmailRegistered" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfif not isDefined("URL.EventStatus")>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.UserRegister = #StructNew()#>
				</cflock>
			</cfif>

			<cfif isDefined("URL.EventStatus")>
				<cfswitch expression="#URl.EventStatus#">
					<cfcase value="ShowCorporations">
						<cfquery name="Session.GetSelectedAccountsWithinOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select UserID, Fname, Lname, Email
							From tusers
							WHERE 1 = 1 AND
								Email LIKE '%#Session.UserRegister.DistrictDomain#%'
							Order by Lname, Fname
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif not isDefined("Session.UserRegister.FirstStep")>
					<cfset Session.UserRegister.FirstStep = #StructCopy(FORM)#>
				</cfif>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
			<cfif isDefined("FORM.DistrictName")>
				<cfif FORM.DistrictName EQ "----">
					<cfscript>
						eventdate = {property="EventDate",message="Please select a School District from the list for the individuals you are registering for this event."};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfswitch expression="#URL.EventStatus#">
				<cfcase value="ShowCorporations">
					<cfquery name="GetMembershipOrganizations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
						From p_EventRegistration_Membership
						Where TContent_ID = <cfqueryparam value="#FORM.DistrictName#" cfsqltype="cf_sql_integer">
						Order by OrganizationName
					</cfquery>
					<cfset Session.UserRegister.DistrictDomain = #GetMembershipOrganizations.OrganizationDomainName#>
					<cfset Session.UserRegister.DistrictMembership = #GetMembershipOrganizations.Active#>
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
					<cfquery name="Session.GetSelectedAccountsWithinOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID, Fname, Lname, Email
						From tusers
						WHERE 1 = 1 AND
							SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							Email LIKE '%#GetMembershipOrganizations.OrganizationDomainName#%'
						Order by Lname, Fname
					</cfquery>
					<cfif Session.GetSelectedAccountsWithinOrganization.RecordCount EQ 0><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventStatus=ShowCorporations&EventID=#URL.EventID#" addtoken="false"></cfif>
				</cfcase>
				<cfcase value="RegisterParticipants">
					<cfif StructCount(Session.UserRegister.FirstStep) EQ 0>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#" addtoken="false">
					</cfif>
					<cfset Session.UserRegister.SecondStep = #StructCopy(FORM)#>
					<cfif not isDefined("FORM.ParticipantEmployee")>
						<cfscript>
							eventdate = {property="EventDate",message="Please select atleast 1 participant that you would like to register from the list provided. Or if the individual is not listed in the list, please add them in the space provided and click the Add Button."};
							arrayAppend(Session.FormErrors, eventdate);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipants&FormRetry=True" addtoken="false">
					</cfif>
					<cfif isDefined("FORM.RegisterParticipantStayForMeal")>
						<cfif FORM.RegisterParticipantStayForMeal EQ "on">
							<cfset FORM.RegisterParticipantStayForMeal = 1>
						</cfif>
					<cfelse>
						<cfset FORM.RegisterParticipantStayForMeal = 0>
					</cfif>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<cfif FORM.RegisterParticipantWebinarOption EQ "----">
							<cfscript>
								eventdate = {property="EventDate",message="Please select whether each participant you are regisering will be utilizing the Webinar Option."};
								arrayAppend(Session.FormErrors, eventdate);
							</cfscript>
							<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventStatus=RegisterParticipants&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
						</cfif>
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

						<cfif Session.getSelectedEvent.MealAvailable EQ 1>
							<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RequestsMeal = <cfqueryparam value="#FORM.RegisterParticipantStayForMeal#" cfsqltype="cf_sql_bit">
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
							<cfif isDefined("Session.UserRegister.FirstStep.EmailConfirmations")>
								<cfif Session.UserRegister.FirstStep.EmailConfirmations EQ "on">
									<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY)#>
									<cfquery name="CheckExistingSentEmailsForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select MsgBody, EmailType, LinksToInclude, DocsToInclude, EmailSentToParticipants, dateCreated, lastUpdated, lastUpdateBy
										From p_EventRegistration_EventEmailLog
										Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
											Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
									</cfquery>
									<cfif CheckExistingSentEmailsForEvent.RecordCount>
										<cfquery name="GetParticipantInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select FName, LName, Email
											From tusers
											Where UserID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
										</cfquery>
										<cfset ParticipantInfo = StructNew()>
										<cfset ParticipantInfo.FName = #GetParticipantInfo.Fname#>
										<cfset ParticipantInfo.LName = #GetParticipantInfo.Lname#>
										<cfset ParticipantInfo.EmailType = "EmailRegistered">
										<cfset ParticipantInfo.Email = #GetParticipantInfo.Email#>
										<cfset ParticipantInfo.EventShortTitle = #Session.getSelectedEvent.ShortTitle#>
										<cfset ParticipantInfo.EmailMessageBody = #CheckExistingSentEmailsForEvent.MsgBody#>
										<cfset ParticipantInfo.WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
										<cfset ParticipantInfo.EventDocsDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #FORM.EventID# & "/">
										<cfif LEN(CheckExistingSentEmailsForEvent.DocsToInclude)>
											<cfquery name="GetSelectedEventDocuments" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
												From p_EventRegistration_EventResources
												Where TContent_ID IN (#FORM.IncludeDocumentLinkInEmail#)
											</cfquery>
											<cfset ParticipantInfo.DocumentLinksInEmail = #StructCopy(GetSelectedEventDocuments)#>
										</cfif>
										<cfif LEN(CheckExistingSentEmailsForEvent.LinksToInclude)>
											<cfquery name="GetSelectedEventWebLinks" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
												From p_EventRegistration_EventResources
												Where TContent_ID IN (#FORM.IncludeWebLinkInEmail#)
											</cfquery>
											<cfset ParticipantInfo.WebLinksInEmail = #StructCopy(GetSelectedEventWebLinks)#>
										</cfif>
										<cfset temp = #Variables.SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo)#>
									</cfif>
								</cfif>
							</cfif>
						<cfelse>
							<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set OnWaitingList = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif isDefined("Session.UserRegister.FirstStep.EmailConfirmations")>
								<cfif Session.UserRegister.FirstStep.EmailConfirmations EQ "on">
									<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY)#>
								</cfif>
							</cfif>
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
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
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

			<cfif getSelectedEvent.MealIncluded EQ 0>
				<cfquery name="getEventCaterer" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite
					From p_EventRegistration_Caterers
					Where TContent_ID = <cfqueryparam value="#getSelectedEvent.MealProvidedBy#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset Session.EventInfo.EventCaterer = #StructCopy(getEventCaterer)#>
			</cfif>


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

			<cfquery name="getPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FName, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getSelectedEvent.Presenters#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfset Session.EventInfo.SelectedEvent = #StructCopy(getSelectedEvent)#>
			<cfset Session.EventInfo.EventRegistrations = #StructCopy(getCurrentRegistrationsbyEvent)#>
			<cfset Session.EventInfo.EventFacility = #StructCopy(getEventFacility)#>
			<cfset Session.EventInfo.EventFacilityRoom = #StructCopy(getEventFacilityRoom)#>
			<cfset Session.EventInfo.EventFacilitator = #StructCopy(getFacilitator)#>
			<cfset Session.EventInfo.EventPresenter = #StructCopy(getPresenter)#>
		<cfelse>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="eventsigninsheet" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
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
					ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy,
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
						ORDER BY tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="Session.getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
						WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
						ORDER BY tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
			</cfswitch>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Event Listing">
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

			<cfif isDefined("FORM.SendConfirmation")>
				<cfif FORM.SendConfirmation EQ "on">
					<cfset FORM.SendConfirmation = 1>
				</cfif>
			<cfelse>
				<cfset FORM.SendConfirmation = 0>
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
					ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, dateCreated, lastUpdated, lastUpdateBy,
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
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>

			<cfif FORM.UserAction EQ "SignIn ALL Participants">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.signinparticipant&EventID=#URL.EventID#&Action=CheckAll" addtoken="false">
			<cfelse>
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
		</cfif>
	</cffunction>

	<cffunction name="namebadges" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
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
			<cfset Session.FormInput = #StructNew()#>
			<cfset Session.SignInSheet.EventDates = ValueList(EventDateQuery.EventDate, ",")>
		<cfelseif isDefined("URL.EventID") and isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput.StepOne = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="emailparticipants" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and not isDefined("FORM.formSubmit")>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfquery name="GetSelectedEventDocuments" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize
				From p_EventRegistration_EventResources
				Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					ResourceType = <cfqueryparam value="D" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="GetSelectedEventLinks" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize
				From p_EventRegistration_EventResources
				Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfset WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
			<cflock scope="Session" type="exclusive" timeout="60">
				<cfset Session.WebEventDirectory = #Variables.WebEventDirectory#>
			</cflock>
			<cfswitch expression="#URL.EmailType#">
				<cfcase value="EmailRegistered">
					<cfquery name="GetRegisteredUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.Site_ID, p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, p_EventRegistration_UserRegistrations.AttendeePrice,
							p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.Comments, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
						WHERE p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery name="GetRegisteredEmailLog" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID, MsgBody, EmailSentToParticipants, LinksToInclude, DocsToInclude
						From p_EventRegistration_EventEmailLog
						Where EmailType = <cfqueryparam value="EmailRegistered" cfsqltype="cf_sql_varchar"> and
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cflock scope="Session" type="exclusive" timeout="60">
						<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
						<cfset Session.GetSelectedEventLinks = StructCopy(GetSelectedEventLinks)>
						<cfset Session.GetSelectedEventDocuments = StructCopy(GetSelectedEventDocuments)>
						<cfset Session.GetEventEmailLogs = StructCopy(GetRegisteredEmailLog)>
						<cfset Session.GetParticipantsForEvent = StructCopy(GetRegisteredUsersForEvent)>
						<cfif GetRegisteredUsersForEvent.RecordCount><cfset Session.EventNumberRegistrations = #GetRegisteredUsersForEvent.RecordCount#><cfelse><cfset Session.EventNumberRegistrations = 0></cfif>
					</cflock>
				</cfcase>
				<cfcase value="EmailAttended">
					<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, tusers.Email, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
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
					<cfquery name="GetAttendedEmailLog" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID, MsgBody, EmailSentToParticipants, LinksToInclude, DocsToInclude
						From p_EventRegistration_EventEmailLog
						Where EmailType = <cfqueryparam value="EmailAttended" cfsqltype="cf_sql_varchar"> and
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cflock scope="Session" type="exclusive" timeout="60">
						<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
						<cfset Session.GetSelectedEventLinks = StructCopy(GetSelectedEventLinks)>
						<cfset Session.GetSelectedEventDocuments = StructCopy(GetSelectedEventDocuments)>
						<cfset Session.GetEventEmailLogs = StructCopy(GetAttendedEmailLog)>
						<cfset Session.GetParticipantsForEvent = StructCopy(GetSelectedEventRegistrations)>
						<cfif GetSelectedEventRegistrations.RecordCount><cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.RecordCount#><cfelse><cfset Session.EventNumberRegistrations = 0></cfif>
					</cflock>
				</cfcase>
			</cfswitch>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FORMData = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "GetRegisteredUsersForEvent")>
				<cfset temp = StructDelete(Session, "GetSelectedEventRegistrations")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "GetSelectedEventLinks")>
				<cfset temp = StructDelete(Session, "GetSelectedEventDocuments")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
			<cfif LEN(FORM.EmailMsg) EQ 0>
				<cfscript>
					eventdate = {property="EventDate",message="Please enter the message body which you want to send to users who have already registered for this event."};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailparticipants&EventID=#URL.EventID#&EmailType=#URL.EmailType#&FormRetry=True" addtoken="false">
			</cfif>
			<cfset ParentDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/">
			<cfset EventDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #URL.EventID# & "/">
			<cfset WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cflock scope="Session" type="exclusive" timeout="60">
				<cfset Session.WebEventDirectory = #Variables.WebEventDirectory#>
			</cflock>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfswitch expression="#FORM.EmailType#">
				<cfcase value="EmailRegistered">
					<cfquery name="GetRegisteredUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.Site_ID,  p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, p_EventRegistration_UserRegistrations.AttendeePrice,
							p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.Comments, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email
						FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
						WHERE p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery name="InsertEmailMessageLog" result="insertNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_EventEmailLog(Site_ID, Event_ID, EmailType, MsgBody, EmailSentToParticipants, dateCreated, lastUpdated, lastUpdateBy)
						Values(
							<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#FORM.EmailType#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.EmailMsg#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#ValueList(GetRegisteredUsersForEvent.User_ID)#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						)
					</cfquery>
					<cfloop query="GetRegisteredUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetRegisteredUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetRegisteredUsersForEvent.Lname#>
						<cfset ParticipantInfo.EmailType = "EmailRegistered">
						<cfset ParticipantInfo.Email = #GetRegisteredUsersForEvent.Email#>
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageHTMLBody = #FORM.EmailMsg#>
						<cfset ParticipantInfo.EmailMessageTextBody = #ReReplaceNoCase(FORM.EmailMsg,"<[^>]*>","","ALL")#>
						<cfset ParticipantInfo.WebEventDirectory = #Variables.WebEventDirectory#>
						<cfset ParticipantInfo.EventDocsDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #FORM.EventID# & "/">
						<cfif isDefined("FORM.IncludeDocumentLinkInEmail")>
							<cfquery name="GetSelectedEventDocuments" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
								From p_EventRegistration_EventResources
								Where TContent_ID IN (#FORM.IncludeDocumentLinkInEmail#)
							</cfquery>
							<cfset ParticipantInfo.DocumentLinksInEmail = #StructCopy(GetSelectedEventDocuments)#>
						</cfif>
						<cfif isDefined("FORM.IncludeWebLinkInEmail")>
							<cfquery name="GetSelectedEventWebLinks" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
								From p_EventRegistration_EventResources
								Where TContent_ID IN (#FORM.IncludeWebLinkInEmail#)
							</cfquery>
							<cfset ParticipantInfo.WebLinksInEmail = #StructCopy(GetSelectedEventWebLinks)#>
						</cfif>
						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo)#>
					</cfloop>
					<cfif isDefined("FORM.IncludeDocumentLinkInEmail")>
						<cfquery name="UpdateEmailMessageLog" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set DocsToInclude = <cfqueryparam value="#FORM.IncludeDocumentLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
					<cfif isDefined("FORM.IncludeWebLinkInEmail")>
						<cfquery name="UpdateEmailMessageLog" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set LinksToInclude = <cfqueryparam value="#FORM.IncludeWebLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailRegistered&Successful=True" addtoken="false">
				</cfcase>
				<cfcase value="EmailAttended">
					<cfquery name="GetAttendedUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, tusers.Email, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
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
					<cfquery name="InsertEmailMessageLog" result="insertNewEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_EventEmailLog(Site_ID, Event_ID, EmailType, MsgBody, EmailSentToParticipants, dateCreated, lastUpdated, lastUpdateBy)
						Values(
							<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#FORM.EmailType#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.EmailMsg#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#ValueList(GetRegisteredUsersForEvent.User_ID)#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						)
					</cfquery>
					<cfloop query="GetAttendedUsersForEvent">
						<cfset ParticipantInfo = StructNew()>
						<cfset ParticipantInfo.FName = #GetAttendedUsersForEvent.Fname#>
						<cfset ParticipantInfo.LName = #GetAttendedUsersForEvent.Lname#>
						<cfset ParticipantInfo.Email = #GetAttendedUsersForEvent.Email#>
						<cfset ParticipantInfo.EmailType = "EmailAttended">
						<cfset ParticipantInfo.EventShortTitle = #GetSelectedEvent.ShortTitle#>
						<cfset ParticipantInfo.EmailMessageHTMLBody = #FORM.EmailMsg#>
						<cfset ParticipantInfo.EmailMessageTextBody = #ReReplaceNoCase(FORM.EmailMsg,"<[^>]*>","","ALL")#>
						<cfset ParticipantInfo.WebEventDirectory = #Variables.WebEventDirectory#>
						<cfset ParticipantInfo.EventDocsDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #FORM.EventID# & "/">
						<cfif isDefined("FORM.IncludeDocumentLinkInEmail")>
							<cfquery name="GetSelectedEventDocuments" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
								From p_EventRegistration_EventResources
								Where TContent_ID IN (#FORM.IncludeDocumentLinkInEmail#)
							</cfquery>
							<cfset ParticipantInfo.DocumentLinksInEmail = #StructCopy(GetSelectedEventDocuments)#>
						</cfif>
						<cfif isDefined("FORM.IncludeWebLinkInEmail")>
							<cfquery name="GetSelectedEventWebLinks" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
								From p_EventRegistration_EventResources
								Where TContent_ID IN (#FORM.IncludeWebLinkInEmail#)
							</cfquery>
							<cfset ParticipantInfo.WebLinksInEmail = #StructCopy(GetSelectedEventWebLinks)#>
						</cfif>
						<cfset temp = #SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo)#>
					</cfloop>
					<cfif isDefined("FORM.IncludeDocumentLinkInEmail")>
						<cfquery name="UpdateEmailMessageLog" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set DocsToInclude = <cfqueryparam value="#FORM.IncludeDocumentLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
					<cfif isDefined("FORM.IncludeWebLinkInEmail")>
						<cfquery name="UpdateEmailMessageLog" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update p_EventRegistration_EventEmailLog
							Set LinksToInclude = <cfqueryparam value="#FORM.IncludeWebLinkInEmail#" cfsqltype="cf_sql_varchar">
							Where TContent_ID = <cfqueryparam value="#insertNewEvent.GENERATED_KEY#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailAttended&Successful=True" addtoken="false">
				</cfcase>
			</cfswitch>
		</cfif>
	</cffunction>

	<cffunction name="sendpgpcertificates" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
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
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
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
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
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
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterexpenses&EventID=#URL.EventID#" addtoken="false">
				</cfcase>
			</cfswitch>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and isDefined("FORM.EventRecID")>
			<cfif FORM.UserAction EQ "Enter Revenue">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
				<cfset temp = StructDelete(Session, "getAvailableEventExpenses")>
				<cfset temp = StructDelete(Session, "getSelectedEventExpenses")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterrevenue&EventID=#URL.EventID#" addtoken="false">
			</cfif>
			<cfquery name="UpdateEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_EventRegistration_EventExpenses
				Set Expense_ID = <cfqueryparam value="#FORM.ExpenseID#" cfsqltype="cf_sql_integer">,
					Cost_Amount = <cfqueryparam value="#FORM.ExpenseAmount#" cfsqltype="cf_sql_money">
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					Event_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer"> and
					TContent_ID = <cfqueryparam value="#URL.EventRecID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterexpenses&EventID=#URL.EventID#" addtoken="false">
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and not isDefined("FORM.EventRecID")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>

			<cfif FORM.UserAction EQ "Enter Revenue">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
				<cfset temp = StructDelete(Session, "getAvailableEventExpenses")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterrevenue&EventID=#URL.EventID#" addtoken="false">
			</cfif>

			<cfif FORM.UserAction EQ "Back to Event Listing">
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
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterexpenses&EventID=#FORM.EventID#" addtoken="false">
		<cfelse>

		</cfif>
	</cffunction>

	<cffunction name="enterrevenue" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="Session.GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.TContent_ID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.AttendeePrice, p_EventRegistration_UserRegistrations.RegistrationDate, tusers.Fname, tusers.Lname, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
					p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM, p_EventRegistration_UserRegistrations.AttendeePriceVerified
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					(
					(p_EventRegistration_UserRegistrations.AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">)
					))
				ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
				<cfset temp = StructDelete(Session, "getAvailableEventExpenses")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>

			<cfset Participant = StructNew()>

			<cfloop list="#FORM.fieldnames#" index="i" delimiters=",">
				<cfif ListContains(i, "Participants", "_")>
					<cfset Participant[i] = StructNew()>
					<cfset Participant[i]['RecordID'] = #ListLast(i, "_")#>
					<cfset Participant[i]['Amount'] = #FORM[i]#>
				</cfif>
			</cfloop>

			<cfloop collection=#Variables.Participant# item="RecNo">
				<cfquery name="UpdateAttendeePrice" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_UserRegistrations
					Set AttendeePrice = <cfqueryparam value="#Variables.Participant[RecNo]['Amount']#" cfsqltype="cf_sql_money">,
						AttendeePriceVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Where TContent_ID = <cfqueryparam value="#Variables.Participant[RecNo]['RecordID']#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfloop>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.enterrevenue&EventID=#URL.EventID#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="viewprofitlossreport" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("URL.UserAction")>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, Site_ID, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventInvoicesGenerated
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfset temp = QueryAddColumn(getSelectedEvent, "EventDateDisplay")>
			<cfset LogoPath = ArrayNew(1)>
			<cfloop from="1" to="#getSelectedEvent.RecordCount#" step="1" index="i">
				<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_LogoSM.png")#>
			</cfloop>
			<cfset temp = QueryAddColumn(getSelectedEvent, "ImagePath", "VarChar", Variables.LogoPath)>
			<cfset EventDates = "">
			<cfif isDate(getSelectedEvent.EventDate)><cfset EventDates = #DateFormat(getSelectedEvent.EventDate, "mm/dd/yyyy")# & " (" & #DateFormat(getSelectedEvent.EventDate, "ddd")# & ")"></cfif>
			<cfif isDate(getSelectedEvent.EventDate1)><cfset EventDates = Variables.EventDates & "; " & #DateFormat(getSelectedEvent.EventDate1, "mm/dd/yyyy")# & " (" & #DateFormat(getSelectedEvent.EventDate1, "ddd")# & ")"></cfif>
			<cfif isDate(getSelectedEvent.EventDate2)><cfset EventDates = Variables.EventDates & "; " & #DateFormat(getSelectedEvent.EventDate2, "mm/dd/yyyy")# & " (" & #DateFormat(getSelectedEvent.EventDate2, "ddd")# & ")"></cfif>
			<cfif isDate(getSelectedEvent.EventDate3)><cfset EventDates = Variables.EventDates & "; " & #DateFormat(getSelectedEvent.EventDate3, "mm/dd/yyyy")# & " (" & #DateFormat(getSelectedEvent.EventDate3, "ddd")# & ")"></cfif>
			<cfif isDate(getSelectedEvent.EventDate4)><cfset EventDates = Variables.EventDates & "; " & #DateFormat(getSelectedEvent.EventDate4, "mm/dd/yyyy")# & " (" & #DateFormat(getSelectedEvent.EventDate4, "ddd")# & ")"></cfif>
			<cfif isDate(getSelectedEvent.EventDate5)><cfset EventDates = Variables.EventDates & "; " & #DateFormat(getSelectedEvent.EventDate5, "mm/dd/yyyy")# & " (" & #DateFormat(getSelectedEvent.EventDate5, "ddd")# & ")"></cfif>
			<cfset temp = QuerySetCell(getSelectedEvent, "EventDateDisplay", Variables.EventDates)>
			<cfset temp = QueryAddColumn(getSelectedEvent, "TotalRevenue")>
			<cfset temp = QueryAddColumn(getSelectedEvent, "TotalExpenses")>
			<cfset temp = QueryAddColumn(getSelectedEvent, "ProfitOrLoss")>

			<cfquery name="GetEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select p_EventRegistration_ExpenseList.Expense_Name, p_EventRegistration_EventExpenses.Cost_Amount
				From p_EventRegistration_EventExpenses INNER JOIN p_EventRegistration_ExpenseList ON p_EventRegistration_ExpenseList.TContent_ID = p_EventRegistration_EventExpenses.Expense_ID
				WHere p_EventRegistration_EventExpenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset EventTotalExpenses = 0>
			<cfloop query="GetEventExpenses">
				<cfset EventTotalExpenses = #Variables.EventTotalExpenses# + #GetEventExpenses.Cost_Amount#>
			</cfloop>
			<cfset temp = QuerySetCell(getSelectedEvent, "TotalExpenses", Variables.EventTotalExpenses)>

			<cfquery name="GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.TContent_ID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.AttendeePrice, p_EventRegistration_UserRegistrations.RegistrationDate, tusers.Fname, tusers.Lname, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
					p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM, p_EventRegistration_UserRegistrations.AttendeePriceVerified
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE (p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					(
					(p_EventRegistration_UserRegistrations.AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">) OR
					(p_EventRegistration_UserRegistrations.AttendedEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">)
					))
				ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
			<cfset temp = QueryAddColumn(GetSelectedEventRegistrations, "OrganizationName")>
			<cfset temp = QueryAddColumn(GetSelectedEventRegistrations, "OrganizationMember")>
			<cfset temp = QueryAddColumn(GetSelectedEventRegistrations, "AttendeeTotalDays")>

			<cfloop query="GetSelectedEventRegistrations">
				<cfquery name="getCorpInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select OrganizationName, Active
					From p_EventRegistration_Membership
					Where OrganizationDomainName = <cfqueryparam value="#GetSelectedEventRegistrations.Domain#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getCorpInfo.RecordCount>
					<cfset temp = QuerySetCell(GetSelectedEventRegistrations, "OrganizationName", getCorpInfo.OrganizationName, GetSelectedEventRegistrations.CurrentRow)>
					<cfif getCorpInfo.Active EQ 1>
						<cfset temp = QuerySetCell(GetSelectedEventRegistrations, "OrganizationMember", "Member", GetSelectedEventRegistrations.CurrentRow)>
					<cfelse>
						<cfset temp = QuerySetCell(GetSelectedEventRegistrations, "OrganizationMember", "Non-Member", GetSelectedEventRegistrations.CurrentRow)>
					</cfif>
				</cfif>
				<cfset TotalDaysAttended = 0>
				<cfif GetSelectedEventRegistrations.AttendedEventDate1 EQ 1><cfset TotalDaysAttended = #Variables.TotalDaysAttended# + 1></cfif>
				<cfif GetSelectedEventRegistrations.AttendedEventDate2 EQ 1><cfset TotalDaysAttended = #Variables.TotalDaysAttended# + 1></cfif>
				<cfif GetSelectedEventRegistrations.AttendedEventDate3 EQ 1><cfset TotalDaysAttended = #Variables.TotalDaysAttended# + 1></cfif>
				<cfif GetSelectedEventRegistrations.AttendedEventDate4 EQ 1><cfset TotalDaysAttended = #Variables.TotalDaysAttended# + 1></cfif>
				<cfif GetSelectedEventRegistrations.AttendedEventDate5 EQ 1><cfset TotalDaysAttended = #Variables.TotalDaysAttended# + 1></cfif>
				<cfif GetSelectedEventRegistrations.AttendedEventDate6 EQ 1><cfset TotalDaysAttended = #Variables.TotalDaysAttended# + 1></cfif>
				<cfif GetSelectedEventRegistrations.AttendedEventSessionAM EQ 1><cfset TotalDaysAttended = #Variables.TotalDaysAttended# + 1></cfif>
				<cfif GetSelectedEventRegistrations.AttendedEventSessionPM EQ 1><cfset TotalDaysAttended = #Variables.TotalDaysAttended# + 1></cfif>
				<cfset temp = QuerySetCell(GetSelectedEventRegistrations, "AttendeeTotalDays", Variables.TotalDaysAttended, GetSelectedEventRegistrations.CurrentRow)>
			</cfloop>

			<cfset EventTotalIncome = 0>
			<cfloop query="GetSelectedEventRegistrations">
				<cfif GetSelectedEventRegistrations.AttendeePriceVerified EQ 1>
					<cfset EventTotalIncome = #Variables.EventTotalIncome# + (#GetSelectedEventRegistrations.AttendeeTotalDays# * #GetSelectedEventRegistrations.AttendeePrice#)>
				</cfif>
			</cfloop>
			<cfset EventProfitLoss = #Variables.EventTotalIncome# - #Variables.EventTotalExpenses#>
			<cfset temp = QuerySetCell(getSelectedEvent, "TotalRevenue", Variables.EventTotalIncome)>
			<cfset temp = QuerySetCell(getSelectedEvent, "ProfitOrLoss", Variables.EventProfitLoss)>

			<cfquery name="EventInfoDropTable_EventProfitLossReport" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Drop Table if Exists p_EventRegistration_EventProfitLossReport
			</cfquery>
			<cfquery name="EventInfoDropTable_EventProfitLossReportExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Drop Table if Exists p_EventRegistration_EventProfitLossReportExpenses
			</cfquery>
			<cfquery name="EventInfoDropTable_EventProfitLossReportRevenue" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Drop Table if Exists p_EventRegistration_EventProfitLossReportRevenue
			</cfquery>

			<cfquery name="EventInfoCreateTemporaryTable_EventProfitLossReport" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				CREATE TABLE `p_EventRegistration_EventProfitLossReport` (
					`TContent_ID` int(10) NOT NULL, `Site_ID` varchar(20) NOT NULL DEFAULT '', `ShortTitle` tinytext NOT NULL, `EventDate` date NOT NULL DEFAULT '1980-01-01', `EventDate1` date DEFAULT NULL, `EventDate2` date DEFAULT NULL, `EventDate3` date DEFAULT NULL, `EventDate4` date DEFAULT NULL, `EventDate5` date DEFAULT NULL, `EventDateDisplay` tinytext DEFAULT NULL, `ImagePath` tinytext DEFAULT NULL, `TotalRevenue` decimal(12,2) DEFAULT NULL, `TotalExpenses` decimal(12,2) DEFAULT NULL, `ProfitOrLoss` decimal(12,2) DEFAULT NULL ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
			</cfquery>

			<cfquery name="EventInfoCreateTemporaryTable_EventProfitLossReportExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Create Table `p_EventRegistration_EventProfitLossReportExpenses` ( `Expense_Name` tinytext NOT NULL, `Cost_Amount` double(8,2) NOT NULL ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
			</cfquery>

			<cfquery name="EventInfoCreateTemporaryTable_EventProfitLossReportExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Create Table `p_EventRegistration_EventProfitLossReportRevenue` ( `Domain` tinytext NOT NULL,
					`Fname` tinytext NOT NULL,
					`Lname` tinytext NOT NULL,
					`AttendeePrice` tinytext NOT NULL,
					`OrganizationName` tinytext NOT NULL,
					`OrganizationMember` tinytext NOT NULL,
					`AttendeeTotalDays` int(10) NOT NULL,
					`AttendeeTotalFee` double(8,2) NOT NULL
				) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
			</cfquery>

			<cfloop query="getSelectedEvent">
				<cfquery name="EventInfoCreateTemporaryTable_EventProfitLossReport" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_EventProfitLossReport(TContent_ID,Site_ID,ShortTitle,EventDate,EventDate1,EventDate2,EventDate3,EventDate4,EventDate5,EventDateDisplay,TotalRevenue,TotalExpenses,ProfitOrLoss,ImagePath)
					Values(
						<cfqueryparam value="#getSelectedEvent.TContent_ID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#getSelectedEvent.Site_ID#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#getSelectedEvent.ShortTitle#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#getSelectedEvent.EventDate#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#getSelectedEvent.EventDate1#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#getSelectedEvent.EventDate2#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#getSelectedEvent.EventDate3#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#getSelectedEvent.EventDate4#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#getSelectedEvent.EventDate5#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#getSelectedEvent.EventDateDisplay#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#getSelectedEvent.TotalRevenue#" cfsqltype="cf_sql_money">,
						<cfqueryparam value="#getSelectedEvent.TotalExpenses#" cfsqltype="cf_sql_money">,
						<cfqueryparam value="#getSelectedEvent.ProfitOrLoss#" cfsqltype="cf_sql_money">,
						<cfqueryparam value="#getSelectedEvent.ImagePath#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
			</cfloop>

			<cfloop query="GetEventExpenses">
				<cfquery name="EventInfoCreateTemporaryTable_EventProfitLossReportExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_EventProfitLossReportExpenses(Expense_Name, Cost_Amount)
					Values(
						<cfqueryparam value="#GetEventExpenses.Expense_Name#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#GetEventExpenses.Cost_Amount#" cfsqltype="cf_sql_money">
					)
				</cfquery>
			</cfloop>

			<cfloop query="GetSelectedEventRegistrations">
				<cfset AttendeeTotalFee = #GetSelectedEventRegistrations.AttendeePrice# * #GetSelectedEventRegistrations.AttendeeTotalDays#>
				<cfquery name="EventInfoCreateTemporaryTable_EventProfitLossReportRevenue" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_EventProfitLossReportRevenue( Domain, Fname, Lname, AttendeePrice, OrganizationName, OrganizationMember, AttendeeTotalDays, AttendeeTotalFee)
					Values(
						<cfqueryparam value="#GetSelectedEventRegistrations.Domain#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#GetSelectedEventRegistrations.Fname#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#GetSelectedEventRegistrations.Lname#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#GetSelectedEventRegistrations.AttendeePrice#" cfsqltype="cf_sql_money">,
						<cfqueryparam value="#GetSelectedEventRegistrations.OrganizationName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#GetSelectedEventRegistrations.OrganizationMember#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#GetSelectedEventRegistrations.AttendeeTotalDays#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Variables.AttendeeTotalFee#" cfsqltype="cf_sql_money">
					)
				</cfquery>
			</cfloop>

			<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
			<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #URL.EventID# & "-" & "EventProfitLossReport.pdf" >
			<cfset URLReportExportLoc = "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/" & #URL.EventID# & "-" & "EventProfitLossReport.pdf" >
			<cfset Session.PLReport = StructNew()>
			<cfset Session.PLReport.ReportDirectory = Variables.ReportDirectory>
			<cfset Session.PLReport.ReportExportLoc = Variables.ReportExportLoc>
			<cfset Session.PLReport.EventInvoicesGenerated = #getSelectedEvent.EventInvoicesGenerated#>
			<cfset Session.PLReport.URLReportExportLoc = #Variables.URLReportExportLoc#>
			<cfset Session.PLReport.GetSelectedEventRegistrations = #StructCopy(GetSelectedEventRegistrations)#>

			<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
			<jr:jasperreport jrxml="#ReportDirectory#/EventProfitLossReport.jrxml" dsn="#rc.$.globalConfig('datasource')#"  exportfile="#ReportExportLoc#" exportType="pdf" />

		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID") and not isDefined("URL.userAction")>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>

			<cfset Participant = StructNew()>

			<cfloop list="#FORM.fieldnames#" index="i" delimiters=",">
				<cfif ListContains(i, "Participants", "_")>
					<cfset Participant[i] = StructNew()>
					<cfset Participant[i]['RecordID'] = #ListLast(i, "_")#>
					<cfset Participant[i]['Amount'] = #FORM[i]#>
				</cfif>
			</cfloop>

			<cfloop collection=#Variables.Participant# item="RecNo">
				<cfquery name="UpdateAttendeePrice" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_UserRegistrations
					Set AttendeePrice = <cfqueryparam value="#Variables.Participant[RecNo]['Amount']#" cfsqltype="cf_sql_money">,
						AttendeePriceVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Where TContent_ID = <cfqueryparam value="#Variables.Participant[RecNo]['RecordID']#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfloop>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.generateprofitlossreport&UserAction=ShowReport&EventID=#FORM.EventID#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="getAllEventExpenses" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrExpenses = ArrayNew(1)>
		<cfif isDefined("URL._search")>
			<cfif URL._search EQ "false">
				<cfquery name="getExpenses" dbtype="Query">
					Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated
					From Session.getEventExpenses
					<cfif Arguments.sidx NEQ "">
						Order By #Arguments.sidx# #Arguments.sord#
					<cfelse>
						Order by Group_Name #Arguments.sord#
					</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="getFacilities" dbtype="Query">
					Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated
					From Session.getEventExpenses
					<cfif Arguments.sidx NEQ "">
						Where #URL.searchField# LIKE '%#URL.searchString#'
						Order By #Arguments.sidx# #Arguments.sord#
					</cfif>
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="getExpenses" dbtype="Query">
				Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated
				From Session.getEventExpenses
				<cfif Arguments.sidx NEQ "">
					Order By #Arguments.sidx# #Arguments.sord#
				<cfelse>
					Order by Group_Name #Arguments.sord#
				</cfif>
			</cfquery>
		</cfif>


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
			<cfset arrExpenses[i] = [#TContent_ID#,#Expense_Name#,#strActive#,#DateFormat(dateCreated, 'ddd, mm/dd/yyyy')#,#DateFormat(lastUpdated, 'ddd, mm/dd/yyyy')#]>
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
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Presenters, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime
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

			<cfquery name="Session.getSelectedPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Lname, FName, EMail
				From tusers
				Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					UserID = <cfqueryparam value="#Session.getSelectedEvent.Presenters#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="Session.getSelectedRoomInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select RoomName, Capacity, RoomFees
				From p_EventRegistration_FacilityRooms
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#Session.getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> and
					Facility_ID = <cfqueryparam value="#Session.getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfelseif isDefined("FORM.FormSubmit")>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getSelectedMealProvider")>
				<cfset temp = StructDelete(Session, "getSelectedLocation")>
				<cfset temp = StructDelete(Session, "getSelectedRoomInfo")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
			<cfif FORM.UserAction EQ "Submit Event Changes">
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
				<cfif FORM.Active EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to display this event or not."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_acceptregistrations&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set AcceptRegistrations = <cfqueryparam value="#FORM.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
						Active = <cfqueryparam value="#FORM.Active#" cfsqltype="cf_sql_bit">,
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
				Where Facility_ID = <cfqueryparam value="#Session.FORMData.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>
		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
						WebinarMemberCost = <cfqueryparam value="#NumberFormat(Replace(FORM.WebinarMemberCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						WebinarNonMemberCost = <cfqueryparam value="#NumberFormat(Replace(FORM.WebinarNonMemberCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
						VideoConferenceCost = <cfqueryparam value="#NumberFormat(Replace(FORM.VideoConferenceCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.MealAvailable EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to offer a meal to participants of this event."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_mealinfo&FormRetry=True&EventID=#URL.EventID#">
				<cfelseif FORM.MealAvailable EQ 1>
					<cfif FORM.MealIncluded EQ "----">
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="Please select one of the options as to whether the meal is included in the registration fee or not for this event"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_mealinfo&FormRetry=True&EventID=#URL.EventID#">
					</cfif>
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set MealAvailable = <cfqueryparam value="#FORM.MealAvailable#" cfsqltype="cf_sql_bit">,
						MealIncluded = <cfqueryparam value="#FORM.MealIncluded#" cfsqltype="cf_sql_bit">,
						MealProvidedBy = <cfqueryparam value="#FORM.MealProvidedBy#" cfsqltype="cf_sql_integer">,
						MealCost = <cfqueryparam value="#NumberFormat(Replace(FORM.MealCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						Meal_Notes = <cfqueryparam value="#FOrm.MealNotes#" cfsqltype="cf_sql_varchar">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_grouppricing" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.ViewGroupPricing EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select one of the options as to whether to offer a Group price if requirements are met."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_speicalpricing&FormRetry=True&EventID=#URL.EventID#">
				</cfif>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set ViewGroupPricing = <cfqueryparam value="#FORM.ViewGroupPricing#" cfsqltype="cf_sql_bit">,
						GroupMemberCost = <cfqueryparam value="#NumberFormat(Replace(FORM.GroupMemberCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						GroupNonMemberCost = <cfqueryparam value="#NumberFormat(Replace(FORM.GroupNonMemberCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						GroupPriceRequirements = <cfqueryparam value="#FORM.GroupPriceRequirements#" cfsqltype="cf_sql_varchar">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
						EarlyBird_MemberCost = <cfqueryparam value="#NumberFormat(Replace(FORM.EarlyBird_MemberCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						EarlyBird_NonMemberCost = <cfqueryparam value="#NumberFormat(Replace(FORM.EarlyBird_NonMemberCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set MemberCost = <cfqueryparam value="#NumberFormat(Replace(FORM.MemberCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						NonMemberCost = <cfqueryparam value="#NumberFormat(Replace(FORM.NonMemberCost, '$', '', 'all'), '999999.99')#" cfsqltype="cf_sql_double">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set Registration_Deadline = <cfqueryparam value="#FORM.Registration_Deadline#" cfsqltype="cf_sql_timestamp">,
						Registration_BeginTime = <cfqueryparam value="#FORM.Registration_BeginTime#" cfsqltype="cf_sql_timestamp">,
						Event_StartTime = <cfqueryparam value="#FORM.Event_StartTime#" cfsqltype="cf_sql_timestamp">,
						Event_EndTime = <cfqueryparam value="#FORM.Event_EndTime#" cfsqltype="cf_sql_timestamp">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_dailysessions" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set EventHasDailySessions = <cfqueryparam value="#FORM.EventHaveSessions#" cfsqltype="cf_sql_bit">,
						Session1BeginTime = <cfqueryparam value="#FORM.EventSession1_StartTime#" cfsqltype="cf_sql_timestamp">,
						Session1EndTime = <cfqueryparam value="#FORM.EventSession1_EndTime#" cfsqltype="cf_sql_timestamp">,
						Session2BeginTime = <cfqueryparam value="#FORM.EventSession2_StartTime#" cfsqltype="cf_sql_timestamp">,
						Session2EndTime = <cfqueryparam value="#FORM.EventSession2_EndTime#" cfsqltype="cf_sql_timestamp">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_presenter" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>
			<cfquery name="getPresenterUserID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID
				From tusers
				Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					GroupName = <cfqueryparam value="Event Presenter" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfquery name="Session.AvailablePresenters" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select tusers.Fname, tusers.Lname, tusersmemb.UserID, tusers.Email, CONCAT(tusers.Lname, ', ', tusers.Fname) as DisplayName
				From tusersmemb LEFT JOIN tusers on tusers.UserID = tusersmemb.UserID
				Where tusersmemb.GroupID = <cfqueryparam value="#getPresenterUserID.UserID#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
			<cfif FORM.UserAction EQ "Update Event Section">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif FORM.EventPresenter EQ "----">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="Please select the primary event presenter who will be speaking at this event."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_presenter&FormRetry=True&EventID=#URL.EventID#">
				<cfelse>
					<cfquery name="updateEventSection" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set Presenters = <cfqueryparam value="#FORM.EventPresenter#" cfsqltype="cf_sql_varchar">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.FName# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateevent_eventdates" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit") and isDefined("URL.EventID")>

		<cfelseif isDefined("FORM.FormSubmit") and isDefined("FORM.EventID")>
			<cfif FORM.UserAction EQ "Back to Event Review"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_review&EventID=#URL.EventID#" addtoken="false"></cfif>
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
						Where DateDiff(Registration_Deadline, Now()) >= 1
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

			<cfset MoreInfoImage = ArrayNew(1)>
			<cfset MoreInfoURL = ArrayNew(1)>
			<cfset MobileLink = ArrayNew(1)>
			<cfset LogoPath = ArrayNew(1)>
			<cfloop from="1" to="#GetUpComingEvents.RecordCount#" step="1" index="i">
				<cfset MoreInfoImage[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/MoreInfoButton_SM.png")#>
				<cfset MoreInfoURL[i] = "http://" & #CGI.Server_Name# & #CGI.Script_name# & #CGI.path_info# & "?" & #HTMLEditFormat(rc.pc.getPackage())# & "action=public:main.eventinfo&EventID=" & #GetUpComingEvents.TContent_ID#>
				<cfset MobileLink[i] = "Link">
				<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo.png")#>
			</cfloop>
			<cfset temp = QueryAddColumn(GetUpComingEvents, "MoreInfoImage", "VarChar", Variables.MoreInfoImage)>
			<cfset temp = QueryAddColumn(GetUpComingEvents, "LinkURL", "VarChar", Variables.MoreInfoURL)>
			<cfset temp = QueryAddColumn(GetUpComingEvents, "MobileLink", "VarChar", Variables.MobileLink)>
			<cfset temp = QueryAddColumn(GetUpComingEvents, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
			<cfset temp = QueryAddColumn(GetUpComingEvents, "EventDateFormat")>
			<cfloop query="#GetUpComingEvents#">
				<cfset temp = QuerySetCell(GetUpComingEvents, "EventDateFormat", DateFormat(GetUpComingEvents.EventDate, "ddd, mmm dd, yyyy"), GetUpComingEvents.CurrentRow)>
			</cfloop>

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

	<cffunction name="generateinvoices" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.FormSubmit")>
			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
						From p_EventRegistration_Events
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
					</cfquery>

					<cfquery name="Session.GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.TContent_ID, p_EventRegistration_Events.TContent_ID as EventID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.AttendeePrice, tusers.Fname, tusers.Lname, tusers.Email, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
							p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain
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
						ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
						From p_EventRegistration_Events
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
					</cfquery>

					<cfquery name="Session.GetSelectedEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						SELECT p_EventRegistration_UserRegistrations.TContent_ID, p_EventRegistration_Events.TContent_ID as EventID, p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.AttendeePrice, tusers.Fname, tusers.Lname, tusers.Email, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
							p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
							p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain
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
				</cfcase>
			</cfswitch>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"OrganizationName")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"Mailing_Address")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"Mailing_City")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"Mailing_State")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"Mailing_ZipCode")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"Primary_PhoneNumber")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"AccountsPayable_EmailAddress")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"AccountsPayable_ContactName")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"ReceiveInvoicesByEmail")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"AttendeePriceDisplay")>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations,"EventDateDisplay")>
			<cfloop query="Session.GetSelectedEventRegistrations">
				<cfquery name="getOrganizationinfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select OrganizationName, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, AccountsPayable_EmailAddress, AccountsPayable_ContactName, ReceiveInvoicesByEmail
					From p_EventRegistration_Membership
					Where OrganizationDomainName = <cfqueryparam value="#Session.GetSelectedEventRegistrations.Domain#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "OrganizationName", getOrganizationInfo.OrganizationName, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "Mailing_Address", getOrganizationInfo.Mailing_Address, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "Mailing_City", getOrganizationInfo.Mailing_City, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "Mailing_State", getOrganizationInfo.Mailing_State, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "Mailing_ZipCode", getOrganizationInfo.Mailing_ZipCode, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "Primary_PhoneNumber", getOrganizationInfo.Primary_PhoneNumber, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "AccountsPayable_EmailAddress", getOrganizationInfo.AccountsPayable_EmailAddress, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "AccountsPayable_ContactName", getOrganizationInfo.AccountsPayable_ContactName, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "ReceiveInvoicesByEmail", getOrganizationInfo.ReceiveInvoicesByEmail, Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "AttendeePriceDisplay", DollarFormat(Session.GetSelectedEventRegistrations.AttendeePrice), Session.GetSelectedEventRegistrations.CurrentRow)#>
				<cfset temp = #QuerySetCell(Session.GetSelectedEventRegistrations, "EventDateDisplay", DateFormat(Session.GetSelectedEventRegistrations.EventDate, "mmm dd, yyyy"), Session.GetSelectedEventRegistrations.CurrentRow)#>
			</cfloop>
			<cfset LogoPath = ArrayNew(1)>
			<cfloop from="1" to="#Session.GetSelectedEventRegistrations.RecordCount#" step="1" index="i">
				<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_LogoSM.png")#>
			</cfloop>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations, "ImagePath", "VarChar", Variables.LogoPath)>
			<cfset InvoiceDate = ArrayNew(1)>
			<cfloop from="1" to="#Session.GetSelectedEventRegistrations.RecordCount#" step="1" index="i">
				<cfset InvoiceDate[i] = #DateFormat(Now(), "mmm dd, yy")#>
			</cfloop>
			<cfset temp = QueryAddColumn(Session.GetSelectedEventRegistrations, "InvoiceDate", "VarChar", Variables.InvoiceDate)>

		<cfelseif isDefined("FORM.FormSubmit")>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "GetSelectedEventRegistrations")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
			<cfquery name="updateEventGeneratedInvoices" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_EventRegistration_Events
				Set EventInvoicesGenerated = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfquery name="GetOrganizations" dbtype="query">
				Select Domain
				From Session.GetSelectedEventRegistrations
				Group By Domain
			</cfquery>
			<cfloop query="GetOrganizations">
				<cfquery name="GetOrganizationRegistrations" dbtype="query">
					Select *
					From Session.GetSelectedEventRegistrations
					Where Domain = <cfqueryparam value="#GetOrganizations.Domain#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
				<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
				<cfset OrgFileName = #Replace(GetOrganizationRegistrations.OrganizationName, " ", "", "ALL")#>
				<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #URL.EventID# & "-" & #Variables.OrgFileName# & "EventInvoice.pdf" >
				<jr:jasperreport jrxml="#ReportDirectory#/EventInvoice.jrxml" query="#GetOrganizationRegistrations#" exportfile="#ReportExportLoc#" exportType="pdf" />
				<cfif GetOrganizationRegistrations.ReceiveInvoicesByEmail EQ 1>
					<cfset Temp = SendEmailCFC.SendInvoiceToCompanyAccountsPayable(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, GetOrganizationRegistrations.AccountsPayable_ContactName, GetOrganizationRegistrations.AccountsPayable_EmailAddress)>
				<cfelseif GetOrganizationRegistrations.ReceiveInvoicesByEmail EQ 0>
					<cfset Temp = SendEmailCFC.SendInvoiceToCompanyAccountsPayable(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, "Sherry Emery", "gpearson@niesc.k12.in.us")>
				</cfif>
			</cfloop>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailInvoicesSent&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="eventdocs" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.UserAction")>
			<cfif URL.UserAction EQ "FileUpload">
				<cfset uploadDir = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #URL.EventID# & "/">
				<cfif not DirectoryExists(variables.uploadDir)><cfdirectory action="Create" directory="#Variables.uploadDir#"></cfif>
				<cffile action="upload" fileField="FORM.file" result="EventDocs" destination="#GetTempDirectory()#" nameconflict="MakeUnique">
				<cfset NewEventDocument = #Replace(Variables.EventDocs.ServerFile, " ", "_", "ALL")#>
				<cfset NewEventDocument = #Replace(Variables.NewEventDocument, "'", "_", "ALL")#>
				<cffile action="rename" source="#GetTempDirectory()#/#Variables.EventDocs.ServerFile#" Destination="#Variables.uploadDir#/#Variables.NewEventDocument#" result="FileInfo">
				<cfset File = #variables.uploadDir# & "/" & #Variables.NewEventDocument#>
				<cfscript>
					FileMimeType = fileGetMimeType(variables.file);
					FileInformation = getFileInfo(variables.file);
				</cfscript>
				<cfquery name="insertEventDocument" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_EventResources(Site_ID, Event_ID, ResourceType, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize)
					Values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">,
						<cfqueryparam value="D" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Variables.NewEventDocument#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Variables.EventDocs.ContentType#/#Variables.EventDocs.ContentSubType#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Variables.FileInformation.size#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>

				<cfquery name="GetSelectedEventDocuments" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize
					From p_EventRegistration_EventResources
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						ResourceType = <cfqueryparam value="D" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cflock scope="Session" type="exclusive" timeout="60">
					<cfset temp = StructDelete(Session, "GetSelectedEventDocuments")>
					<cfset Session.GetSelectedEventDocuments = StructCopy(GetSelectedEventDocuments)>
				</cflock>
			</cfif>
		</cfif>

		<cfif not isDefined("FORM.FormSubmit") and not isDefined("URL.UserAction")>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
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
			<cfquery name="GetSelectedEventResources" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
				From p_EventRegistration_EventResources
				Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfif GetSelectedEventResources.RecordCount EQ 0>
				<cfset uploadDir = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #URL.EventID# & "/">
				<cfif not DirectoryExists(variables.uploadDir)><cfdirectory action="Create" directory="#Variables.uploadDir#"></cfif>
				<cfdirectory action="list" directory="#variables.uploaddir#" name="EventDocuments">
				<cfif EventDocuments.RecordCount>
					<cfloop query="Variables.EventDocuments">
						<cfif Variables.EventDocuments.Type EQ "File">
							<cfset File = #EventDocuments.directory# & "/" & #EventDocuments.name#>
							<cfscript>
								FileMimeType = fileGetMimeType(variables.file);
								FileInformation = getFileInfo(variables.file);
							</cfscript>
							<cfquery name="insertEventDocument" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Insert into p_EventRegistration_EventResources(Site_ID, Event_ID, ResourceType, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize)
								Values(
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
									<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">,
									<cfqueryparam value="D" cfsqltype="cf_sql_varchar">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#EventDocuments.Name#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.FileMimeType#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.FileInformation.size#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
			</cfif>
			<cfquery name="GetSelectedEventDocuments" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize
				From p_EventRegistration_EventResources
				Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					ResourceType = <cfqueryparam value="D" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
			<cflock scope="Session" type="exclusive" timeout="60">
				<cfif GetSelectedEventRegistrations.RecordCount><cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.NumRegistrations#><cfelse><cfset Session.EventNumberRegistrations = 0></cfif>
				<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
				<cfset temp = StructDelete(Session, "GetSelectedEventDocuments")>
				<cfset temp = StructDelete(Session, "GetSelectedEventLinks")>
				<cfset Session.GetSelectedEventDocuments = StructCopy(GetSelectedEventDocuments)>
				<cfset Session.WebEventDirectory = #Variables.WebEventDirectory#>
			</cflock>
		<cfelseif not isDefined("FORM.FormSubmit") and isDefined("URL.UserAction")>
			<cfif URL.UserAction EQ "DeleteEventDocument">
				<cfquery name="GetEventDocumentName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ResourceDocument
					From p_EventRegistration_EventResources
					WHere Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						TContent_ID = <cfqueryparam value="#URL.DocumentID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfset uploadDir = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #URL.EventID# & "/">
				<cfset FileToDelete = #Variables.uploadDir# & #GetEventDocumentName.ResourceDocument#>
				<cffile action="delete" file="#Variables.FileToDelete#">
				<cfquery name="DeleteEventDocument" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Delete from p_EventRegistration_EventResources
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						TContent_ID = <cfqueryparam value="#URL.DocumentID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="GetSelectedEventDocuments" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize
					From p_EventRegistration_EventResources
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						ResourceType = <cfqueryparam value="D" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cflock scope="Session" type="exclusive" timeout="60">
					<cfset Session.GetSelectedEventDocuments = StructCopy(GetSelectedEventDocuments)>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventdocs&UserAction=ResourceDocumentDeleted&Successful=True&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		<cfelseif isDefined("FORM.FormSubmit")>

		</cfif>
	</cffunction>

	<cffunction name="eventweblinks" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.UserAction")>
			<cfif URL.UserAction EQ "DeleteEventWebLink">
				<cfquery name="DeleteEventWebLink" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Delete from p_EventRegistration_EventResources
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						TContent_ID = <cfqueryparam value="#URL.DocumentID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="GetSelectedEventWebLinks" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize
					From p_EventRegistration_EventResources
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cflock scope="Session" type="exclusive" timeout="60">
					<cfset Session.GetSelectedEventWebLinks = StructCopy(GetSelectedEventWebLinks)>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventweblinks&UserAction=ResourceLinkDeleted&Successful=True&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>

		<cfif not isDefined("FORM.FormSubmit")>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
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
			<cfquery name="GetSelectedEventWebLinks" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
				From p_EventRegistration_EventResources
				Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cflock scope="Session" type="exclusive" timeout="60">
				<cfif GetSelectedEventRegistrations.RecordCount><cfset Session.EventNumberRegistrations = #GetSelectedEventRegistrations.NumRegistrations#><cfelse><cfset Session.EventNumberRegistrations = 0></cfif>
				<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
				<cfset Session.GetSelectedEventWebLinks = StructCopy(GetSelectedEventWebLinks)>
			</cflock>
		<cfelseif isDefined("FORM.FormSubmit")>
			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "EventNumberRegistrations")>
				<cfset temp = StructDelete(Session, "GetSelectedEventWebLinks")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false">
			</cfif>
			<cfset Session.FormData = #StructCopy(FORM)#>
			<cfset Session.FormErrors = #ArrayNew()#>

			<cfif LEN(FORM.FirstWebLink)>
				<cfif Left(FORM.FirstWebLink, 7) NEQ "http://" and Left(FORM.FirstWebLink, 8) NEQ "https://">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="WebLink",message="Please add either http:// or https:// to the entered website so participants will get the correct site."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventweblinks&EventID=#FORM.EventID#&FormRetry=True">
				</cfif>
			</cfif>

			<cfif LEN(FORM.SecondWebLink)>
				<cfif Left(FORM.SecondWebLink, 7) NEQ "http://" and Left(FORM.SecondWebLink, 8) NEQ "https://">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="WebLink",message="Please add either http:// or https:// to the entered website so participants will get the correct site."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventweblinks&EventID=#FORM.EventID#&FormRetry=True">
				</cfif>
			</cfif>

			<cfif LEN(FORM.ThirdWebLink)>
				<cfif Left(FORM.ThirdWebLink, 7) NEQ "http://" and Left(FORM.ThirdWebLink, 8) NEQ "https://">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="WebLink",message="Please add either http:// or https:// to the entered website so participants will get the correct site."};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventweblinks&EventID=#FORM.EventID#&FormRetry=True">
				</cfif>
			</cfif>

			<cfif LEN(FORM.FirstWebLink) EQ 0 and LEN(FORM.SecondWebLink) EQ 0 and LEN(FORM.ThirdWebLink) EQ 0>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="WebLink",message="To add Event Website Links to this event, atleast one website link must be entered to submit this form."};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventweblinks&EventID=#FORM.EventID#&FormRetry=True">
			</cfif>

			<cfif LEN(FORM.FirstWebLink)>
				<cfquery name="insertEventDocument" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_EventResources(Site_ID, Event_ID, ResourceType, dateCreated, lastUpdated, lastUpdateBy, ResourceLink)
					Values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">,
						<cfqueryparam value="L" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#FORM.FirstWebLink#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
			</cfif>
			<cfif LEN(FORM.SecondWebLink)>
				<cfquery name="insertEventDocument" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_EventResources(Site_ID, Event_ID, ResourceType, dateCreated, lastUpdated, lastUpdateBy, ResourceLink)
					Values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">,
						<cfqueryparam value="L" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#FORM.SecondWebLink#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
			</cfif>
			<cfif LEN(FORM.ThirdWebLink)>
				<cfquery name="insertEventDocument" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_EventResources(Site_ID, Event_ID, ResourceType, dateCreated, lastUpdated, lastUpdateBy, ResourceLink)
					Values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">,
						<cfqueryparam value="L" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#FORM.ThirdWebLink#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
			</cfif>
			<cfquery name="GetSelectedEventWebLinks" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType, ResourceDocumentSize
				From p_EventRegistration_EventResources
				Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cflock scope="Session" type="exclusive" timeout="60">
				<cfset Session.GetSelectedEventWebLinks = StructCopy(GetSelectedEventWebLinks)>
			</cflock>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventweblinks&UserAction=ResourceLinkAdded&Successful=True&EventID=#URL.EventID#" addtoken="false">
		</cfif>
	</cffunction>

</cfcomponent>
