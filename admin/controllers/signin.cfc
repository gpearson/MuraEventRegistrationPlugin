/* This file is part of MuraFW1 Copyright 2010-2013 Stephen J. Withington, Jr. Licensed under the Apache License, Version v2.0 http://www.apache.org/licenses/LICENSE-2.0 */
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">


	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
	</cffunction>


	<cffunction name="addattendee" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfif not isDefined("Session.FormData")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructNew()#>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cflock>
		</cfif>
		<cfif isDefined("FORM.formSubmit")>
			<cfif isDefined("FORM.SignInAttendee")>
				<cfif isDefined("FORM.AttendeeUserID")>
					<cfif ListLen(FORM.AttendeeUserID) EQ 1>
						<cftry>
							<cfquery name="getUserAttendedEventRecNo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID
								From eRegistrations
								Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
									UserID = <cfqueryparam value="#FORM.AttendeeUserID#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfquery name="updateUserAttendedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update eRegistrations
								set AttendedEvent = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
								Where TContent_ID = <cfqueryparam value="#getUserAttendedEventRecNo.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfcatch type="database">
								<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.addattendee&SuccessfullAttendeeSignin=False&EventID=#URL.EventID#" addtoken="false">
							</cfcatch>
						</cftry>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.addattendee&SuccessfullAttendeeSignin=True&EventID=#URL.EventID#" addtoken="false">
					<cfelse>
						<cfset AttendeeToSignIn = #ListToArray(FORM.AttendeeUserID)#>
						<cfloop index="i" from="1" to="#ArrayLen(Variables.AttendeeToSignIn)#">
							<cftry>
								<cfquery name="getSelectedAttendee" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select UserID, Fname, Lname, Company, UserName, Email
									From tusers
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										Type = <cfqueryparam value="2" cfsqltype="cf_sql_integer"> and
										UserID = <cfqueryparam value="#Variables.AttendeeToSignIn[i]#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, Featured_StartDate, Featured_EndDate, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
									From eEvents
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfset UserEmailDomain = #Right(getSelectedAttendee.Email, Len(getSelectedAttendee.Email) - Find("@", getSelectedAttendee.Email))#>
								<cfquery name="getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select TContent_ID, OrganizationName, OrganizationDomainName
									From eMembership
									Where Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
										Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
									<cfif DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GTE 0>
										<cfset UserGetsEarlyBirdRegistration = True>
									<cfelse>
										<cfset UserGetsEarlyBirdRegistration = False>
									</cfif>
								</cfif>
								<cfif getActiveMembership.RecordCount EQ 1>
									<cfset UserGetsMembershipPrice = True>
									<cfset UserEventPrice = #getSelectedEvent.MemberCost#>
									<cfif Variables.UserGetsEarlyBirdRegistration EQ "True">
										<cfset UserEventPrice = #getSelectedEvent.EarlyBird_MemberCost#>
									</cfif>
								<cfelse>
									<cfset UserGetsMembershipPrice = False>
									<cfset UserEventPrice = #getSelectedEvent.NonMemberCost#>
									<cfif UserGetsEarlyBirdRegistration EQ "True">
										<cfset UserEventPrice = #getSelectedEvent.EarlyBird_NonMemberCost#>
									</cfif>
								</cfif>
								<cfset RegistrationID = #CreateUUID()#>
								<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, UserID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, AttendedEvent)
									Values(
										<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
										<cfqueryparam value="#Variables.AttendeeToSignIn[i]#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Variables.UserEventPrice#" cfsqltype="cf_sql_double">,
										<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="1" cfsqltype="cf_sql_integer">
									)
								</cfquery>
								<cfcatch type="Database">
									<cfdump var="#CFCATCH#">
									<cfabort>
								</cfcatch>
							</cftry>
							<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
						</cfloop>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.addattendee&SuccessfullAttendeeSignin=True&&MultipleAttendee=True&EventID=#URL.EventID#" addtoken="false">
					</cfif>
				<cfelse>
					<cfscript>
						noattendee = {property="NoAttendee",message="Please select a registered attendee to confirm they are at this event."};
						arrayAppend(Session.FormErrors, noattendee);
					</cfscript>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.addattendee&SiteID=#rc.$.siteConfig('siteID')#&EventID=#URL.EventID#" addtoken="false">
				</cfif>
			<cfelseif isDefined("FORM.WalkInAttendee")>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.walkinattendee&SiteID=#rc.$.siteConfig('siteID')#&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>


	<cffunction name="walkinattendee" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfset Session.FormData = #StructNew()#>
			<cfset Session.FormData.PluginInfo = StructNew()>
			<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
			<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
			<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
			<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
			<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
		</cflock>
		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
		<cfset CreateiCalCard = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
		<cfif isDefined("FORM.formSubmit")>
			<cfif isDefined("FORM.RegisterWalkInAttendee")>
				<cfif isDefined("FORM.AttendeeUserID")>
					<cfif ListLen(FORM.AttendeeUserID) EQ 1>
						<cftry>
							<cfquery name="getSelectedAttendee" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname, Company, UserName, Email
								From tusers
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									Type = <cfqueryparam value="2" cfsqltype="cf_sql_integer"> and
									UserID = <cfqueryparam value="#FORM.AttendeeUserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, Featured_StartDate, Featured_EndDate, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
								From eEvents
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfset UserEmailDomain = #Right(getSelectedAttendee.Email, Len(getSelectedAttendee.Email) - Find("@", getSelectedAttendee.Email))#>
							<cfquery name="getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID, OrganizationName, OrganizationDomainName
								From eMembership
								Where Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
								<cfif DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GTE 0>
									<cfset UserGetsEarlyBirdRegistration = True>
								<cfelse>
									<cfset UserGetsEarlyBirdRegistration = False>
								</cfif>
							</cfif>
							<cfif getActiveMembership.RecordCount EQ 1>
								<cfset UserGetsMembershipPrice = True>
								<cfset UserEventPrice = #getSelectedEvent.MemberCost#>
								<cfif Variables.UserGetsEarlyBirdRegistration EQ "True">
									<cfset UserEventPrice = #getSelectedEvent.EarlyBird_MemberCost#>
								</cfif>
							<cfelse>
								<cfset UserGetsMembershipPrice = False>
								<cfset UserEventPrice = #getSelectedEvent.NonMemberCost#>
								<cfif UserGetsEarlyBirdRegistration EQ "True">
									<cfset UserEventPrice = #getSelectedEvent.EarlyBird_NonMemberCost#>
								</cfif>
							</cfif>
							<cfset RegistrationID = #CreateUUID()#>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, UserID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, AttendedEvent)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#FORM.AttendeeUserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Variables.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="1" cfsqltype="cf_sql_integer">
								)
							</cfquery>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#">
								<cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.addattendee&SuccessfullAttendeeSignin=True&EventID=#URL.EventID#" addtoken="false">
					<cfelse>
						<cfset AttendeeToSignIn = #ListToArray(FORM.AttendeeUserID)#>
						<cfloop index="i" from="1" to="#ArrayLen(Variables.AttendeeToSignIn)#">
							<cftry>
								<cfquery name="getSelectedAttendee" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select UserID, Fname, Lname, Company, UserName, Email
									From tusers
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										Type = <cfqueryparam value="2" cfsqltype="cf_sql_integer"> and
										UserID = <cfqueryparam value="#Variables.AttendeeToSignIn[i]#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, Featured_StartDate, Featured_EndDate, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
									From eEvents
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfset UserEmailDomain = #Right(getSelectedAttendee.Email, Len(getSelectedAttendee.Email) - Find("@", getSelectedAttendee.Email))#>
								<cfquery name="getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select TContent_ID, OrganizationName, OrganizationDomainName
									From eMembership
									Where Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
										Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
									<cfif DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GTE 0>
										<cfset UserGetsEarlyBirdRegistration = True>
									<cfelse>
										<cfset UserGetsEarlyBirdRegistration = False>
									</cfif>
								</cfif>
								<cfif getActiveMembership.RecordCount EQ 1>
									<cfset UserGetsMembershipPrice = True>
									<cfset UserEventPrice = #getSelectedEvent.MemberCost#>
									<cfif Variables.UserGetsEarlyBirdRegistration EQ "True">
										<cfset UserEventPrice = #getSelectedEvent.EarlyBird_MemberCost#>
									</cfif>
								<cfelse>
									<cfset UserGetsMembershipPrice = False>
									<cfset UserEventPrice = #getSelectedEvent.NonMemberCost#>
									<cfif UserGetsEarlyBirdRegistration EQ "True">
										<cfset UserEventPrice = #getSelectedEvent.EarlyBird_NonMemberCost#>
									</cfif>
								</cfif>
								<cfset RegistrationID = #CreateUUID()#>
								<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, UserID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, AttendedEvent)
									Values(
										<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
										<cfqueryparam value="#Variables.AttendeeToSignIn[i]#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Variables.UserEventPrice#" cfsqltype="cf_sql_double">,
										<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="1" cfsqltype="cf_sql_integer">
									)
								</cfquery>
								<cfcatch type="Database">
									<cfdump var="#CFCATCH#">
									<cfabort>
								</cfcatch>
							</cftry>
							<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
						</cfloop>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.addattendee&SuccessfullAttendeeSignin=True&&MultipleAttendee=True&EventID=#URL.EventID#" addtoken="false">
					</cfif>
				<cfelse>
					<cfscript>
						noattendee = {property="NoAttendee",message="Please select a registered attendee to confirm they are at this event."};
						arrayAppend(Session.FormErrors, noattendee);
					</cfscript>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.addattendee&SiteID=#rc.$.siteConfig('siteID')#&EventID=#URL.EventID#" addtoken="false">
				</cfif>
			<cfelseif isDefined("FORM.WalkInAttendee")>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:signin.walkinattendee&SiteID=#rc.$.siteConfig('siteID')#&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>


</cfcomponent>
