<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cfquery name="getAllCaterers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, PaymentTerms, DeliveryInfo, GuaranteeInformation, AdditionalNotes
	From eCaterers
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
						<div class="alert-box error">
							<p>An Error has occurred in the database. Please try your request again.</p>
						</div>
						<cfdump var="#Session#">
					</cfcase>
				</cfswitch>
			</cfcase>
			<cfcase value="true">
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="AddedCaterers">
							<div class="alert-box success">
								<p>You have successfully added a new caterer to the database.</p>
							</div>
						</cfcase>
						<cfcase value="UpdatedFacility">
							<div class="alert-box success">
								<p>You have successfully updated a caterer in the database.</p>
							</div>
						</cfcase>
						<cfcase value="DeleteFacility">
							<div class="alert-box success">
								<p>You have successfully removed a caterer from the database.</p>
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
				<th>Facility Name</th>
				<th>Address</th>
				<th>City</th>
				<th>State</th>
				<th>Zip Code</th>
				<th width="100">Actions</th>
			</tr>
		</thead>
		<cfif getAllCaterers.RecordCount>
			<tfoot>
				<tr>
					<td colspan="6">Add new Catering Business not listed above by clicking <a href="#buildURL('eventcoord:caterers.addcaterer')#" class="art-button">here</a></td>
				</tr>
			</tfoot>
			<tbody>
				<cfloop query="getAllCaterers">
					<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
					<td>#getAllCaterers.FacilityName#</td>
					<td>#getAllCaterers.PhysicalAddress#</td>
					<td>#getAllCaterers.PhysicalCity#</td>
					<td>#getAllCaterers.PhysicalState#</td>
					<td>#getAllCaterers.PhysicalZipCode#</td>
					<td><a href="#buildURL('eventcoord:caterers.updatecaterer')#&PerformAction=Edit&RecNo=#getAllCaterers.TContent_ID#" class="btn btn-warning btn-small">U</a>&nbsp;<a href="#buildURL('eventcoord:caterers.updatecaterer')#&PerformAction=Delete&RecNo=#getAllCaterers.TContent_ID#" class="btn btn-danger btn-small">D</a></td>
					</tr>
				</cfloop>
			</tbody>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="6"><div align="center" class="alert-box notice">No Catering Business has been added to this website. Please click <a href="#buildURL('eventcoord:caterers.addcaterer')#" class="art-button">here</a> to add a new catering business.</div></td>
				</tr>
			</tbody>
		</cfif>
	</table>
</cfoutput>