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
<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfoutput>
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<script>
		$(function() {
			$("##EventDate").datepick();
			$("##Registration_Deadline").datepick();
			$('##Registration_BeginTime').timepicker({ 'scrollDefault': 'now' });
			$('##Event_StartTime').timepicker({ 'scrollDefault': 'now' });
			$('##Event_EndTime').timepicker({ 'scrollDefault': 'now' });
		});
	</script>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 1 of 3 - Add New Event/Workshop</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for it.</div>
					<fieldset>
						<legend><h2>Date and Time Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Primary Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventDate")>
								<cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#Session.FormInput.EventStep1.EventDate#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="EventDate" name="EventDate" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSpanDates" class="col-lg-5 col-md-5">Event has Multiple Dates:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventSpanDates")>
								<cfif Session.FormInput.EventStep1.EventSpandates EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="EventSpanDates" id="EventSpanDates" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="EventSpanDates" id="EventSpanDates" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventSpanDates" id="EventSpanDates" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Registration_Deadline" class="col-lg-5 col-md-5">Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Registration_Deadline")>
								<cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.FormInput.EventStep1.Registration_Deadline#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="col-lg-5 col-md-5">Registration Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Registration_BeginTime")>
								<cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#TimeFormat(Session.FormInput.EventStep1.Registration_BeginTime, 'hh:mm tt')#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="col-lg-5 col-md-5">Event Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_StartTime")>
								<cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#TimeFormat(Session.FormInput.EventStep1.Event_StartTime, 'hh:mm tt')#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="col-lg-5 col-md-5">Event End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_EndTime")>
								<cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#TimeFormat(Session.FormInput.EventStep1.Event_EndTime, 'hh:mm tt')#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" required="no">
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Description Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ShortTitle" class="col-lg-5 col-md-5">Short Title:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.ShortTitle")>
								<cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.FormInput.EventStep1.ShortTitle#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="col-lg-5 col-md-5">Description:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.LongDescription")>
								<textarea name="LongDescription" id="LongDescription" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.LongDescription#</textarea>
							<cfelse>
								<textarea name="LongDescription" id="LongDescription" class="form-control form-control-lg" cols="80" rows="10"></textarea>
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
								<textarea name="EventAgenda" id="EventAgenda" class="form-control form-control-lg" cols="80" rows="10"></textarea>
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
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control form-control-lg" cols="80" rows="10"></textarea>
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
								<textarea name="EventStrategies" id="EventStrategies" class="form-control form-control-lg" cols="80" rows="10"></textarea>
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
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control form-control-lg" cols="80" rows="10"></textarea>
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
					<fieldset>
						<legend><h2>Event At Location Pricing</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.MemberCost")>
								<cfinput type="text" class="form-control" id="MemberCost" name="MemberCost" value="#Session.FormInput.EventStep1.MemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
							<cfelse>
								<cfinput type="text" class="form-control" id="MemberCost" name="MemberCost" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.NonMemberCost")>
								<cfinput type="text" class="form-control" id="NonMemberCost" name="NonMemberCost" value="#Session.FormInput.EventStep1.NonMemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
							<cfelse>
								<cfinput type="text" class="form-control" id="NonMemberCost" name="NonMemberCost" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventCostPerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventCostPerDay")>
								<cfif Session.FormInput.EventStep1.EventCostPerDay EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="EventCostPerDay" id="EventCostPerDay" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="EventCostPerDay" id="EventCostPerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventCostPerDay" id="EventCostPerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Held At Location</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.LocationID")>
								<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilities" value="TContent_ID" Display="FacilityName" selected="#Session.FormInput.EventStep1.LocationID#"  queryposition="below"><option value="----">Select Location where Event will be held</option></cfselect>
							<cfelse>
								<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilities" value="TContent_ID" Display="FacilityName"  queryposition="below"><option value="----">Select Location where Event will be held</option></cfselect>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Presenter for this Event</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PresenterID" class="col-lg-5 col-md-5">Primary Event Presenter:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PresenterID")>
								<cfselect name="PresenterID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllPresenters" value="UserID" Display="DisplayName" selected="#Session.FormInput.EventStep1.PresenterID#"  queryposition="below"><option value="----">Select Primary Event Presenter</option></cfselect>
							<cfelse>
								<cfselect name="PresenterID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllPresenters" value="UserID" Display="DisplayName"  queryposition="below"><option value="----">Select Primary Event Presenter</option></cfselect>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Optional Features</h2></legend>
					</fieldset>
					<div class="alert alert-info">The default option for each one of the following is No unless you specifically select Yes on these questions.</div>
					<div class="form-group">
						<label for="EventHasOptionalCosts" class="col-lg-5 col-md-5">Event Has Optional Costs:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventHasOptionalCosts")>
								<cfif Session.FormInput.EventStep1.EventHasOptionalCosts EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="EventHasOptionalCosts" id="EventHasOptionalCosts" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Add Optional Costs to Registration Fee to Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="EventHasOptionalCosts" id="EventHasOptionalCosts" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Add Optional Costs to Registration Fee to Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventHasOptionalCosts" id="EventHasOptionalCosts" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Add Optional Costs to Registration Fee to Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventFeatured" class="col-lg-5 col-md-5">Event is Featured:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventFeatured")>
								<cfif Session.FormInput.EventStep1.EventFeatured EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="EventFeatured" id="EventFeatured" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="EventFeatured" id="EventFeatured" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventFeatured" id="EventFeatured" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventHaveSessions" class="col-lg-5 col-md-5">Event has Daily Sessions:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventHaveSessions")>
								<cfif Session.FormInput.EventStep1.EventHaveSessions EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="EventHaveSessions" id="EventHaveSessions" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="EventHaveSessions" id="EventHaveSessions" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventHaveSessions" id="EventHaveSessions" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="col-lg-5 col-md-5">Earlybird Registration Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable")>
								<cfif Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="EarlyBird_RegistrationAvailable" id="EarlyBird_RegistrationAvailable" checked value="1"> <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="EarlyBird_RegistrationAvailable" id="EarlyBird_RegistrationAvailable" value="1"> <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EarlyBird_RegistrationAvailable" id="EarlyBird_RegistrationAvailable" value="1"> <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="ViewGroupPricing" class="col-lg-5 col-md-5">Group Pricing Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.ViewGroupPricing")>
								<cfif Session.FormInput.EventStep1.ViewGroupPricing EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="ViewGroupPricing" id="ViewGroupPricing" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="ViewGroupPricing" id="ViewGroupPricing" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="ViewGroupPricing" id="ViewGroupPricing" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="PGPAvailable" class="col-lg-5 col-md-5">PGP Certificate Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PGPAvailable")>
								<cfif Session.FormInput.EventStep1.PGPAvailable EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="PGPAvailable" id="PGPAvailable" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="PGPAvailable" id="PGPAvailable" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PGPAvailable" id="PGPAvailable" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="MealAvailable" class="col-lg-5 col-md-5">Meal Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.MealAvailable")>
								<cfif Session.FormInput.EventStep1.MealAvailable EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="MealAvailable" id="MealAvailable" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="MealAvailable" id="MealAvailable" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="MealAvailable" id="MealAvailable" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="AllowVideoConference" class="col-lg-5 col-md-5">Is Distance Education Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.AllowVideoConference")>
								<cfif Session.FormInput.EventStep1.AllowVideoConference EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="AllowVideoConference" id="AllowVideoConference" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="AllowVideoConference" id="AllowVideoConference" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="AllowVideoConference" id="AllowVideoConference" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="WebinarEvent" class="col-lg-5 col-md-5">Webinar Only Event:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.WebinarEvent")>
								<cfif Session.FormInput.EventStep1.WebinarEvent EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="WebinarEvent" id="WebinarEvent" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="WebinarEvent" id="WebinarEvent" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="WebinarEvent" id="WebinarEvent" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div>
							</cfif>
						</div>
					</div>
					<cfif Session.SiteConfigSettings.Facebook_Enabled EQ 1>
						<div class="form-group">
						<label for="PostEventToFB" class="col-lg-5 col-md-5">Post to FB Fan Page:&nbsp;&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PostEventToFB")>
								<cfif Session.FormInput.EventStep1.PostEventToFB EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="PostEventToFB" id="PostEventToFB" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="PostEventToFB" id="PostEventToFB" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PostEventToFB" id="PostEventToFB" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div>
							</cfif>
						</div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.BillForNoShowRegistrations EQ 1>
						<div class="form-group">
						<label for="BillForNoSHow" class="col-lg-5 col-md-5">Bill For NoShow:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.BillForNoSHow")>
								<cfif Session.FormInput.EventStep1.BillForNoSHow EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="BillForNoSHow" id="BillForNoSHow" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to enable billing participants who do not show to this event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="BillForNoSHow" id="BillForNoSHow" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to enable billing participants who do not show to this event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="BillForNoSHow" id="BillForNoSHow" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to enable billing participants who do not show to this event)</div>
							</cfif>
						</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Events Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed to Step 2"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<cfif isDefined("Session.FormErrors")>
					<cfif ArrayLen(Session.FormErrors)>
						<div id="modelWindowDialog" class="modal fade">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
										<h3>Missing Information</h3>
									</div>
									<div class="modal-body">
										<p class="alert alert-danger">#Session.FormErrors[1].Message#</p>
									</div>
									<div class="modal-footer">
										<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
									</div>
								</div>
							</div>
						</div>
						<script type='text/javascript'>
							(function() {
								'use strict';
								function remoteModal(idModal){
									var vm = this;
									vm.modal = $(idModal);
									if( vm.modal.length == 0 ) { return false; } else { openModal(); }
									if( window.location.hash == idModal ){ openModal(); }
									var services = { open: openModal, close: closeModal };
									return services;
									function openModal(){
										vm.modal.modal('show');
									}
									function closeModal(){
										vm.modal.modal('hide');
									}
								}
								Window.prototype.remoteModal = remoteModal;
							})();
							$(function(){
								window.remoteModal('##modelWindowDialog');
							});
						</script>
					</cfif>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 1 of 3 - Add New Event/Workshop</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for it.</div>
					<fieldset>
						<legend><h2>Date and Time Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Primary Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#Session.FormInput.EventStep1.EventDate#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventSpanDates" class="col-lg-5 col-md-5">Event has Multiple Dates:&nbsp;</label>
						<div class="col-sm-7">
							<cfif Session.FormInput.EventStep1.EventSpanDates EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EventSpanDates" id="EventSpanDates" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventSpanDates" id="EventSpanDates" value="1">
							</cfif> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div></div>
					</div>
					<div class="form-group">
						<label for="Registration_Deadline" class="col-lg-5 col-md-5">Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.FormInput.EventStep1.Registration_Deadline#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="col-lg-5 col-md-5">Registration Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#TimeFormat(Session.FormInput.EventStep1.Registration_BeginTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="col-lg-5 col-md-5">Event Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#TimeFormat(Session.FormInput.EventStep1.Event_StartTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="col-lg-5 col-md-5">Event End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#TimeFormat(Session.FormInput.EventStep1.Event_EndTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Event Description Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ShortTitle" class="col-lg-5 col-md-5">Short Title:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.FormInput.EventStep1.ShortTitle#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="col-lg-5 col-md-5">Description:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><textarea name="LongDescription" id="LongDescription" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.LongDescription#</textarea>
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
					<fieldset>
						<legend><h2>Additional Detail Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventAgenda" class="col-lg-5 col-md-5">Agenda:&nbsp;</label>
						<div class="col-sm-7"><textarea name="EventAgenda" id="EventAgenda" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.EventAgenda#</textarea>
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
						<div class="col-sm-7"><textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.EventTargetAudience#</textarea>
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
						<div class="col-sm-7"><textarea name="EventStrategies" id="EventStrategies" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.EventStrategies#</textarea>
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
						<div class="col-sm-7"><textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.EventSpecialInstructions#</textarea>
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
					<fieldset>
						<legend><h2>Event At Location Pricing</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="MemberCost" name="MemberCost" value="#Session.FormInput.EventStep1.MemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div></div>
					</div>
					<div class="form-group">
						<label for="NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="NonMemberCost" name="NonMemberCost" value="#Session.FormInput.EventStep1.NonMemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div></div>
					</div>
					<div class="form-group">
						<label for="EventCostPerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
						<div class="col-lg-2 col-md-2">&nbsp;</div>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.EventCostPerDay EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EventCostPerDay" id="EventCostPerDay" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventCostPerDay" id="EventCostPerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Held At Location</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-7">
							<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilities" selected="#Session.FormInput.EventStep1.LocationID#" value="TContent_ID" Display="FacilityName"  queryposition="below">
								<option value="----">Select Location where Event will be held</option>
							</cfselect>
						</div>
					</div>
					<fieldset>
						<legend><h2>Presenter for this Event</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PresenterID" class="col-lg-5 col-md-5">Primary Event Presenter:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PresenterID")>
								<cfselect name="PresenterID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllPresenters" value="UserID" Display="DisplayName" selected="#Session.FormInput.EventStep1.PresenterID#"  queryposition="below"><option value="----">Select Primary Event Presenter</option></cfselect>
							<cfelse>
								<cfselect name="PresenterID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllPresenters" value="UserID" Display="DisplayName"  queryposition="below"><option value="----">Select Primary Event Presenter</option></cfselect>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Optional Features</h2></legend>
					</fieldset>
					<div class="alert alert-info">The default option for each one of the following is No unless you specifically select Yes on these questions.</div>
					<div class="form-group">
						<label for="EventFeatured" class="col-lg-5 col-md-5">Event is Featured:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.EventFeatured EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EventFeatured" id="EventFeatured" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventFeatured" id="EventFeatured" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="EventHaveSessions" class="col-lg-5 col-md-5">Event has Daily Sessions:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.EventHaveSessions EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EventHaveSessions" id="EventHaveSessions" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventHaveSessions" id="EventHaveSessions" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="col-lg-5 col-md-5">Earlybird Registration Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EarlyBird_RegistrationAvailable" id="EarlyBird_RegistrationAvailable" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EarlyBird_RegistrationAvailable" id="EarlyBird_RegistrationAvailable" value="1">
							</cfif>
							 <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div></div>
					</div>
					<div class="form-group">
						<label for="ViewGroupPricing" class="col-lg-5 col-md-5">Group Pricing Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.ViewGroupPricing EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="ViewGroupPricing" id="ViewGroupPricing" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="ViewGroupPricing" id="ViewGroupPricing" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div></div>
					</div>
					<div class="form-group">
						<label for="PGPAvailable" class="col-lg-5 col-md-5">PGP Certificate Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.PGPAvailable EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="PGPAvailable" id="PGPAvailable" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PGPAvailable" id="PGPAvailable" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div></div>
					</div>
					<div class="form-group">
						<label for="MealAvailable" class="col-lg-5 col-md-5">Meal Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.MealAvailable EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="MealAvailable" id="MealAvailable" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="MealAvailable" id="MealAvailable" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div></div>
					</div>
					<div class="form-group">
						<label for="AllowVideoConference" class="col-lg-5 col-md-5">Is Distance Education Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.AllowVideoConference EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="AllowVideoConference" id="AllowVideoConference" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="AllowVideoConference" id="AllowVideoConference" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div></div>
					</div>
					<div class="form-group">
						<label for="WebinarEvent" class="col-lg-5 col-md-5">Webinar Only Event:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.WebinarEvent EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="WebinarEvent" id="WebinarEvent" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="WebinarEvent" id="WebinarEvent" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div></div>
					</div>
					<cfif Session.SiteConfigSettings.Facebook_Enabled EQ 1>
						<div class="form-group">
						<label for="PostEventToFB" class="col-lg-5 col-md-5">Post to FB Fan Page:&nbsp;&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.PostEventToFB EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="PostEventToFB" id="PostEventToFB" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PostEventToFB" id="PostEventToFB" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div></div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.BillForNoShowRegistrations EQ 1>
						<div class="form-group">
						<label for="BillForNoSHow" class="col-lg-5 col-md-5">Bill For NoShow:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.BillForNoSHow EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="BillForNoSHow" id="BillForNoSHow" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="BillForNoSHow" id="BillForNoSHow" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to enable billing participants who do not show to this event)</div></div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Events Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed to Step 2"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
