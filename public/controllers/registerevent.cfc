/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cfset Session.FormData = #StructCopy(FORM)#>
			<cfset Session.FormData.PluginInfo = StructNew()>
			<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
			<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
			<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
			<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
			<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			<cfset Session.FormErrors = #ArrayNew()#>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset CreateiCalCard = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

			<cfif FORM.formSubmit EQ "true" and FORM.RegisterAdditionalParticipants EQ 0>
				<cfif isDefined("FORM.CancelButton")>
					<cftry>
						<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Delete from eRegistrations
							Where EventID =
								<cfif isDefined("URL.EventID")>
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
								<cfelse>
									<cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer"> and
								</cfif>
								User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
								Site_ID = <cfqueryparam value="#Session.Mura.SiteID#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfcatch type="Database">
							<cfdump var="#CFCATCH#"><cfabort>
						</cfcatch>
					</cftry>
					<cfif isDefined("URL.EventID")>
						<cfset Temp = #SendEmailCFC.SendEventCancellationToSingleParticipant(URL.EventID)#>
					<cfelse>
						<cfset Temp = #SendEmailCFC.SendEventCancellationToSingleParticipant(Session.UserRegistrationInfo.RegisterUserForEvent)#>
						<cfset temp = #StructDelete(Session, "UserRegistrationInfo")#>
					</cfif>
					<cflocation url="?EventRegistrationaction=public:events.viewavailableevents&CancelRegistrationSuccessfull=True&SingleRegistration=True" addtoken="false">
				<cfelseif isDefined("FORM.submitButton")>
					<cfif isDefined("FORM.RegisterAllDays")>
						<cfswitch expression="#FORM.RegisterAllDays#">
							<cfcase value="1">
								<cfquery name="GetEventMultipleDatesID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select EventID_AdditionalDates
									From eEventsMatrix
									Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>

								<!--- User wants to register for this event wothout registering other participants --->
								<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select TContent_ID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
										<cfif isDefined("URL.EventID")>
											EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
										<cfelse>
											EventID = <cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">
										</cfif>
								</cfquery>
								<cfif CheckUserAlreadyRegistered.RecordCount EQ 0>
									<cfset RegistrationID = #CreateUUID()#>
									<cfparam name="FORM.WantsMeal" default="0">
									<cftry>
										<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
											Values(
												<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("URL.EventID")><cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.DateRegistered#" cfsqltype="cf_sql_date">,</cfif>
												<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("URL.EventID")><cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">,</cfif>
												<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
												<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
											)
										</cfquery>

										<cfif isDefined("FORM.WebinarParticipant")>
											<cfif FORM.WebinarParticipant EQ 1>
												<cfquery name="updateRegistrationToWebinar" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
													Update eRegistrations
													Set WebinarParticipant = <cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,
														RequestsMeal = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
														AttendeePrice = <cfqueryparam value="#Session.UserRegistrationInfo.WebinarPricingEventCost#" cfsqltype="cf_sql_money">
													Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
												</cfquery>
											</cfif>
										</cfif>
										<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
										<cfcatch type="Database">
											<cfdump var="#CFCATCH#"><cfabort>
										</cfcatch>
									</cftry>
								<cfelse>
									<cfscript>
										AlreadyRegistered = {property="RegisterAdditionalParticipants",message="You are already registered for this event. Please change this option to register additional participants."};
										arrayAppend(Session.FormErrors, AlreadyRegistered);
									</cfscript>
									<cfif isDefined("URL.EventID")>
										<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#URL.EventID#&RegistrationSuccessfull=False" addtoken="false">
									<cfelse>
										<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#Session.UserRegistrationInfo.RegisterUserForEvent#&RegistrationSuccessfull=False" addtoken="false">
									</cfif>
								</cfif>
								<cfloop query="GetEventMultipleDatesID">
									<!--- User wants to register for this event wothout registering other participants --->
									<cfquery name="CheckUserAlreadyRegisteredAdditionalDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
											User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
											EventID = <cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">
									</cfquery>
									<cfif CheckUserAlreadyRegisteredAdditionalDates.RecordCount EQ 0>
										<cfset RegistrationID = #CreateUUID()#>
										<cfparam name="FORM.WantsMeal" default="0">
										<cftry>
											<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
												Values(
													<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
													<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">,
													<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
													<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
												)
											</cfquery>

											<cfif isDefined("FORM.WebinarParticipant")>
												<cfif FORM.WebinarParticipant EQ 1>
													<cfquery name="updateRegistrationToWebinar" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
														Update eRegistrations
														Set WebinarParticipant = <cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,
															RequestsMeal = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
															AttendeePrice = <cfqueryparam value="#Session.UserRegistrationInfo.WebinarPricingEventCost#" cfsqltype="cf_sql_money">
														Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
													</cfquery>
												</cfif>
											</cfif>
											<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
											<cfcatch type="Database">
												<cfdump var="#CFCATCH#"><cfabort>
											</cfcatch>
										</cftry>
									</cfif>
								</cfloop>
								<cfset temp = #StructDelete(Session, "UserRegistrationInfo")#>
								<cflocation url="/index.cfm?RegistrationSuccessfull=True&SingleRegistration=True" addtoken="false">
							</cfcase>
							<cfdefaultcase>
								<!--- User wants to register for this event wothout registering other participants --->
								<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select TContent_ID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
										<cfif isDefined("URL.EventID")>
											EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
										<cfelse>
											EventID = <cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">
										</cfif>
								</cfquery>
								<cfif CheckUserAlreadyRegistered.RecordCount EQ 0>
									<cfset RegistrationID = #CreateUUID()#>
									<cfparam name="FORM.WantsMeal" default="0">
									<cftry>
										<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
											Values(
												<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("URL.EventID")><cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.DateRegistered#" cfsqltype="cf_sql_date">,</cfif>
												<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("URL.EventID")><cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">,</cfif>
												<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
												<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
											)
										</cfquery>
										<cfif isDefined("FORM.WebinarParticipant")>
											<cfif FORM.WebinarParticipant EQ 1>
												<cfquery name="updateRegistrationToWebinar" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
													Update eRegistrations
													Set WebinarParticipant = <cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,
														RequestsMeal = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
														AttendeePrice = <cfqueryparam value="#Session.UserRegistrationInfo.WebinarPricingEventCost#" cfsqltype="cf_sql_money">
													Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
												</cfquery>
											</cfif>
										</cfif>
										<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
										<cfset temp = #StructDelete(Session, "UserRegistrationInfo")#>
										<cflocation url="/index.cfm?RegistrationSuccessfull=True&SingleRegistration=True" addtoken="false">
										<cfcatch type="Database">
											<cfdump var="#CFCATCH#"><cfabort>
										</cfcatch>
									</cftry>
								<cfelse>
									<cfscript>
										AlreadyRegistered = {property="RegisterAdditionalParticipants",message="You are already registered for this event. Please change this option to register additional participants."};
										arrayAppend(Session.FormErrors, AlreadyRegistered);
									</cfscript>
									<cfif isDefined("URL.EventID")>
										<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#URL.EventID#&RegistrationSuccessfull=False" addtoken="false">
									<cfelse>
										<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#Session.UserRegistrationInfo.RegisterUserForEvent#&RegistrationSuccessfull=False" addtoken="false">
									</cfif>
								</cfif>
							</cfdefaultcase>
						</cfswitch>
					<cfelse>
						<!--- User wants to register for this event wothout registering other participants --->
						<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select TContent_ID
							From eRegistrations
							Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
								User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
								<cfif isDefined("URL.EventID")>
									EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								<cfelse>
									EventID = <cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">
								</cfif>
						</cfquery>
						<cfif CheckUserAlreadyRegistered.RecordCount EQ 0>
							<cfset RegistrationID = #CreateUUID()#>
							<cfparam name="FORM.WantsMeal" default="0">
							<cftry>
								<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
									Values(
										<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
										<cfif isDefined("URL.EventID")><cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.DateRegistered#" cfsqltype="cf_sql_date">,</cfif>
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfif isDefined("URL.EventID")><cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">,</cfif>
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
										<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
									)
								</cfquery>
								<cfif isDefined("FORM.WebinarParticipant")>
									<cfif FORM.WebinarParticipant EQ 1>
										<cfquery name="updateRegistrationToWebinar" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set WebinarParticipant = <cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,
												RequestsMeal = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
												AttendeePrice = <cfqueryparam value="#Session.UserRegistrationInfo.WebinarPricingEventCost#" cfsqltype="cf_sql_money">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
								<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
								<cfset temp = #StructDelete(Session, "UserRegistrationInfo")#>
								<cflocation url="/index.cfm?RegistrationSuccessfull=True&SingleRegistration=True" addtoken="false">
								<cfcatch type="Database">
									<cfdump var="#CFCATCH#"><cfabort>
								</cfcatch>
							</cftry>
						<cfelse>
							<cfscript>
								AlreadyRegistered = {property="RegisterAdditionalParticipants",message="You are already registered for this event. Please change this option to register additional participants."};
								arrayAppend(Session.FormErrors, AlreadyRegistered);
							</cfscript>
							<cfif isDefined("URL.EventID")>
								<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#URL.EventID#&RegistrationSuccessfull=False" addtoken="false">
							<cfelse>
								<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#Session.UserRegistrationInfo.RegisterUserForEvent#&RegistrationSuccessfull=False" addtoken="false">
							</cfif>
						</cfif>
					</cfif>
				</cfif>
			<cfelseif FORM.formSubmit EQ "true" and FORM.RegisterAdditionalParticipants EQ 1>
				<!--- User would like to Register Additional PArticipants --->
				<cflock scope="session" type="exclusive" timeout="30">
					<cfset Session.FormData = #StructCopy(FORM)#>
				</cflock>
				<cfset Session.UserRegistrationInfo.RegisterAdditionalParticipants = True>
				<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.registeradditionalparticipants&EventID=#URL.EventID#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="registeradditionalparticipants" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.EventID")>
			<cflock scope="session" type="exclusive" timeout="30">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset CreateiCalCard = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

			<cfif isDefined("FORM.additionalParticipants")>
				<cfif ListLen(FORM.additionalParticipants) EQ 1>
					<cfif isDefined("FORM.RegisterAllDays")>
						<cfswitch expression="#FORM.RegisterAllDays#">
							<cfcase value="1">
								<cfquery name="GetEventMultipleDatesID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select EventID_AdditionalDates
									From eEventsMatrix
									Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>

								<!--- User wants to register for this event wothout registering other participants --->
								<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select TContent_ID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#FORM.additionalParticipants#" cfsqltype="cf_sql_varchar"> and
										<cfif isDefined("URL.EventID")>
											EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
										<cfelse>
											EventID = <cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">
										</cfif>
								</cfquery>
								<cfif CheckUserAlreadyRegistered.RecordCount EQ 0>
									<cfset RegistrationID = #CreateUUID()#>
									<cfparam name="FORM.WantsMeal" default="0">
									<cftry>
										<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
											Values(
												<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("URL.EventID")><cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.DateRegistered#" cfsqltype="cf_sql_date">,</cfif>
												<cfqueryparam value="#FORM.additionalParticipants#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("URL.EventID")><cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">,</cfif>
												<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
												<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
											)
										</cfquery>

										<cfif isDefined("FORM.WebinarParticipant")>
											<cfif FORM.WebinarParticipant EQ 1>
												<cfquery name="updateRegistrationToWebinar" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
													Update eRegistrations
													Set WebinarParticipant = <cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,
														RequestsMeal = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
														AttendeePrice = <cfqueryparam value="#Session.UserRegistrationInfo.WebinarPricingEventCost#" cfsqltype="cf_sql_money">
													Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
												</cfquery>
											</cfif>
										</cfif>
										<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
										<cfcatch type="Database">
											<cfdump var="#CFCATCH#"><cfabort>
										</cfcatch>
									</cftry>
								<cfelse>
									<cfscript>
										AlreadyRegistered = {property="RegisterAdditionalParticipants",message="You are already registered for this event. Please change this option to register additional participants."};
										arrayAppend(Session.FormErrors, AlreadyRegistered);
									</cfscript>
									<cfif isDefined("URL.EventID")>
										<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#URL.EventID#&RegistrationSuccessfull=False" addtoken="false">
									<cfelse>
										<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#Session.UserRegistrationInfo.RegisterUserForEvent#&RegistrationSuccessfull=False" addtoken="false">
									</cfif>
								</cfif>
								<cfloop query="GetEventMultipleDatesID">
									<!--- User wants to register for this event wothout registering other participants --->
									<cfquery name="CheckUserAlreadyRegisteredAdditionalDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select TContent_ID
										From eRegistrations
										Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
											User_ID = <cfqueryparam value="#FORM.additionalParticipants#" cfsqltype="cf_sql_varchar"> and
											EventID = <cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">
									</cfquery>
									<cfif CheckUserAlreadyRegisteredAdditionalDates.RecordCount EQ 0>
										<cfset RegistrationID = #CreateUUID()#>
										<cfparam name="FORM.WantsMeal" default="0">
										<cftry>
											<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
												insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
												Values(
													<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
													<cfqueryparam value="#FORM.additionalParticipants#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">,
													<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
													<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
													<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
												)
											</cfquery>

											<cfif isDefined("FORM.WebinarParticipant")>
												<cfif FORM.WebinarParticipant EQ 1>
													<cfquery name="updateRegistrationToWebinar" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
														Update eRegistrations
														Set WebinarParticipant = <cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,
															RequestsMeal = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
															AttendeePrice = <cfqueryparam value="#Session.UserRegistrationInfo.WebinarPricingEventCost#" cfsqltype="cf_sql_money">
														Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
													</cfquery>
												</cfif>
											</cfif>
											<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
											<cfcatch type="Database">
												<cfdump var="#CFCATCH#"><cfabort>
											</cfcatch>
										</cftry>
									</cfif>
								</cfloop>
							</cfcase>
							<cfdefaultcase>
								<!--- User wants to register for this event wothout registering other participants --->
								<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select TContent_ID
									From eRegistrations
									Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
										User_ID = <cfqueryparam value="#FORM.additionalParticipants#" cfsqltype="cf_sql_varchar"> and
										<cfif isDefined("URL.EventID")>
											EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
										<cfelse>
											EventID = <cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">
										</cfif>
								</cfquery>
								<cfif CheckUserAlreadyRegistered.RecordCount EQ 0>
									<cfset RegistrationID = #CreateUUID()#>
									<cfparam name="FORM.WantsMeal" default="0">
									<cftry>
										<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
											Values(
												<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("URL.EventID")><cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.DateRegistered#" cfsqltype="cf_sql_date">,</cfif>
												<cfqueryparam value="#FORM.additionalParticipants#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("URL.EventID")><cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,<cfelse><cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">,</cfif>
												<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
												<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
											)
										</cfquery>
										<cfif isDefined("FORM.WebinarParticipant")>
											<cfif FORM.WebinarParticipant EQ 1>
												<cfquery name="updateRegistrationToWebinar" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
													Update eRegistrations
													Set WebinarParticipant = <cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,
														RequestsMeal = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
														AttendeePrice = <cfqueryparam value="#Session.UserRegistrationInfo.WebinarPricingEventCost#" cfsqltype="cf_sql_money">
													Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
												</cfquery>
											</cfif>
										</cfif>
										<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
										<cfcatch type="Database">
											<cfdump var="#CFCATCH#"><cfabort>
										</cfcatch>
									</cftry>
								<cfelse>
									<cfscript>
										AlreadyRegistered = {property="RegisterAdditionalParticipants",message="You are already registered for this event. Please change this option to register additional participants."};
										arrayAppend(Session.FormErrors, AlreadyRegistered);
									</cfscript>
									<cfif isDefined("URL.EventID")>
										<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#URL.EventID#&RegistrationSuccessfull=False" addtoken="false">
									<cfelse>
										<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#Session.UserRegistrationInfo.RegisterUserForEvent#&RegistrationSuccessfull=False" addtoken="false">
									</cfif>
								</cfif>
							</cfdefaultcase>
						</cfswitch>
					<cfelse>
						<cfset RegistrationID = #CreateUUID()#>
						<cftry>
							<cfparam name="FORM.WantsMeal" default="0">
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, WebinarParticipant, RequestsMeal)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#Form.additionalparticipants#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfif isDefined("FORM.WebinarParticipant")><cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
									<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
								)
							</cfquery>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfif Session.Mura.UserID EQ FORM.additionalParticipants>
							<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
						<cfelse>
							<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
						</cfif>
					</cfif>
				<cfelseif ListLen(FORM.additionalParticipants) GTE 2>
					<cfif isDefined("FORM.RegisterAllDays")>
						<cfswitch expression="#FORM.RegisterAllDays#">
							<cfcase value="1">
								<cfquery name="GetEventMultipleDatesID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select EventID_AdditionalDates
									From eEventsMatrix
									Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfloop list="#FORM.additionalParticipants#" index="i" delimiters=",">
									<cfset RegistrationID = #CreateUUID()#>
									<cftry>
										<cfparam name="FORM.WantsMeal" default="0">
										<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, WebinarParticipant, RequestsMeal)
											Values(
												<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
												<cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
												<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
												<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("FORM.WebinarParticipant")><cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
												<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
											)
										</cfquery>
										<cfcatch type="Database">
											<cfdump var="#CFCATCH#"><cfabort>
										</cfcatch>
									</cftry>
									<cfif Session.Mura.UserID EQ FORM.additionalParticipants>
										<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
									<cfelse>
										<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
									</cfif>
									<cfloop query="GetEventMultipleDatesID">
										<cfquery name="CheckUserAlreadyRegisteredAdditionalDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select TContent_ID
											From eRegistrations
											Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
												User_ID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"> and
												EventID = <cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfif CheckUserAlreadyRegisteredAdditionalDates.RecordCount EQ 0>
											<cfset RegistrationID = #CreateUUID()#>
											<cfparam name="FORM.WantsMeal" default="0">
											<cftry>
												<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
													insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RequestsMeal)
													Values(
														<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
														<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
														<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
														<cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">,
														<cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">,
														<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_money">,
														<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
														<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
														<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
													)
												</cfquery>
												<cfif isDefined("FORM.WebinarParticipant")>
													<cfif FORM.WebinarParticipant EQ 1>
														<cfquery name="updateRegistrationToWebinar" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
															Update eRegistrations
															Set WebinarParticipant = <cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,
																RequestsMeal = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
																AttendeePrice = <cfqueryparam value="#Session.UserRegistrationInfo.WebinarPricingEventCost#" cfsqltype="cf_sql_money">
															Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
														</cfquery>
													</cfif>
												</cfif>
												<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
												<cfcatch type="Database">
													<cfdump var="#CFCATCH#"><cfabort>
												</cfcatch>
											</cftry>
										</cfif>
									</cfloop>
								</cfloop>
							</cfcase>
							<cfdefaultcase>
								<cfloop list="#FORM.additionalParticipants#" index="i" delimiters=",">
									<cfset RegistrationID = #CreateUUID()#>
									<cftry>
										<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, WebinarParticipant, RequestsMeal)
											Values(
												<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
												<cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
												<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
												<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
												<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
												<cfif isDefined("FORM.WebinarParticipant")><cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
												<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
											)
										</cfquery>
										<cfcatch type="Database">
											<cfdump var="#CFCATCH#"><cfabort>
										</cfcatch>
									</cftry>
									<cfif Session.Mura.UserID EQ FORM.additionalParticipants>
										<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
									<cfelse>
										<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
									</cfif>
								</cfloop>
							</cfdefaultcase>
						</cfswitch>
					<cfelse>
						<cfloop list="#FORM.additionalParticipants#" index="i" delimiters=",">
							<cfset RegistrationID = #CreateUUID()#>
							<cftry>
								<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, WebinarParticipant, RequestsMeal)
									Values(
										<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
										<cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
										<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
										<cfif isDefined("FORM.WebinarParticipant")><cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
										<cfqueryparam value="#FORM.WantsMeal#" cfsqltype="cf_sql_bit">
									)
								</cfquery>
								<cfcatch type="Database">
									<cfdump var="#CFCATCH#"><cfabort>
								</cfcatch>
							</cftry>
							<cfif Session.Mura.UserID EQ FORM.additionalParticipants>
								<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
							<cfelse>
								<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
							</cfif>
						</cfloop>
					</cfif>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_1_FirstName) and LEN(FORM.AdditionalParticipant_1_LastName) and LEN(AdditionalParticipant_1_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_1_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_1_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_1_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_1_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_1_IPVideo)>
							<cfif FORM.AdditionalParticipant_1_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>

					<cfset temp = #this.AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_1_FirstName, FORM.AdditionalParticipant_1_LastName, FORM.AdditionalParticipant_1_Email, FORM.RegisterAllDays, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_2_FirstName) and LEN(FORM.AdditionalParticipant_2_LastName) and LEN(AdditionalParticipant_2_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_2_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_2_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_2_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_2_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_2_IPVideo)>
							<cfif FORM.AdditionalParticipant_2_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>
					<cfset temp = #this.AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_2_FirstName, FORM.AdditionalParticipant_2_LastName, FORM.AdditionalParticipant_2_Email, Variables.ParticipantRegisterAllDates, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_3_FirstName) and LEN(FORM.AdditionalParticipant_3_LastName) and LEN(AdditionalParticipant_3_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_3_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_3_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_3_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_3_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_3_IPVideo)>
							<cfif FORM.AdditionalParticipant_3_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>
					<cfset temp = #AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_3_FirstName, FORM.AdditionalParticipant_3_LastName, FORM.AdditionalParticipant_3_Email, Variables.ParticipantRegisterAllDates, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_4_FirstName) and LEN(FORM.AdditionalParticipant_4_LastName) and LEN(AdditionalParticipant_4_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_4_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_4_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_4_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_4_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_4_IPVideo)>
							<cfif FORM.AdditionalParticipant_4_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>
					<cfset temp = #AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_4_FirstName, FORM.AdditionalParticipant_4_LastName, FORM.AdditionalParticipant_4_Email, Variables.ParticipantRegisterAllDates, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_5_FirstName) and LEN(FORM.AdditionalParticipant_5_LastName) and LEN(AdditionalParticipant_5_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_5_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_5_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_5_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_5_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_5_IPVideo)>
							<cfif FORM.AdditionalParticipant_5_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>
					<cfset temp = #AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_5_FirstName, FORM.AdditionalParticipant_5_LastName, FORM.AdditionalParticipant_5_Email, Variables.ParticipantRegisterAllDates, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>
				<cflock scope="Session" type="Exclusive" timeout="60">
					<cfset StructDelete(Session, "UserRegistrationInfo")>
				</cflock>
				<cfset temp = #StructDelete(Session, "UserRegistrationInfo")#>
				<cflocation url="/index.cfm?RegistrationSuccessfull=True&MultipleRegistration=True" addtoken="false">
			<cfelse>
				<cfif LEN(FORM.AdditionalParticipant_1_FirstName) and LEN(FORM.AdditionalParticipant_1_LastName) and LEN(AdditionalParticipant_1_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_1_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_1_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_1_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_1_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_1_IPVideo)>
							<cfif FORM.AdditionalParticipant_1_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>

					<cfset temp = #this.AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_1_FirstName, FORM.AdditionalParticipant_1_LastName, FORM.AdditionalParticipant_1_Email, FORM.RegisterAllDays, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_2_FirstName) and LEN(FORM.AdditionalParticipant_2_LastName) and LEN(AdditionalParticipant_2_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_2_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_2_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_2_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_2_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_2_IPVideo)>
							<cfif FORM.AdditionalParticipant_2_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>
					<cfset temp = #this.AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_2_FirstName, FORM.AdditionalParticipant_2_LastName, FORM.AdditionalParticipant_2_Email, Variables.ParticipantRegisterAllDates, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_3_FirstName) and LEN(FORM.AdditionalParticipant_3_LastName) and LEN(AdditionalParticipant_3_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_3_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_3_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_3_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_3_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_3_IPVideo)>
							<cfif FORM.AdditionalParticipant_3_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>
					<cfset temp = #AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_3_FirstName, FORM.AdditionalParticipant_3_LastName, FORM.AdditionalParticipant_3_Email, Variables.ParticipantRegisterAllDates, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_4_FirstName) and LEN(FORM.AdditionalParticipant_4_LastName) and LEN(AdditionalParticipant_4_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_4_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_4_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_4_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_4_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_4_IPVideo)>
							<cfif FORM.AdditionalParticipant_4_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>
					<cfset temp = #AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_4_FirstName, FORM.AdditionalParticipant_4_LastName, FORM.AdditionalParticipant_4_Email, Variables.ParticipantRegisterAllDates, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_5_FirstName) and LEN(FORM.AdditionalParticipant_5_LastName) and LEN(AdditionalParticipant_5_EMail)>
					<cfif isDefined("FORM.AdditionalParticipant_5_Stay4Meal")>
						<cfif Len(FORM.AdditionalParticipant_5_Stay4Meal)>
							<cfif FORM.AdditionalParticipant_5_Stay4Meal EQ 1><cfset ParticipantStayForMeal = 1><cfelse><cfset ParticipantStayForMeal = 0></cfif>
						<cfelse><cfset ParticipantStayForMeal = 0></cfif>
					<cfelse><cfset ParticipantStayForMeal = 0></cfif>

					<cfif isDefined("FORM.AdditionalParticipant_5_IPVideo")>
						<cfif Len(FORM.AdditionalParticipant_5_IPVideo)>
							<cfif FORM.AdditionalParticipant_5_IPVideo EQ 1><cfset ParticipantIPVideo = 1><cfelse><cfset ParticipantIPVideo = 0></cfif>
						<cfelse><cfset ParticipantIPVideo = 0></cfif>
					<cfelse><cfset ParticipantIPVideo = 0></cfif>

					<cfif isDefined("FORM.RegisterAllDays")>
						<cfif FORM.RegisterAllDays EQ 1><cfset ParticipantRegisterAllDates = 1><cfelse><cfset ParticipantRegisterAllDates = 0></cfif>
					</cfif>
					<cfset temp = #AdditionalPartifipantInformationToRegister(FORM.AdditionalParticipant_5_FirstName, FORM.AdditionalParticipant_5_LastName, FORM.AdditionalParticipant_5_Email, Variables.ParticipantRegisterAllDates, FORM.SiteID, Variables.ParticipantStayForMeal, Variables.ParticipantIPVideo)#>
				</cfif>
				<cflock scope="Session" type="Exclusive" timeout="60">
					<cfset StructDelete(Session, "UserRegistrationInfo")>
				</cflock>
				<cfset temp = #StructDelete(Session, "UserRegistrationInfo")#>
				<cflocation url="/index.cfm?RegistrationSuccessfull=True&MultipleRegistration=True" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="AdditionalPartifipantInformationToRegister" returntype="any" output="true">
		<cfargument name="FirstName" type="String" required="True">
		<cfargument name="LastName" type="String" required="True">
		<cfargument name="Email" type="String" required="True">
		<cfargument name="RegisterAllDates" type="boolean" required="True">
		<cfargument name="SiteID" type="String" required="True">
		<cfargument name="Stay4Meal" type="boolean" required="false">
		<cfargument name="IPVideoParticipant" type="boolean" required="false">

		<cfquery name="CheckUserAlreadyHasAccount" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select UserID
			From tusers
			Where SiteID = <cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar"> and
				FName = <cfqueryparam value="#Arguments.FirstName#" cfsqltype="cf_sql_varchar"> and
				Lname = <cfqueryparam value="#Arguments.LastName#" cfsqltype="cf_sql_varchar"> and
				UserName = <cfqueryparam value="#Arguments.Email#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif CheckUserAlreadyHasAccount.RecordCount>
			<cfswitch expression="#Arguments.RegisterAllDates#">
				<cfcase value="1">
					<cfquery name="GetEventMultipleDatesID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select EventID_AdditionalDates
						From eEventsMatrix
						Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset RegistrationID = #CreateUUID()#>
					<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
						insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
						Values(
							<cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
							<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						)
					</cfquery>
					<cfif Arguments.Stay4Meal EQ 1>
						<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Update eRegistrations
							Set RequestsMeal = <cfqueryparam value="#Arguments.Stay4Meal#" cfsqltype="cf_sql_bit">
							Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
					<cfif Arguments.IPVideoParticipant EQ 1>
						<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Update eRegistrations
							Set IVCParticipant = <cfqueryparam value="#Arguments.IPVideoParticipant#" cfsqltype="cf_sql_bit">
							Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
					<cfloop query="GetEventMultipleDatesID">
						<cfquery name="CheckUserAlreadyRegisteredAdditionalDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select TContent_ID
							From eRegistrations
							Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
								User_ID = <cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar"> and
								EventID = <cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif CheckUserAlreadyRegisteredAdditionalDates.RecordCount EQ 0>
							<cfset RegistrationID = #CreateUUID()#>
							<cftry>
								<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
									insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
									Values(
										<cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
										<cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
										<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									)
								</cfquery>
								<cfif Arguments.Stay4Meal EQ 1>
									<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
										Update eRegistrations
										Set RequestsMeal = <cfqueryparam value="#Arguments.Stay4Meal#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif Arguments.IPVideoParticipant EQ 1>
									<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
										Update eRegistrations
										Set IVCParticipant = <cfqueryparam value="#Arguments.IPVideoParticipant#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
								<cfcatch type="Database">
									<cfdump var="#CFCATCH#"><cfabort>
								</cfcatch>
							</cftry>
						</cfif>
					</cfloop>
				</cfcase>
				<cfdefaultcase>
					<cfset RegistrationID = #CreateUUID()#>
					<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
						insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
						Values(
							<cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
							<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						)
					</cfquery>
					<cfif Arguments.Stay4Meal EQ 1>
						<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Update eRegistrations
							Set RequestsMeal = <cfqueryparam value="#Arguments.Stay4Meal#" cfsqltype="cf_sql_bit">
							Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
					<cfif Arguments.IPVideoParticipant EQ 1>
						<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Update eRegistrations
							Set IVCParticipant = <cfqueryparam value="#Arguments.IPVideoParticipant#" cfsqltype="cf_sql_bit">
							Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
					<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
				</cfdefaultcase>
			</cfswitch>
		<cfelse>
			<cfset RegistrationID = #CreateUUID()#>
			<cfset NewUserErrors = ArrayNew()>
			<cfset NewUser = Application.userManager.read('')>
			<cfset NewUser.setSiteID("#Arguments.SiteID#")>
			<cfset NewUser.setFname("#Arguments.FirstName#")>
			<cfset NewUser.setLname("#Arguments.LastName#")>
			<cfset NewUser.setEmail("#Arguments.Email#")>
			<cfset NewUser.setUsername("#Arguments.Email#")>
			<cfset NewUser.setPassword("NewUserTempPassword")>
			<cfset NewUser = Application.UserManager.save(NewUser)>
			<cfif !StructIsEmpty(NewUser.getErrors())>
				<!--- Display Error Message regarding regarding inserting new user --->
			</cfif>
			<cfquery name="GetNewUserAccountInfo" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
				Select UserID
				From tusers
				Where SiteID = <cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar"> and
					FName = <cfqueryparam value="#Arguments.FirstName#" cfsqltype="cf_sql_varchar"> and
					Lname = <cfqueryparam value="#Arguments.LastName#" cfsqltype="cf_sql_varchar"> and
					UserName = <cfqueryparam value="#Arguments.Email#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfswitch expression="#Arguments.RegisterAllDates#">
				<cfcase value="1">
					<cfquery name="GetEventMultipleDatesID" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
						Select EventID_AdditionalDates
						From eEventsMatrix
						Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset RegistrationID = #CreateUUID()#>
					<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
						insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
						Values(
							<cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#GetNewUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
							<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						)
					</cfquery>
					<cfif Arguments.Stay4Meal EQ 1>
						<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Update eRegistrations
							Set RequestsMeal = <cfqueryparam value="#Arguments.Stay4Meal#" cfsqltype="cf_sql_bit">
							Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
					<cfif Arguments.IPVideoParticipant EQ 1>
						<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Update eRegistrations
							Set IVCParticipant = <cfqueryparam value="#Arguments.IPVideoParticipant#" cfsqltype="cf_sql_bit">
							Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
					<cfloop query="GetEventMultipleDatesID">
						<cfquery name="CheckUserAlreadyRegisteredAdditionalDates" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Select TContent_ID
							From eRegistrations
							Where Site_ID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
								User_ID = <cfqueryparam value="#GetNewUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar"> and
								EventID = <cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfif CheckUserAlreadyRegisteredAdditionalDates.RecordCount EQ 0>
							<cfset RegistrationID = #CreateUUID()#>
							<cftry>
								<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
									insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
									Values(
										<cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
										<cfqueryparam value="#GetNewUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#GetEventMultipleDatesID.EventID_AdditionalDates#" cfsqltype="cf_sql_integer">,
										<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
										<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
										<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									)
								</cfquery>
								<cfif Arguments.Stay4Meal EQ 1>
									<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
										Update eRegistrations
										Set RequestsMeal = <cfqueryparam value="#Arguments.Stay4Meal#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif Arguments.IPVideoParticipant EQ 1>
									<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
										Update eRegistrations
										Set IVCParticipant = <cfqueryparam value="#Arguments.IPVideoParticipant#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
								<cfcatch type="Database">
									<cfdump var="#CFCATCH#"><cfabort>
								</cfcatch>
							</cftry>
						</cfif>
					</cfloop>
				</cfcase>
				<cfdefaultcase>
					<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
						insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
						Values(
							<cfqueryparam value="#Arguments.SiteID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
							<cfqueryparam value="#GetNewUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
							<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
						)
					</cfquery>
					<cfif Arguments.Stay4Meal EQ 1>
						<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Update eRegistrations
							Set RequestsMeal = <cfqueryparam value="#Arguments.Stay4Meal#" cfsqltype="cf_sql_bit">
							Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
					<cfif Arguments.IPVideoParticipant EQ 1>
						<cfquery name="updateNewRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
							Update eRegistrations
							Set IVCParticipant = <cfqueryparam value="#Arguments.IPVideoParticipant#" cfsqltype="cf_sql_bit">
							Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
					<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
				</cfdefaultcase>
			</cfswitch>
		</cfif>
	</cffunction>
</cfcomponent>