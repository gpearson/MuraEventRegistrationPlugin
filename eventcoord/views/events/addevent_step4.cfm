<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>
<cfoutput>
	<cfscript>
		timeConfig = structNew();
		timeConfig['show24Hours'] = true;
		timeConfig['showSeconds'] = false;
	</cfscript>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Add new Event or Workshop</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">This is Step 4 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
			<hr>
			<uForm:form action="" method="Post" id="AddEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step3&PerformAction=Step2&compactDisplay=false"
				submitValue="Proceed To Event Review" loadValidation="true" loadMaskUI="true" loadDateUI="true"
				loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="AcceptRegistrations" value="0">
				<input type="hidden" name="PerformAction" value="Step5">

				<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
					<cfquery name="getFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select FacilityName
						From eFacility
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT"> and
							FacilityType = <cfqueryparam value="#Session.UserSuppliedInfo.LocationType#" cfsqltype="cf_sql_varchar"> and
							TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfquery name="getFacilityRoomInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select TContent_ID, RoomName, Capacity
						From eFacilityRooms
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
							Facility_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationID#" cfsqltype="cf_sql_integer"> and
							TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationRoomID#" cfsqltype="cf_sql_integer"> and
							Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
					</cfquery>
					<uForm:fieldset legend="Facility Room Information">
						<uform:field label="Facility Location" name="LocationIDName" isDisabled="true" type="text" value="#GetFacilityInformation.FacilityName#" hint="Where is this facility being held at?" />
						<uform:field label="Facility Room Name" name="LocationRoomID" isDisabled="true" type="text" value="#GetFacilityRoomInformation.RoomName#" hint="Which room at this facility would this event be held?" />
						<uform:field label="Maximum Participants" name="RoomMaxParticipants" type="text" value="#getFacilityRoomInformation.Capacity#" hint="Maximum Participants allowed to register for this event?" />
					</uForm:fieldset>
				<cfelse>
					<uForm:fieldset legend="Maximum Participants Allowed">
						<uform:field label="Maximum Participants" name="RoomMaxParticipants" type="text" hint="How many participants would you want to limit this Webinar Event to?" />
					</uForm:fieldset>
				</cfif>
			</uForm:form>
		</div>
	</div>
</cfoutput>