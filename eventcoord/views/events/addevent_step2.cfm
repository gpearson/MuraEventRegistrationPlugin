<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>
<cfoutput>
	<script>
		$(function() {
			$("##EventDate1").datepicker();
			$("##EventDate2").datepicker();
			$("##EventDate3").datepicker();
			$("##EventDate4").datepicker();
			$("##EventDate5").datepicker();
		});
	</script>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Add new Event or Workshop</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">This is Step 2 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
			<hr>
			<uForm:form action="" method="Post" id="AddEvent"  errorMessagePlacement="both"
			commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
			cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent&compactDisplay=false"
			submitValue="Proceed To Step 3" loadValidation="true" loadMaskUI="true" loadDateUI="false"
			loadTimeUI="false">
			<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<input type="hidden" name="formSubmit" value="true">
			<input type="hidden" name="AcceptRegistrations" value="0">
			<input type="hidden" name="PerformAction" value="Step3">
			<cfif Session.UserSuppliedInfo.EventSpanDates EQ 1>
				<uForm:fieldset legend="Event Additional Date(s)">
					<cfif isDefined("Session.UserSuppliedInfo.EventDate1")>
						<uform:field label="Additional Event Date" name="EventDate1" isRequired="true" value="#Session.UserSuppliedInfo.EventDate1#" type="date" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
					<cfelse>
						<uform:field label="Additional Event Date" name="EventDate1" isRequired="true" type="date" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.EventDate2")>
						<uform:field label="Additional Event Date" name="EventDate2" isRequired="false" value="#Session.UserSuppliedInfo.EventDate2#" type="date" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
					<cfelse>
						<uform:field label="Additional Event Date" name="EventDate2" isRequired="false" type="date" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.EventDate3")>
						<uform:field label="Additional Event Date" name="EventDate3" isRequired="false" value="#Session.UserSuppliedInfo.EventDate3#" type="date" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
					<cfelse>
						<uform:field label="Additional Event Date" name="EventDate3" isRequired="false" type="date" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.EventDate4")>
						<uform:field label="Additional Event Date" name="EventDate4" isRequired="false" value="#Session.UserSuppliedInfo.EventDate4#" type="date" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
					<cfelse>
						<uform:field label="Additional Event Date" name="EventDate4" isRequired="false" type="date" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.EventDate5")>
						<uform:field label="Additional Event Date" name="EventDate5" isRequired="false" value="#Session.UserSuppliedInfo.EventDate5#" type="date" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." />
					<cfelse>
						<uform:field label="Additional Event Date" name="EventDate5" isRequired="false" type="date" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." />
					</cfif>
				</uForm:fieldset>
			</cfif>

			<uForm:fieldset legend="Event Details">
				<cfif isDefined("Session.UserSuppliedInfo.EventAgenda")>
					<uform:field label="Event Agenda" name="EventAgenda" isRequired="false" value="#Session.UserSuppliedInfo.EventAgenda#" type="textarea" hint="The Agenda if avaialble for this event." />
				<cfelse>
					<uform:field label="Event Agenda" name="EventAgenda" isRequired="false" type="textarea" hint="The Agenda if avaialble for this event." />
				</cfif>
				<cfif isDefined("Session.UserSuppliedInfo.EventAgenda")>
					<uform:field label="Event Target Audience" name="EventTargetAudience" value="#Session.UserSuppliedInfo.EventTargetAudience#" isRequired="false" type="textarea" hint="The Target Audience for this event. Who should come to this event" />
				<cfelse>
					<uform:field label="Event Target Audience" name="EventTargetAudience" isRequired="false" type="textarea" hint="The Target Audience for this event. Who should come to this event" />
				</cfif>
				<cfif isDefined("Session.UserSuppliedInfo.EventStrategies")>
					<uform:field label="Event Strategies" name="EventStrategies" isRequired="false" value="#Session.UserSuppliedInfo.EventStrategies#" type="textarea" hint="The Strategies of this event, if any." />
				<cfelse>
					<uform:field label="Event Strategies" name="EventStrategies" isRequired="false" type="textarea" hint="The Strategies of this event, if any." />
				</cfif>
				<cfif isDefined("Session.UserSuppliedInfo.EventSpecialInstructions")>
					<uform:field label="Event Special Instructions" name="EventSpecialInstructions" isRequired="false" value="#Session.UserSuppliedInfo.EventSpecialInstructions#" type="textarea" hint="If available, any special instructions participants need." />
				<cfelse>
					<uform:field label="Event Special Instructions" name="EventSpecialInstructions" isRequired="false" type="textarea" hint="If available, any special instructions participants need." />
				</cfif>
			</uForm:fieldset>
			<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
				<uForm:fieldset legend="Event Pricing">
					<cfif isDefined("Session.UserSuppliedInfo.MemberCost")>
						<uform:field label="Member Pricing" name="MemberCost" isRequired="true" type="text" value="#Session.UserSuppliedInfo.MemberCost#" hint="The cost for a member school district to attend per person." />
					<cfelse>
						<uform:field label="Member Pricing" name="MemberCost" isRequired="true" type="text" Value="#NumberFormat('0.00', '9999.99')#" hint="The cost for a member school district to attend per person." />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.NonMemberCost")>
						<uform:field label="NonMember Pricing" name="NonMemberCost" isRequired="true" type="text" value="#Session.UserSuppliedInfo.NonMemberCost#" hint="The cost for a nonmember school district to attend per person." />
					<cfelse>
						<uform:field label="NonMember Pricing" name="NonMemberCost" isRequired="true" type="text" Value="#NumberFormat('0.00', '9999.99')#" hint="The cost for a nonmember school district to attend per person." />
					</cfif>
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.EventFeatured EQ 1>
				<uForm:fieldset legend="Event Featured Information">
				<cfif isDefined("Session.UserSuppliedInfo.Featured_StartDate")>
					<uform:field label="Start Date" name="Featured_StartDate" isRequired="true" value="#Session.UserSuppliedInfo.Featured_StartDate#" type="date" inputClass="date" hint="The start date of this event being featured" />
				<cfelse>
					<uform:field label="Start Date" name="Featured_StartDate" isRequired="true" type="date" inputClass="date" hint="The start date of this event being featured" />
				</cfif>
				<cfif isDefined("Session.UserSuppliedInfo.Featured_EndDate")>
					<uform:field label="End Date" name="Featured_EndDate" isRequired="true" type="date" value="#Session.UserSuppliedInfo.Featured_EndDate#" inputClass="date" hint="The ending date of this event being featured" />
				<cfelse>
					<uform:field label="End Date" name="Featured_EndDate" isRequired="true" type="date" inputClass="date" hint="The ending date of this event being featured" />
				</cfif>
				<cfif isDefined("Session.UserSuppliedInfo.Featured_SortOrder")>
					<uform:field label="Sort Order" name="Featured_SortOrder" isRequired="true" maxFieldLength="3" value="#Session.UserSuppliedInfo.Featured_SortOrder#" type="text" hint="The Sort Order of this featured event. Lower the number higher in the listing" />
				<cfelse>
					<uform:field label="Sort Order" name="Featured_SortOrder" isRequired="true" maxFieldLength="3" value="100" type="text" hint="The Sort Order of this featured event. Lower the number higher in the listing" />
				</cfif>
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1>
				<uForm:fieldset legend="Early Bird Registration Information">
					<cfif isDefined("Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline")>
						<uform:field label="Registration Deadline" name="EarlyBird_RegistrationDeadline" isRequired="true" value="#Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline#" type="date" inputClass="date" hint="The cutoff date for Early Bird Registrations" />
					<cfelse>
						<uform:field label="Registration Deadline" name="EarlyBird_RegistrationDeadline" isRequired="true" type="date" inputClass="date" hint="The cutoff date for Early Bird Registrations" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.EarlyBird_MemberCost")>
						<uform:field label="Member Pricing" name="EarlyBird_MemberCost" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.EarlyBird_MemberCost, '9999.99')#" hint="The Early Bird Pricing for Member School Districts" />
					<cfelse>
						<uform:field label="Member Pricing" name="EarlyBird_MemberCost" isRequired="true" type="text" Value="#NumberFormat('0.00', '9999.99')#" hint="The Early Bird Pricing for Member School Districts" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.EarlyBird_NonMemberCost")>
						<uform:field label="NonMember Pricing" name="EarlyBird_NonMemberCost" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.EarlyBird_NonMemberCost, '9999.99')#" hint="The Early Bird Pricing for NonMember School Districts" />
					<cfelse>
						<uform:field label="NonMember Pricing" name="EarlyBird_NonMemberCost" isRequired="true" type="text" Value="#NumberFormat('0.00', '9999.99')#" hint="The Early Bird Pricing for NonMember School Districts" />
					</cfif>
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
				<uForm:fieldset legend="Event Special Pricing Information">
					<cfif isDefined("Session.UserSuppliedInfo.SpecialPriceRequirements")>
						<uform:field label="Requirements" name="SpecialPriceRequirements" isRequired="true" type="textarea" value="#Session.UserSuppliedInfo.SpecialPriceRequirements#" hint="The requirements a participant must meet to get this price for this event" />
					<cfelse>
						<uform:field label="Requirements" name="SpecialPriceRequirements" isRequired="true" type="textarea" hint="The requirements a participant must meet to get this price for this event" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.SpecialMemberCost")>
						<uform:field label="Member Pricing" name="SpecialMemberCost" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.SpecialMemberCost, '9999.99')#" hint="The Special Price for this event from a Member School Districts" />
					<cfelse>
						<uform:field label="Member Pricing" name="SpecialMemberCost" isRequired="true" type="text" Value="#NumberFormat('0.00', '9999.99')#" hint="The Special Price for this event from a Member School Districts" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.SpecialNonMemberCost")>
						<uform:field label="NonMember Pricing" name="SpecialNonMemberCost" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.SpecialNonMemberCost, '9999.99')#" hint="The Special Price for this event from a NonMember School Districts" />
					<cfelse>
						<uform:field label="NonMember Pricing" name="SpecialNonMemberCost" isRequired="true" type="text" Value="#NumberFormat('0.00', '9999.99')#" hint="The Special Price for this event from a NonMember School Districts" />
					</cfif>
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1>
				<uForm:fieldset legend="Event Professional Growth Points Information">
					<cfif isDefined("Session.UserSuppliedInfo.PGPPoints")>
						<uform:field label="Number of Points" name="PGPPoints" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.PGPPoints, '999.99')#" hint="The number of PGP Points available to particiapnt upon sucessfull completion of this event." />
					<cfelse>
						<uform:field label="Number of Points" name="PGPPoints" isRequired="true" type="text" Value="#NumberFormat('0.00', '999.99')#" hint="The number of PGP Points available to particiapnt upon sucessfull completion of this event." />
					</cfif>
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.MealProvided EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
				<cfquery name="getCatererInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, FacilityName
					From eCaterers
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
				</cfquery>
				<uForm:fieldset legend="Event Caterer Information">
					<cfif isDefined("Session.UserSuppliedInfo.MealCost_Estimated")>
						<uform:field label="Cost Per Person " name="MealCost_Estimated" isRequired="false" Value="#NumberFormat(Session.UserSuppliedInfo.MealCost_Estimated, '999.99')#" type="text" hint="The estimated cost per person for providing this meal." />
					<cfelse>
						<uform:field label="Cost Per Person " name="MealCost_Estimated" isRequired="false" Value="#NumberFormat('0.00', '999.99')#" type="text" hint="The estimated cost per person for providing this meal." />
					</cfif>
					<uform:field label="Meal Provided By" name="MealProvidedBy" type="select" isRequired="true" hint="Which Caterer is providing this meal?">
						<cfif getCatererInformation.RecordCount EQ 0>
							<uform:option display="Please Enter Caterer Information to Database First" value="0" isSelected="true" />
						<cfelse>
							<cfif isDefined("Session.UserSuppliedInfo.MealProvidedBy")>
								<uform:option display="Vendor/Speaker Provided Meal for Event" value="0" />
								<cfloop query="getCatererInformation">
									<cfif isDefined("Session.UserSuppliedInfo.MealProvidedBy")>
										<cfif #getCatererInformation.TContent_ID# EQ #Session.UserSuppliedInfo.MealProvidedBy#>
											<uform:option display="#getCatererInformation.FacilityName#" value="#getCatererInformation.TContent_ID#" isSelected="True" />
										<cfelse>
											<uform:option display="#getCatererInformation.FacilityName#" value="#getCatererInformation.TContent_ID#" isSelected="False" />
										</cfif>
									<cfelse>
									<uform:option display="#getCatererInformation.FacilityName#" value="#getCatererInformation.TContent_ID#" />
									</cfif>
								</cfloop>
							<cfelse>
								<uform:option display="Please Select Caterer from Listing" value="0" isSelected="true" />
								<cfloop query="getCatererInformation">
									<uform:option display="#getCatererInformation.FacilityName#" value="#getCatererInformation.TContent_ID#" />
								</cfloop>
							</cfif>
						</cfif>
					</uform:field>
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1 and Session.UserSuppliedInfo.WebinarEvent EQ 0>
				<uForm:fieldset legend="Event Video Conference Information">
					<uform:field label="Video Conference Details" name="VideoConferenceInfo" isRequired="false" type="textarea" hint="Information about Video Conference that participants need to know to be able to connect." />
					<uform:field label="Video Confernece Cost" name="VideoConferenceCost" type="text" Value="#NumberFormat('750.00', '9999.99')#" isRequired="true" hint="What are the costs for a participant to attend via video conference" />
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1>
				<uForm:fieldset legend="Event Webinar Information">
					<uform:field label="Webinar Connection Details" name="WebinarConnectWebInfo" isRequired="false" type="textarea" hint="Provide the details for users to be able to connect to this webinar. Give information just incase user has to get viewing device software installed." />
					<uform:field label="Webinar Member Cost" name="WebinarMemberCost" type="text" Value="#NumberFormat('750.00', '9999.99')#" isRequired="true" hint="What is the cost for a member participant to attend via this method" />
					<uform:field label="Webinar NonMember Cost" name="WebinarNonMemberCost" type="text" Value="#NumberFormat('1500.00', '9999.99')#" isRequired="true" hint="What is the cost for a nonmember participant to attend via this method" />
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
				<cfquery name="getFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, FacilityName
					From eFacility
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT"> and
						FacilityType = <cfqueryparam value="#Session.UserSuppliedInfo.LocationType#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getFacilityInformation.RecordCount>
					<uForm:fieldset legend="Event Held At">
						<uform:field label="Facility Location" name="LocationID" type="select" isRequired="true" hint="Where is this facility being held at?">
							<uform:option display="Please Select Facility from Listing" value="0" isSelected="true" />
							<cfif isDefined("Session.UserSuppliedInfo.LocationID")>
								<cfloop query="getFacilityInformation">
									<cfif getFacilityInformation.TContent_ID EQ Session.UserSuppliedInfo.LocationID>
										<uform:option display="#getFacilityInformation.FacilityName#" value="#getFacilityInformation.TContent_ID#" isSelected="true" />
									<cfelse>
										<uform:option display="#getFacilityInformation.FacilityName#" value="#getFacilityInformation.TContent_ID#" />
									</cfif>
								</cfloop>
							<cfelse>
								<cfloop query="getFacilityInformation">
									<uform:option display="#getFacilityInformation.FacilityName#" value="#getFacilityInformation.TContent_ID#" />
								</cfloop>
							</cfif>
						</uform:field>
					</uForm:fieldset>
				<cfelse>
					<uForm:fieldset legend="Event Held At">
						<uform:field label="Facility Location" name="LocationID" type="select" isRequired="true" hint="Where is this facility being held at?">
							<uform:option display="Please Add Facility to System" value="0" isSelected="true" />
						</uform:field>
					</uForm:fieldset>
				</cfif>
			</cfif>
		</uForm:form>
		</div>
	</div>
	</cfoutput>