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
			$("##EventDate1").datepicker();
			$("##EventDate2").datepicker();
			$("##EventDate3").datepicker();
			$("##EventDate4").datepicker();
			$("##Featured_StartDate").datepicker();
			$("##Featured_EndDate").datepicker();
			$("##EarlyBird_RegistrationDeadline").datepicker();
			$("##EventSession1_StartTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##EventSession2_StartTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##EventSession1_EndTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##EventSession2_EndTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
		});
	</script>
	<cfset pluginPath = rc.$.globalConfig('context') & '/plugins/' & rc.pluginConfig.getPackage() />
	<script type="text/javascript" src="#pluginPath#/includes/assets/js/jquery.formatCurrency-1.4.0.js"></script>
	<script type="text/javascript" src="#pluginPath#/includes/assets/js/jquery.formatCurrnecy.all.js"></script>
	<script type="text/javascript">
		$(document).ready(function()
			{
				$('##MemberCost').blur(function() {
					$('##MemberCost').formatCurrency();
				});

				$('##NonMemberCost').blur(function() {
					$('##NonMemberCost').formatCurrency();
				});

				$('##MealCost').blur(function() {
					$('##MealCost').formatCurrency();
				});

				$('##EarlyBird_NonMemberCost').blur(function() {
					$('##EarlyBird_NonMemberCost').formatCurrency();
				});

				$('##EarlyBird_Member').blur(function() {
					$('##EarlyBird_Member').formatCurrency();
				});

				$('##GroupMemberCost').blur(function() {
					$('##GroupMemberCost').formatCurrency();
				});

				$('##GroupNonMemberCost').blur(function() {
					$('##GroupNonMemberCost').formatCurrency();
				});

				$('##VideoConferenceCost').blur(function() {
					$('##VideoConferenceCost').formatCurrency();
				});

				$('##WebinarMemberCost').blur(function() {
					$('##WebinarMemberCost').formatCurrency();
				});

				$('##WebinarNonMemberCost').blur(function() {
					$('##WebinarNonMemberCost').formatCurrency();
				});

			});

	</script>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 2 of 5 - Add New Event</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete any additional information and click the Proceed Button Below to continue.</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EventSpanDates EQ 1>
						<fieldset>
							<legend><h2>Additional Dates for Event or Workshop</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EventDate1" class="control-label col-sm-3">2nd Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">3rd Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" required="no"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">4th Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" required="no"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">5th Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" required="no"></div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Additional Detail Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="EventAgenda" id="EventAgenda" class="form-control" cols="80" rows="10"></textarea>
							<script>
								CKEDITOR.replace('EventAgenda', {
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
						<label for="EventTargetAudience" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control" cols="80" rows="10"></textarea>
							<script>
								CKEDITOR.replace('EventTargetAudience', {
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
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="EventStrategies" id="EventStrategies" class="form-control" cols="80" rows="10"></textarea>
							<script>
								CKEDITOR.replace('EventStrategies', {
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
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control" cols="80" rows="10"></textarea>
							<script>
								CKEDITOR.replace('EventSpecialInstructions', {
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
					<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Event Pricing Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="MemberCost" class="control-label col-sm-3">Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="MemberCost" name="MemberCost" value="0.00" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="NonMemberCost" class="control-label col-sm-3">NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="NonMemberCost" name="NonMemberCost" value="0.00" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.EventFeatured EQ 1>
						<fieldset>
							<legend><h2>Event Featured Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Featured_StartDate" class="control-label col-sm-3">Start Date to be Featured:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="control-label col-sm-3">End Date to be Featured:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_SortOrder" class="control-label col-sm-3">Featured Sort order:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_SortOrder" name="Featured_SortOrder" value="100" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.EarlyBird_RegistrationAvailable EQ 1>
						<fieldset>
							<legend><h2>Early Bird Registration Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Early Bird Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_Member" class="control-label col-sm-3">EarlyBird Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_Member" value="0.00" name="EarlyBird_Member" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">EarlyBird NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" value="0.00" name="EarlyBird_NonMemberCost" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.ViewGroupPricing EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Group Pricing Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="GroupPriceRequirements" class="control-label col-sm-3">Requirements to Meet Group Pricing:&nbsp;</label>
							<div class="col-sm-8">
								<textarea name="GroupPriceRequirements" id="GroupPriceRequirements" class="form-control" cols="80" rows="10"></textarea>
								<script>
									CKEDITOR.replace('GroupPriceRequirements', {
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
							<label for="GroupMemberCost" class="control-label col-sm-3">Group Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupMemberCost" name="GroupMemberCost" value="0.00" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="GroupNonMemberCost" class="control-label col-sm-3">Group NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupNonMemberCost" name="GroupNonMemberCost" value="0.00" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.PGPAvailable EQ 1>
						<fieldset>
							<legend><h2>Professional Growth Point Certification Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="PGPPoints" class="control-label col-sm-3">Number of PGP Points Per Day:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.MealAvailable EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Meal Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="MealIncluded" class="control-label col-sm-3">Meal Included in Registration:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="MealIncluded" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Is Meal Price included in Registration Fee</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="MealProvidedBy" class="control-label col-sm-3">Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getCatererInformation" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Who Provides Meal</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="MealCost" class="control-label col-sm-3">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="MealCost" name="MealCost" value="0.00" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="MealInformation" class="control-label col-sm-3">Meal Information:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<textarea name="MealInformation" id="MealInformation" class="form-control" cols="80" rows="10"></textarea>
								<script>
									CKEDITOR.replace('MealInformation', {
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
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.AllowVideoConference EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Video Conference Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8">
								<textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control" cols="80" rows="10"></textarea>
								<script>
									CKEDITOR.replace('VideoConferenceInfo', {
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
							<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 1>
						<fieldset>
							<legend><h2>Webinar Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="WebinarConnectWebInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8">
								<textarea name="WebinarConnectWebInfo" id="WebinarConnectWebInfo" class="form-control" cols="80" rows="10"></textarea>
								<script>
									CKEDITOR.replace('WebinarConnectWebInfo', {
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
							<label for="WebinarMemberCost" class="control-label col-sm-3">Member Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarMemberCost" name="WebinarMemberCost" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="control-label col-sm-3">NonMember Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarNonMemberCost" name="WebinarNonMemberCost" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Event Facility Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="LocationID" class="control-label col-sm-3">Location of Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityInformation" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Location of Event</option>
								</cfselect>
							</div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.EventHaveSessions EQ 1>
						<fieldset>
							<legend><h2>Event Session Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EventSession1_StartTime" class="control-label col-sm-3">First Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_StartTime" name="EventSession1_StartTime" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession1_EndTime" class="control-label col-sm-3">First Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_EndTime" name="EventSession1_EndTime" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession2_StartTime" class="control-label col-sm-3">Second Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_StartTime" name="EventSession2_StartTime" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession2_EndTime" class="control-label col-sm-3">Second Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_EndTime" name="EventSession2_EndTime" required="yes"></div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 1">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Proceed to Step 3"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 2 of 5 - Add New Event</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete any additional information and click the Proceed Button Below to continue.</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EventSpanDates EQ 1>
						<fieldset>
							<legend><h2>Additional Dates for Event or Workshop</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EventDate1" class="control-label col-sm-3">2nd Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate1" value="#Session.UserSuppliedInfo.SecondStep.EventDate1#" name="EventDate1" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">3rd Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.UserSuppliedInfo.SecondStep.EventDate2#" required="no"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">4th Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.UserSuppliedInfo.SecondStep.EventDate3#" required="no"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">5th Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.UserSuppliedInfo.SecondStep.EventDate4#" required="no"></div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Additional Detail Information for Event or Workshop</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventAgenda")>
								<textarea name="EventAgenda" id="EventAgenda" class="form-control" cols="80" rows="10">#Session.UserSuppliedInfo.SecondStep.EventAgenda#</textarea>
								<script>
									CKEDITOR.replace('EventAgenda', {
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
							<cfelse>
								<textarea name="EventAgenda" id="EventAgenda" class="form-control" cols="80" rows="10"></textarea>
								<script>
									CKEDITOR.replace('EventAgenda', {
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
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventAgenda")>
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control" cols="80" rows="10">#Session.UserSuppliedInfo.SecondStep.EventTargetAudience#</textarea>
								<script>
									CKEDITOR.replace('EventTargetAudience', {
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
							<cfelse>
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control" cols="80" rows="10"></textarea>
								<script>
									CKEDITOR.replace('EventTargetAudience', {
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
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventStrategies")>
								<textarea name="EventStrategies" id="EventStrategies" class="form-control" cols="80" rows="10">#Session.UserSuppliedInfo.SecondStep.EventStrategies#</textarea>
								<script>
									CKEDITOR.replace('EventStrategies', {
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
							<cfelse>
								<textarea name="EventStrategies" id="EventStrategies" class="form-control" cols="80" rows="10"></textarea>
								<script>
									CKEDITOR.replace('EventStrategies', {
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
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventSpecialInstructions")>
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control" cols="80" rows="10">#Session.UserSuppliedInfo.SecondStep.EventSpecialInstructions#</textarea>
								<script>
									CKEDITOR.replace('EventSpecialInstructions', {
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
							<cfelse>
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control" cols="80" rows="10"></textarea>
								<script>
									CKEDITOR.replace('EventSpecialInstructions', {
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
							</cfif>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Event Pricing Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="MemberCost" class="control-label col-sm-3">Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.MemberCost")>
									<cfinput type="text" class="form-control" id="MemberCost" name="MemberCost" value="#Session.UserSuppliedInfo.SecondStep.MemberCost#" required="yes">
								<cfelse>
									<cfinput type="text" class="form-control" id="MemberCost" name="MemberCost" required="yes">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="NonMemberCost" class="control-label col-sm-3">NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.NonMemberCost")>
									<cfinput type="text" class="form-control" id="NonMemberCost" name="NonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.NonMemberCost#" required="yes">
								<cfelse>
									<cfinput type="text" class="form-control" id="NonMemberCost" name="NonMemberCost" required="yes">
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.EventFeatured EQ 1>
						<fieldset>
							<legend><h2>Event Featured Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Featured_StartDate" class="control-label col-sm-3">Start Date to be Featured:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#Session.UserSuppliedInfo.SecondStep.Featured_StartDate#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="control-label col-sm-3">End Date to be Featured:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#Session.UserSuppliedInfo.SecondStep.Featured_EndDate#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_SortOrder" class="control-label col-sm-3">Featured Sort order:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_SortOrder" name="Featured_SortOrder" value="#Session.UserSuppliedInfo.SecondStep.Featured_SortOrder#"  required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.EarlyBird_RegistrationAvailable EQ 1>
						<fieldset>
							<legend><h2>Early Bird Registration Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Featured Sort order:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" value="#Session.UserSuppliedInfo.SecondStep.EarlyBird_RegistrationDeadline#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_Member" class="control-label col-sm-3">EarlyBird Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_Member" name="EarlyBird_Member" value="#Session.UserSuppliedInfo.SecondStep.EarlyBird_Member#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">EarlyBird NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.EarlyBird_NonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.ViewGroupPricing EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Group Pricing Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="GroupPriceRequirements" class="control-label col-sm-3">Requirements to Meet Group Pricing:&nbsp;</label>
							<div class="col-sm-8">
								<textarea name="GroupPriceRequirements" id="GroupPriceRequirements" class="form-control" cols="80" rows="10">#Session.UserSuppliedInfo.SecondStep.GroupPriceRequirements#</textarea>
								<script>
									CKEDITOR.replace('GroupPriceRequirements', {
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
							<label for="GroupMemberCost" class="control-label col-sm-3">Group Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupMemberCost" name="GroupMemberCost" value="#Session.UserSuppliedInfo.SecondStep.GroupMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="GroupNonMemberCost" class="control-label col-sm-3">Group NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupNonMemberCost" name="GroupNonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.GroupNonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.PGPAvailable EQ 1>
						<fieldset>
							<legend><h2>Professional Growth Point Certificate Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="PGPPoints" class="control-label col-sm-3">Number of PGP Points Per Day:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" value="#Session.UserSuppliedInfo.SecondStep.PGPPoints#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.MealAvailable EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Meal Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="MealIncluded" class="control-label col-sm-3">Meal Included in Registration:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.MealIncluded")>
									<cfselect name="MealIncluded" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.UserSuppliedInfo.SecondStep.MealIncluded#" queryposition="below">
										<option value="----">Is Meal Price included in Registration Fee</option>
									</cfselect>
								<cfelse>
									<cfselect name="MealIncluded" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
										<option value="----">Is Meal Price included in Registration Fee</option>
									</cfselect>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="MealProvidedBy" class="control-label col-sm-3">Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getCatererInformation" value="TContent_ID" Display="FacilityName" selected="#Session.UserSuppliedInfo.SecondStep.MealProvidedBy#" queryposition="below">
									<option value="----">Select Who Provides Meal</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="MealCost" class="control-label col-sm-3">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="MealCost" name="MealCost" value="#Session.UserSuppliedInfo.SecondStep.MealCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="MealInformation" class="control-label col-sm-3">Meal Information:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<textarea name="MealInformation" id="MealInformation" class="form-control" cols="80" rows="10">#Session.UserSuppliedInfo.SecondStep.MealInformation#</textarea>
								<script>
									CKEDITOR.replace('MealInformation', {
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
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.AllowVideoConference EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Video Conference Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8">
								<textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control" cols="80" rows="10">#Session.UserSuppliedInfo.SecondStep.VideoConferenceInfo#</textarea>
								<script>
									CKEDITOR.replace('VideoConferenceInfo', {
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
							<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.UserSuppliedInfo.SecondStep.VideoConferenceCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 1>
						<fieldset>
							<legend><h2>Webinar Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="WebinarConnectWebInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8">
								<textarea name="WebinarConnectWebInfo" id="WebinarConnectWebInfo" class="form-control" cols="80" rows="10">#Session.UserSuppliedInfo.SecondStep.WebinarConnectWebInfo#</textarea>
								<script>
									CKEDITOR.replace('WebinarConnectWebInfo', {
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
							<label for="WebinarMemberCost" class="control-label col-sm-3">Member Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarMemberCost" name="WebinarMemberCost" value="#Session.UserSuppliedInfo.SecondStep.WebinarMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="control-label col-sm-3">NonMember Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarNonMemberCost" name="WebinarNonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.WebinarNonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<fieldset>
							<legend><h2>Event Facility Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="LocationID" class="control-label col-sm-3">Location of Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.LocationID")>
									<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityInformation" selected="#Session.UserSuppliedInfo.SecondStep.LocationID#" value="TContent_ID" Display="FacilityName"  queryposition="below">
										<option value="----">Select Location of Event</option>
									</cfselect>
								<cfelse>
									<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityInformation" value="TContent_ID" Display="FacilityName"  queryposition="below">
										<option value="----">Select Location of Event</option>
									</cfselect>
								</cfif>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 1">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Proceed to Step 3"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>