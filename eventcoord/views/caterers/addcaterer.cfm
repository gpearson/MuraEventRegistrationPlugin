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
		<div class="container-fluid">
			<div class="row-fluid">
				<div class="span12">
					<h2>Add New Caterer</h2>
					<p class="well">Please complete the following information to add a new caterer where meals are received for your events.</p>
					<hr>
					<uForm:form action="" method="Post" id="AddCaterer" errors="#Session.FormErrors#" errorMessagePlacement="both"
						commonassetsPath="/properties/uniForm/"
						showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
						cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:caterers&compactDisplay=false"
						submitValue="Add Caterer" loadValidation="true" loadMaskUI="true" loadDateUI="true"
						loadTimeUI="true">
						<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
						<input type="hidden" name="formSubmit" value="true">
						<uForm:fieldset legend="Required Fields">
							<uForm:field label="Facility Name" name="FacilityName" isRequired="true" maxFieldLength="35" type="text" hint="Official Registered Business Name" />
							<uForm:field label="Physical Address" name="PhysicalAddress" isRequired="true" maxFieldLength="70" type="text" hint="Business Physical Address" />
							<uForm:field label="Physical Address City" name="PhysicalCity" isRequired="true" maxFieldLength="70" type="text" hint="City of Physical Address" />
							<uForm:field label="Physical Address State" name="PhysicalState" isRequired="true" type="select" hint="State of Physical Address"><uForm:states-us /><uForm:states-can showSelect="false" /></uForm:field>
							<uForm:field label="Physical Address ZipCode" name="PhysicalZipCode" isRequired="true" maxFieldLength="5" type="text" hint="Zip Code of Physical Address" />
						</uForm:fieldset>
						<uForm:fieldset legend="Optional Fields">
							<uForm:field label="Business Phone Number" name="PrimaryVoiceNumber" type="text" maxFieldLength="14" hint="Primary Phone Number of Business" mask="(999) 999-9999" />
							<uForm:field label="Business Website" name="BusinessWebsite" type="text" maxFieldLength="100" hint="Business Website, if any" />
							<uForm:field label="Payment Terms" name="PaymentTerms" type="textarea" maxFieldLength="100" hint="Payment Terms, if any" />
							<uForm:field label="Delivery Info" name="DeliveryInfo" type="textarea" maxFieldLength="100" hint="Delivery Info, if any" />
							<uForm:field label="Guarantee Info" name="GuaranteeInformation" type="textarea" maxFieldLength="100" hint="Guarantee Info, if any" />
							<uForm:field label="Additional Notes" name="AdditionalNotes" type="textarea" maxFieldLength="100" hint="Additional Notes, if any" />
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
				</div>
			</div>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.PerformAction")>
	<cfoutput>
		<h2>Add New Caterer</h2>
		<p class="well">Please complete the following information to add a new caterer where meals are received for your events.</p>
		<hr>
		<uForm:form action="" method="Post" id="AddCaterer" errors="#Session.FormErrors#" errorMessagePlacement="both"
			commonassetsPath="/properties/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
			cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:caterers&compactDisplay=false"
			submitValue="Add Caterer" loadValidation="true" loadMaskUI="true" loadDateUI="true"
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
		</uForm:fieldset><br /><br />
		<uForm:fieldset legend="Optional Fields">
				<uForm:field label="Business Phone Number" name="PrimaryVoiceNumber" type="text" maxFieldLength="14" hint="Primary Phone Number of Business" mask="(999) 999-9999" />
				<uForm:field label="Business Website" name="BusinessWebsite" type="text" maxFieldLength="100" hint="Business Website, if any" />
				<uForm:field label="Payment Terms" name="PaymentTerms" type="textarea" maxFieldLength="100" hint="Payment Terms, if any" />
				<uForm:field label="Delivery Info" name="DeliveryInfo" type="textarea" maxFieldLength="100" hint="Delivery Info, if any" />
				<uForm:field label="Guarantee Info" name="GuaranteeInformation" type="textarea" maxFieldLength="100" hint="Guarantee Info, if any" />
				<uForm:field label="Additional Notes" name="AdditionalNotes" type="textarea" maxFieldLength="100" hint="Additional Notes, if any" />
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