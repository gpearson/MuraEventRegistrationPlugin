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
				<cfinput type="hidden" name="FacilitatorID" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<cfinput type="hidden" name="BillForNoShow" value="0">
				<cfinput type="hidden" name="Event_HasMultipleDates" value="0">
				<cfinput type="hidden" name="Event_OptionalCosts" value="0">
				<cfinput type="hidden" name="Event_DailySessions" value="0">
				<cfinput type="hidden" name="Featured_Event" value="0">
				<cfinput type="hidden" name="EarlyBird_Available" value="0">
				<cfinput type="hidden" name="GroupPrice_Available" value="0">
				<cfinput type="hidden" name="PGPCertificate_Available" value="0">
				<cfinput type="hidden" name="H323_Available" value="0">
				<cfinput type="hidden" name="Meal_Available" value="0">
				<cfinput type="hidden" name="Webinar_Available" value="0">
				<cfinput type="hidden" name="PostedTo_Facebook" value="0">
				<cfinput type="hidden" name="PostedTo_Twitter" value="0">
				<cfinput type="hidden" name="EventPricePerDay" value="0">
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
						<label for="Event_HasMultipleDates" class="col-lg-5 col-md-5">Event has Multiple Dates:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_HasMultipleDates")>
								<cfif Session.FormInput.EventStep1.Event_HasMultipleDates EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="Event_HasMultipleDates" id="Event_HasMultipleDates" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="Event_HasMultipleDates" id="Event_HasMultipleDates" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Event_HasMultipleDates" id="Event_HasMultipleDates" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div>
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
					<div class="form-group">
						<label for="Event_SpecialMessage" class="col-lg-5 col-md-5">Special Alert Message:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_SpecialMessage")>
								<textarea name="Event_SpecialMessage" id="Event_SpecialMessage" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.Event_SpecialMessage#</textarea>
							<cfelse>
								<textarea name="Event_SpecialMessage" id="Event_SpecialMessage" class="form-control form-control-lg" cols="80" rows="10"></textarea>
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
					<fieldset>
						<legend><h2>Event At Location Pricing</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_MemberCost")>
								<cfinput type="text" class="form-control" id="Event_MemberCost" name="Event_MemberCost" value="#Session.FormInput.EventStep1.Event_MemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
							<cfelse>
								<cfinput type="text" class="form-control" id="Event_MemberCost" name="Event_MemberCost" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Event_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_NonMemberCost")>
								<cfinput type="text" class="form-control" id="Event_NonMemberCost" name="Event_NonMemberCost" value="#Session.FormInput.EventStep1.Event_NonMemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
							<cfelse>
								<cfinput type="text" class="form-control" id="Event_NonMemberCost" name="Event_NonMemberCost" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventPricePerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventPricePerDay")>
								<cfif Session.FormInput.EventStep1.EventPricePerDay EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Held At Location</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_HeldAtFacilityID" class="col-lg-5 col-md-5">Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_HeldAtFacilityID")>
								<cfselect name="Event_HeldAtFacilityID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilities" value="TContent_ID" Display="FacilityName" selected="#Session.FormInput.EventStep1.Event_HeldAtFacilityID#"  queryposition="below"><option value="----">Select Location where Event will be held</option></cfselect>
							<cfelse>
								<cfselect name="Event_HeldAtFacilityID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilities" value="TContent_ID" Display="FacilityName"  queryposition="below"><option value="----">Select Location where Event will be held</option></cfselect>
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
						<legend><h2>Estimated Workshop/Event Expenses</h2></legend>
					</fieldset>
					<div class="alert alert-info">Enter the estimated expenses for this event to generate a break even amount for this event.</div>
					<div class="form-group">
						<label for="WhatIf_MealCostPerAttendee" class="col-lg-5 col-md-5">Estimated Meal Cost Per Attendee:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.WhatIf_MealCostPerAttendee")>
								<cfinput type="text" class="form-control" id="WhatIf_MealCostPerAttendee" name="WhatIf_MealCostPerAttendee" value="#Session.FormInput.EventStep1.WhatIf_MealCostPerAttendee#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="WhatIf_MealCostPerAttendee" name="WhatIf_MealCostPerAttendee" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="WhatIf_PresenterCostTotal" class="col-lg-5 col-md-5">Estimated Total Presenter Costs:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.WhatIf_PresenterCostTotal")>
								<cfinput type="text" class="form-control" id="WhatIf_PresenterCostTotal" name="WhatIf_PresenterCostTotal" value="#Session.FormInput.EventStep1.WhatIf_PresenterCostTotal#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="WhatIf_PresenterCostTotal" name="WhatIf_PresenterCostTotal" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="WhatIf_FacilityCostTotal" class="col-lg-5 col-md-5">Estimated Total Facility Costs:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.WhatIf_FacilityCostTotal")>
								<cfinput type="text" class="form-control" id="WhatIf_FacilityCostTotal" name="WhatIf_FacilityCostTotal" value="#Session.FormInput.EventStep1.WhatIf_FacilityCostTotal#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="WhatIf_FacilityCostTotal" name="WhatIf_FacilityCostTotal" required="no">
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Optional Features</h2></legend>
					</fieldset>
					<div class="alert alert-info">The default option for each one of the following is No unless you specifically select Yes on these questions.</div>
					<div class="form-group">
						<label for="Event_OptionalCosts" class="col-lg-5 col-md-5">Event Has Optional Costs:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_OptionalCosts")>
								<cfif Session.FormInput.EventStep1.Event_OptionalCosts CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="Event_OptionalCosts" id="Event_OptionalCosts" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Add Optional Costs to Registration Fee to Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="Event_OptionalCosts" id="Event_OptionalCosts" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Add Optional Costs to Registration Fee to Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Event_OptionalCosts" id="Event_OptionalCosts" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Add Optional Costs to Registration Fee to Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Featured_Event" class="col-lg-5 col-md-5">Event is Featured:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Featured_Event")>
								<cfif Session.FormInput.EventStep1.Featured_Event CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="Featured_Event" id="Featured_Event" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="Featured_Event" id="Featured_Event" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Featured_Event" id="Featured_Event" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Event_DailySessions" class="col-lg-5 col-md-5">Event has Daily Sessions:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_DailySessions")>
								<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="Event_DailySessions" id="Event_DailySessions" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="Event_DailySessions" id="Event_DailySessions" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Event_DailySessions" id="Event_DailySessions" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_Available" class="col-lg-5 col-md-5">Earlybird Registration Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.EarlyBird_Available")>
								<cfif Session.FormInput.EventStep1.EarlyBird_Available CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="EarlyBird_Available" id="EarlyBird_Available" checked value="1"> <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="EarlyBird_Available" id="EarlyBird_Available" value="1"> <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EarlyBird_Available" id="EarlyBird_Available" value="1"> <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="GroupPrice_Available" class="col-lg-5 col-md-5">Group Pricing Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.GroupPrice_Available")>
								<cfif Session.FormInput.EventStep1.GroupPrice_Available CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="GroupPrice_Available" id="GroupPrice_Available" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="GroupPrice_Available" id="GroupPrice_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="GroupPrice_Available" id="GroupPrice_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="PGPCertificate_Available" class="col-lg-5 col-md-5">PGP Certificate Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PGPCertificate_Available")>
								<cfif Session.FormInput.EventStep1.PGPCertificate_Available CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="PGPCertificate_Available" id="PGPCertificate_Available" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="PGPCertificate_Available" id="PGPCertificate_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PGPCertificate_Available" id="PGPCertificate_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Meal_Available" class="col-lg-5 col-md-5">Meal Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Meal_Available")>
								<cfif Session.FormInput.EventStep1.Meal_Available CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="Meal_Available" id="Meal_Available" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="Meal_Available" id="Meal_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Meal_Available" id="Meal_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="H323_Available" class="col-lg-5 col-md-5">Is Distance Education Available:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.H323_Available")>
								<cfif Session.FormInput.EventStep1.H323_Available CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="H323_Available" id="H323_Available" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="H323_Available" id="H323_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="H323_Available" id="H323_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Webinar_Available" class="col-lg-5 col-md-5">Webinar Only Event:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Webinar_Available")>
								<cfif Session.FormInput.EventStep1.Webinar_Available CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="Webinar_Available" id="Webinar_Available" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="Webinar_Available" id="Webinar_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Webinar_Available" id="Webinar_Available" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div>
							</cfif>
						</div>
					</div>
					<cfif Session.SiteConfigSettings.Facebook_Enabled EQ 1>
						<div class="form-group">
						<label for="PostedTo_Facebook" class="col-lg-5 col-md-5">Post to Facebook Fan Page:&nbsp;&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PostedTo_Facebook")>
								<cfif Session.FormInput.EventStep1.PostedTo_Facebook CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="PostedTo_Facebook" id="PostedTo_Facebook" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="PostedTo_Facebook" id="PostedTo_Facebook" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PostedTo_Facebook" id="PostedTo_Facebook" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div>
							</cfif>
						</div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.Twitter_Enabled EQ 1>
						<div class="form-group">
						<label for="PostedTo_Twitter" class="col-lg-5 col-md-5">Post to Twitter Handle:&nbsp;&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PostedTo_Twitter")>
								<cfif Session.FormInput.EventStep1.PostedTo_Twitter CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="PostedTo_Twitter" id="PostedTo_Twitter" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Companies Twitter Handle)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="PostedTo_Twitter" id="PostedTo_Twitter" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Companies Twitter Handle)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PostedTo_Twitter" id="PostedTo_Twitter" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Companies Twitter Handle)</div>
							</cfif>
						</div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.BillForNoShowRegistrations EQ 1>
						<div class="form-group">
						<label for="BillForNoShow" class="col-lg-5 col-md-5">Bill For NoShow:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.BillForNoShow")>
								<cfif Session.FormInput.EventStep1.BillForNoShow CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="BillForNoShow" id="BillForNoShow" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to enable billing participants who do not show to this event)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="BillForNoShow" id="BillForNoShow" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to enable billing participants who do not show to this event)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="BillForNoShow" id="BillForNoShow" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to enable billing participants who do not show to this event)</div>
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
				<cfinput type="hidden" name="FacilitatorID" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<cfinput type="hidden" name="BillForNoShow" value="0">
				<cfinput type="hidden" name="Event_HasMultipleDates" value="0">
				<cfinput type="hidden" name="Event_OptionalCosts" value="0">
				<cfinput type="hidden" name="Event_DailySessions" value="0">
				<cfinput type="hidden" name="Featured_Event" value="0">
				<cfinput type="hidden" name="EarlyBird_Available" value="0">
				<cfinput type="hidden" name="GroupPrice_Available" value="0">
				<cfinput type="hidden" name="PGPCertificate_Available" value="0">
				<cfinput type="hidden" name="H323_Available" value="0">
				<cfinput type="hidden" name="Meal_Available" value="0">
				<cfinput type="hidden" name="Webinar_Available" value="0">
				<cfinput type="hidden" name="PostedTo_Facebook" value="0">
				<cfinput type="hidden" name="PostedTo_Twitter" value="0">
				<cfinput type="hidden" name="EventPricePerDay" value="0">
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
						<label for="Event_HasMultipleDates" class="col-lg-5 col-md-5">Event has Multiple Dates:&nbsp;</label>
						<div class="col-sm-7">
							<cfif Session.FormInput.EventStep1.Event_HasMultipleDates EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="Event_HasMultipleDates" id="Event_HasMultipleDates" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Event_HasMultipleDates" id="Event_HasMultipleDates" value="1">
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
					<div class="form-group">
						<label for="Event_SpecialMessage" class="col-lg-5 col-md-5">Special Alert Message:&nbsp;</label>
						<div class="col-sm-7"><textarea name="Event_SpecialMessage" id="Event_SpecialMessage" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep1.Event_SpecialMessage#</textarea>
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
					<fieldset>
						<legend><h2>Event At Location Pricing</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="Event_MemberCost" name="Event_MemberCost" value="#Session.FormInput.EventStep1.Event_MemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div></div>
					</div>
					<div class="form-group">
						<label for="Event_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="Event_NonMemberCost" name="Event_NonMemberCost" value="#Session.FormInput.EventStep1.Event_NonMemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div></div>
					</div>
					<div class="form-group">
						<label for="EventPricePerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
						<div class="col-lg-2 col-md-2">&nbsp;</div>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.EventPricePerDay EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Held At Location</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_HeldAtFacilityID" class="col-lg-5 col-md-5">Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-7">
							<cfselect name="Event_HeldAtFacilityID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilities" selected="#Session.FormInput.EventStep1.Event_HeldAtFacilityID#" value="TContent_ID" Display="FacilityName"  queryposition="below">
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
						<legend><h2>Estimated Workshop/Event Expenses</h2></legend>
					</fieldset>
					<div class="alert alert-info">Enter the estimated expenses for this event to generate a break even amount for this event.</div>
					<div class="form-group">
						<label for="WhatIf_MealCostPerAttendee" class="col-lg-5 col-md-5">Estimated Meal Cost Per Attendee:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.WhatIf_MealCostPerAttendee")>
								<cfinput type="text" class="form-control" id="WhatIf_MealCostPerAttendee" name="WhatIf_MealCostPerAttendee" value="#Session.FormInput.EventStep1.WhatIf_MealCostPerAttendee#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="WhatIf_MealCostPerAttendee" name="WhatIf_MealCostPerAttendee" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="WhatIf_PresenterCostTotal" class="col-lg-5 col-md-5">Estimated Total Presenter Costs:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.WhatIf_PresenterCostTotal")>
								<cfinput type="text" class="form-control" id="WhatIf_PresenterCostTotal" name="WhatIf_PresenterCostTotal" value="#Session.FormInput.EventStep1.WhatIf_PresenterCostTotal#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="WhatIf_PresenterCostTotal" name="WhatIf_PresenterCostTotal" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="WhatIf_FacilityCostTotal" class="col-lg-5 col-md-5">Estimated Total Facility Costs:&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.WhatIf_FacilityCostTotal")>
								<cfinput type="text" class="form-control" id="WhatIf_FacilityCostTotal" name="WhatIf_FacilityCostTotal" value="#Session.FormInput.EventStep1.WhatIf_FacilityCostTotal#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="WhatIf_FacilityCostTotal" name="WhatIf_FacilityCostTotal" required="no">
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Optional Features</h2></legend>
					</fieldset>
					<div class="alert alert-info">The default option for each one of the following is No unless you specifically select Yes on these questions.</div>
					<div class="form-group">
						<label for="Featured_Event" class="col-lg-5 col-md-5">Event is Featured:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.Featured_Event EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="Featured_Event" id="Featured_Event" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Featured_Event" id="Featured_Event" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="Event_DailySessions" class="col-lg-5 col-md-5">Event has Daily Sessions:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.Event_DailySessions EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="Event_DailySessions" id="Event_DailySessions" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Event_DailySessions" id="Event_DailySessions" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_Available" class="col-lg-5 col-md-5">Earlybird Registration Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.EarlyBird_Available EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EarlyBird_Available" id="EarlyBird_Available" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EarlyBird_Available" id="EarlyBird_Available" value="1">
							</cfif>
							 <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div></div>
					</div>
					<div class="form-group">
						<label for="GroupPrice_Available" class="col-lg-5 col-md-5">Group Pricing Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.GroupPrice_Available EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="GroupPrice_Available" id="GroupPrice_Available" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="GroupPrice_Available" id="GroupPrice_Available" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div></div>
					</div>
					<div class="form-group">
						<label for="PGPCertificate_Available" class="col-lg-5 col-md-5">PGP Certificate Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.PGPCertificate_Available EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="PGPCertificate_Available" id="PGPCertificate_Available" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PGPCertificate_Available" id="PGPCertificate_Available" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div></div>
					</div>
					<div class="form-group">
						<label for="Meal_Available" class="col-lg-5 col-md-5">Meal Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.Meal_Available EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="Meal_Available" id="Meal_Available" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Meal_Available" id="Meal_Available" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div></div>
					</div>
					<div class="form-group">
						<label for="H323_Available" class="col-lg-5 col-md-5">Is Distance Education Available:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.H323_Available EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="H323_Available" id="H323_Available" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="H323_Available" id="H323_Available" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div></div>
					</div>
					<div class="form-group">
						<label for="Webinar_Available" class="col-lg-5 col-md-5">Webinar Only Event:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.Webinar_Available EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="Webinar_Available" id="Webinar_Available" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="Webinar_Available" id="Webinar_Available" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div></div>
					</div>
					<cfif Session.SiteConfigSettings.Facebook_Enabled EQ 1>
						<div class="form-group">
						<label for="PostedTo_Facebook" class="col-lg-5 col-md-5">Post to Facebook Fan Page:&nbsp;&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.PostedTo_Facebook EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="PostedTo_Facebook" id="PostedTo_Facebook" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PostedTo_Facebook" id="PostedTo_Facebook" value="1">
							</cfif>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div></div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.Twitter_Enabled EQ 1>
						<div class="form-group">
						<label for="PostedTo_Twitter" class="col-lg-5 col-md-5">Post to Twitter Handle:&nbsp;&nbsp;</label>
						<div class="checkbox col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.PostedTo_Twitter")>
								<cfif Session.FormInput.EventStep1.PostedTo_Twitter CONTAINS 1>
									<cfinput type="checkbox" class="form-check-input" name="PostedTo_Twitter" id="PostedTo_Twitter" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Companies Twitter Handle)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="PostedTo_Twitter" id="PostedTo_Twitter" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Companies Twitter Handle)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="PostedTo_Twitter" id="PostedTo_Twitter" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Companies Twitter Handle)</div>
							</cfif>
						</div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.BillForNoShowRegistrations EQ 1>
						<div class="form-group">
						<label for="BillForNoShow" class="col-lg-5 col-md-5">Bill For NoShow:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif Session.FormInput.EventStep1.BillForNoShow EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="BillForNoShow" id="BillForNoShow" checked value="1">
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="BillForNoShow" id="BillForNoShow" value="1">
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
