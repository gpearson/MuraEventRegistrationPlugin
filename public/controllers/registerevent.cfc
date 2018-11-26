/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">

	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID") and isNumeric(URL.EventID) and Session.Mura.IsLoggedIn EQ "false">
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfif isDefined("Session.UserRegistrationInfo")>
					<cfset Session.UserRegistrationInfo.EventID = #URL.EventID#>
					<cfset Session.UserRegistrationInfo.DateRegistered = #Now()#>
				<cfelse>
					<cfset Session.UserRegistrationInfo = StructNew()>
					<cfset Session.UserRegistrationInfo.EventID = #URL.EventID#>
					<cfset Session.UserRegistrationInfo.DateRegistered = #Now()#>
				</cfif>
			</cflock>
			<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cflocation addtoken="false" url="#CGI.Script_name##CGI.path_info#?display=login">
		<cfelseif isDefined("URL.EventID") and isNumeric(URL.EventID) and Session.Mura.IsLoggedIn EQ "true" and not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfquery name="Session.getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
						EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				</cfquery>
				<cfquery name="checkRegisteredForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, RegistrationID, RegistrationDate
					From p_EventRegistration_UserRegistrations
					Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif isDefined("Session.UserRegistrationInfo")>
					<cfset Session.UserRegistrationInfo.EventID = #URL.EventID#>
					<cfset Session.UserRegistrationInfo.DateRegistered = #Now()#>
					<cfset Session.UserRegistrationInfo.UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>
					<cfif checkRegisteredForEvent.RecordCount>
						<cfset Session.UserRegistrationInfo.UserAlreadyRegistered = true>
					<cfelse>
						<cfset Session.UserRegistrationInfo.UserAlreadyRegistered = false>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo = StructNew()>
					<cfset Session.UserRegistrationInfo.EventID = #URL.EventID#>
					<cfset Session.UserRegistrationInfo.DateRegistered = #Now()#>
					<cfset Session.UserRegistrationInfo.UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>
					<cfif checkRegisteredForEvent.RecordCount>
						<cfset Session.UserRegistrationInfo.UserAlreadyRegistered = true>
					<cfelse>
						<cfset Session.UserRegistrationInfo.UserAlreadyRegistered = false>
					</cfif>
				</cfif>

				<cfquery name="Session.getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, OrganizationName, OrganizationDomainName, Active
					From p_EventRegistration_Membership
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						OrganizationDomainName = <cfqueryparam value="#Session.UserRegistrationInfo.UserEmailDomain#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
					<cfif DateDiff("d", Now(), Session.getSelectedEvent.EarlyBird_RegistrationDeadline) GTE 0>
						<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = True>
					<cfelse>
						<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
				</cfif>

				<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
					<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = True>
					<cfif Session.getActiveMembership.RecordCount GTE 1>
						<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #Session.getSelectedEvent.WebinarMemberCost#>
					<cfelse>
						<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #Session.getSelectedEvent.WebinarNonMemberCost#>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = False>
				</cfif>

				<cfif Session.getSelectedEvent.ViewGroupPricing EQ 1>
					<cfset Session.UserRegistrationInfo.GroupPricingAvailable = True>
				<cfelse>
					<cfset Session.UserRegistrationInfo.GroupPricingAvailable = False>
				</cfif>

				<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
					<cfset Session.UserRegistrationInfo.VideoConferenceOption = True>
					<cfset Session.UserRegistrationInfo.VideoConferenceInfo = #Session.getSelectedEvent.VideoConferenceInfo#>
					<cfif Session.getActiveMembership.RecordCount GTE 1>
						<cfset Session.UserRegistrationInfo.VideoConferenceCost = #Session.getSelectedEvent.VideoConferenceCost#>
					<cfelse>
						<cfset Session.UserRegistrationInfo.VideoConferenceCost = #Session.getSelectedEvent.VideoConferenceCost#>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.VideoConferenceOption = False>
				</cfif>

				<cfif Session.getActiveMembership.RecordCount EQ 1>
					<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = True>
					<cfset Session.UserRegistrationInfo.UserEventPrice = #Session.getSelectedEvent.MemberCost#>
					<cfset Session.UserRegistrationInfo.GroupEventPrice = #Session.getSelectedEvent.GroupMemberCost#>
					<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
				<cfelse>
					<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = False>
					<cfset Session.UserRegistrationInfo.UserEventPrice = #Session.getSelectedEvent.NonMemberCost#>
					<cfset Session.UserRegistrationInfo.GroupEventPrice = #Session.getSelectedEvent.GroupNonMemberCost#>
					<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
				</cfif>
			</cflock>
		<cfelseif isDefined("FORM.EventID") and isNumeric(FORM.EventID) and Session.Mura.IsLoggedIn EQ "true" and isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>

			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "UserRegistrationInfo")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getActiveMembership")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" addtoken="false">
			</cfif>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset CreateiCalCard = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>


			<cfif FORM.RegisterAdditionalIndividuals EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Do you want to register additional individuals for this event? Select Yes or No below."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
			</cfif>

			<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)>
				<cfif FORM.RegisterDate EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Please Select whether you will be attending the first date of this event."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
				</cfif>
				<cfif isDefined("FORM.RegisterDate2")>
					<cfif FORM.RegisterDate2 EQ "----">
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Select whether you will be attending the second date of this event."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
					</cfif>
				</cfif>
				<cfif isDefined("FORM.RegisterDate3")>
					<cfif FORM.RegisterDate3 EQ "----">
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Select whether you will be attending the third date of this event."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
					</cfif>
				</cfif>
				<cfif isDefined("FORM.RegisterDate4")>
					<cfif FORM.RegisterDate4 EQ "----">
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Select whether you will be attending the fourth date of this event."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
					</cfif>
				</cfif>
				<cfif isDefined("FORM.RegisterDate5")>
					<cfif FORM.RegisterDate5 EQ "----">
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Select whether you will be attending the fifth date of this event."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
					</cfif>
				</cfif>
				<cfif isDefined("FORM.RegisterDate6")>
					<cfif FORM.RegisterDate6 EQ "----">
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Select whether you will be attending the sixth date of this event."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
					</cfif>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.AttendViaWebinar")>
				<cfif FORM.AttendViaWebinar EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Please Select whether you will be attending this event via the Webinar Option or not."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif isDefined("FORM.AttendViaIVC")>
				<cfif FORM.AttendViaIVC EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Please Select whether you will be attending this event via the Video Conference Option or not."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StayForMeal")>
				<cfif FORM.StayForMeal EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Please Select whether you will be stayinf for the Meal that is provided to Participants or not"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.RegisterAdditionalIndividuals EQ 0>
				<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID
					From p_EventRegistration_UserRegistrations
					Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
						User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
						EventID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif CheckUserAlreadyRegistered.RecordCount EQ 0>
					<cfset RegistrationID = #CreateUUID()#>
					<cfif Session.getSelectedEvent.MealProvided EQ 0>
						<cfset FORM.StayForMeal = 0>
					</cfif>
					<cftry>
						<cfif isDefined("FORM.RegisterDate")>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, RegisterForEventDate1, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									<cfqueryparam value="#FORM.RegisterDate#" cfsqltype="cf_sql_bit">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
								)
							</cfquery>
						<cfelse>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, RegisterForEventDate1, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
								)
							</cfquery>
						</cfif>

						<cfif isDefined("FORM.RegisterDate1")>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate2 = <cfqueryparam value="#FORM.RegisterDate1#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
						<cfif isDefined("FORM.RegisterDate2")>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate3 = <cfqueryparam value="#FORM.RegisterDate2#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
						<cfif isDefined("FORM.RegisterDate3")>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate4 = <cfqueryparam value="#FORM.RegisterDate3#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
						<cfif isDefined("FORM.RegisterDate4")>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate5 = <cfqueryparam value="#FORM.RegisterDate4#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
						<cfif isDefined("FORM.RegisterDate5")>
						<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate6 = <cfqueryparam value="#FORM.RegisterDate5#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>

						<cfif isDefined("FORM.AttendViaWebinar")>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set WebinarParticipant = <cfqueryparam value="#FORM.AttendViaWebinar#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
						<cfif isDefined("FORM.AttendViaIVC")>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set IVCParticipant = <cfqueryparam value="#FORM.AttendViaIVC#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
						<cfif Session.getSelectedEvent.MealProvided EQ 1>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RequestsMeal = <cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY)#>
						<cfset temp = StructDelete(Session, "FormErrors")>
						<cfset temp = StructDelete(Session, "FormInput")>
						<cfset temp = StructDelete(Session, "UserRegistrationInfo")>
						<cfset temp = StructDelete(Session, "getActiveMembership")>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default&UserAction=UserRegistered&Successfull=True&SingleRegistration=True" addtoken="false">
						<cfcatch type="Database">
							<cfdump var="#CFCATCH#"><cfabort>
						</cfcatch>
					</cftry>
				<cfelse>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True&UserAction=UserAlreadyRegistered" addtoken="false">
				</cfif>
			<cfelseif FORM.RegisterAdditionalIndividuals EQ 1>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.registeradditionalparticipants" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="registeradditionalparticipants" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.GetUsersWithinCorporation" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, Fname, Lname, Email
				From tusers
				Where Email LIKE '%#Session.UserRegistrationInfo.UserEmailDomain#'
				Order By Lname ASC, Fname ASC
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "UserRegistrationInfo")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				<cfset temp = StructDelete(Session, "getActiveMembership")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" addtoken="false">
			</cfif>

			<cfif not isDefined("FORM.ParticipantEmployee")>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select a Participant from the list who you would like to register for this event."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.registeradditionalparticipants&FormRetry=True" addtoken="false">
			<cfelse>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfset CreateiCalCard = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

				<cfloop list="#FORM.ParticipantEmployee#" index="i" delimiters=",">
					<cfset ParticipantUserID = ListFirst(i, "_")>
					<cfset DayNumber = ListLast(i, "_")>
					<cfswitch expression="#Variables.DayNumber#">
						<cfcase value="1">
							<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select RegistrationID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate1)
									Values(
										<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
										<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="1" cfsqltype="cf_sql_bit">
									)
								</cfquery>
								<cfif isDefined("FORM.StayForMeal")>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RequestsMeal = <cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
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
									EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate2)
									Values(
										<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
										<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="1" cfsqltype="cf_sql_bit">
									)
								</cfquery>
								<cfif isDefined("FORM.StayForMeal")>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RequestsMeal = <cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
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
									EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate3)
									Values(
										<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
										<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="1" cfsqltype="cf_sql_bit">
									)
								</cfquery>
								<cfif isDefined("FORM.StayForMeal")>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RequestsMeal = <cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
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
									EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate4)
									Values(
										<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
										<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="1" cfsqltype="cf_sql_bit">
									)
								</cfquery>
								<cfif isDefined("FORM.StayForMeal")>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RequestsMeal = <cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
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
									EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate5)
									Values(
										<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
										<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="1" cfsqltype="cf_sql_bit">
									)
								</cfquery>
								<cfif isDefined("FORM.StayForMeal")>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RequestsMeal = <cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
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
									EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate6)
									Values(
										<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
										<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="1" cfsqltype="cf_sql_bit">
									)
								</cfquery>
								<cfif isDefined("FORM.StayForMeal")>
									<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RequestsMeal = <cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							<cfelse>
								<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>
						</cfcase>
					</cfswitch>
					<cfquery name="GetRegistrationID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID
						From p_EventRegistration_UserRegistrations
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
							EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, GetRegistrationID.TContent_ID)#>
				</cfloop>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "UserRegistrationInfo")>
				<cfset temp = StructDelete(Session, "getActiveMembership")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default&UserAction=UserRegistered&Successfull=True&MultipleRegistration=True" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>