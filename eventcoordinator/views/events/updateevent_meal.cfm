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
			<cfinput type="hidden" name="Meal_Available" value="0">
			<cfinput type="hidden" name="Meal_Included" value="0">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Meal Option</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="Meal_Available" class="col-lg-5 col-md-5">Event Has Meal Availability:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.Meal_Available#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="Meal_Available" id="Meal_Available" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="Meal_Available" id="Meal_Available" value="1">
							</cfdefaultcase>
						</cfswitch>
						 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Event having meal availability)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="Meal_Included" class="col-lg-5 col-md-5">Meal Included in Price of Event:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.Meal_Included#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="Meal_Included" id="Meal_Included" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="Meal_Included" id="Meal_Included" value="1">
							</cfdefaultcase>
						</cfswitch>
						 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Include Meal Cost in Price of Event)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="Meal_Information" class="col-lg-5 col-md-5">Meal Information:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Meal_Information")>
							<textarea name="Meal_Information" id="Meal_Information" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.Meal_Information#</textarea>
						<cfelse>
							<textarea name="Meal_Information" id="Meal_Information" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.Meal_Information#</textarea>
						</cfif>
						<script>CKEDITOR.replace('Meal_Information', {
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
					<label for="Meal_Cost" class="col-lg-5 col-md-5">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Meal_Cost")>
							<cfinput type="text" class="form-control" id="Meal_Cost" name="Meal_Cost" value="#Session.FormInput.EventStep1.Meal_Cost#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="Meal_Cost" name="Meal_Cost" value="#Session.getSelectedEvent.Meal_Cost#" required="no">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="Meal_ProvidedBy" class="col-lg-5 col-md-5">Meal Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep2.Meal_ProvidedBy")>
							<cfselect name="Meal_ProvidedBy" class="form-control" Required="no" Multiple="No" query="Session.getActiveCaterers" value="TContent_ID" Display="FacilityName" selected="#Session.FormInput.EventStep2.Meal_ProvidedBy#" queryposition="below"><option value="----">Select Who Is Providing the Meal?</option></cfselect>
						<cfelse>
							<cfselect name="Meal_ProvidedBy" class="form-control" Required="no" Multiple="No" query="Session.getActiveCaterers" value="TContent_ID" Display="FacilityName" selected="#Session.getSelectedEvent.Meal_ProvidedBy#" queryposition="below"><option value="----">Select Who Is Providing the Meal?</option></cfselect>
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