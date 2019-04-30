<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfquery name="SiteConfigSettings" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, Twitter_Enabled, Twitter_ConsumerKey, Twitter_ConsumerSecret, Twitter_AccessToken, Twitter_AccessTokenSecret, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
			From p_EventRegistration_SiteConfig
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>

		<cfif isDefined("URL.ShortURL")>
			<cfquery name="GetFullLinkFromShortURL" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FullLink
				From p_EventRegistration_ShortURL
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and
					ShortLink = <cfqueryparam value="#URL.ShortURL#" cfsqltype="cf_sql_varchar"> and
					Active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			</cfquery>

			<cfif GetFullLinkFromShortURL.RecordCount>
				<cfquery name="UpdateShortURLAccess" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_ShortURL
					Set Active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam value="System" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="System" cfsqltype="cf_sql_varchar">
					Where ShortLink = <cfqueryparam value="#URL.ShortURL#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cflocation url="#GetFullLinkFromShortURL.FullLink#" addtoken="false">
			<cfelse>
				<cfscript>
					errormsg = {property="EmailMsg",message="The ShortLink is either invalid or is not active because someone else has clicked on the link to change the status of the Short Link. Please check your email and if you have issues please utilize the Contact Us section of the website."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=ShortLinkInvalid" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=ShortLinkInvalid" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfif>

		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateExpiredFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
					Where DateDiff(Featured_StartDate, Now()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						DateDiff(Featured_EndDate, Now()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				</cfquery>
				<cfquery name="getNonFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, WhatIf_MealCostPerAttendee, WhatIf_FacilityCostTotal, WhatIf_PresenterCostTotal
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						DateDiff(EventDate, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate1, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate2, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate3, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate4, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate5, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Order By EventDate
				</cfquery>
				<cfquery name="getFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, WhatIf_MealCostPerAttendee, WhatIf_FacilityCostTotal, WhatIf_PresenterCostTotal
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						DateDiff(EventDate, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate1, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate2, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate3, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate4, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate5, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Order By Featured_SortOrder ASC, EventDate ASC
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateExpiredFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
					Where DateDiff("d",Featured_StartDate, GETUTCDATE()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						DateDiff("d",Featured_EndDate, GETUTCDATE()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				</cfquery>
				<cfquery name="getNonFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, WhatIf_MealCostPerAttendee, WhatIf_FacilityCostTotal, WhatIf_PresenterCostTotal
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						DateDiff("d",EventDate, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate1, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate2, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate3, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate4, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate5, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Order By EventDate
				</cfquery>
				<cfquery name="getFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, WhatIf_MealCostPerAttendee, WhatIf_FacilityCostTotal, WhatIf_PresenterCostTotal
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						DateDiff("d",EventDate, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate1, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate2, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate3, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate4, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate5, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Order By Featured_SortOrder ASC, EventDate ASC
				</cfquery>
			</cfcase>
		</cfswitch>

		<cfif getFeaturedEvents.RecordCount>
			<cfset getFeaturedEventRecordID = #RandRange(1, getFeaturedEvents.RecordCount)#>
			<cfloop query="getFeaturedEvents">
				<cfif getFeaturedEvents.currentRow EQ getFeaturedEventRecordID>
					<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select Count(TContent_ID) as CurrentNumberofRegistrations
						From p_EventRegistration_UserRegistrations
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#Variables.getFeaturedEventRecordID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset getFeaturedEvent = StructCopy(getFeaturedEvents)>
					<cfif getFeaturedEvent.RecordCount>

					</cfif>
					<cfset FeatureEventShortTitle = #getFeaturedEvents.ShortTitle#>
					<cfset FeatureEventEventDate = #getFeaturedEvents.EventDate#>
					<cfset FeatureEventRecordID = #getFeaturedEvents.TContent_ID#>
					<cfset FeatureFeatured_Event = #getFeaturedEvents.Featured_Event#>
					<cfset FeatureEventDisplayStartDate = #getFeaturedEvents.Featured_StartDate#>
					<cfset FeatureEventDisplayEndDate = #getFeaturedEvents.Featured_EndDate#>
					<cfset FeatureEventFeatureSortOrder = #getFeaturedEvents.Featured_SortOrder#>
					<cfset FeatureEventAcceptRegistrations = #getFeaturedEvents.AcceptRegistrations#>
					<cfset FeatureEventRegistrationDeadline = #getFeaturedEvents.Registration_Deadline#>
					<cfset FeatureEventMaxParticipants = #getFeaturedEvents.MaxParticipants#>
					<cfset FeatureEventPGPAvailable = #getFeaturedEvents.PGPAvailable#>
					<cfset FeatureEventAllowVideoConf = #getFeaturedEvents.AllowVideoConference#>
					<cfset FeatureEventWebinarAvailable = #getFeaturedEvents.WebinarAvailable#>
					<cfset FeatureEventPresenter = #getFeaturedEvents.Presenters#>
					<cfset FeaturedEventSeatsLeft = #Variables.FeatureEventMaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
				<cfelse>
					<cfset temp = #QueryAddRow(getNonFeaturedEvents, 1)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "ShortTitle", getFeaturedEvents.ShortTitle)#>
					<cfif DateDiff("d", Now(), getFeaturedEvents.EventDate) LT 0 and Len(getFeaturedEvents.EventDate) eq 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate) LT 0 and DateDiff("d", Now(), getFeaturedEvents.EventDate1) GT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate1)#>
					<!--- 
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate1) LT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate2)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate2) LT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate3)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate3) LT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate4)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate4) LT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate5)#>
						--->
					</cfif>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "TContent_ID", getFeaturedEvents.TContent_ID)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_Event", getFeaturedEvents.Featured_Event)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_StartDate", getFeaturedEvents.Featured_StartDate)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_EndDate", getFeaturedEvents.Featured_EndDate)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_SortOrder", getFeaturedEvents.Featured_SortOrder)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "AcceptRegistrations", getFeaturedEvents.AcceptRegistrations)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Registration_Deadline", getFeaturedEvents.Registration_Deadline)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "MaxParticipants", getFeaturedEvents.MaxParticipants)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "PGPAvailable", getFeaturedEvents.PGPAvailable)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "AllowVideoConference", getFeaturedEvents.AllowVideoConference)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "WebinarAvailable", getFeaturedEvents.WebinarAvailable)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Presenters", getFeaturedEvents.Presenters)#>
				</cfif>
			</cfloop>
		</cfif>
		<cfset Session.getNonFeaturedEvents = StructCopy(getNonFeaturedEvents)>
		<cfset Session.getFeaturedEvents = StructCopy(getFeaturedEvents)>

	</cffunction>

	<cffunction name="eventinfo" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID")>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, WhatIf_MealCostPerAttendee, WhatIf_FacilityCostTotal, WhatIf_PresenterCostTotal
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
					Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone, MailingAddress, MailingCity, MailingState, MailingZipCode, MailingZip4, Mailing_isAddressVerified, Mailing_USPSDeliveryPoint, Mailing_USPSCheckDigit, Mailing_USPSCarrierRoute, PrimaryVoiceNumber, PrimaryFaxNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, AdditionalNotes, Cost_HaveEventAt, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
				From p_EventRegistration_Facility
				Where TContent_ID = <cfqueryparam value="#getSelectedEvent.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select RoomName, Capacity
				From p_EventRegistration_FacilityRooms
				Where TContent_ID = <cfqueryparam value="#getSelectedEvent.Event_FacilityRoomID#" cfsqltype="cf_sql_integer"> and
					Facility_ID = <cfqueryparam value="#getSelectedEvent.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FName, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getSelectedEvent.FacilitatorID#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="getPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FName, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset Session.EventInfo = StructNew()>

			<cfif Session.Mura.isLoggedIn EQ true>
				<cfquery name="checkRegisteredForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, RegistrationID, RegistrationDate
					From p_EventRegistration_UserRegistrations
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif checkRegisteredForEvent.RecordCount>
					<cfset Session.EventInfo.ParticipantRegistered = true>
				<cfelse>
					<cfset Session.EventInfo.ParticipantRegistered = false>
				</cfif>
			<cfelse>
				<cfset Session.EventInfo.ParticipantRegistered = false>
			</cfif>

			<cfset Session.EventInfo.SelectedEvent = #StructCopy(getSelectedEvent)#>
			<cfset Session.EventInfo.EventRegistrations = #StructCopy(getCurrentRegistrationsbyEvent)#>
			<cfset Session.EventInfo.EventFacility = #StructCopy(getEventFacility)#>
			<cfset Session.EventInfo.EventFacilityRoom = #StructCopy(getEventFacilityRoom)#>
			<cfset Session.EventInfo.EventFacilitator = #StructCopy(getFacilitator)#>
			<cfset Session.EventInfo.EventPresenter = #StructCopy(getPresenter)#>
		<cfelse>

		</cfif>
	</cffunction>

</cfcomponent>