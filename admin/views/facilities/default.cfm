<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cfquery name="getAllFacilities" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, USPS_CarrierRoute, USPS_CheckDigit, USPS_DeliveryPoint, PhysicalLocationCountry, PhysicalCountry
	From eFacility
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Active = 1
	Order by FacilityName ASC
</cfquery>

<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfset Session.FormErrors = #ArrayNew()#>
	<cfset Session.UserSuppliedInfo = #structNew()#>
</cflock>

<cfoutput>
	<cfif isDefined("URL.Successful")>
		<cfswitch expression="#URL.Successful#">
			<cfcase value="false">
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="ErrorDatabase">
						<div class="alert-box success">
							<p>An Error has occurred in the database. Please try your request again.</p>
						</div>
						<cfdump var="#Session#">
					</cfcase>
				</cfswitch>
			</cfcase>
			<cfcase value="true">
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="AddFacilityRoom">
							<div class="alert-box success">
								<p>You have successfully added a new facility room to {Name of Facility}</p>
							</div>
						</cfcase>
						<cfcase value="AddedFacility">
							<div class="alert-box success">
								<p>You have successfully added a new facility to the database.</p>
							</div>
						</cfcase>
						<cfcase value="UpdatedFacility">
							<div class="alert-box success">
								<p>You have successfully updated a facility in the database.</p>
							</div>
						</cfcase>
						<cfcase value="DeleteFacility">
							<div class="alert-box success">
								<p>You have successfully removed a facility from the database.</p>
							</div>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfif>
	<table class="art-article" style="width:100%;">
		<thead>
			<tr>
				<td>Facility Name</td>
				<td>Address</td>
				<td>City</td>
				<td>State</td>
				<td>ZipCode</td>
				<td>Actions</td>
			</tr>
		</thead>
		<cfif getAllFacilities.RecordCount>
			<tfoot>
				<tr>
					<td colspan="6">Add a new Facility for an upcoming event that is not listed above by clicking <a href="#buildURL('admin:facilities.addfacility')#" class="art-button">here</a></td>
				</tr>
			</tfoot>
			<tbody>
				<cfloop query="getAllFacilities">
					<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
						<td>#getAllFacilities.FacilityName#</td>
						<td>#getAllFacilities.PhysicalAddress#</td>
						<td>#getAllFacilities.PhysicalCity#</td>
						<td>#getAllFacilities.PhysicalState#</td>
						<td>#getAllFacilities.PhysicalZipCode#</td>
						<td><a href="#buildURL('admin:facilities.updatefacility')#&PerformAction=Edit&RecNo=#getAllFacilities.TContent_ID#" class="art-button">Update</a>&nbsp;&nbsp;<a href="#buildURL('admin:facilities.updatefacility')#&PerformAction=Delete&RecNo=#getAllFacilities.TContent_ID#" class="art-button">D</a>&nbsp;&nbsp;<a href="#buildURL('admin:facilities.managerooms')#&RecNo=#getAllFacilities.TContent_ID#" class="art-button">Rooms</a></td>
					</tr>
				</cfloop>
			</tbody>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="6"><div align="center" class="alert-box notice">No Facilities are located within the database Please click <a href="#buildURL('admin:facilities.addfacility')#" class="art-button">here</a> to add one.</div></td>
				</tr>
			</tbody>
		</cfif>
	</table>
</cfoutput>