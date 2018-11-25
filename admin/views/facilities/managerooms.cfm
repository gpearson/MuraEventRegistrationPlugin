<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfif isDefined("URL.RecNo") and isDefined("URL.EventRegistrationaction")>
	<cfquery name="getFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, USPS_CarrierRoute, USPS_CheckDigit, USPS_DeliveryPoint, PhysicalLocationCountry, PhysicalCountry
		From eFacility
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Active = 1 and
			TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
		Order by FacilityName ASC
	</cfquery>
	<cfif not isDefined("URL.PerformAction")>
		<cfquery name="getFacilityRooms" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Tcontent_ID, RoomName, Capacity, RoomFees, Active
			From eFacilityRooms
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Facility_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
				and Active = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfoutput>
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Manage Facility Rooms Administrative Interface</h3>
				</div>
				<div class="art-blockcontent">
					<h2>Facility Name: #getFacility.FacilityName#</h2>
					<cfif isDefined("URL.Successful")>
						<cfswitch expression="#URL.Successful#">
							<cfcase value="true">
								<cfif isDefined("URL.UserAction")>
									<cfswitch expression="#URL.UserAction#">
										<cfcase value="AddedFacilityRoom">
											<div class="alert-box success">You have successfully added a new meeting room within this facility.</div>
										</cfcase>
										<cfcase value="UpdatedFacilityRoom">
											<div class="alert-box success">You have successfully updated a meeting room within this facility with new information.</div>
										</cfcase>
									</cfswitch>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfif>
					<br>
					<table class="art-article" style="width:100%;">
						<thead>
							<tr>
								<td>Room Name</td>
								<td>Room Capacity</td>
								<td>Active</td>
								<td>Actions</td>
							</tr>
						</thead>
						<cfif getFacilityRooms.RecordCount>
							<tfoot>
								<tr>
									<td colspan="6">Add a new room within the facility that is not listed above by clicking <a href="#buildURL('admin:facilities.managerooms')#&PerformAction=AddRoom&RecNo=#getFacility.TContent_ID#" class="art-button">here</a> <strong>or</strong> you can return to the listing of facilities by clicking <a href="#buildURL('admin:facilities')#" class="art-button">here</a></td>
								</tr>
							</tfoot>
							<tbody>
								<cfloop query="getFacilityRooms">
									<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
										<td>#getFacilityRooms.RoomName#</td>
										<td>#getFacilityRooms.Capacity#</td>
										<td><cfswitch expression="#GetFacilityRooms.Active#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch></td>
										<td><a href="#buildURL('admin:facilities.managerooms')#&PerformAction=EditRoom&RecNo=#getFacility.TContent_ID#&RoomRecNo=#getFacilityRooms.TContent_ID#" class="art-button">Edit</a>&nbsp;&nbsp;<a href="#buildURL('admin:facilities.managerooms')#&PerformAction=DeleteRoom&RecNo=#getFacility.TContent_ID#&RoomRecNo=#getFacilityRooms.TContent_ID#" class="art-button">D</a></td>
									</tr>
								</cfloop>
							</tbody>
						<cfelse>
							<tbody>
								<tr>
									<td colspan="6"><div align="center" class="alert-box notice">No rooms within the facility were located in the database Please click <a href="#buildURL('admin:facilities.managerooms')#&PerformAction=AddRoom&RecNo=#getFacility.TContent_ID#" class="art-button">here</a> to add one.</div></td>
								</tr>
							</tbody>
						</cfif>
					</table>
				</div>
			</div>
		</cfoutput>
	<cfelseif isDefined("URL.PerformAction")>
		<cfoutput>
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Manage Facility Rooms Administrative Interface</h3>
				</div>
				<div class="art-blockcontent">
					<h2>Facility Name: #getFacility.FacilityName#</h2>
					<br>
					<cfswitch expression="#URL.PerformAction#">
						<cfcase value="DeleteRoom">
							<cfquery name="getFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select Tcontent_ID, RoomName, Capacity, RoomFees, Active
								From eFacilityRooms
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									Facility_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer"> and
									TContent_ID = <cfqueryparam value="#URL.RoomRecNo#" cfsqltype="cf_sql_integer">
							</cfquery>
							<uForm:form action="" method="Post" id="DeleteFacilityRoom" errors="#Session.FormErrors#" errorMessagePlacement="both"
								commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
								cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&compactDisplay=false"
								submitValue="Update Facility Room" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
								<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
								<input type="hidden" name="FacilityID" value="#URL.RecNo#">
								<input type="hidden" name="FacilityRoomID" value="#URL.RoomRecNo#">
								<input type="hidden" name="formSubmit" value="true">
								<uForm:fieldset legend="Required Fields">
									<uForm:field label="Room Name" name="RoomName" value="#getFacilityRoom.RoomName#" isDisabled="true" maxFieldLength="20" type="text" hint="Meeting Room Name" />
									<uForm:field label="Room Capacity" name="RoomCapacity" isDisabled="true" value="#getFacilityRoom.Capacity#" maxFieldLength="3" type="text" hint="Room Seating Capacity" />
									<uForm:field label="Room Fees" name="RoomFees" isDisabled="true" value="#NumberFormat(getFacilityRoom.RoomFees, '99999.99')#" maxFieldLength="10" type="text" hint="Fees to rent this room if any" />
									<cfswitch expression="#getFacilityRoom.Active#"><cfcase value="1"><cfset RoomAvailableText = "Yes"></cfcase><cfcase value="0"><cfset RoomAvailableText = "No"></cfcase></cfswitch>
									<uform:field label="Room Available" name="Active" isDisabled="true" type="text" value="#RoomAvailableText#" hint="Is the room available to be used?" />
								</uForm:fieldset>
								<uForm:fieldset legend="Informational Fields">
									<uForm:field label="Date Created" name="dateCreated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Created Date" />
									<uForm:field label="Date Updated" name="lastUpdated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Date Last Updated" />
									<uForm:field label="Updated By" name="lastUpdateBy" type="text" isDisabled="true" value="#rc.$.currentUser('userName')#" hint="Last Updated By" />
								</uForm:fieldset>
								<uForm:fieldset legend="Are you Sure?">
									<uform:field label="Delete Room" name="DeleteConfirm" type="select" hint="Are you sure you want to delete this room?">
										<uform:option display="Yes" value="1" isSelected="true" />
										<uform:option display="No" value="0" />
									</uform:field>
								</uForm:fieldset>
							</uForm:form>
						</cfcase>
						<cfcase value="EditRoom">
							<cfquery name="getFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select Tcontent_ID, RoomName, Capacity, RoomFees, Active
								From eFacilityRooms
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									Facility_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer"> and
									TContent_ID = <cfqueryparam value="#URL.RoomRecNo#" cfsqltype="cf_sql_integer">
							</cfquery>
							<uForm:form action="" method="Post" id="EditFacilityRoom" errors="#Session.FormErrors#" errorMessagePlacement="both"
								commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
								cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&compactDisplay=false"
								submitValue="Update Facility Room" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
								<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
								<input type="hidden" name="FacilityID" value="#URL.RecNo#">
								<input type="hidden" name="FacilityRoomID" value="#URL.RoomRecNo#">
								<input type="hidden" name="formSubmit" value="true">
								<uForm:fieldset legend="Required Fields">
									<uForm:field label="Room Name" name="RoomName" value="#getFacilityRoom.RoomName#" isRequired="true" maxFieldLength="20" type="text" hint="Meeting Room Name" />
									<uForm:field label="Room Capacity" name="RoomCapacity" isRequired="true" value="#getFacilityRoom.Capacity#" maxFieldLength="3" type="text" hint="Room Seating Capacity" />
									<uForm:field label="Room Fees" name="RoomFees" isRequired="true" value="#NumberFormat(getFacilityRoom.RoomFees, '99999.99')#" maxFieldLength="10" type="text" hint="Fees to rent this room if any" />
									<uform:field label="Room Available" name="Active" type="select" hint="Is the room available to be used?">
										<cfif getFacilityRoom.Active EQ 1>
											<uform:option display="Yes" value="1" isSelected="true" />
											<uform:option display="No" value="0" />
										<cfelse>
											<uform:option display="Yes" value="1" />
											<uform:option display="No" value="0" isSelected="true" />
										</cfif>
									</uform:field>
								</uForm:fieldset>
								<uForm:fieldset legend="Informational Fields">
									<uForm:field label="Date Created" name="dateCreated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Created Date" />
									<uForm:field label="Date Updated" name="lastUpdated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Date Last Updated" />
									<uForm:field label="Updated By" name="lastUpdateBy" type="text" isDisabled="true" value="#rc.$.currentUser('userName')#" hint="Last Updated By" />
								</uForm:fieldset>
							</uForm:form>
						</cfcase>
						<cfcase value="AddRoom">
							<uForm:form action="" method="Post" id="AddFacilityRoom" errors="#Session.FormErrors#" errorMessagePlacement="both"
								commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
								cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:facilities&compactDisplay=false"
								submitValue="Add Facility Room" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
								<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
								<input type="hidden" name="FacilityID" value="#URL.RecNo#">
								<input type="hidden" name="formSubmit" value="true">
								<uForm:fieldset legend="Required Fields">
									<uForm:field label="Room Name" name="RoomName" isRequired="true" maxFieldLength="20" type="text" hint="Meeting Room Name" />
									<uForm:field label="Room Capacity" name="RoomCapacity" isRequired="true" maxFieldLength="3" type="text" hint="Room Seating Capacity" />
									<uForm:field label="Room Fees" name="RoomFees" isRequired="true" maxFieldLength="10" type="text" hint="Fees to rent this room if any" />
									<uform:field label="Room Available" name="Active" type="select" hint="Is the room available to be used?">
										<uform:option display="Yes" value="1" isSelected="true" />
										<uform:option display="No" value="0" />
									</uform:field>
								</uForm:fieldset>
								<uForm:fieldset legend="Informational Fields">
									<uForm:field label="Date Created" name="dateCreated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Created Date" />
									<uForm:field label="Date Updated" name="lastUpdated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Date Last Updated" />
									<uForm:field label="Updated By" name="lastUpdateBy" type="text" isDisabled="true" value="#rc.$.currentUser('userName')#" hint="Last Updated By" />
								</uForm:fieldset>
							</uForm:form>
						</cfcase>
					</cfswitch>
				</div>
			</div>
		</cfoutput>
	</cfif>
</cfif>