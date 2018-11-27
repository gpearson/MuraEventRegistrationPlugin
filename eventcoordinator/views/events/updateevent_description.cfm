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
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Descriptions</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="ShortTitle" class="col-lg-5 col-md-5">Short Title:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.ShortTitle")>
							<cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.FormInput.EventStep1.ShortTitle#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.getSelectedEvent.ShortTitle#" required="no">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="LongDescription" class="col-lg-5 col-md-5">Description:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.LongDescription")>
							<textarea name="LongDescription" id="LongDescription" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.LongDescription#</textarea>
						<cfelse>
							<textarea name="LongDescription" id="LongDescription" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.LongDescription#</textarea>
						</cfif>
						<script>CKEDITOR.replace('LongDescription', {
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
					<label for="EventAgenda" class="col-lg-5 col-md-5">Agenda:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.EventAgenda")>
							<textarea name="EventAgenda" id="EventAgenda" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.EventAgenda#</textarea>
						<cfelse>
							<textarea name="EventAgenda" id="EventAgenda" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.EventAgenda#</textarea>
						</cfif>
						<script>CKEDITOR.replace('EventAgenda', {
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
					<label for="EventTargetAudience" class="col-lg-5 col-md-5">Target Audience:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.EventTargetAudience")>
							<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.EventTargetAudience#</textarea>
						<cfelse>
							<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.EventTargetAudience#</textarea>
						</cfif>
						<script>CKEDITOR.replace('EventTargetAudience', {
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
					<label for="EventStrategies" class="col-lg-5 col-md-5">Strategies:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.EventStrategies")>
							<textarea name="EventStrategies" id="EventStrategies" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.EventStrategies#</textarea>
						<cfelse>
							<textarea name="EventStrategies" id="EventStrategies" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.EventStrategies#</textarea>
						</cfif>
						<script>CKEDITOR.replace('EventStrategies', {
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
					<label for="EventSpecialInstructions" class="col-lg-5 col-md-5">Special Instructions:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.EventSpecialInstructions")>
							<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.EventSpecialInstructions#</textarea>
						<cfelse>
							<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.EventSpecialInstructions#</textarea>
						</cfif>
						<script>CKEDITOR.replace('EventSpecialInstructions', {
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
					<label for="Event_SpecialMessage" class="col-lg-5 col-md-5">Special Alert Message:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Event_SpecialMessage")>
							<textarea name="Event_SpecialMessage" id="Event_SpecialMessage" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.Event_SpecialMessage#</textarea>
						<cfelse>
							<textarea name="Event_SpecialMessage" id="Event_SpecialMessage" class="form-control form-control-lg" cols="80" rows="10">#Session.getSelectedEvent.Event_SpecialMessage#</textarea>
						</cfif>
						<script>CKEDITOR.replace('Event_SpecialMessage', {
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
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event"><br /><br />
				</div>
			</div>
		</cfform>
	</div>
</cfoutput>