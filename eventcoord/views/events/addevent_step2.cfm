<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<script>
		$(function() {
			$("##EventDate1").datepicker();
			$("##EventDate2").datepicker();
			$("##EventDate3").datepicker();
			$("##EventDate4").datepicker();
			$("##Featured_StartDate").datepicker();
			$("##Featured_EndDate").datepicker();
			$("##EarlyBird_RegistrationDeadline").datepicker();
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
			});

	</script>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add New Event or Workshop - Step 2</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="alert alert-info">This is Step 2 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
					<cfif Session.UserSuppliedInfo.EventSpanDates EQ 1>
						<div class="panel-heading"><h1>Additional Dates for Event or Workshop</h1></div>
						<div class="form-group">
							<label for="EventDate1" class="control-label col-sm-3">2nd Event Date:&nbsp;</label>
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
					<div class="panel-heading"><h1>Additional Detail Information for Event or Workshop</h1></div>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventAgenda" id="EventAgenda" class="form-control"></textarea></div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control"></textarea></div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventStrategies" id="EventStrategies" class="form-control"></textarea></div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control"></textarea></div>
					</div>
					<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Event Pricing</h1></div>
						<div class="form-group">
							<label for="MemberCost" class="control-label col-sm-3">Member Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control MemberCost" id="MemberCost" name="MemberCost" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="NonMemberCost" class="control-label col-sm-3">NonMember Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control NonMemberCost" id="NonMemberCost" name="NonMemberCost" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.EventFeatured EQ 1>
						<div class="panel-heading"><h1>Event Featured Information</h1></div>
						<div class="form-group">
							<label for="Featured_StartDate" class="control-label col-sm-3">Start Date to be Featured:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="control-label col-sm-3">End Date to be Featured:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_SortOrder" class="control-label col-sm-3">Featured Sort order:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_SortOrder" name="Featured_SortOrder" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1>
						<div class="panel-heading"><h1>Event Early Bird Registration Information</h1></div>
						<div class="form-group">
							<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Featured Sort order:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_Member" class="control-label col-sm-3">EarlyBird Member Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_Member" name="EarlyBird_Member" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">EarlyBird NonMember Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Event Special Pricing Information</h1></div>
						<div class="form-group">
							<label for="SpecialPriceRequirements" class="control-label col-sm-3">Requirements to Meet Special Pricing:&nbsp;</label>
							<div class="col-sm-8"><textarea name="SpecialPriceRequirements" id="SpecialPriceRequirements" class="form-control"></textarea></div>
						</div>
						<div class="form-group">
							<label for="SpecialMemberCost" class="control-label col-sm-3">Special Member Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="SpecialMemberCost" name="SpecialMemberCost" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="SpecialNonMemberCost" class="control-label col-sm-3">Special NonMember Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="SpecialNonMemberCost" name="SpecialNonMemberCost" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1>
						<div class="panel-heading"><h1>Professional Growth Point Certificate Available</h1></div>
						<div class="form-group">
							<label for="PGPPoints" class="control-label col-sm-3">Number of PGP Points:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.MealProvided EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Caterer Information</h1></div>
						<div class="form-group">
							<label for="MealCost_Estimated" class="control-label col-sm-3">Meal Cost Estimated:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="MealCost_Estimated" name="MealCost_Estimated" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="MealProvidedBy" class="control-label col-sm-3">Provided By:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getCatererInformation" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Who Provides Meal</option>
								</cfselect>
							</div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Video Conference Information</h1></div>
						<div class="form-group">
							<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control"></textarea></div>
						</div>
						<div class="form-group">
							<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1>
						<div class="panel-heading"><h1>Webinar Information</h1></div>
						<div class="form-group">
							<label for="WebinarConnectWebInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="WebinarConnectWebInfo" id="WebinarConnectWebInfo" class="form-control"></textarea></div>
						</div>
						<div class="form-group">
							<label for="WebinarMemberCost" class="control-label col-sm-3">Member Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarMemberCost" name="WebinarMemberCost" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="control-label col-sm-3">NonMember Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarNonMemberCost" name="WebinarNonMemberCost" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Event Held At</h1></div>
						<div class="form-group">
							<label for="LocationID" class="control-label col-sm-3">Location of Event:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityInformation" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Location of Event</option>
								</cfselect>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="RegisterAccount" class="btn btn-primary pull-right" value="Add Event - Step 3"><br /><br />
				</div>
			</cfform>
			<cfdump var="#Session#">
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add New Event or Workshop - Step 2</h1></div>
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
					<div class="alert alert-info">This is Step 2 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
					<cfif Session.UserSuppliedInfo.EventSpanDates EQ 1>
						<div class="panel-heading"><h1>Additional Dates for Event or Workshop</h1></div>
						<div class="form-group">
							<label for="EventDate1" class="control-label col-sm-3">2nd Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate1" value="#Session.UserSuppliedInfo.EventDate1#" name="EventDate1" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">3rd Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.UserSuppliedInfo.EventDate2#" required="no"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">4th Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.UserSuppliedInfo.EventDate3#" required="no"></div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">5th Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.UserSuppliedInfo.EventDate4#" required="no"></div>
						</div>
					</cfif>
					<div class="panel-heading"><h1>Additional Detail Information for Event or Workshop</h1></div>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventAgenda" id="EventAgenda" class="form-control">#Session.UserSuppliedInfo.EventAgenda#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control">#Session.UserSuppliedInfo.EventTargetAudience#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventStrategies" id="EventStrategies" class="form-control">#Session.UserSuppliedInfo.EventStrategies#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control">#Session.UserSuppliedInfo.EventSpecialInstructions#</textarea></div>
					</div>
					<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Event Pricing</h1></div>
						<div class="form-group">
							<label for="MemberCost" class="control-label col-sm-3">Member Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="MemberCost" name="MemberCost" value="#Session.UserSuppliedInfo.MemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="NonMemberCost" class="control-label col-sm-3">NonMember Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="NonMemberCost" name="NonMemberCost" value="#Session.UserSuppliedInfo.NonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.EventFeatured EQ 1>
						<div class="panel-heading"><h1>Event Featured Information</h1></div>
						<div class="form-group">
							<label for="Featured_StartDate" class="control-label col-sm-3">Start Date to be Featured:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#Session.UserSuppliedInfo.Featured_StartDate#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="control-label col-sm-3">End Date to be Featured:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#Session.UserSuppliedInfo.Featured_EndDate#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_SortOrder" class="control-label col-sm-3">Featured Sort order:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_SortOrder" name="Featured_SortOrder" value="#Session.UserSuppliedInfo.Featured_SortOrder#"  required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1>
						<div class="panel-heading"><h1>Event Early Bird Registration Information</h1></div>
						<div class="form-group">
							<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Featured Sort order:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" value="#Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_Member" class="control-label col-sm-3">EarlyBird Member Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_Member" name="EarlyBird_Member" value="#Session.UserSuppliedInfo.EarlyBird_Member#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">EarlyBird NonMember Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.UserSuppliedInfo.EarlyBird_NonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Event Special Pricing Information</h1></div>
						<div class="form-group">
							<label for="SpecialPriceRequirements" class="control-label col-sm-3">Requirements to Meet Special Pricing:&nbsp;</label>
							<div class="col-sm-8"><textarea name="SpecialPriceRequirements" id="SpecialPriceRequirements" class="form-control">#Session.UserSuppliedInfo.SpecialPriceRequirements#</textarea></div>
						</div>
						<div class="form-group">
							<label for="SpecialMemberCost" class="control-label col-sm-3">Special Member Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="SpecialMemberCost" name="SpecialMemberCost" value="#Session.UserSuppliedInfo.SpecialMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="SpecialNonMemberCost" class="control-label col-sm-3">Special NonMember Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="SpecialNonMemberCost" name="SpecialNonMemberCost" value="#Session.UserSuppliedInfo.SpecialNonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1>
						<div class="panel-heading"><h1>Professional Growth Point Certificate Available</h1></div>
						<div class="form-group">
							<label for="PGPPoints" class="control-label col-sm-3">Number of PGP Points:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" value="#Session.UserSuppliedInfo.PGPPoints#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.MealProvided EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Caterer Information</h1></div>
						<div class="form-group">
							<label for="MealCost_Estimated" class="control-label col-sm-3">Meal Cost Estimated:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="MealCost_Estimated" name="MealCost_Estimated" value="#Session.UserSuppliedInfo.MealCost_Estimated#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="MealProvidedBy" class="control-label col-sm-3">Provided By:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getCatererInformation" selected="#Session.UserSUppliedInfo.MealProvidedBy#" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Who Provides Meal</option>
								</cfselect>
							</div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Video Conference Information</h1></div>
						<div class="form-group">
							<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control">#Session.UserSuppliedInfo.VideoConferenceInfo#</textarea></div>
						</div>
						<div class="form-group">
							<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.UserSuppliedInfo.VideoConferenceCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1>
						<div class="panel-heading"><h1>Webinar Information</h1></div>
						<div class="form-group">
							<label for="WebinarConnectWebInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="WebinarConnectWebInfo" id="WebinarConnectWebInfo" class="form-control">#Session.UserSuppliedInfo.WebinarConnectWebInfo#</textarea></div>
						</div>
						<div class="form-group">
							<label for="WebinarMemberCost" class="control-label col-sm-3">Member Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarMemberCost" name="WebinarMemberCost" value="#Session.UserSuppliedInfo.WebinarMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="control-label col-sm-3">NonMember Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarNonMemberCost" name="WebinarNonMemberCost" value="#Session.UserSuppliedInfo.WebinarNonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
						<div class="panel-heading"><h1>Event Held At</h1></div>
						<div class="form-group">
							<label for="LocationID" class="control-label col-sm-3">Location of Event:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityInformation" selected="#Session.UserSuppliedInfo.LocationID#" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Location of Event</option>
								</cfselect>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="RegisterAccount" class="btn btn-primary pull-right" value="Add Event - Step 3"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>