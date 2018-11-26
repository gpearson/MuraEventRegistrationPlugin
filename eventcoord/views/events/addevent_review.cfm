<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>

<cfoutput>
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
	<script>
		$(function() {
			$("##EventDate").datepicker();
			$("##EventDate1").datepicker();
			$("##EventDate2").datepicker();
			$("##EventDate3").datepicker();
			$("##EventDate4").datepicker();
			$("##Featured_StartDate").datepicker();
			$("##Featured_EndDate").datepicker();
			$("##Registration_Deadline").datepicker();
			$("##Registration_BeginTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##Event_StartTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##Event_EndTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
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

	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 5 of 5 - Add New Event</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete any additional information and click the Proceed Button Below to continue.</div>
					<fieldset>
						<legend><h2>Event Date and Time Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#Session.UserSuppliedInfo.FirstStep.EventDate#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventSpanDates" class="control-label col-sm-3">Event has Multiple Dates:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventSpanDates" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FirstStep.EventSpanDates#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have multiple dates</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EventSpanDates EQ 1>
						<div class="form-group">
							<label for="EventDate1" class="control-label col-sm-3">2nd Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventDate1")>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#Session.UserSuppliedInfo.SecondStep.EventDate1#" required="yes">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" required="yes">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">3rd Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventDate2")>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.UserSuppliedInfo.SecondStep.EventDate2#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">4th Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventDate3")>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.UserSuppliedInfo.SecondStep.EventDate3#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">5th Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventDate4")>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.UserSuppliedInfo.SecondStep.EventDate4#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<br />
					<div class="form-group">
						<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.UserSuppliedInfo.FirstStep.Registration_Deadline#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="control-label col-sm-3">Registration Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#Session.UserSuppliedInfo.FirstStep.Registration_BeginTime#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="control-label col-sm-3">Event Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#Session.UserSuppliedInfo.FirstStep.Event_StartTime#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="control-label col-sm-3">Event Ending Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#Session.UserSuppliedInfo.FirstStep.Event_EndTime#" required="yes"></div>
					</div>
					<br />
					<fieldset>
						<legend><h2>Event Description Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.UserSuppliedInfo.FirstStep.ShortTitle#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.FirstStep.LongDescription")>
								<textarea name="LongDescription" id="LongDescription" class="form-control" >#Session.UserSuppliedInfo.FirstStep.LongDescription#</textarea>
							<cfelse>
								<textarea name="LongDescription" id="LongDescription" class="form-control" ></textarea>
							</cfif>
							<span id="LongDescriptionCharacters"></span> Characters
						</div>
					</div>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventAgenda")>
								<textarea name="EventAgenda" id="EventAgenda" class="form-control">#Session.UserSuppliedInfo.SecondStep.EventAgenda#</textarea>
							<cfelse>
								<textarea name="EventAgenda" id="EventAgenda" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventTargetAudience")>
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control">#Session.UserSuppliedInfo.SecondStep.EventTargetAudience#</textarea>
							<cfelse>
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventStrategies")>
								<textarea name="EventStrategies" id="EventStrategies" class="form-control">#Session.UserSuppliedInfo.SecondStep.EventStrategies#</textarea>
							<cfelse>
								<textarea name="EventStrategies" id="EventStrategies" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventSpecialInstructions")>
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control">#Session.UserSuppliedInfo.SecondStep.EventSpecialInstructions#</textarea>
							<cfelse>
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Post Event to Facebook</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PostEventToFB" class="control-label col-sm-3">Post to Fan Page:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="PostEventToFB" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.PostEventToFB#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Post Event to FB Page</option>
							</cfselect>
						</div>
					</div>
					<fieldset>
						<legend><h2>Allow Online Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="control-label col-sm-3">Accept Registrations:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="AcceptRegistrations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FourthStep.AcceptRegistrations#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Allow Individuals To Register</option>
							</cfselect>
						</div>
					</div>
					<br />
					<fieldset>
						<legend><h2>Event has Daily Sessions</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventHaveSessions" class="control-label col-sm-3">Event has Daily Sessions:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventHaveSessions" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.UserSuppliedInfo.FirstStep.EventHaveSessions#"  queryposition="below">
								<option value="----">Will Event have 2 Sessions on a Single Day</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EventHaveSessions EQ 1>
						<div class="form-group">
							<label for="EventSession1_StartTime" class="control-label col-sm-3">First Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_StartTime" name="EventSession1_StartTime" value="#Session.UserSuppliedInfo.SecondStep.EventSession1_StartTime#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession1_EndTime" class="control-label col-sm-3">First Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_EndTime" name="EventSession1_EndTime" value="#Session.UserSuppliedInfo.SecondStep.EventSession1_EndTime#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession2_StartTime" class="control-label col-sm-3">Second Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_StartTime" name="EventSession2_StartTime" value="#Session.UserSuppliedInfo.SecondStep.EventSession2_StartTime#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession2_EndTime" class="control-label col-sm-3">Second Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_EndTime" name="EventSession2_EndTime" value="#Session.UserSuppliedInfo.SecondStep.EventSession2_EndTime#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Event Featured Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Event is Featured:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventFeatured" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.EventFeatured#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event be Featured on Website</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EventFeatured EQ 1>
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
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_SortOrder" name="Featured_SortOrder" value="#Session.UserSuppliedInfo.SecondStep.Featured_SortOrder#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Early Bird Registration Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Earlybird Registration Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FirstStep.EarlyBird_RegistrationAvailable#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event allow Early Bird Registrations</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EarlyBird_RegistrationAvailable EQ 1>
						<div class="form-group">
							<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Early Bird Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
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
					<br />
					<fieldset>
						<legend><h2>Group Pricing Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ViewGroupPricing" class="control-label col-sm-3">Group Pricing Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="ViewGroupPricing" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.ViewGroupPricing#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event have Group pricing avialable</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.ViewGroupPricing EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="GroupPriceRequirements" class="control-label col-sm-3">Requirements to Meet Group Pricing:&nbsp;</label>
							<div class="col-sm-8"><textarea name="GroupPriceRequirements" id="GroupPriceRequirements" class="form-control">#Session.UserSuppliedInfo.SecondStep.GroupPriceRequirements#</textarea><span id="GroupPricingRequirementsCharacters"></span> Characters</div>
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
					<br />
					<fieldset>
						<legend><h2>Professional Growth Point Certification Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="PGPAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.PGPAvailable#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event issue PGP Certificates</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.PGPAvailable EQ 1>
						<div class="form-group">
							<label for="PGPPoints" class="control-label col-sm-3">Number of PGP Points Per Day:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" value="#Session.UserSuppliedInfo.SecondStep.PGPPoints#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Meal Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MealAvailable" class="control-label col-sm-3">Meal Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="MealAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.MealAvailable#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Meal be provided to Participants</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.MealAvailable EQ 1  and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="MealProvidedBy" class="control-label col-sm-3">Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getCatererInformation" selected="#Session.UserSuppliedInfo.SecondStep.MealProvidedBy#" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Who Provides Meal</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="MealIncluded" class="control-label col-sm-3">Meal Included in Registration:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="MealIncluded" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.UserSuppliedInfo.SecondStep.MealIncluded#"  queryposition="below">
									<option value="----">Is Meal Price included in Registration Fee</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="MealCost" class="control-label col-sm-3">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="MealCost" name="MealCost" value="#Session.UserSuppliedInfo.SecondStep.MealCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="MealInformation" class="control-label col-sm-3">Meal Information:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><textarea name="MealInformation" id="MealInformation" class="form-control">#Session.UserSuppliedInfo.SecondStep.MealInformation#</textarea></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Video Conference Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AllowVideoConference" class="control-label col-sm-3">Is Distance Education Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FirstStep.AllowVideoConference#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Can Participants participate via Distance Education</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.AllowVideoConference EQ 1  and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control">#Session.UserSuppliedInfo.SecondStep.VideoConferenceInfo#</textarea><span id="VideoConferenceInfoCharacters"></span> Characters</div>
						</div>
						<div class="form-group">
							<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.UserSuppliedInfo.SecondStep.VideoConferenceCost#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Webinar Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="WebinarEvent" class="control-label col-sm-3">Webinar Only Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="WebinarEvent" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.WebinarEvent#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Webinar Only Event</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 1>
						<div class="form-group">
							<label for="WebinarConnectWebInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="WebinarConnectWebInfo" id="WebinarConnectWebInfo" class="form-control">#Session.UserSuppliedInfo.SecondStep.WebinarConnectWebInfo#</textarea><span id="WebinarConnectWebInfoCharacters"></span> Characters</div>
						</div>
						<div class="form-group">
							<label for="WebinarMemberCost" class="control-label col-sm-3">Member Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarMemberCost" name="WebinarMemberCost" value="#Session.UserSuppliedInfo.SecondStep.WebinarMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="control-label col-sm-3">NonMember Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarNonMemberCost" name="WebinarNonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.WebinarNonMemberCost#" required="yes"></div>
						</div>
					<cfelseif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<br />
						<fieldset>
							<legend><h2>Event Facility Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="LocationID" class="control-label col-sm-3">Location of Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityInformation" selected="#Session.UserSuppliedInfo.SecondStep.LocationID#" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Location of Event</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="LocationRoomID" class="control-label col-sm-3">Which Room at Facility:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityRoomInfo" selected="#Session.UserSuppliedInfo.ThirdStep.LocationRoomID#" value="RoomID" Display="RoomName"  queryposition="below">
								<option value="----">Select Which Room at Facility this event is held in</option></cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="RoomMaxParticipants" class="control-label col-sm-3">Maximum Particpants:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control MemberCost" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.UserSuppliedInfo.FourthStep.RoomMaxParticipants#" required="yes">
							</div>
						</div>

						<div class="form-group">
							<label for="MemberCost" class="control-label col-sm-3">Member Pricing To Attend:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control MemberCost" id="MemberCost" name="MemberCost" value="#Session.UserSuppliedInfo.SecondStep.MemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="NonMemberCost" class="control-label col-sm-3">NonMember Pricing To Attend:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control NonMemberCost" id="NonMemberCost" name="NonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.NonMemberCost#" required="yes"></div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 4">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event"><br /><br />
				</div>
			</cfform>
		</div>
		<script type="text/javascript">
			$('##LongDescription').keyup(LongDescriptionupdateCounter);
			$('##LongDescription').keydown(LongDescriptionupdateCounter);

			function LongDescriptionupdateCounter() {
				var cs = $(this).val().length;
				$('##LongDescriptionCharacters').text(cs);
			}

			$('##GroupPriceRequirements').keyup(GroupPriceRequirementsupdateCounter);
			$('##GroupPriceRequirements').keydown(GroupPriceRequirementsupdateCounter);

			function GroupPriceRequirementsupdateCounter() {
				var cs = $(this).val().length;
				$('##GroupPriceRequirementsCharacters').text(cs);
			}

			$('##VideoConferenceInfo').keyup(VideoConferenceInfoupdateCounter);
			$('##VideoConferenceInfo').keydown(VideoConferenceInfoupdateCounter);

			function VideoConferenceInfoupdateCounter() {
				var cs = $(this).val().length;
				$('##VideoConferenceInfoCharacters').text(cs);
			}

			$('##WebinarConnectWebInfo').keyup(WebinarConnectWebInfoupdateCounter);
			$('##WebinarConnectWebInfo').keydown(WebinarConnectWebInfoupdateCounter);

			function WebinarConnectWebInfoupdateCounter() {
				var cs = $(this).val().length;
				$('##WebinarConnectWebInfoCharacters').text(cs);
			}
		</script>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 5 of 5 - Add New Event</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete any additional information and click the Proceed Button Below to continue.</div>
					<fieldset>
						<legend><h2>Event Date and Time Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#Session.UserSuppliedInfo.FinalStep.EventDate#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventSpanDates" class="control-label col-sm-3">Event has Multiple Dates:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventSpanDates" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FinalStep.EventSpanDates#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have multiple dates</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EventSpanDates EQ 1>
						<div class="form-group">
							<label for="EventDate1" class="control-label col-sm-3">2nd Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.FinalStep.EventDate1")>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#Session.UserSuppliedInfo.FinalStep.EventDate1#" required="yes">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" required="yes">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">3rd Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.FinalStep.EventDate2")>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.UserSuppliedInfo.FinalStep.EventDate2#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">4th Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.FinalStep.EventDate3")>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.UserSuppliedInfo.FinalStep.EventDate3#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">5th Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.FinalStep.EventDate4")>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.UserSuppliedInfo.FinalStep.EventDate4#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<br />
					<div class="form-group">
						<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.UserSuppliedInfo.FinalStep.Registration_Deadline#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="control-label col-sm-3">Registration Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#Session.UserSuppliedInfo.FinalStep.Registration_BeginTime#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="control-label col-sm-3">Event Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#Session.UserSuppliedInfo.FinalStep.Event_StartTime#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="control-label col-sm-3">Event Ending Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#Session.UserSuppliedInfo.FinalStep.Event_EndTime#" required="yes"></div>
					</div>
					<br />
					<fieldset>
						<legend><h2>Event Description Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.UserSuppliedInfo.FinalStep.ShortTitle#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.FirstStep.LongDescription")>
								<textarea name="LongDescription" id="LongDescription" class="form-control" >#Session.UserSuppliedInfo.FinalStep.LongDescription#</textarea>
							<cfelse>
								<textarea name="LongDescription" id="LongDescription" class="form-control" ></textarea>
							</cfif>
							<span id="LongDescriptionCharacters"></span> Characters
						</div>
					</div>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.FinalStep.EventAgenda")>
								<textarea name="EventAgenda" id="EventAgenda" class="form-control">#Session.UserSuppliedInfo.FinalStep.EventAgenda#</textarea>
							<cfelse>
								<textarea name="EventAgenda" id="EventAgenda" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.FinalStep.EventTargetAudience")>
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control">#Session.UserSuppliedInfo.FinalStep.EventTargetAudience#</textarea>
							<cfelse>
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.FinalStep.EventStrategies")>
								<textarea name="EventStrategies" id="EventStrategies" class="form-control">#Session.UserSuppliedInfo.FinalStep.EventStrategies#</textarea>
							<cfelse>
								<textarea name="EventStrategies" id="EventStrategies" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.FinalStep.EventSpecialInstructions")>
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control">#Session.UserSuppliedInfo.FinalStep.EventSpecialInstructions#</textarea>
							<cfelse>
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Post Event to Facebook</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PostEventToFB" class="control-label col-sm-3">Post to Fan Page:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="PostEventToFB" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FinalStep.PostEventToFB#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Post Event to FB Page</option>
							</cfselect>
						</div>
					</div>
					<fieldset>
						<legend><h2>Allow Online Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="control-label col-sm-3">Accept Registrations:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="AcceptRegistrations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FinalStep.AcceptRegistrations#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Allow Individuals To Register</option>
							</cfselect>
						</div>
					</div>
					<br />
					<fieldset>
						<legend><h2>Event has Daily Sessions</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventHaveSessions" class="control-label col-sm-3">Event has Daily Sessions:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventHaveSessions" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.UserSuppliedInfo.FinalStep.EventHaveSessions#"  queryposition="below">
								<option value="----">Will Event have 2 Sessions on a Single Day</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FinalStep.EventHaveSessions EQ 1>
						<div class="form-group">
							<label for="EventSession1_StartTime" class="control-label col-sm-3">First Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_StartTime" name="EventSession1_StartTime" value="#Session.UserSuppliedInfo.FinalStep.EventSession1_StartTime#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession1_EndTime" class="control-label col-sm-3">First Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_EndTime" name="EventSession1_EndTime" value="#Session.UserSuppliedInfo.FinalStep.EventSession1_EndTime#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession2_StartTime" class="control-label col-sm-3">Second Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_StartTime" name="EventSession2_StartTime" value="#Session.UserSuppliedInfo.FinalStep.EventSession2_StartTime#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSession2_EndTime" class="control-label col-sm-3">Second Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_EndTime" name="EventSession2_EndTime" value="#Session.UserSuppliedInfo.FinalStep.EventSession2_EndTime#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Event Featured Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Event is Featured:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventFeatured" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FinalStep.EventFeatured#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event be Featured on Website</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FinalStep.EventFeatured EQ 1>
						<div class="form-group">
							<label for="Featured_StartDate" class="control-label col-sm-3">Start Date to be Featured:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#Session.UserSuppliedInfo.FinalStep.Featured_StartDate#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="control-label col-sm-3">End Date to be Featured:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#Session.UserSuppliedInfo.FinalStep.Featured_EndDate#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_SortOrder" class="control-label col-sm-3">Featured Sort order:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_SortOrder" name="Featured_SortOrder" value="#Session.UserSuppliedInfo.FinalStep.Featured_SortOrder#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Early Bird Registration Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Earlybird Registration Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FinalStep.EarlyBird_RegistrationAvailable#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event allow Early Bird Registrations</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EarlyBird_RegistrationAvailable EQ 1>
						<div class="form-group">
							<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Early Bird Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" value="#Session.UserSuppliedInfo.FinalStep.EarlyBird_RegistrationDeadline#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_Member" class="control-label col-sm-3">EarlyBird Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_Member" name="EarlyBird_Member" value="#Session.UserSuppliedInfo.FinalStep.EarlyBird_Member#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">EarlyBird NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.UserSuppliedInfo.FinalStep.EarlyBird_NonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Group Pricing Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ViewGroupPricing" class="control-label col-sm-3">Group Pricing Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="ViewGroupPricing" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FinalStep.ViewGroupPricing#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event have Group pricing avialable</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FinalStep.ViewGroupPricing EQ 1 and Session.UserSuppliedInfo.FinalStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="GroupPriceRequirements" class="control-label col-sm-3">Requirements to Meet Group Pricing:&nbsp;</label>
							<div class="col-sm-8"><textarea name="GroupPriceRequirements" id="GroupPriceRequirements" class="form-control">#Session.UserSuppliedInfo.FinalStep.GroupPriceRequirements#</textarea><span id="GroupPricingRequirementsCharacters"></span> Characters</div>
						</div>
						<div class="form-group">
							<label for="GroupMemberCost" class="control-label col-sm-3">Group Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupMemberCost" name="GroupMemberCost" value="#Session.UserSuppliedInfo.FinalStep.GroupMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="GroupNonMemberCost" class="control-label col-sm-3">Group NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupNonMemberCost" name="GroupNonMemberCost" value="#Session.UserSuppliedInfo.FinalStep.GroupNonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Professional Growth Point Certification Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="PGPAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FinalStep.PGPAvailable#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event issue PGP Certificates</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FinalStep.PGPAvailable EQ 1>
						<div class="form-group">
							<label for="PGPPoints" class="control-label col-sm-3">Number of PGP Points Per Day:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" value="#Session.UserSuppliedInfo.FinalStep.PGPPoints#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Caterer Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MealAvailable" class="control-label col-sm-3">Meal Provided:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="MealAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FinalStep.MealAvailable#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Meal be provided to Participants</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FinalStep.MealAvailable EQ 1  and Session.UserSuppliedInfo.FinalStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="MealProvidedBy" class="control-label col-sm-3">Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getCatererInformation" selected="#Session.UserSuppliedInfo.FinalStep.MealProvidedBy#" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Who Provides Meal</option>
								</cfselect>
							</div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Video Conference Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AllowVideoConference" class="control-label col-sm-3">Is Distance Education Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FinalStep.AllowVideoConference#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Can Participants participate via Distance Education</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FinalStep.AllowVideoConference EQ 1  and Session.UserSuppliedInfo.FinalStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control">#Session.UserSuppliedInfo.FinalStep.VideoConferenceInfo#</textarea><span id="VideoConferenceInfoCharacters"></span> Characters</div>
						</div>
						<div class="form-group">
							<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.UserSuppliedInfo.FinalStep.VideoConferenceCost#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<fieldset>
						<legend><h2>Webinar Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="WebinarEvent" class="control-label col-sm-3">Webinar Only Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="WebinarEvent" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FinalStep.WebinarEvent#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Webinar Only Event</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FinalStep.WebinarEvent EQ 1>
						<div class="form-group">
							<label for="WebinarConnectWebInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="WebinarConnectWebInfo" id="WebinarConnectWebInfo" class="form-control">#Session.UserSuppliedInfo.FinalStep.WebinarConnectWebInfo#</textarea><span id="WebinarConnectWebInfoCharacters"></span> Characters</div>
						</div>
						<div class="form-group">
							<label for="WebinarMemberCost" class="control-label col-sm-3">Member Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarMemberCost" name="WebinarMemberCost" value="#Session.UserSuppliedInfo.FinalStep.WebinarMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="control-label col-sm-3">NonMember Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarNonMemberCost" name="WebinarNonMemberCost" value="#Session.UserSuppliedInfo.FinalStep.WebinarNonMemberCost#" required="yes"></div>
						</div>
					<cfelseif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<br />
						<fieldset>
							<legend><h2>Event Facility Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="LocationID" class="control-label col-sm-3">Location of Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityInformation" selected="#Session.UserSuppliedInfo.FinalStep.LocationID#" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Location of Event</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="LocationRoomID" class="control-label col-sm-3">Which Room at Facility:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityRoomInfo" selected="#Session.UserSuppliedInfo.FinalStep.LocationRoomID#" value="RoomID" Display="RoomName"  queryposition="below">
								<option value="----">Select Which Room at Facility this event is held in</option></cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="RoomMaxParticipants" class="control-label col-sm-3">Maximum Particpants:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control MemberCost" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.UserSuppliedInfo.FinalStep.RoomMaxParticipants#" required="yes">
							</div>
						</div>

						<div class="form-group">
							<label for="MemberCost" class="control-label col-sm-3">Member Pricing To Attend:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control MemberCost" id="MemberCost" name="MemberCost" value="#Session.UserSuppliedInfo.FinalStep.MemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="NonMemberCost" class="control-label col-sm-3">NonMember Pricing To Attend:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfinput type="text" class="form-control NonMemberCost" id="NonMemberCost" name="NonMemberCost" value="#Session.UserSuppliedInfo.FinalStep.NonMemberCost#" required="yes"></div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 4">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event"><br /><br />
				</div>
			</cfform>
		</div>
		<script type="text/javascript">
			$('##LongDescription').keyup(LongDescriptionupdateCounter);
			$('##LongDescription').keydown(LongDescriptionupdateCounter);

			function LongDescriptionupdateCounter() {
				var cs = $(this).val().length;
				$('##LongDescriptionCharacters').text(cs);
			}

			$('##GroupPriceRequirements').keyup(GroupPriceRequirementsupdateCounter);
			$('##GroupPriceRequirements').keydown(GroupPriceRequirementsupdateCounter);

			function GroupPriceRequirementsupdateCounter() {
				var cs = $(this).val().length;
				$('##GroupPriceRequirementsCharacters').text(cs);
			}

			$('##VideoConferenceInfo').keyup(VideoConferenceInfoupdateCounter);
			$('##VideoConferenceInfo').keydown(VideoConferenceInfoupdateCounter);

			function VideoConferenceInfoupdateCounter() {
				var cs = $(this).val().length;
				$('##VideoConferenceInfoCharacters').text(cs);
			}

			$('##WebinarConnectWebInfo').keyup(WebinarConnectWebInfoupdateCounter);
			$('##WebinarConnectWebInfo').keydown(WebinarConnectWebInfoupdateCounter);

			function WebinarConnectWebInfoupdateCounter() {
				var cs = $(this).val().length;
				$('##WebinarConnectWebInfoCharacters').text(cs);
			}
		</script>
	</cfif>
</cfoutput>
