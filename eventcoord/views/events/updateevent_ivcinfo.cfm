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
				<uForm:fieldset legend="Event Interactive Video Conference Information">
					<uform:field label="Allow Video Conference" name="AllowVideoConference" type="select" hint="Can an attendee participate with Video Conference (IP Video)?">
						<cfif isDefined("Session.UserSuppliedInfo.AllowVideoConference")>
							<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1>
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
					<uform:field label="Video Conference Details" name="VideoConferenceInfo" isRequired="false" type="textarea" value="#Session.UserSuppliedInfo.VideoConferenceInfo#" hint="Information about Video Conference that participants need to know to be able to connect." />
					<uform:field label="Video Confernece Cost" name="VideoConferenceCost" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.VideoConferenceCost, '9999.99')#" isRequired="true" hint="What are the costs for a participant to attend via video conference" />
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>