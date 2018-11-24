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
									<cfif isDefined("URL.EventID")>
										<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfelse>
										<cfqueryparam value="#Session.UserRegistrationInfo.DateRegistered#" cfsqltype="cf_sql_date">,
									</cfif>
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfif isDefined("URL.EventID")>
										<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfelse>
										<cfqueryparam value="#Session.UserRegistrationInfo.RegisterUserForEvent#" cfsqltype="cf_sql_integer">,
									</cfif>
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

							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToSingleParticipant(insertNewRegistration.GENERATED_KEY)#>
						<cfset temp = #StructDelete(Session, "UserRegistrationInfo")#>
						<cflocation url="/index.cfm?RegistrationSuccessfull=True&SingleRegistration=True" addtoken="false">
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
					<cfset RegistrationID = #CreateUUID()#>
					<cftry>
						<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, WebinarParticipant)
							Values(
								<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
								<cfqueryparam value="#Form.additionalparticipants#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
								<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
								<cfif isDefined("FORM.WebinarParticipant")>
									<cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">
								<cfelse>
									<cfqueryparam value="0" cfsqltype="cf_sql_bit">
								</cfif>

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
				<cfelseif ListLen(FORM.additionalParticipants) GTE 2>
					<cfloop list="#FORM.additionalParticipants#" index="i" delimiters=",">
						<cfset RegistrationID = #CreateUUID()#>
						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, WebinarParticipant)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
									<cfif isDefined("FORM.WebinarParticipant")>
										<cfqueryparam value="#FORM.WebinarParticipant#" cfsqltype="cf_sql_bit">
									<cfelse>
										<cfqueryparam value="0" cfsqltype="cf_sql_bit">
									</cfif>
									)
							</cfquery>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					</cfloop>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_1_FirstName) and LEN(FORM.AdditionalParticipant_1_LastName) and LEN(AdditionalParticipant_1_EMail)>
					<cfquery name="CheckUserAlreadyHasAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID
						From tusers
						Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
							FName = <cfqueryparam value="#FORM.AdditionalParticipant_1_FirstName#" cfsqltype="cf_sql_varchar"> and
							Lname = <cfqueryparam value="#FORM.AdditionalParticipant_1_LastName#" cfsqltype="cf_sql_varchar"> and
							UserName = <cfqueryparam value="#FORM.AdditionalParticipant_1_EMail#" cfsqltype="cf_sql_varchar">
					</cfquery>

					<cfif CheckUserAlreadyHasAccount.RecordCount>
						<cfset RegistrationID = #CreateUUID()#>
						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>
							<cfif isDefined("FORM.AdditionalParticipant_1_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_1_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_1_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_1_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_1_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_1_IPVideo)>
									<cfif FORM.AdditionalParticipant_1_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_1_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					<cfelse>
						<cfset RegistrationID = #CreateUUID()#>
						<cfset NewUserErrors = ArrayNew()>
						<cfset NewUser = Application.userManager.read('')>
						<cfset NewUser.setSiteID("#FORM.SiteID#")>
						<cfset NewUser.setFname("#FORM.AdditionalParticipant_1_FirstName#")>
						<cfset NewUser.setLname("#FORM.AdditionalParticipant_1_LastName#")>
						<cfset NewUser.setEmail("#FORM.AdditionalParticipant_1_Email#")>
						<cfset NewUser.setUsername("#FORM.AdditionalParticipant_1_Email#")>
						<cfset NewUser.setPassword("NewUserTempPassword")>
						<cfset NewUser = Application.UserManager.save(NewUser)>

						<cfif !StructIsEmpty(NewUser.getErrors())>
							<!--- Display Error Message regarding regarding inserting new user --->
						</cfif>

						<cfquery name="GetUserAccountInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select UserID
							From tusers
							Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
								FName = <cfqueryparam value="#FORM.AdditionalParticipant_1_FirstName#" cfsqltype="cf_sql_varchar"> and
								Lname = <cfqueryparam value="#FORM.AdditionalParticipant_1_LastName#" cfsqltype="cf_sql_varchar"> and
								UserName = <cfqueryparam value="#FORM.AdditionalParticipant_1_EMail#" cfsqltype="cf_sql_varchar">
						</cfquery>

						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#GetUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>

							<cfif isDefined("FORM.AdditionalParticipant_1_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_1_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_1_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_1_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_1_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_1_IPVideo)>
									<cfif FORM.AdditionalParticipant_1_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_1_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					</cfif>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_2_FirstName) and LEN(FORM.AdditionalParticipant_2_LastName) and LEN(AdditionalParticipant_2_EMail)>
					<cfquery name="CheckUserAlreadyHasAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID
						From tusers
						Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
							FName = <cfqueryparam value="#FORM.AdditionalParticipant_2_FirstName#" cfsqltype="cf_sql_varchar"> and
							Lname = <cfqueryparam value="#FORM.AdditionalParticipant_2_LastName#" cfsqltype="cf_sql_varchar"> and
							UserName = <cfqueryparam value="#FORM.AdditionalParticipant_2_EMail#" cfsqltype="cf_sql_varchar">
					</cfquery>

					<cfif CheckUserAlreadyHasAccount.RecordCount>
						<cfset RegistrationID = #CreateUUID()#>
						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>
							<cfif isDefined("FORM.AdditionalParticipant_2_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_2_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_2_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_2_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_2_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_2_IPVideo)>
									<cfif FORM.AdditionalParticipant_2_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_2_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					<cfelse>
						<cfset RegistrationID = #CreateUUID()#>
						<cfset NewUserErrors = ArrayNew()>
						<cfset NewUser = Application.userManager.read('')>
						<cfset NewUser.setSiteID("#FORM.SiteID#")>
						<cfset NewUser.setFname("#FORM.AdditionalParticipant_2_FirstName#")>
						<cfset NewUser.setLname("#FORM.AdditionalParticipant_2_LastName#")>
						<cfset NewUser.setEmail("#FORM.AdditionalParticipant_2_Email#")>
						<cfset NewUser.setUsername("#FORM.AdditionalParticipant_2_Email#")>
						<cfset NewUser.setPassword("NewUserTempPassword")>
						<cfset NewUser = Application.UserManager.save(NewUser)>

						<cfif !StructIsEmpty(NewUser.getErrors())>
							<!--- Display Error Message regarding regarding inserting new user --->
						</cfif>

						<cfquery name="GetUserAccountInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select UserID
							From tusers
							Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
								FName = <cfqueryparam value="#FORM.AdditionalParticipant_2_FirstName#" cfsqltype="cf_sql_varchar"> and
								Lname = <cfqueryparam value="#FORM.AdditionalParticipant_2_LastName#" cfsqltype="cf_sql_varchar"> and
								UserName = <cfqueryparam value="#FORM.AdditionalParticipant_2_EMail#" cfsqltype="cf_sql_varchar">
						</cfquery>

						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#GetUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>

							<cfif isDefined("FORM.AdditionalParticipant_2_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_2_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_2_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_2_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_2_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_2_IPVideo)>
									<cfif FORM.AdditionalParticipant_2_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_2_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					</cfif>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_3_FirstName) and LEN(FORM.AdditionalParticipant_3_LastName) and LEN(AdditionalParticipant_3_EMail)>
					<cfquery name="CheckUserAlreadyHasAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID
						From tusers
						Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
							FName = <cfqueryparam value="#FORM.AdditionalParticipant_3_FirstName#" cfsqltype="cf_sql_varchar"> and
							Lname = <cfqueryparam value="#FORM.AdditionalParticipant_3_LastName#" cfsqltype="cf_sql_varchar"> and
							UserName = <cfqueryparam value="#FORM.AdditionalParticipant_3_EMail#" cfsqltype="cf_sql_varchar">
					</cfquery>

					<cfif CheckUserAlreadyHasAccount.RecordCount>
						<cfset RegistrationID = #CreateUUID()#>
						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>
							<cfif isDefined("FORM.AdditionalParticipant_3_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_3_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_3_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_3_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_3_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_3_IPVideo)>
									<cfif FORM.AdditionalParticipant_3_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_3_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					<cfelse>
						<cfset RegistrationID = #CreateUUID()#>
						<cfset NewUserErrors = ArrayNew()>
						<cfset NewUser = Application.userManager.read('')>
						<cfset NewUser.setSiteID("#FORM.SiteID#")>
						<cfset NewUser.setFname("#FORM.AdditionalParticipant_3_FirstName#")>
						<cfset NewUser.setLname("#FORM.AdditionalParticipant_3_LastName#")>
						<cfset NewUser.setEmail("#FORM.AdditionalParticipant_3_Email#")>
						<cfset NewUser.setUsername("#FORM.AdditionalParticipant_3_Email#")>
						<cfset NewUser.setPassword("NewUserTempPassword")>
						<cfset NewUser = Application.UserManager.save(NewUser)>

						<cfif !StructIsEmpty(NewUser.getErrors())>
							<!--- Display Error Message regarding regarding inserting new user --->
						</cfif>

						<cfquery name="GetUserAccountInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select UserID
							From tusers
							Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
								FName = <cfqueryparam value="#FORM.AdditionalParticipant_3_FirstName#" cfsqltype="cf_sql_varchar"> and
								Lname = <cfqueryparam value="#FORM.AdditionalParticipant_3_LastName#" cfsqltype="cf_sql_varchar"> and
								UserName = <cfqueryparam value="#FORM.AdditionalParticipant_3_EMail#" cfsqltype="cf_sql_varchar">
						</cfquery>

						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#GetUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>

							<cfif isDefined("FORM.AdditionalParticipant_3_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_3_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_3_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_3_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_3_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_3_IPVideo)>
									<cfif FORM.AdditionalParticipant_3_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_3_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					</cfif>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_4_FirstName) and LEN(FORM.AdditionalParticipant_4_LastName) and LEN(AdditionalParticipant_4_EMail)>
					<cfquery name="CheckUserAlreadyHasAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID
						From tusers
						Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
							FName = <cfqueryparam value="#FORM.AdditionalParticipant_4_FirstName#" cfsqltype="cf_sql_varchar"> and
							Lname = <cfqueryparam value="#FORM.AdditionalParticipant_4_LastName#" cfsqltype="cf_sql_varchar"> and
							UserName = <cfqueryparam value="#FORM.AdditionalParticipant_4_EMail#" cfsqltype="cf_sql_varchar">
					</cfquery>

					<cfif CheckUserAlreadyHasAccount.RecordCount>
						<cfset RegistrationID = #CreateUUID()#>
						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>
							<cfif isDefined("FORM.AdditionalParticipant_4_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_4_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_4_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_4_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_4_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_4_IPVideo)>
									<cfif FORM.AdditionalParticipant_4_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_4_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					<cfelse>
						<cfset RegistrationID = #CreateUUID()#>
						<cfset NewUserErrors = ArrayNew()>
						<cfset NewUser = Application.userManager.read('')>
						<cfset NewUser.setSiteID("#FORM.SiteID#")>
						<cfset NewUser.setFname("#FORM.AdditionalParticipant_4_FirstName#")>
						<cfset NewUser.setLname("#FORM.AdditionalParticipant_4_LastName#")>
						<cfset NewUser.setEmail("#FORM.AdditionalParticipant_4_Email#")>
						<cfset NewUser.setUsername("#FORM.AdditionalParticipant_4_Email#")>
						<cfset NewUser.setPassword("NewUserTempPassword")>
						<cfset NewUser = Application.UserManager.save(NewUser)>

						<cfif !StructIsEmpty(NewUser.getErrors())>
							<!--- Display Error Message regarding regarding inserting new user --->
						</cfif>

						<cfquery name="GetUserAccountInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select UserID
							From tusers
							Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
								FName = <cfqueryparam value="#FORM.AdditionalParticipant_4_FirstName#" cfsqltype="cf_sql_varchar"> and
								Lname = <cfqueryparam value="#FORM.AdditionalParticipant_4_LastName#" cfsqltype="cf_sql_varchar"> and
								UserName = <cfqueryparam value="#FORM.AdditionalParticipant_4_EMail#" cfsqltype="cf_sql_varchar">
						</cfquery>

						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#GetUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>

							<cfif isDefined("FORM.AdditionalParticipant_4_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_4_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_4_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_4_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_4_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_4_IPVideo)>
									<cfif FORM.AdditionalParticipant_4_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_4_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					</cfif>
				</cfif>

				<cfif LEN(FORM.AdditionalParticipant_5_FirstName) and LEN(FORM.AdditionalParticipant_5_LastName) and LEN(AdditionalParticipant_5_EMail)>
					<cfquery name="CheckUserAlreadyHasAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID
						From tusers
						Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
							FName = <cfqueryparam value="#FORM.AdditionalParticipant_5_FirstName#" cfsqltype="cf_sql_varchar"> and
							Lname = <cfqueryparam value="#FORM.AdditionalParticipant_5_LastName#" cfsqltype="cf_sql_varchar"> and
							UserName = <cfqueryparam value="#FORM.AdditionalParticipant_5_EMail#" cfsqltype="cf_sql_varchar">
					</cfquery>

					<cfif CheckUserAlreadyHasAccount.RecordCount>
						<cfset RegistrationID = #CreateUUID()#>
						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#CheckUserAlreadyHasAccount.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>
							<cfif isDefined("FORM.AdditionalParticipant_5_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_5_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_5_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_5_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_5_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_5_IPVideo)>
									<cfif FORM.AdditionalParticipant_5_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_5_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					<cfelse>
						<cfset RegistrationID = #CreateUUID()#>
						<cfset NewUserErrors = ArrayNew()>
						<cfset NewUser = Application.userManager.read('')>
						<cfset NewUser.setSiteID("#FORM.SiteID#")>
						<cfset NewUser.setFname("#FORM.AdditionalParticipant_5_FirstName#")>
						<cfset NewUser.setLname("#FORM.AdditionalParticipant_5_LastName#")>
						<cfset NewUser.setEmail("#FORM.AdditionalParticipant_5_Email#")>
						<cfset NewUser.setUsername("#FORM.AdditionalParticipant_5_Email#")>
						<cfset NewUser.setPassword("NewUserTempPassword")>
						<cfset NewUser = Application.UserManager.save(NewUser)>

						<cfif !StructIsEmpty(NewUser.getErrors())>
							<!--- Display Error Message regarding regarding inserting new user --->
						</cfif>

						<cfquery name="GetUserAccountInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select UserID
							From tusers
							Where SiteID = <cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar"> and
								FName = <cfqueryparam value="#FORM.AdditionalParticipant_5_FirstName#" cfsqltype="cf_sql_varchar"> and
								Lname = <cfqueryparam value="#FORM.AdditionalParticipant_5_LastName#" cfsqltype="cf_sql_varchar"> and
								UserName = <cfqueryparam value="#FORM.AdditionalParticipant_5_EMail#" cfsqltype="cf_sql_varchar">
						</cfquery>

						<cftry>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into eRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, EventID, AttendeePrice, RegistrationIPAddr, RegisterByUserID)
								Values(
									<cfqueryparam value="#FORM.SiteID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
									<cfqueryparam value="#GetUserAccountInfo.UserID#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
									<cfqueryparam value="#Session.UserRegistrationInfo.UserEventPrice#" cfsqltype="cf_sql_double">,
									<cfqueryparam value="#CGI.Remote_ADDR#" cfsqltype="cf_sql_varchar">,
									<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
							</cfquery>

							<cfif isDefined("FORM.AdditionalParticipant_5_Stay4Meal")>
								<cfif Len(FORM.AdditionalParticipant_5_Stay4Meal)>
									<cfif FORM.AdditionalParticipant_5_Stay4Meal EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set RequestsMeal = <cfqueryparam value="#FORM.AdditionalParticipant_5_Stay4Meal#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfif isDefined("FORM.AdditionalParticipant_5_IPVideo")>
								<cfif LEN(FORM.AdditionalParticipant_5_IPVideo)>
									<cfif FORM.AdditionalParticipant_5_IPVideo EQ 1>
										<cfquery name="updateNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Update eRegistrations
											Set IVCParticipant = <cfqueryparam value="#FORM.AdditionalParticipant_5_IPVideo#" cfsqltype="cf_sql_bit">
											Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfif>
							<cfcatch type="Database">
								<cfdump var="#CFCATCH#"><cfabort>
							</cfcatch>
						</cftry>
						<cfset Temp = #SendEmailCFC.SendEventRegistrationToParticipantFromAnother(insertNewRegistration.GENERATED_KEY)#>
					</cfif>
				</cfif>
				<cflock scope="Session" type="Exclusive" timeout="60">
					<cfset StructDelete(Session, "UserRegistrationInfo")>
				</cflock>
				<cflocation url="plugins/EventRegistration/index.cfm?EventRegistrationaction=public:events.viewavailableevents&RegistrationSuccessfull=True&MultipleRegistration=True" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>