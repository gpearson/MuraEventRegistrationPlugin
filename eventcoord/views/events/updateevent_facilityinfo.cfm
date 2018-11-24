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
<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfquery name="getCatererInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select TContent_ID, FacilityName
	From eCaterers
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
		Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
</cfquery>
<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Updating Workshop/Event: #Session.UserSuppliedInfo.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<p class="alert-box notice">Please make changes to the information listed below so this event displays accurate information.</p>
			<hr>
			<uForm:form action="" method="Post" id="UpdateEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
				submitValue="Update Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<cfif not isDefined("URL.FormStep")>
					<input type="hidden" name="formStep" value="1">
				<cfelseif isDefined("URL.FormStep")>
					<cfswitch expression="#URL.FormStep#">
						<cfcase value="1">
							<input type="hidden" name="formStep" value="2">
						</cfcase>
						<cfcase value="2">
							<input type="hidden" name="formStep" value="3">
						</cfcase>
						<cfcase value="3">
							<input type="hidden" name="formStep" value="4">
						</cfcase>
					</cfswitch>
				</cfif>
				<input type="hidden" name="PerformAction" value="UpdateEvent">
				<uForm:fieldset legend="Event Location Information">
					<cfif not isDefined("URL.FormStep")>
						<uform:field label="Location for Event" name="LocationType" type="select" hint="What type of Facility will this event be held at?">
							<cfif isDefined("Session.UserSuppliedInfo.LocationType")>
								<cfif Session.UserSuppliedInfo.LocationType EQ "S">
									<uform:option display="School District" value="S" isSelected="true" />
									<uform:option display="Business Facility" value="B" />
								<cfelse>
									<uform:option display="School District" value="S" />
									<uform:option display="Business Facility" value="B" isSelected="true" />
								</cfif>
							<cfelse>
								<uform:option display="School District" value="S" />
								<uform:option display="Business Facility" value="B" isSelected="true" />
							</cfif>
						</uform:field>
					<cfelseif isDefined("URL.FormStep")>
						<cfswitch expression="#URL.FormStep#">
							<cfcase value="1">
								<cfquery name="getFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select TContent_ID, FacilityName
									From eFacility
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT"> and
										FacilityType = <cfqueryparam value="#Session.UserSuppliedInfo.LocationType#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif getFacilityInformation.RecordCount>
									<uform:field label="Facility Location" name="LocationID" type="select" isRequired="true" hint="Where is this facility being held at?">
										<uform:option display="Please Select Facility from Listing" value="0" isSelected="true" />
										<cfif isDefined("Session.UserSuppliedInfo.LocationID")>
											<cfloop query="getFacilityInformation">
												<cfif getFacilityInformation.TContent_ID EQ Session.UserSuppliedInfo.LocationID>
													<uform:option display="#getFacilityInformation.FacilityName#" value="#getFacilityInformation.TContent_ID#" isSelected="true" />
												<cfelse>
													<uform:option display="#getFacilityInformation.FacilityName#" value="#getFacilityInformation.TContent_ID#" />
												</cfif>
											</cfloop>
										<cfelse>
											<cfloop query="getFacilityInformation">
												<uform:option display="#getFacilityInformation.FacilityName#" value="#getFacilityInformation.TContent_ID#" />
											</cfloop>
										</cfif>
									</uform:field>
								<cfelse>
									<uform:field label="Facility Location" name="LocationID" type="select" isRequired="true" hint="Where is this facility being held at?">
										<uform:option display="Please Add Facility to System" value="0" isSelected="true" />
									</uform:field>
								</cfif>
							</cfcase>
							<cfcase value="2">
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
								<uform:field label="Facility Location" name="LocationIDName" isDisabled="true" type="text" value="#GetFacilityInformation.FacilityName#" hint="Where is this facility being held at?" />
								<uform:field label="Facility Room Name" name="LocationRoomID" type="select" isRequired="false" hint="Which room at this facility would this event be held?">
								<cfif isDefined("Session.UserSuppliedInfo.LocationRoomID")>
										<cfloop query="getFacilityRoomInformation">
											<cfif getFacilityRoomInformation.TContent_ID EQ Session.UserSuppliedInfo.LocationRoomID>
												<uform:option display="#getFacilityRoomInformation.RoomName#" value="#getFacilityRoomInformation.TContent_ID#" isSelected="True" />
											<cfelse>
												<uform:option display="#getFacilityRoomInformation.RoomName#" value="#getFacilityRoomInformation.TContent_ID#" />
											</cfif>
										</cfloop>
									<cfelse>
										<cfif getFacilityRoomInformation.RecordCount EQ 0>
											<uform:option display="Please Add Facility Room to Facility First" value="0" isSelected="true" />
										<cfelse>
											<uform:option display="Please Select Facility Room from Listing" value="0" isSelected="true" />
											<cfloop query="getFacilityRoomInformation">
												<uform:option display="#getFacilityRoomInformation.RoomName#" value="#getFacilityRoomInformation.TContent_ID#" />
											</cfloop>
										</cfif>
									</cfif>
								</uform:field>
							</cfcase>
							<cfcase value="3">
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
								<uform:field label="Facility Location" name="LocationIDName" isDisabled="true" type="text" value="#GetFacilityInformation.FacilityName#" hint="Where is this facility being held at?" />
								<uform:field label="Facility Room Name" name="LocationRoomName" isDisabled="true" type="text" value="#getFacilityRoomInformation.RoomName#" hint="Which room at this facility would this event be held?" />
								<uform:field label="Maximum Participants" name="RoomMaxParticipants" type="text" value="#getFacilityRoomInformation.Capacity#" hint="Maximum Participants allowed to register for this event?" />
							</cfcase>
						</cfswitch>
					</cfif>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>