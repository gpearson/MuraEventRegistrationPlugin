<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1><cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&PerformAction=Step4&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false"></cfif>
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
			<div class="alert-box notice">This is Step 3 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
			<hr>
			<uForm:form action="" method="Post" id="AddEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step2&PerformAction=Step2&compactDisplay=false"
				submitValue="Proceed To Step 4" loadValidation="true" loadMaskUI="true" loadDateUI="true"
				loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="AcceptRegistrations" value="0">
				<input type="hidden" name="PerformAction" value="Step4">

				<cfquery name="getFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FacilityName
					From eFacility
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT"> and
						FacilityType = <cfqueryparam value="#Session.UserSuppliedInfo.LocationType#" cfsqltype="cf_sql_varchar"> and
						TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfquery name="getFacilityRoomInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, RoomName
					From eFacilityRooms
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						Facility_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationID#" cfsqltype="cf_sql_integer"> and
						Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
				</cfquery>

				<uForm:fieldset legend="Facility Room Information">
					<uform:field label="Facility Location" name="LocationIDName" isDisabled="true" type="text" value="#GetFacilityInformation.FacilityName#" hint="Where is this facility being held at?" />
					<uform:field label="Facility Room Name" name="LocationRoomID" type="select" isRequired="false" hint="Which room at this facility would this event be held?">
					<cfif getFacilityRoomInformation.RecordCount EQ 0>
						<uform:option display="Please Add Facility Room to Facility First" value="0" isSelected="true" />
					<cfelse>
						<uform:option display="Please Select Facility Room from Listing" value="0" isSelected="true" />
						<cfloop query="getFacilityRoomInformation">
							<uform:option display="#getFacilityRoomInformation.RoomName#" value="#getFacilityRoomInformation.TContent_ID#" />
						</cfloop>
					</cfif>
				</uform:field>
			</uForm:fieldset>

			<!--- <uForm:fieldset legend="Event Documents">
				<uform:field label="Event Document 1" name="EventDocument1" type="file" hint="Allowed Document Extensions: pdf" />
				<uform:field label="Event Document 2" name="EventDocument2" type="file" hint="Allowed Document Extensions: pdf" />
				<uform:field label="Event Document 3" name="EventDocument3" type="file" hint="Allowed Document Extensions: pdf" />
				<uform:field label="Event Document 4" name="EventDocument4" type="file" hint="Allowed Document Extensions: pdf" />
				<uform:field label="Event Document 5" name="EventDocument5" type="file" hint="Allowed Document Extensions: pdf" />
			</uForm:fieldset> --->

			<cfset GetAllUserGroups = #$.getBean( 'userManager' ).getUserGroups( rc.$.siteConfig('siteID'), 1 )#>
			<cfparam name="PresenterUserID" type="string" default="">
			<cfloop query="GetAllUserGroups">
				<cfif GetAllUserGroups.GroupName EQ "Presenters">
					<cfset PresenterUserID = #GetAllUserGroups.UserID#>
				</cfif>
			</cfloop>

			<cfif LEN(Variables.PresenterUserID)>
				<cfquery name="getPresentersByUserID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select UserID
					From tusersmemb
					Where GroupID = <cfqueryparam value="#Variables.PresenterUserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getPresentersByUserID.RecordCount>
					<uForm:fieldset legend="Event Presenters">
						<uForm:field name="Presenters" type="checkboxgroup">
						<cfloop query="getPresentersByUserID">
							<cfquery name="getUsersbyUserID" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname
								From tusers
								Where UserID = <cfqueryparam value="#getPresentersByUserID.UserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<uForm:checkbox label="#getUsersbyUserID.FName# #getUsersbyUserID.LName#" value="#getUsersbyUserID.UserID#" />
						</cfloop>
					</uForm:field>
					</uForm:fieldset>
				</cfif>
			</cfif>
			</uForm:form>
		</div>
	</div>
</cfoutput>