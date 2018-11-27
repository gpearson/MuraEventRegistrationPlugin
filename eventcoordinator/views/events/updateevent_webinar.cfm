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
			<cfinput type="hidden" name="Webinar_Available" value="0">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Webinar Access Option</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="Webinar_Available" class="col-lg-5 col-md-5">Event Has Webinar Availability:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.Webinar_Available#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="Webinar_Available" id="Webinar_Available" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="Webinar_Available" id="Webinar_Available" value="1">
							</cfdefaultcase>
						</cfswitch>
						 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Event having H323 Distance Education Option)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="Webinar_ConnectInfo" class="col-lg-5 col-md-5">Webinar Connection Information:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Webinar_ConnectInfo")>
							<textarea name="Webinar_ConnectInfo" id="Webinar_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.Webinar_ConnectInfo#</textarea>
						<cfelse>
							<textarea name="Webinar_ConnectInfo" id="Webinar_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.Webinar_ConnectInfo#</textarea>
						</cfif>
						<script>CKEDITOR.replace('Webinar_ConnectInfo', {
							// Define the toolbar groups as it is a more accessible solution.
							toolbarGroups: [
								{"name":"basicstyles","groups":["basicstyles"]},
								{"name":"links","groups":["links"]},
								{"name":"paragraph","groups":["list","blocks"]},
								{"name":"document","groups":["mode"]},
								{"name":"insert","groups":["insert"]},
								{"name":"styles","groups":["styles"]},
								{"name":"about","groups":["about"]}
							],
							// Remove the redundant buttons from toolbar groups defined above.
							removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
						} );
						</script>
					</div>
				</div>
				<div class="form-group">
					<label for="Webinar_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Webinar_MemberCost")>
							<cfinput type="text" class="form-control" id="Webinar_MemberCost" name="Webinar_MemberCost" value="#Session.FormInput.EventStep1.Webinar_MemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
						<cfelse>
							<cfinput type="text" class="form-control" id="Webinar_MemberCost" name="Webinar_MemberCost" value="#Session.getSelectedEvent.Webinar_MemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="Webinar_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Webinar_NonMemberCost")>
							<cfinput type="text" class="form-control" id="Webinar_NonMemberCost" name="Webinar_NonMemberCost" value="#Session.FormInput.EventStep1.Webinar_NonMemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
						<cfelse>
							<cfinput type="text" class="form-control" id="Webinar_NonMemberCost" name="Webinar_NonMemberCost" value="#Session.getSelectedEvent.Webinar_NonMemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
						</cfif>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event"><br /><br />
				</div>
			</div>
		</cfform>
	</div>
</cfoutput>