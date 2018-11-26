/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">

	<cffunction name="oauthtest" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfset TwitterJARPath = ArrayNew(1)>
		<cfset TwitterJARPath[1] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/jars/twitter4j-core-4.0.4.jar")#>
		<cfset TwitterJARPath[2] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/jars/twitter4j-async-4.0.4.jar")#>
		<cfset TwitterJARPath[3] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/jars/twitter4j-media-support-4.0.4.jar")#>
		<cfset TwitterJARPath[4] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/jars/twitter4j-stream-4.0.4.jar")#>

		<cfset JavaLoader = createObject("component", "plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/JavaLoader").init(TwitterJARPath)>
		<cfset TwitterLibrary = JavaLoader.create("twitter4j.TwitterFactory").getInstance()>
		<cfset TwitterAccessToken = JavaLoader.create("twitter4j.auth.AccessToken")>
		<cfset TwitterLibrary.setOAuthConsumer('pEuVQfc5Lg7yRzyV3eGrdPiV0', 'Ae47ywGPPNavUUSP4RyqOUaat73JNUCxT0fK4ZdUxSFaOBnmuu')>
		<cfset TwitterOAuthAccessToken = TwitterAccessToken.init('894989565420859392-m2OzwOGAqwRJnmP5hl4cylne7IuyNnJ', 'bVQiGaaCURY1ZrSdi15WF4zpqyG51zXVYL7nvPd3kvYHG')>
		<cfset TwitterLibrary.setOAuthAccessToken(TwitterOAuthAccessToken)>
		<cfset Message = "This is my First Twitter Update from Application">
		<cfset TwitterLibrary.updateStatus(Variables.Message)>
		



		<cfdump var="#Variables.TwitterLibrary#" abort="true">
		
		<!--- 
		<cfscript>
			TwitterConfigBuilder.setOAuthConsumerKey('pEuVQfc5Lg7yRzyV3eGrdPiV0');
			TwitterConfigBuilder.setOAuthCOnsumerSecret('Ae47ywGPPNavUUSP4RyqOUaat73JNUCxT0fK4ZdUxSFaOBnmuu');
			TwitterConfigBuilder.setOAuthAccessToken('894989565420859392-m2OzwOGAqwRJnmP5hl4cylne7IuyNnJ');
			TwitterConfigBuilder.setOAuthAccessToeknSecret('bVQiGaaCURY1ZrSdi15WF4zpqyG51zXVYL7nvPd3kvYHG');
		</cfscript>
		<cfset config = TwitterConfigBuilder.build()>

		<cfset TwitterFactory = createObject("java", "twitter4j.TwitterFactory").init(config)>
		<cfset TwitterClient = TwitterFactory.getInstance();
		<cfset TwitterTweet = TwitterClient.updateStatus('Hello World')>

		<cfdump var="#Variables.TwitterTweet#" abort="true">





		<cfdump var="#variables.TwitterObj#" abort="true">
	--->

		<!--- <cfset application.Twitter = javaloader.create ("twitter4j.TwitterFactory").getInstance()>
		<cfset application.Twitter.setOAuthConsumer ('consumerkey',consumersecret')>
		<cfset local.accessToken = javaloader.create ("twitter4j.auth.AccessToken").init ("storedaccesstoken" ,"storedaccesssecret")> <cfset application.Twitter.setOAuthAccessToken (local.accessToken)>


		<cfset ConsumerKey = "pEuVQfc5Lg7yRzyV3eGrdPiV0">
		<cfset ConsumerSecret = "Ae47ywGPPNavUUSP4RyqOUaat73JNUCxT0fK4ZdUxSFaOBnmuu">
		<cfset CallBack = "http://events.niesc.k12.in.us/#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.oauthtest">



		<cfset oAuthCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/oAuth2/oauth2")>

		<cfset bitlyclient = oAuthCFC.init(client_id = 'ef61eea07d91ba54208f86480368611db4efbaef', client_secret='a4c7759b2f4d02a4b1037e83f032f685292e19e9',
			authEndpoint="https://api-ssl.bitly.com/", accessTokenEndpoint="https://bitly.com/oauth/authorize", redirect_uri="http://events.niesc.k12.in.us/#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.oauthtest")>
		<cfset AccessToken = #bitlyclient.MakeAccessTokenRequest(code='Test')#>



		<cfdump var="#Variables.AccessToken#" abort="true">
		--->

	</cffunction>

	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.Info")>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#URL.Info#" addtoken="false">
		</cfif>

		<cfif isDefined("URL.ShortURL")>
			<cfset EventServicesComponent = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

			<cfset GetFullLink = #EventServicesComponent.getFullLinkFromShortURL(rc, URL.ShortURL)#>
			<cfif Variables.GetFullLink DOES NOT CONTAIN "The ShortURL Link is not valid">
				<cflocation url="#Variables.GetFullLink#" addtoken="false">
			</cfif>
		</cfif>

		<cflock scope="Session" timeout="60" type="Exclusive">
			<cfset Session.getNonFeaturedEvents = StructNew()>
			<cfset Session.getFeaturedEvents = StructNew()>
		</cflock>


		<!--- Checking to make sure that today's date is within the Featured Events Date Window, Otherwise Update Event to not be featured. --->
		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="updateExpiredFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
					Where DateDiff(Featured_StartDate, Now()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						DateDiff(Featured_EndDate, Now()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				</cfquery>
				<cfquery name="getNonFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, TContent_ID, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, AcceptRegistrations, Registration_Deadline, MaxParticipants, PGPAvailable, AllowVideoConference, WebinarAvailable, Presenters, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						DateDiff(EventDate, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate1, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate2, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate3, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate4, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate5, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Order By EventDate
				</cfquery>
				<cfquery name="getFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, TContent_ID, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, AcceptRegistrations, Registration_Deadline, MaxParticipants, PGPAvailable, AllowVideoConference, WebinarAvailable, Presenters, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						DateDiff(EventDate, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate1, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate2, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate3, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate4, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff(EventDate5, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Order By Featured_SortOrder ASC, EventDate ASC
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="updateExpiredFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
					Where DateDiff("d",Featured_StartDate, GETUTCDATE()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						DateDiff("d",Featured_EndDate, GETUTCDATE()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				</cfquery>
				<cfquery name="getNonFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, TContent_ID, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, AcceptRegistrations, Registration_Deadline, MaxParticipants, PGPAvailable, AllowVideoConference, WebinarAvailable, Presenters, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						DateDiff("d",EventDate, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate1, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate2, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate3, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate4, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate5, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Order By EventDate
				</cfquery>
				<cfquery name="getFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, TContent_ID, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, AcceptRegistrations, Registration_Deadline, MaxParticipants, PGPAvailable, AllowVideoConference, WebinarAvailable, Presenters, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime
					From p_EventRegistration_Events
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						DateDiff("d",EventDate, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
						EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate1, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate2, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate3, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate4, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
							Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							DateDiff("d",EventDate5, GETUTCDATE()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
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
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and EventID = <cfqueryparam value="#Variables.getFeaturedEventRecordID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset getFeaturedEvent = StructCopy(getFeaturedEvents)>
					<cfif getFeaturedEvent.RecordCount>

					</cfif>
					<cfset FeatureEventShortTitle = #getFeaturedEvents.ShortTitle#>
					<cfset FeatureEventEventDate = #getFeaturedEvents.EventDate#>
					<cfset FeatureEventRecordID = #getFeaturedEvents.TContent_ID#>
					<cfset FeatureEventFeatured = #getFeaturedEvents.EventFeatured#>
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
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventFeatured", getFeaturedEvents.EventFeatured)#>
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
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupMemberCost, GroupNonMemberCost, GroupPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Presenters, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime
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
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, GeoCode_Latitude, GeoCode_Longitude, Physical_TimeZone, Physical_UTCOffset, Physical_DST
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

			<cfquery name="getPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FName, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getSelectedEvent.Presenters#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset Session.EventInfo = StructNew()>

			<cfif Session.Mura.isLoggedIn EQ true>
				<cfquery name="checkRegisteredForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, RegistrationID, RegistrationDate
					From p_EventRegistration_UserRegistrations
					Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
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