<cfquery name="getAllCaterers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active, PaymentTerms, DeliveryInfo, GuaranteeInformation, AdditionalNotes
	From eCaterers
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
	Order by FacilityName ASC
</cfquery>

<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">

<cfif not isDefined("URL.PerformAction")>
	<cfoutput>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Catering Listing</h3>
			</div>
			<div class="art-blockcontent">
				<p class="alert-box notice">Please complete the following information to add a new caterer where meals are received for your events.</p>
				<hr>
				<table class="table table-striped" cellspacing="0" cellpadding="0">
					<thead>
						<tr>
							<th>Facility Name</th>
							<th>Address</th>
							<th>City</th>
							<th>State</th>
							<th>Zip Code</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="getAllFacilities">
							<tr>
							<td>#getAllFacilities.FacilityName#</td>
							<td>#getAllFacilities.PhysicalAddress#</td>
							<td>#getAllFacilities.PhysicalCity#</td>
							<td>#getAllFacilities.PhysicalState#</td>
							<td>#getAllFacilities.PhysicalZipCode#</td>
							<td width="110"><a href="#buildURL('admin:caterers.updatecaterer')#&PerformAction=Edit&RecNo=#getAllFacilities.TContent_ID#" class="btn btn-small">Edit</a>&nbsp;<a href="#buildURL('admin:caterers.updatecaterer')#&PerformAction=Delete&RecNo=#getAllFacilities.TContent_ID#" class="btn btn-small">Delete</a></td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.PerformAction")>
	<cfif not isNumeric(URL.RecNo)><cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:caterers" addtoken="false"></cfif>
	<cfswitch expression="#URL.PerformAction#">
		<cfcase value="Edit">
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructNew()#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.UserSuppliedInfo = #StructNew()#>
			</cflock>

			<cfquery name="getSelectedCaterer" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active, PaymentTerms, DeliveryInfo, GuaranteeInformation, AdditionalNotes
				From eCaterers
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
				Order by FacilityName ASC
			</cfquery>
			<cfoutput>
				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Update Catering Informationr</h3>
					</div>
					<div class="art-blockcontent">
						<p class="alert-box notice">Please complete the following information to update caterer's information</p>
						<hr>
						<uForm:form action="" method="Post" id="UpdateCaterer" errors="#Session.FormErrors#" errorMessagePlacement="both"
							commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
							cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:caterers&compactDisplay=false"
							submitValue="Update Caterer" loadValidation="true" loadMaskUI="true" loadDateUI="true"
							loadTimeUI="true">
							<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<input type="hidden" name="RecNo" value="#URL.RecNo#">
							<input type="hidden" name="formSubmit" value="true">
							<uForm:fieldset legend="Required Fields">
								<uForm:field label="Facility Name" name="FacilityName" isRequired="true" maxFieldLength="35" value="#getSelectedCaterer.FacilityName#" type="text" class="input-large" hint="Official Registered Business Name" />
								<uForm:field label="Physical Address" name="PhysicalAddress" isRequired="true" maxFieldLength="70" value="#getSelectedCaterer.PhysicalAddress#" type="text" hint="Business Physical Address" />
								<uForm:field label="Physical Address City" name="PhysicalCity" isRequired="true" maxFieldLength="70" value="#getSelectedCaterer.PhysicalCity#" type="text" hint="City of Physical Address" />
								<uForm:field label="Physical Address State" name="PhysicalState" isRequired="true" type="select" hint="State of Physical Address"><uForm:states-us defaultState="#getSelectedCaterer.PhysicalState#" /><uForm:states-can showSelect="false" /></uForm:field>
								<uForm:field label="Physical Address ZipCode" name="PhysicalZipCode" isRequired="true" value="#getSelectedCaterer.PhysicalZipCode#" maxFieldLength="5" type="text" hint="Zip Code of Physical Address" />
								<uForm:field type="custom">
									<div class="control-group">
										<label class="control-label" for="Active">Caterer Active</label>
										<div class="controls">
											<select name="Active"><option value="1" <cfif isDefined("Session.FormData.Active")><cfif Session.FormData.Active EQ 1>Selected</cfif></cfif>>Yes</option><option value="0" <cfif isDefined("Session.FormData.Active")><cfif Session.FormData.Active EQ 0>Selected</cfif></cfif>>No</option></select>
										</div>
									</div>
								</uForm:field>
							</uForm:fieldset>
							<uForm:fieldset legend="Optional Fields">
								<uForm:field label="Business Phone Number" name="PrimaryVoiceNumber" type="text" value="#getSelectedCaterer.PrimaryVoiceNumber#" maxFieldLength="14" hint="Primary Phone Number of Business" mask="(999) 999-9999" />
								<uForm:field label="Business Website" name="BusinessWebsite" type="text" value="#getSelectedCaterer.BusinessWebsite#" maxFieldLength="100" hint="Business Website, if any" />
								<uForm:field label="Payment Terms" name="PaymentTerms" type="textarea" value="#getSelectedCaterer.PaymentTerms#" hint="Payment Terms, if any" />
								<uForm:field label="Delivery Info" name="DeliveryInfo" type="textarea" value="#getSelectedCaterer.DeliveryInfo#" hint="Delivery Info, if any" />
								<uForm:field label="Guarantee Info" name="GuaranteeInformation" type="textarea" value="#getSelectedCaterer.GuaranteeInformation#" hint="Guarantee Info, if any" />
								<uForm:field label="Additional Notes" name="AdditionalNotes" type="textarea" value="#getSelectedCaterer.AdditionalNotes#" hint="Additional Notes, if any" />
							</uForm:fieldset>
							<uForm:fieldset legend="Contact Information">
								<uForm:field label="Contact Person" name="ContactName" type="text" value="#getSelectedCaterer.ContactName#" hint="Contact Person for Business" />
								<uForm:field label="Contact's Phone Number" name="ContactPhoneNumber" type="text" value="#getSelectedCaterer.ContactPhoneNumber#" hint="Contact Person's Phone Number" mask="(999) 999-9999" />
								<uForm:field label="Contact's Email Address" name="ContactEmail" type="text" value="#getSelectedCaterer.ContactEmail#" hint="Contact Person's Email Address" />
							</uForm:fieldset>
							<uForm:fieldset legend="Informational Fields">
								<uForm:field label="Date Created" name="dateCreated" type="text" isDisabled="true" value="#DateFormat(getSelectedCaterer.dateCreated, 'FULL')#" hint="Preferred Vendor Created Date" />
								<uForm:field label="Date Updated" name="lastUpdated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Preferred Vendor Last Updated" />
								<uForm:field label="Updated By" name="lastUpdateBy" type="text" isDisabled="true" value="#rc.$.currentUser('userName')#" hint="Preferred Vendor Last Updated By" />
							</uForm:fieldset>
							<uForm:fieldset legend="Address GeoCode">
								<uForm:field label="Address Verified" name="isAddressVerified" value="1" isChecked="#getSelectedCaterer.isAddressVerified EQ 1#" type="checkbox" isDisabled="true" />
								<uForm:field label="Address Latitude" name="GeoCode_Latitude" value="#getSelectedCaterer.GeoCode_Latitude#" type="text" isDisabled="true" />
								<uForm:field label="Address Longitude" name="GeoCode_Longitude" value="#getSelectedCaterer.GeoCode_Longitude#" type="text" isDisabled="true" />
								<uForm:field label="Address Township" name="GeoCode_Township" value="#getSelectedCaterer.GeoCode_Township#" type="text" isDisabled="true" />
								<uForm:field label="State Long Name" name="GeoCode_StateLongName" value="#getSelectedCaterer.GeoCode_StateLongName#" type="text" isDisabled="true" />
								<uForm:field label="Address County" name="GeoCode_CountryShortName" value="#getSelectedCaterer.GeoCode_CountryShortName#" type="text" isDisabled="true" />
								<uForm:field label="Address Neighborhood" name="GeoCode_Neighborhood" value="#getSelectedCaterer.GeoCode_Neighborhood#" type="text" isDisabled="true"  />
							</uForm:fieldset>
						</uForm:form>
					</div>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="ReEnterAddress">
			<cfquery name="getSelectedCaterer" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From eCaterers
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
				Order by FacilityName ASC
			</cfquery>
			<cfoutput>
				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Update Catering Informationr</h3>
					</div>
					<div class="art-blockcontent">
						<p class="alert-box notice">Please complete the following information to update caterer's information</p>
						<hr>
						<uForm:form action="" method="Post" id="UpdateFacilityRooms" errors="#Session.FormErrors#" errorMessagePlacement="both"
							commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
							cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:caterers&compactDisplay=false"
							submitValue="Update Facility" loadValidation="true" loadMaskUI="true" loadDateUI="true"
							loadTimeUI="true">
							<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<input type="hidden" name="RecNo" value="#URL.RecNo#">
							<input type="hidden" name="formSubmit" value="true">
							<input type="hidden" name="ReSubmit" value="true">
							<uForm:fieldset legend="Required Fields">
								<uForm:field label="Facility Name" name="FacilityName" isRequired="true" maxFieldLength="35" value="#Session.UserSuppliedInfo.FacilityName#" type="text" hint="Official Registered Business Name" />
								<uForm:field label="Physical Address" name="PhysicalAddress" isRequired="true" maxFieldLength="70" value="#Session.UserSuppliedInfo.PhysicalAddress#" type="text" hint="Business Physical Address" />
								<uForm:field label="Physical Address City" name="PhysicalCity" isRequired="true" maxFieldLength="70" value="#Session.UserSuppliedInfo.PhysicalCity#" type="text" hint="City of Physical Address" />
								<uForm:field label="Physical Address State" name="PhysicalState" isRequired="true" type="select" hint="State of Physical Address"><uForm:states-us defaultState="#Session.UserSuppliedInfo.PhysicalState#" /><uForm:states-can showSelect="false" /></uForm:field>
								<uForm:field label="Physical Address ZipCode" name="PhysicalZipCode" isRequired="true" value="#Session.UserSuppliedInfo.PhysicalZipCode#" maxFieldLength="5" type="text" hint="Zip Code of Physical Address" />
								<uForm:field type="custom">
									<div class="control-group">
										<label class="control-label" for="Active">Caterer Active</label>
										<div class="controls">
											<select name="Active"><option value="1" <cfif isDefined("Session.FormData.Active")><cfif Session.FormData.Active EQ 1>Selected</cfif></cfif>>Yes</option><option value="0" <cfif isDefined("Session.FormData.Active")><cfif Session.FormData.Active EQ 0>Selected</cfif></cfif>>No</option></select>
										</div>
									</div>
								</uForm:field>
							</uForm:fieldset>
							<uForm:fieldset legend="Optional Fields">
								<uForm:field label="Business Phone Number" name="PrimaryVoiceNumber" type="text" value="#Session.UserSuppliedInfo.PrimaryVoiceNumber#" maxFieldLength="14" hint="Primary Phone Number of Business" mask="(999) 999-9999" />
								<uForm:field label="Business Website" name="BusinessWebsite" type="text" value="#Session.UserSuppliedInfo.BusinessWebsite#" maxFieldLength="100" hint="Business Website, if any" />
								<uForm:field label="Payment Terms" name="PaymentTerms" type="textarea" value="#Session.UserSuppliedInfo.PaymentTerms#" hint="Payment Terms, if any" />
								<uForm:field label="Delivery Info" name="DeliveryInfo" type="textarea" value="#Session.UserSuppliedInfo.DeliveryInfo#" hint="Delivery Info, if any" />
								<uForm:field label="Guarantee Info" name="GuaranteeInformation" type="textarea" value="#Session.UserSuppliedInfo.GuaranteeInformation#" hint="Guarantee Info, if any" />
								<uForm:field label="Additional Notes" name="AdditionalNotes" type="textarea" value="#Session.UserSuppliedInfo.AdditionalNotes#" hint="Additional Notes, if any" />
							</uForm:fieldset>
							<uForm:fieldset legend="Contact Information">
								<uForm:field label="Contact Person" name="ContactName" type="text" value="#Session.UserSuppliedInfo.ContactName#" hint="Contact Person for Business" />
								<uForm:field label="Contact's Phone Number" name="ContactPhoneNumber" type="text" value="#Session.UserSuppliedInfo.ContactPhoneNumber#" hint="Contact Person's Phone Number" mask="(999) 999-9999" />
								<uForm:field label="Contact's Email Address" name="ContactEmail" type="text" value="#Session.UserSuppliedInfo.ContactEmail#" hint="Contact Person's Email Address" />
							</uForm:fieldset>
							<uForm:fieldset legend="Informational Fields">
								<uForm:field label="Date Created" name="dateCreated" type="text" isDisabled="true" value="#DateFormat(getSelectedFacility.dateCreated, 'FULL')#" hint="Preferred Vendor Created Date" />
								<uForm:field label="Date Updated" name="lastUpdated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Preferred Vendor Last Updated" />
								<uForm:field label="Updated By" name="lastUpdateBy" type="text" isDisabled="true" value="#rc.$.currentUser('userName')#" hint="Preferred Vendor Last Updated By" />
							</uForm:fieldset>
							<uForm:fieldset legend="Address GeoCode">
								<uForm:field label="Address Verified" name="isAddressVerified" value="1" isChecked="#getSelectedFacility.isAddressVerified EQ 1#" type="checkbox" isDisabled="true" />
								<uForm:field label="Address Latitude" name="GeoCode_Latitude" value="#getSelectedFacility.GeoCode_Latitude#" type="text" isDisabled="true" />
								<uForm:field label="Address Longitude" name="GeoCode_Longitude" value="#getSelectedFacility.GeoCode_Longitude#" type="text" isDisabled="true" />
								<uForm:field label="Address Township" name="GeoCode_Township" value="#getSelectedFacility.GeoCode_Township#" type="text" isDisabled="true" />
								<uForm:field label="State Long Name" name="GeoCode_StateLongName" value="#getSelectedFacility.GeoCode_StateLongName#" type="text" isDisabled="true" />
								<uForm:field label="Address County" name="GeoCode_CountryShortName" value="#getSelectedFacility.GeoCode_CountryShortName#" type="text" isDisabled="true" />
								<uForm:field label="Address Neighborhood" name="GeoCode_Neighborhood" value="#getSelectedFacility.GeoCode_Neighborhood#" type="text" isDisabled="true"  />
							</uForm:fieldset>
						</uForm:form>
					</div>
				</div>
			</cfoutput>
		</cfcase>
		<cfcase value="Delete">
			<cfquery name="DeActivateCaterer" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update eCaterers
				Set Active = 0, lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
				Where TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:caterers&UserAction=DeleteFacility&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
		</cfcase>
	</cfswitch>
</cfif>