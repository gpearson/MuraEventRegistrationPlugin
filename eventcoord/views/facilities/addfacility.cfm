<cfsilent>
<!---

--->
</cfsilent>

<cfimport taglib="/properties/uniForm/tags/" prefix="uForm">

<cfif not isDefined("URL.PerformAction")>
	<cflock timeout="60" scope="SESSION" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.UserSuppliedInfo = #StructNew()#>
	</cflock>
	<cfoutput>
		<h2>Add New Facility</h2>
		<p class="well">Please complete the following information to add a new facility where events can be held.</p>
		<hr>
		<uForm:form action="" method="Post" id="AddFacility" errors="#Session.FormErrors#" errorMessagePlacement="both"
			commonassetsPath="/properties/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
			cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facilities&compactDisplay=false"
			submitValue="Add Facility" loadValidation="true" loadMaskUI="true" loadDateUI="true"
			loadTimeUI="true">
			<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<input type="hidden" name="formSubmit" value="true">
			<uForm:fieldset legend="Required Fields">
				<uForm:field label="Facility Name" name="FacilityName" isRequired="true" maxFieldLength="35" type="text" hint="Official Registered Business Name" />
				<uForm:field label="Physical Address" name="PhysicalAddress" isRequired="true" maxFieldLength="70" type="text" hint="Business Physical Address" />
				<uForm:field label="Physical Address City" name="PhysicalCity" isRequired="true" maxFieldLength="70" type="text" hint="City of Physical Address" />
				<uForm:field label="Physical Address State" name="PhysicalState" isRequired="true" type="select" hint="State of Physical Address"><uForm:states-us /><uForm:states-can showSelect="false" /></uForm:field>
				<uForm:field label="Physical Address ZipCode" name="PhysicalZipCode" isRequired="true" maxFieldLength="5" type="text" hint="Zip Code of Physical Address" />
				<uform:field label="Facility Type" name="FacilityType" type="select" hint="Type of Facility for meeting location?">
					<uform:option display="Location is a Business" value="B" isSelected="true" />
					<uform:option display="Location is a School" value="S" />
				</uform:field>
			</uForm:fieldset><br /><br />
			<uForm:fieldset legend="Optional Fields">
				<uForm:field label="Business Phone Number" name="PrimaryVoiceNumber" type="text" maxFieldLength="14" hint="Primary Phone Number of Business" mask="(999) 999-9999" />
				<uForm:field label="Business Website" name="BusinessWebsite" type="text" maxFieldLength="100" hint="Business Website, if any" />
			</uForm:fieldset>
			<uForm:fieldset legend="Contact Information">
				<uForm:field label="Contact Person" name="ContactName" type="text" hint="Contact Person for Business" />
				<uForm:field label="Contact's Phone Number" name="ContactPhoneNumber" type="text" hint="Contact Person's Phone Number" mask="(999) 999-9999" />
				<uForm:field label="Contact's Email Address" name="ContactEmail" type="text" hint="Contact Person's Email Address" />
			</uForm:fieldset>
			<uForm:fieldset legend="Informational Fields">
				<uForm:field label="Date Created" name="dateCreated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Preferred Vendor Created Date" />
				<uForm:field label="Date Updated" name="lastUpdated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Preferred Vendor Last Updated" />
				<uForm:field label="Updated By" name="lastUpdateBy" type="text" isDisabled="true" value="#rc.$.currentUser('userName')#" hint="Preferred Vendor Last Updated By" />
			</uForm:fieldset>
			<uForm:fieldset legend="Address GeoCode">
				<uForm:field label="Address Verified" name="isAddressVerified" type="text" isDisabled="true" hint="Address Verified by USPS" />
				<uForm:field label="Address Latitude" name="GeoCode_Latitude" type="text" isDisabled="true" hint="Address Latitude" />
				<uForm:field label="Address Longitude" name="GeoCode_Longitude" type="text" isDisabled="true" hint="Address Longitude" />
				<uForm:field label="Address Township" name="GeoCode_Township" type="text" isDisabled="true" hint="Addressed Township" />
				<uForm:field label="State Long Name" name="GeoCode_StateLongName" type="text" isDisabled="true" hint="State Long Name" />
				<uForm:field label="Address County" name="GeoCode_CountryShortName" type="text" isDisabled="true" hint="Address County" />
				<uForm:field label="Address Neighborhood" name="GeoCode_Neighborhood" type="text" isDisabled="true" hint="Address Neighborhood" />
			</uForm:fieldset>
		</uForm:form>
	</cfoutput>
<cfelseif isDefined("URL.PerformAction")>
	<cfoutput>
		<h2>Add New Facility</h2>
		<p class="well">Please complete the following information to add a new facility where events can be held.</p>
		<hr>
		<uForm:form action="" method="Post" id="AddFacility" errors="#Session.FormErrors#" errorMessagePlacement="both"
			commonassetsPath="/properties/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
			cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facilities&compactDisplay=false"
			submitValue="Add Facility" loadValidation="true" loadMaskUI="true" loadDateUI="true"
			loadTimeUI="true">
		<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
		<input type="hidden" name="formSubmit" value="true">
		<input type="hidden" name="ReSubmit" value="true">
		<uForm:fieldset legend="Required Fields">
			<uForm:field label="Facility Name" name="FacilityName" isRequired="true" type="text" value="#Session.UserSuppliedInfo.FacilityName#" hint="Official Registered Business Name" />
			<uForm:field label="Physical Address" name="PhysicalAddress" isRequired="true" type="text" value="#Session.UserSuppliedInfo.PhysicalAddress#" hint="Business Physical Address" />
			<uForm:field label="Physical Address City" name="PhysicalCity" isRequired="true" type="text" value="#Session.UserSuppliedInfo.PhysicalCity#" hint="City of Physical Address" />
			<uForm:field label="Physical Address State" name="PhysicalState" isRequired="true" type="select" hint="State of Physical Address"><uForm:states-us defaultState="#Session.UserSuppliedInfo.PhysicalState#" /><uForm:states-can showSelect="false" /></uForm:field>
			<uForm:field label="Physical Address ZipCode" name="PhysicalZipCode" isRequired="true" type="text" value="#Session.UserSuppliedInfo.PhysicalZipCode#" hint="Zip Code of Physical Address" />
			<uform:field label="Facility Type" name="FacilityType" type="select" hint="Type of Facility for meeting location?">
					<uform:option display="Location is a Business" value="B" isSelected="true" />
					<uform:option display="Location is a School" value="S" />
				</uform:field>
		</uForm:fieldset><br /><br />
		<uForm:fieldset legend="Optional Fields">
			<uForm:field label="Business Phone Number" name="PrimaryVoiceNumber" type="text" hint="Primary Phone Number of Business" mask="(999) 999-9999" />
			<uForm:field label="Business Website" name="BusinessWebsite" type="text" hint="Business Website, if any" />
		</uForm:fieldset>
		<uForm:fieldset legend="Contact Information">
			<uForm:field label="Contact Person" name="ContactName" type="text" hint="Contact Person for Business" />
			<uForm:field label="Contact's Phone Number" name="ContactPhoneNumber" type="text" hint="Contact Person's Phone Number" mask="(999) 999-9999" />
			<uForm:field label="Contact's Email Address" name="ContactEmail" type="text" hint="Contact Person's Email Address" />
		</uForm:fieldset>
		<uForm:fieldset legend="Informational Fields">
			<uForm:field label="Date Created" name="dateCreated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Preferred Vendor Created Date" />
			<uForm:field label="Date Updated" name="lastUpdated" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="Preferred Vendor Last Updated" />
			<uForm:field label="Updated By" name="lastUpdateBy" type="text" isDisabled="true" value="#rc.$.currentUser('userName')#" hint="Preferred Vendor Last Updated By" />
		</uForm:fieldset>
	</uForm:form>
</cfoutput>
</cfif>