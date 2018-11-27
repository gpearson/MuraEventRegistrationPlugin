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
	<script>
		$(function() {
			$("##EarlyBird_Deadline").datepick();
		});
	</script>
	<div class="panel panel-default">
		<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="GroupPrice_Available" value="0">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Group Pricing Discount</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="GroupPrice_Available" class="col-lg-5 col-md-5">Event Has Group Pricing Availability Discount:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.GroupPrice_Available#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="GroupPrice_Available" id="GroupPrice_Available" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="GroupPrice_Available" id="GroupPrice_Available" value="1">
							</cfdefaultcase>
						</cfswitch>
						 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Event Group Pricing Discount)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="GroupPrice_Requirements" class="col-lg-5 col-md-5">Group Price Requirements:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.GroupPrice_Requirements")>
							<textarea name="GroupPrice_Requirements" id="GroupPrice_Requirements" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.GroupPrice_Requirements#</textarea>
						<cfelse>
							<textarea name="GroupPrice_Requirements" id="GroupPrice_Requirements" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.GroupPrice_Requirements#</textarea>
						</cfif>
						<script>CKEDITOR.replace('GroupPrice_Requirements', {
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
					<label for="GroupPrice_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.GroupPrice_MemberCost")>
							<cfinput type="text" class="form-control" id="GroupPrice_MemberCost" name="GroupPrice_MemberCost" value="#Session.FormInput.EventStep1.GroupPrice_MemberCost#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="GroupPrice_MemberCost" name="GroupPrice_MemberCost" value="#Session.getSelectedEvent.GroupPrice_MemberCost#" required="no">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="GroupPrice_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.GroupPrice_NonMemberCost")>
							<cfinput type="text" class="form-control" id="GroupPrice_NonMemberCost" name="GroupPrice_NonMemberCost" value="#Session.FormInput.EventStep1.GroupPrice_NonMemberCost#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="GroupPrice_NonMemberCost" name="GroupPrice_NonMemberCost" value="#Session.getSelectedEvent.GroupPrice_NonMemberCost#" required="no">
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