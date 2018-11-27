<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
</cfsilent>
<cfoutput>
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<div class="panel panel-default">
		<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="PGPCertificate_Available" value="0">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Professional Growth Points</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="PGPCertificate_Available" class="col-lg-5 col-md-5">Event Has Professional Growth Points:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.PGPCertificate_Available#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="PGPCertificate_Available" id="PGPCertificate_Available" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="PGPCertificate_Available" id="PGPCertificate_Available" value="1">
							</cfdefaultcase>
						</cfswitch>
						 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Event to have Professional Growth Points)</div>
					</div>
				</div>
				<div class="form-group">
					<cfif Session.getSelectedEvent.EventPricePerDay EQ 1>
						<label for="PGPCertificate_Points" class="col-lg-5 col-md-5">Number of PGP Points Per Day:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PGPCertificate_Points")>
								<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" value="#Session.FormInput.EventStep1.PGPCertificate_Points#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Points are Per Event Date)</div>
							<cfelse>
								<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" value="#Session.getSelectedEvent.PGPCertificate_Points#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Points are Per Event Date)</div>
							</cfif>
						</div>
					<cfelse>
						<label for="PGPCertificate_Points" class="col-lg-5 col-md-5">Number of PGP Points Per Event:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PGPCertificate_Points")>
								<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" value="#Session.FormInput.EventStep1.PGPCertificate_Points#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Points are Per Event)</div>
							<cfelse>
								<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" value="#Session.getSelectedEvent.PGPCertificate_Points#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Points are Per Event)</div>
							</cfif>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event"><br /><br />
				</div>
			</div>
		</cfform>
	</div>
</cfoutput>