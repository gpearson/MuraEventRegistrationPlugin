<cfif isDefined("URL.EventID") and isNumeric(URL.EventID) and Session.Mura.IsLoggedIn EQ "true">
	<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, Featured_StartDate, Featured_EndDate, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
		From eEvents
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
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

	<cfset UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>

	<cfquery name="getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select TContent_ID, OrganizationName, OrganizationDomainName, Active
		From eMembership
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
			OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
		<cfif DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GTE 0>
			<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = True>
		<cfelse>
			<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
		</cfif>
	<cfelse>
		<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
	</cfif>

	<cfif getSelectedEvent.ViewSpecialPricing EQ 1>
		<cfset Session.UserRegistrationInfo.SpecialPricingAvailable = True>
		<cfset Session.UserRegistrationInfo.SpecialPriceRequirements = #getSelectedEvent.SpecialPriceRequirements#>
		<cfif getActiveMembership.RecordCount GTE 1>
			<cfset Session.UserRegistrationInfo.SpecialPriceEventCost = #getSelectedEvent.SpecialMemberCost#>
		<cfelse>
			<cfset Session.UserRegistrationInfo.SpecialPriceEventCost = #getSelectedEvent.SpecialNonMemberCost#>
		</cfif>
	<cfelse>
		<cfset Session.UserRegistrationInfo.SpecialPricingAvailable = False>
	</cfif>

	<cfif getSelectedEvent.WebinarAvailable EQ 1>
		<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = True>
		<cfif getActiveMembership.RecordCount GTE 1>
			<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #getSelectedEvent.WebinarMemberCost#>
		<cfelse>
			<cfset Session.UserRegistrationInfo.WebinarPricingEventCost = #getSelectedEvent.WebinarNonMemberCost#>
		</cfif>
	<cfelse>
		<cfset Session.UserRegistrationInfo.WebinarPricingAvailable = False>
	</cfif>

	<cfif getSelectedEvent.MealProvided EQ 1>
		<cfset Session.UserRegistrationInfo.MealOptionAvailable = True>
	<cfelse>
		<cfset Session.UserRegistrationInfo.MealOptionAvailable = False>
	</cfif>

	<cfif getSelectedEvent.AllowVideoConference EQ 1>
		<cfset Session.UserRegistrationInfo.VideoConferenceOption = True>
		<cfset Session.UserRegistrationInfo.VideoConferenceInfo = #getSelectedEvent.VideoConferenceInfo#>
		<cfset Session.UserRegistrationInfo.VideoConferenceCost = #getSelectedEvent.VideoConferenceCost#>
	<cfelse>
		<cfset Session.UserRegistrationInfo.VideoConferenceOption = False>
	</cfif>

	<cfif getSelectedEvent.PGPAvailable EQ 1>
		<cfset Session.UserRegistrationInfo.PGPPointsAvailable = True>
		<cfset Session.UserRegistrationInfo.PGPPoints = #getSelectedEvent.PGPPoints#>
	<cfelse>
		<cfset Session.UserRegistrationInfo.PGPPointsAvailable = False>
	</cfif>

	<cfif getActiveMembership.RecordCount EQ 1>
		<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = True>
		<cfset Session.UserRegistrationInfo.UserEventPrice = #getSelectedEvent.MemberCost#>
		<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
			<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #getSelectedEvent.EarlyBird_MemberCost#>
		</cfif>
	<cfelse>
		<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = False>
		<cfset Session.UserRegistrationInfo.UserEventPrice = #getSelectedEvent.NonMemberCost#>
		<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
			<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #getSelectedEvent.EarlyBird_NonMemberCost#>
		</cfif>
	</cfif>

	<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
	<cfif not isDefined("URL.RegistrationSuccessfull")>
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfset Session.FormData = #StructNew()#>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.UserSuppliedInfo = #StructNew()#>
		</cflock>
		<cfoutput>
			<h2>Register for Event: #getSelectedEvent.ShortTitle#</h2>
			<p class="alert-box notice">Please complete the following information to register for this event. All electronic communication from this system will be sent to the Participant's Email Address</p>
			<hr>
			<uForm:form action="" method="Post" id="RegisterEvent" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/properties/uniForm/"
				showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:main.viewavailableevents&Return=True"
				submitValue="Register for Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="EventID" value="#URL.EventID#">
				<input type="hidden" name="formSubmit" value="true">
				<uForm:fieldset legend="Required Fields">
					<uForm:field label="Participant's Name" name="ParticipantName" isRequired="false" isDisabled="True" value="#Session.Mura.FName# #Session.Mura.LName#" maxFieldLength="50" type="text" hint="Name of Participant" />
					<uForm:field label="Participant's Email Address" name="ParticipantEmail" isRequired="false" isDisabled="True" value="#Session.Mura.Email#" maxFieldLength="50" type="text" hint="Email Address of Participant" />
					<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
						<uform:field label="Staying for Meal" name="WantsMeal" type="select" isRequired="True" hint="Will you be staying for the Provided Meal?">
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true"/>
						</uform:field>
					</cfif>
					<cfif Session.UserRegistrationInfo.PGPPointsAvailable EQ "True">
						<uForm:field label="Professional Growth Points" name="PGPPoints" isRequired="false" isDisabled="True" value="#NumberFormat(Session.UserRegistrationInfo.PGPPoints, '99.99')#" maxFieldLength="50" type="text" hint="Number of Points upon Successfully completing workshop" />
					</cfif>
					<cfif getActiveMembership.RecordCount EQ 1><cfset UserActiveMembership = True><cfelse><cfset UserActiveMembership = False></cfif>
					<uForm:field label="Active Membership" name="ActiveMembership" isRequired="false" isDisabled="True" value="#Variables.UserActiveMembership#" maxFieldLength="50" type="text" hint="Active Membership based on Current Email Address" />
					<uform:field label="Register Additional Participants" name="RegisterAdditionalParticipants" type="select" isRequired="True" hint="Will you also be registering additional participants for this event?">
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true"/>
						</uform:field>
				</uForm:fieldset>
				<cfif getSelectedEvent.WebinarAvailable EQ 1>
					<uForm:fieldset legend="Webinar Option">
						<input type="Hidden" Name="WebinarParticipant" Value="1">
						<uForm:field label="Webinar Information" name="WebinarConnectInfo" isRequired="false" isDisabled="True" value="#getSelectedEvent.WebinarConnectInfo#" type="textarea" hint="Information about Event's Webinar Option" />
						<uForm:field label="Cost to Participate" name="WebinarEventPrice" isRequired="false" isDisabled="True" value="#DollarFormat(Session.UserRegistrationInfo.WebinarPricingEventCost)#" maxFieldLength="50" type="text" hint="Event Cost to Participate with Webinar Technology for this event" />
					</uForm:fieldset>
				</cfif>
				<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
					<uForm:fieldset legend="Video Conferencing Option">
						<uForm:field label="Video Conference Information" name="IVCEventInfo" isRequired="false" isDisabled="True" value="#getSelectedEvent.VideoConferenceInfo#" type="textarea" hint="Information about Event's Video Conference Option" />
						<uForm:field label="Cost to Participate" name="IVCEventCost" isRequired="false" isDisabled="True" value="#DollarFormat(getSelectedEvent.VideoConferenceCost)#" maxFieldLength="50" type="text" hint="Event Cost to Participate with Video Conference Equipment for this event" />
						<uform:field label="Participate via Video Conference" name="IVCParticipant" type="select" isRequired="True" hint="Will you be participating through Video Conferencing for this event?">
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true"/>
						</uform:field>
					</uForm:fieldset>
				</cfif>
				<cfif getSelectedEvent.WebinarAvailable EQ 0>
					<uForm:fieldset legend="Cost to physically attend Event">
						<cfif Session.UserRegistrationInfo.SpecialPricingAvailable EQ "True">
							<cfif UserRegistrationInfo.SpecialPricingAvailable EQ "True"><cfset SpecialPriceAvailable = "Yes"><cfelse><cfset SpecialPriceAvailable = "No"></cfif>
							<uForm:field label="Special Price Available" name="SpecialPriceAvailable" isRequired="false" isDisabled="True" value="#Variables.SpecialPriceAvailable#" maxFieldLength="50" type="text" hint="Does Event allow for Special Pricing if Requirements are met?" />
							<uForm:field label="Special Price Requirements" name="SpecialPriceInfo" isRequired="false" isDisabled="True" value="#Session.UserRegistrationInfo.SpecialPriceRequirement#" type="textarea" hint="Requirements to must be met to receive this special price for attending this event." />
							<uForm:field label="Special Price for Event" name="SpecialPriceInfo" isRequired="false" isDisabled="True" value="$ #DollarFormat(Session.UserRegistrationInfo.SpecialPriceEventCost)#" maxFieldLength="50" type="text" hint="Event Price if Special Requirements are met" />
						</cfif>
						<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
							<uForm:field label="Cost to Participate" name="EventEarlyBirdPrice" isRequired="false" isDisabled="True" value="#DollarFormat(Session.UserRegistrationInfo.UserEventEarlyBirdPrice)#" maxFieldLength="50" type="text" hint="Event Cost to Physically Attend this event at the location where event is to be held" />
						<cfelse>
							<uForm:field label="Cost to Participate" name="EventPrice" isRequired="false" isDisabled="True" value="#DollarFormat(Session.UserRegistrationInfo.UserEventPrice)#" maxFieldLength="50" type="text" hint="Event Cost to Physically Attend this event at the location where event is to be held" />
						</cfif>
					</uForm:fieldset>
				</cfif>
			</uForm:form>
		</cfoutput>
	<cfelseif isDefined("URL.RegistrationSuccessfull")>
		<cfoutput>
			<h2>Register for Event: #getSelectedEvent.ShortTitle#</h2>
			<p class="alert-box notice">Please complete the following information to register for this event. All electric communications from this system will be sent to the Participant's Email Address</p>
			<hr>
			<uForm:form action="" method="Post" id="RegisterEvent" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/properties/uniForm/"
				showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:main.viewavailableevents&Return=True"
				submitValue="Register for Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="EventID" value="#URL.EventID#">
				<input type="hidden" name="formSubmit" value="true">
				<uForm:fieldset legend="Required Fields">
					<uForm:field label="Participant's Name" name="ParticipantName" isRequired="false" isDisabled="True" value="#Session.Mura.FName# #Session.Mura.LName#" maxFieldLength="50" type="text" hint="Name of Participant" />
					<uForm:field label="Participant's Email Address" name="ParticipantEmail" isRequired="false" isDisabled="True" value="#Session.Mura.Email#" maxFieldLength="50" type="text" hint="Email Address of Participant" />
					<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
						<uform:field label="Staying for Meal" name="WantsMeal" type="select" isRequired="True" hint="Will you be staying for the Provided Meal?">
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true"/>
						</uform:field>
					</cfif>
					<cfif Session.UserRegistrationInfo.PGPPointsAvailable EQ "True">
						<uForm:field label="Professional Growth Points" name="PGPPoints" isRequired="false" isDisabled="True" value="#NumberFormat(Session.UserRegistrationInfo.PGPPoints, '99.99')#" maxFieldLength="50" type="text" hint="Number of Points upon Successfully completing workshop" />
					</cfif>
					<cfif getActiveMembership.RecordCount EQ 1><cfset UserActiveMembership = True><cfelse><cfset UserActiveMembership = False></cfif>
					<uForm:field label="Active Membership" name="ActiveMembership" isRequired="false" isDisabled="True" value="#Variables.UserActiveMembership#" maxFieldLength="50" type="text" hint="Active Membership based on Current Email Address" />
					<uform:field label="Register Additional Participants" name="RegisterAdditionalParticipants" type="select" isRequired="True" hint="Will you also be registering additional participants for this event?">
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true"/>
						</uform:field>
				</uForm:fieldset>
				<cfif getSelectedEvent.WebinarAvailable EQ 1>
					<uForm:fieldset legend="Webinar Option">
						<input type="Hidden" Name="WebinarParticipant" Value="1">
						<uForm:field label="Webinar Information" name="WebinarConnectInfo" isRequired="false" isDisabled="True" value="#getSelectedEvent.WebinarConnectInfo#" type="textarea" hint="Information about Event's Webinar Option" />
						<uForm:field label="Cost to Participate" name="WebinarEventPrice" isRequired="false" isDisabled="True" value="#DollarFormat(Session.UserRegistrationInfo.WebinarPricingEventCost)#" maxFieldLength="50" type="text" hint="Event Cost to Participate with Webinar Technology for this event" />
					</uForm:fieldset>
				</cfif>
				<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
					<uForm:fieldset legend="Video Conferencing Option">
						<uForm:field label="Video Conference Information" name="IVCEventInfo" isRequired="false" isDisabled="True" value="#getSelectedEvent.VideoConferenceInfo#" type="textarea" hint="Information about Event's Video Conference Option" />
						<uForm:field label="Cost to Participate" name="IVCEventCost" isRequired="false" isDisabled="True" value="#DollarFormat(getSelectedEvent.VideoConferenceCost)#" maxFieldLength="50" type="text" hint="Event Cost to Participate with Video Conference Equipment for this event" />
						<uform:field label="Participate via Video Conference" name="IVCParticipant" type="select" isRequired="True" hint="Will you be participating through Video Conferencing for this event?">
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true"/>
						</uform:field>
					</uForm:fieldset>
				</cfif>
				<cfif getSelectedEvent.WebinarAvailable EQ 0>
					<uForm:fieldset legend="Cost to physically attend Event">
						<cfif Session.UserRegistrationInfo.SpecialPricingAvailable EQ "True">
							<cfif UserRegistrationInfo.SpecialPricingAvailable EQ "True"><cfset SpecialPriceAvailable = "Yes"><cfelse><cfset SpecialPriceAvailable = "No"></cfif>
							<uForm:field label="Special Price Available" name="SpecialPriceAvailable" isRequired="false" isDisabled="True" value="#Variables.SpecialPriceAvailable#" maxFieldLength="50" type="text" hint="Does Event allow for Special Pricing if Requirements are met?" />
							<uForm:field label="Special Price Requirements" name="SpecialPriceInfo" isRequired="false" isDisabled="True" value="#Session.UserRegistrationInfo.SpecialPriceRequirement#" type="textarea" hint="Requirements to must be met to receive this special price for attending this event." />
							<uForm:field label="Special Price for Event" name="SpecialPriceInfo" isRequired="false" isDisabled="True" value="$ #DollarFormat(Session.UserRegistrationInfo.SpecialPriceEventCost)#" maxFieldLength="50" type="text" hint="Event Price if Special Requirements are met" />
						</cfif>
						<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
							<uForm:field label="Cost to Participate" name="EventEarlyBirdPrice" isRequired="false" isDisabled="True" value="#DollarFormat(Session.UserRegistrationInfo.UserEventEarlyBirdPrice)#" maxFieldLength="50" type="text" hint="Event Cost to Physically Attend this event at the location where event is to be held" />
						<cfelse>
							<uForm:field label="Cost to Participate" name="EventPrice" isRequired="false" isDisabled="True" value="#DollarFormat(Session.UserRegistrationInfo.UserEventPrice)#" maxFieldLength="50" type="text" hint="Event Cost to Physically Attend this event at the location where event is to be held" />
						</cfif>
					</uForm:fieldset>
				</cfif>
			</uForm:form>
		</cfoutput>
	</cfif>
<cfelseif isDefined("URL.EventID") and isNumeric(URL.EventID) and Session.Mura.IsLoggedIn EQ "false">
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
	<cflocation addtoken="true" url="/index.cfm?display=login">
	<!--- <cflocation addtoken="false" url="/index.cfm?display=login"> --->
<cfelse>
	<cfdump var="#Session#">
	Here We Go Again
</cfif>