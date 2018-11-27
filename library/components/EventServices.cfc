<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="generateShortLink" returntype="string">
		<cfargument name="length" type="Numeric" required="true" default="6">
		<cfset var local=StructNew()>

		<!--- create a list of all allowable characters for our short URL link --->
		<cfset local.chars="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,-">
		<!--- our radix is the total number of possible characters --->
		<cfset local.radix=listlen(local.chars)>
		<!--- initialise our return variable --->
		<cfset local.shortlink="">

		<!--- loop from 1 until the number of characters our URL should be, adding a random character from our master list on each iteration  --->
		<cfloop from="1" to="#arguments.length#" index="i">
			<!--- generate a random number in the range of 1 to the total number of possible characters we have defined --->
			<cfset local.randnum=RandRange(1,local.radix)>
			<!--- add the character from a random position in our list to our short link --->
			<cfset local.shortlink=local.shortlink & listGetAt(local.chars,local.randnum)>
		</cfloop>

		<!--- return the generated random short link --->
		<cfreturn local.shortlink>
	</cffunction>

	<cffunction name="ConvertCurrencyToDecimal" returntype="string" output="false" hint="I convert currency values to decimal for database">
		<cfargument name="Amount" type="string" required="true" hint="I am the currency amount to convert.">

		<cfset temp = #Replace(Arguments.Amount, '$', '', 'all')#>
		<cfset temp = #Replace(variables.temp, ',', '', 'all')#>
		<cfif isNumeric(variables.temp)>
			<cfset newnumber = #NumberFormat(Variables.temp, '-999999.99')#>
		<cfelse>
			<cfset newnumber = #variables.temp#>
		</cfif>
		<cfreturn variables.newnumber>
	</cffunction>

	<cffunction name="insertShortURLContent" returntype="any">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="link" type="String" required="true">
		<cfset var result=StructNew()>


		<!--- begin our error-catching block --->
		<cftry>
			<!--- try to insert the new link into the database --->
			<cfif IsDefined("rc.$")>
				<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result.qry" result="result.stats">
					INSERT INTO p_EventRegistration_ShortURL(Site_ID, FullLink, ShortLink, Active, dateCreated, lastUpdated)
					VALUES(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.link#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#generateShortLink()#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					)
				</cfquery>
				<!--- try to return the new shortlink value, referencing the last returned identifier --->
				<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result.inserted">
					SELECT ShortLink
					FROM p_EventRegistration_ShortURL
					WHERE TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result.stats.GENERATED_KEY#">
				</cfquery>
			<cfelse>
				<cfquery Datasource="#rc.DBInfo.Datasource#" username="#rc.DBInfo.DBUsername#" password="#rc.DBInfo.DBPassword#" name="result.qry" result="result.stats">
					INSERT INTO p_EventRegistration_ShortURL(Site_ID, FullLink, ShortLink, Active, dateCreated, lastUpdated)
					VALUES(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.DBInfo.SiteID#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.link#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#generateShortLink()#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					)
				</cfquery>
				<!--- try to return the new shortlink value, referencing the last returned identifier --->
				<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result.inserted">
					SELECT ShortLink
					FROM p_EventRegistration_ShortURL
					WHERE TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result.stats.GENERATED_KEY#">
				</cfquery>
			</cfif>

			<cfcatch>
				<!--- insert was not successful - the shortlink generated was not unqiue, so set the return variable to an empty string --->
				<cfset result.inserted.cfdump = #CFCATCH#>
				<cfset result.inserted.shortlink="">
				<cfreturn result.inserted>
			</cfcatch> 
		</cftry>		

		<!--- return either the newly created shortlink, or an empty string if an error occurred --->
		<cfreturn result.inserted.ShortLink> 
	</cffunction>
	
	<cffunction name="getFullLinkFromShortURL" returntype="string">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="shortlink" type="string" required="true">
		<cfset var result="">
		<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result">
			SELECT TContent_ID, FullLink
			FROM p_EventRegistration_ShortURL
			WHERE ShortLink = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.shortlink#"> and Active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		</cfquery>

		<cfif Result.RecordCount>
			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_EventRegistration_ShortURL
				Set Active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					LastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result.TContent_ID#">
			</cfquery>
			<cfreturn result.FullLink>
		<cfelse>
			<cfreturn "The ShortURL Link is not valid">
		</cfif>
	</cffunction>

	<cffunction name="QRCodeImage" ReturnType="String" output="False">
		<cfargument name="Data" type="string" Required="True">
		<cfargument name="PluginDirectory" type="string" Required="True">
		<cfargument name="QRCodeImageFilename" type="string" Required="True">

		<cfset qr = createObject("component","plugins/#Arguments.PluginDirectory#/library/components/QRCode")>
		<cfset CurLoc = #ExpandPath("/")#>
		<cfset FileStoreLoc = #Variables.CurLoc# & "plugins/" & #Arguments.PluginDirectory# & "/library/images/QRCodes">
		<cfset ImageFilename = #Arguments.QRCodeImageFilename# & ".png">
		<cfset FileWritePathWithName = #Variables.FileStoreLoc# & "/" & #Variables.ImageFilename#>
		<cfset URLFileLocation = "/plugins/" & #Arguments.PluginDirectory# & "/library/images/QRCodes/" & #Variables.ImageFilename#>
		<cffile action="write" file="#Variables.FileWritePathWithName#" output="#qr.getQRCode("#Arguments.Data#",100,100,"png")#">
		<cfreturn #Variables.URLFileLocation#>
	</cffunction>

	<cffunction name="iCalUS" returntype="String" output="false" hint="Create iCal Event for Registered Users">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="RegistrationRecordID" required="true" type="numeric">

		<cfquery name="getRegistrationInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			SELECT
				tusers.Fname, tusers.Lname, tusers.Email, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegistrationID,p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.AttendeePrice, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.WebinarParticipant, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.RegistrationIPAddr, p_EventRegistration_UserRegistrations.RegisteredByUserID, p_EventRegistration_UserRegistrations.dateCreated, p_EventRegistration_UserRegistrations.lastUpdated, p_EventRegistration_UserRegistrations.lastUpdateBy, p_EventRegistration_UserRegistrations.lastUpdateByID, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_Events.EventDate6, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.PresenterID, p_EventRegistration_Events.FacilitatorID, p_EventRegistration_Facility.FacilityName, p_EventRegistration_Facility.PhysicalAddress, p_EventRegistration_Facility.PhysicalCity, p_EventRegistration_Facility.PhysicalState, p_EventRegistration_Facility.PhysicalZipCode, p_EventRegistration_Facility.PhysicalZip4, p_EventRegistration_Facility.Physical_isAddressVerified, p_EventRegistration_Facility.Physical_Latitude, p_EventRegistration_Facility.Physical_Longitude, p_EventRegistration_FacilityRooms.RoomName, p_EventRegistration_Events.Event_MemberCost, p_EventRegistration_Events.Event_MaxParticipants, p_EventRegistration_Events.EventAgenda, p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_Events.PGPCertificate_Available, p_EventRegistration_Events.PGPCertificate_Points, p_EventRegistration_Events.Webinar_Available, p_EventRegistration_Events.Event_DailySessions, p_EventRegistration_Events.H323_Available, p_EventRegistration_Events.BillForNoShow
			FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID INNER JOIN p_EventRegistration_Facility ON p_EventRegistration_Facility.TContent_ID = p_EventRegistration_Events.Event_HeldAtFacilityID INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.TContent_ID = p_EventRegistration_Events.Event_FacilityRoomID
			WHERE p_EventRegistration_UserRegistrations.TContent_ID = <cfqueryparam value="#Arguments.RegistrationRecordID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfif getRegistrationInfo.User_ID NEQ getRegistrationInfo.RegisteredByUserID>
			<cfquery name="getRegisteredByUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getRegistrationInfo.RegisteredByUserID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset RegisteredBy = #getRegisteredByUserInfo.Lname# & ", " & #getRegisteredByUserInfo.Fname# & " (" & #getRegisteredByUserInfo.Email# & ")">
		<cfelse>
			<cfset RegisteredBy = "self">
		</cfif>

		<cfif LEN(getRegistrationInfo.PresenterID)>
			<cfquery name="getEventPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getRegistrationInfo.PresenterID#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>

		<cfquery name="getEventFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getRegistrationInfo.FacilitatorID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset CRLF = #chr(13)# & #chr(10)#>
		<cfset CurrentDateTime = #Now()#>
		<cfset stEvent = StructNew()>
		<cfset stEvent.FacilitatorName = #getEventFacilitator.Fname# & " " & #getEventFacilitator.Lname#>
		<cfset stEvent.FacilitatorEmail = #getEventFacilitator.Email#>
		<cfset stEvent.EventLocation = #getRegistrationInfo.FacilityName# & " (" & #getRegistrationInfo.PhysicalAddress# & " " & #getRegistrationInfo.PhysicalCity# & ", " & #getRegistrationInfo.PhysicalState# & " " & #getRegistrationInfo.PhysicalZipCode# & ")">
		<cfset stEvent.EventDescription = #getRegistrationInfo.LongDescription# & "\n\n" & "Special Instructions:\n" & #getRegistrationInfo.EventSpecialInstructions#>
		<cfset stEvent.Priority = 1>

		<cfset vCal = "BEGIN:VCALENDAR" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "PRODID: -//Northern Indiana ESC//Event Registration System//EN" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "VERSION:2.0" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "METHOD:REQUEST" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "BEGIN:VTIMEZONE" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZID:Eastern Time" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "BEGIN:STANDARD" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTSTART:20061101T020000" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=1SU;BYMONTH=11" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZOFFSETFROM:-0400" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZOFFSETTO:-0500" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZNAME:Standard Time" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "END:STANDARD" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "BEGIN:DAYLIGHT" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTSTART:20060301T020000" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=2SU;BYMONTH=3" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZOFFSETFROM:-0500" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZOFFSETTO:-0400" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TZNAME:Daylight Savings Time" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "END:DAYLIGHT" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "END:VTIMEZONE" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "BEGIN:VEVENT" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "UID:" & #getRegistrationInfo.RegistrationID# & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "ORGANIZER;CN=:" & #stEvent.FacilitatorName# & ":MAILTO:" & #stEvent.FacilitatorEmail# & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTSTAMP:" & #DateFormat(Now(), "yyyymmdd")# & "T" & TimeFormat(Now(), "HHmmss") & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTSTART;TZID=Eastern Time:" & #DateFormat(getRegistrationInfo.EventDate, "yyyymmdd")# & "T" & TimeFormat(getRegistrationInfo.Event_StartTime, "HHmmss") & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "DTEND;TZID=Eastern Time:" & #DateFormat(getRegistrationInfo.EventDate, "yyyymmdd")# & "T" & TimeFormat(getRegistrationInfo.Event_EndTime, "HHmmss") & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "SUMMARY:" & #getRegistrationInfo.ShortTitle# & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "LOCATION:" & #stEvent.EventLocation# & #Variables.CRLF#>
		<cfif getRegistrationInfo.WebinarParticipant EQ 0>
			<cfset vCal = #Variables.vCal# & "DESCRIPTION:" & #stEvent.EventDescription# & #Variables.CRLF#>
		<cfelseif getRegistrationInfo.WebinarParticipant EQ 1 AND getRegistrationInfo.WebinarAvailable EQ 1>
			<cfset vCal = #Variables.vCal# & "DESCRIPTION:" & #stEvent.EventDescription# & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "Webinar Information: " & #getRegistrationInfo.WebinarConnectInfo# & #Variables.CRLF#>
		</cfif>
		<cfset vCal = #Variables.vCal# & "PRIORITY:" & #stEvent.Priority# & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "TRANSP:OPAQUE" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "CLASS:PUBLIC" & #Variables.CRLF#>
		<!---
			For a Reminder Use the Below Lines
			<cfset vCal = #Variables.vCal# & "BEGIN:VALARM" & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "TRIGGER:-PT30M" & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "ACTION:DISPLAY" & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "DESCRIPTION:Reminder" & #Variables.CRLF#>
			<cfset vCal = #Variables.vCal# & "END:VALARM" & #Variables.CRLF#>

		--->
		<cfset vCal = #Variables.vCal# & "END:VEVENT" & #Variables.CRLF#>
		<cfset vCal = #Variables.vCal# & "END:VCALENDAR" & #Variables.CRLF#>
		<cfreturn Trim(variables.vcal)>
	</cffunction>

</cfcomponent>