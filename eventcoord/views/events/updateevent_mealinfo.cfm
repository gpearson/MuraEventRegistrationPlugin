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
			<h3 class="t">Add New Caterer</h3>
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
				<input type="hidden" name="PerformAction" value="UpdateEvent">
				<uForm:fieldset legend="Event Meal Information">
					<uform:field label="Meal Provided" name="MealProvided" type="select" hint="Does this event have a meal available to attendee(s)?">
						<cfif isDefined("Session.UserSuppliedInfo.MealProvided")>
							<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Cost Per Person " name="MealCost_Estimated" isRequired="false" Value="#NumberFormat('0.00', '999.99')#" type="text" hint="The estimated cost per person for providing this meal." />
					<uform:field label="Meal Provided By" name="MealProvidedBy" type="select" isRequired="true" hint="Which Caterer is providing this meal?">
					<cfif getCatererInformation.RecordCount EQ 0>
						<uform:option display="Please Add Caterer to System First" value="0" isSelected="true" />
					<cfelse>
						<cfif isDefined("Session.UserSuppliedInfo.MealProvidedBy")>
							<uform:option display="Vendor/Speaker Provided Meal for Event" value="0" />
							<cfloop query="getCatererInformation">
								<cfif isDefined("Session.UserSuppliedInfo.MealProvidedBy")>
									<cfif #getCatererInformation.TContent_ID# EQ #Session.UserSuppliedInfo.MealProvidedBy#>
										<uform:option display="#getCatererInformation.FacilityName#" value="#getCatererInformation.TContent_ID#" isSelected="True" />
									<cfelse>
										<uform:option display="#getCatererInformation.FacilityName#" value="#getCatererInformation.TContent_ID#" />
									</cfif>
								<cfelse>
									<uform:option display="#getCatererInformation.FacilityName#" value="#getCatererInformation.TContent_ID#" />
								</cfif>
							</cfloop>
						<cfelse>
							<uform:option display="Vendor/Speaker Provided Meal for Event" value="0" isSelected="true" />
							<cfloop query="getCatererInformation">
								<uform:option display="#getCatererInformation.FacilityName#" value="#getCatererInformation.TContent_ID#" />
							</cfloop>
						</cfif>
					</cfif>
					</uform:field>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>