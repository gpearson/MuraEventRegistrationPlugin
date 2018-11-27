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
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.getSelectedEvent = #StructCopy(getSelectedEvent)#>
			</cflock>
			<cflocation addtoken="false" url="#CGI.Script_name##CGI.path_info#?display=login">
		<cfelseif isDefined("URL.EventID") and isNumeric(URL.EventID) and Session.Mura.IsLoggedIn EQ "true" and not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
						EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				</cfquery>
				<cfset Session.getSelectedEvent = #StructCopy(getSelectedEvent)#>
				<cfquery name="checkRegisteredForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, RegistrationID, RegistrationDate
					From p_EventRegistration_UserRegistrations
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 0>
					<cfquery name="getEventCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber
						From p_EventRegistration_Caterers
						Where TContent_ID = <cfqueryparam value="#getSelectedEvent.MealProvidedBy#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset Session.getEventCaterer = #StructCopy(getEventCatererInfo)#>
				</cfif>
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

				<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1>
					<cfif DateDiff("d", Now(), Session.getSelectedEvent.EarlyBird_Deadline) GTE 0>
						<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = True>
					<cfelse>
						<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
				</cfif>

				<cfif Session.getSelectedEvent.Webinar_Available EQ 1>
					<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = True>
					<cfif Session.getActiveMembership.RecordCount GTE 1>
						<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #Session.getSelectedEvent.Webinar_MemberCost#>
					<cfelse>
						<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #Session.getSelectedEvent.Webinar_NonMemberCost#>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = False>
				</cfif>

				<cfif Session.getSelectedEvent.GroupPrice_Available EQ 1>
					<cfset Session.UserRegistrationInfo.GroupPricingAvailable = True>
				<cfelse>
					<cfset Session.UserRegistrationInfo.GroupPricingAvailable = False>
				</cfif>

				<cfif Session.getSelectedEvent.H323_Available EQ 1>
					<cfset Session.UserRegistrationInfo.VideoConferenceOption = True>
					<cfset Session.UserRegistrationInfo.VideoConferenceInfo = #Session.getSelectedEvent.H323_ConnectInfo#>
					<cfif Session.getActiveMembership.RecordCount GTE 1>
						<cfset Session.UserRegistrationInfo.VideoConferenceCost = #Session.getSelectedEvent.H323_MemberCost#>
					<cfelse>
						<cfset Session.UserRegistrationInfo.VideoConferenceCost = #Session.getSelectedEvent.H323_NonMemberCost#>
					</cfif>
				<cfelse>
					<cfset Session.UserRegistrationInfo.VideoConferenceOption = False>
				</cfif>

				<cfif Session.getActiveMembership.Active EQ 1>
					<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = True>
					<cfset Session.UserRegistrationInfo.UserEventPrice = #Session.getSelectedEvent.Event_MemberCost#>
					<cfset Session.UserRegistrationInfo.GroupEventPrice = #Session.getSelectedEvent.GroupPrice_MemberCost#>
					<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
				<cfelse>
					<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = False>
					<cfset Session.UserRegistrationInfo.UserEventPrice = #Session.getSelectedEvent.Event_NonMemberCost#>
					<cfset Session.UserRegistrationInfo.GroupEventPrice = #Session.getSelectedEvent.GroupPrice_NonMemberCost#>
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

			<cfset userBean = rc.$.getBean('user').loadBy(username='#Session.Mura.Username#', siteid='#rc.$.siteConfig('siteID')#')>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset CreateiCalCard = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

			<cfif FORM.RegisterAdditionalIndividuals EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Do you want to register additional individuals for this event? Select Yes or No below."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
			</cfif>

			<cfif Session.getSelectedEvent.Event_DailySessions EQ 1>
				<cfif FORM.AttendSession1 EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Do you want to attend Session 1 of this event? Select Yes or No below."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
				</cfif>
				<cfif FORM.AttendSession2 EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Do you want to attend Session 2 of this event? Select Yes or No below."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&FormRetry=True" addtoken="false">
				</cfif>
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
						Event_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif CheckUserAlreadyRegistered.RecordCount EQ 0>
					<cfset RegistrationID = #CreateUUID()#>
					<cfif Session.getSelectedEvent.Meal_Available EQ 0>
						<cfset FORM.StayForMeal = 0>
					<cfelseif Session.getSelectedEvent.Meal_Available EQ 1 and Session.getSelectedEvent.Meal_Included EQ 1>
						<cfset FORM.StayForMeal = 1>
					</cfif>
					<cftry>
						<cfif isDefined("FORM.RegisterDate")>
							<cfquery name="insertNewRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, RegisterForEventDate1, User_ID, Event_ID, AttendeePrice, RegistrationIPAddr, RegisteredByUserID, RequestsMeal)
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
								insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, RegisterForEventDate1, User_ID, Event_ID, AttendeePrice, RegistrationIPAddr, RegisteredByUserID, RequestsMeal)
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
						<cfif isDefined("FORM.AttendSession1")>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventSessionAM = <cfqueryparam value="#FORM.AttendSession1#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>
						<cfif isDefined("FORM.AttendSession2")>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RegisterForEventSessionPM = <cfqueryparam value="#FORM.AttendSession2#" cfsqltype="cf_sql_bit">
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
						<cfif Session.getSelectedEvent.Meal_Available EQ 1>
							<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_EventRegistration_UserRegistrations
								Set RequestsMeal = <cfqueryparam value="#FORM.StayForMeal#" cfsqltype="cf_sql_bit">
								Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>

						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, "127.0.0.1")#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>
						
						<cfset temp = StructDelete(Session, "FormErrors")>
						<cfset temp = StructDelete(Session, "FormInput")>
						<cfset temp = StructDelete(Session, "UserRegistrationInfo")>
						<cfset temp = StructDelete(Session, "getActiveMembership")>

						<cfif userBean.isInGroup("Event Facilitator")>
							<cfif LEN(cgi.path_info)>
								<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:main.default&UserAction=UserRegistered&Successfull=True&SingleRegistration=True" >
							<cfelse>
								<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:main.default&UserAction=UserRegistered&Successfull=True&SingleRegistration=True" >
							</cfif>
							<cflocation url="#variables.newurl#" addtoken="false">
						<cfelse>
							<cfif LEN(cgi.path_info)>
								<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=UserRegistered&Successfull=True&SingleRegistration=True" >
							<cfelse>
								<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=UserRegistered&Successfull=True&SingleRegistration=True" >
							</cfif>
							<cflocation url="#variables.newurl#" addtoken="false">
						</cfif>
						<cfcatch type="Database">
							<cfdump var="#CFCATCH#"><cfabort>
						</cfcatch>
					</cftry>
				<cfelse>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registerevent.default&FormRetry=True&UserAction=UserAlreadyRegistered" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registerevent.default&FormRetry=True&UserAction=UserAlreadyRegistered" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
			<cfelseif FORM.RegisterAdditionalIndividuals EQ 1>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registerevent.registeradditionalparticipants" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registerevent.registeradditionalparticipants" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
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
									Event_ID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, Event_ID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate1)
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
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							<cfelse>
								<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="2">
							<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select RegistrationID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, Event_ID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate2)
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
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							<cfelse>
								<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="3">
							<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select RegistrationID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, Event_ID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate3)
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
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							<cfelse>
								<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="4">
							<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select RegistrationID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, Event_ID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate4)
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
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							<cfelse>
								<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="5">
							<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select RegistrationID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, Event_ID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate5)
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
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							<cfelse>
								<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="6">
							<cfquery name="CheckRegisteredAlready" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select RegistrationID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif CheckRegisteredAlready.RecordCount EQ 0>
								<cfset RegistrationUUID = #CreateUUID()#>
								<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Insert into p_EventRegistration_UserRegistrations(Site_ID, RegistrationID, RegistrationDate, User_ID, Event_ID, AttendeePrice, RegistrationIPAddr, RegisterByUserID, RegisterForEventDate6)
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
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							<cfelse>
								<cfquery name="updateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif isDefined("Session.FormInput.AttendSession1")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionAM = <cfqueryparam value="#Session.FormInput.AttendSession1#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
								<cfif isDefined("Session.FormInput.AttendSession2")>
									<cfquery name="updateRegistrationRegisterDates" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventSessionPM = <cfqueryparam value="#Session.FormInput.AttendSession2#" cfsqltype="cf_sql_bit">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_varchar">
									</cfquery>
								</cfif>
							</cfif>
						</cfcase>
					</cfswitch>
					<cfquery name="GetRegistrationID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID
						From p_EventRegistration_UserRegistrations
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
							Event_ID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
						<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, GetRegistrationID.TContent_ID, "127.0.0.1")#>
					<cfelse>
						<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
							<cfif rc.$.siteConfig('mailserverssl') EQ "True">
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, GetRegistrationID.TContent_ID, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, GetRegistrationID.TContent_ID, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
							</cfif>
						<cfelse>
							<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, GetRegistrationID.TContent_ID, rc.$.siteConfig('mailserverip'))#>
						</cfif>
					</cfif>
				</cfloop>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "UserRegistrationInfo")>
				<cfset temp = StructDelete(Session, "getActiveMembership")>

				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=UserRegistered&Successfull=True&MultipleRegistration=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=UserRegistered&Successfull=True&MultipleRegistration=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>