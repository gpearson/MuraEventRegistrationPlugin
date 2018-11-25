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
	<cfset Session.FormErrors = #ArrayNew()#>
	<cfif not isDefined("Session.UserSuppliedInfo")><cfset Session.UserSuppliedInfo = #StructNew()#></cfif>
</cflock>
<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfoutput>
	<cfif not isDefined("FORM.formSubmit")>
		<script>
			$(function() {
				$("##ReportStartDate").datepicker();
				$("##ReportEndDate").datepicker();
			});
		</script>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Year End Report</h3>
			</div>
			<div class="art-blockcontent">
				<div class="alert-box notice">Please complete the following information to display a report that will list each event witihn the timeperiod selected broken down by school corporations.</div>
				<hr>
				<uForm:form action="" method="Post" id="AddEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
					commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
					cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin&compactDisplay=false"
					submitValue="Display Report" loadValidation="true" loadMaskUI="true" loadDateUI="false"
					loadTimeUI="false">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="formSubmit" value="true">
					<uForm:fieldset legend="Start / End Date">
						<uform:field label="Report Start Date" name="ReportStartDate" id="ReportStartDate" isRequired="true" type="date" hint="Starting Date for Report" />
						<uform:field label="Report End Date" name="ReportEndDate" id="ReportEndDate" isRequired="true" type="date" hint="Ending Date for Report" />
					</uForm:fieldset>
					<uForm:fieldset legend="Display Corporation Participants">
						<uform:field label="Show Participants" name="ShowParticipants" type="select" hint="Show Participants who Attended Events?">
							<uform:option display="Yes" value="1" isSelected="true" />
							<uform:option display="No" value="0" />
						</uform:field>
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	<cfelseif isDefined("FORM.formSubmit")>
		<cfset ReportTemplateDir = #Left(ExpandPath("*"), Find("*", ExpandPath("*")) - 1)#>
		<cfset ReportCompletedFile = #Variables.ReportTemplateDir# & "library/ReportExports/" & #DateFormat(Session.FormResponse.Info.ReportStartDate, "yyyy")# & "-" & #DateFormat(Session.FormResponse.Info.ReportEndDate, "yyyy")#  & "YearEndReport.pdf">
		<cfset ReportName = #DateFormat(Session.FormResponse.Info.ReportStartDate, "yyyy")# & "-" & #DateFormat(Session.FormResponse.Info.ReportEndDate, "yyyy")#  & "YearEndReport.pdf">
		<cfset TotalRegistrations = 0>
		<cfdocument format="PDF" filename="#Variables.ReportCompletedFile#" overwrite="yes">
			<table border="0" align="Center" Width="100%" Cellspacing="0" cellpadding="0">
				<tr>
					<td width="200"><img src="/plugins/EventRegistration/library/images/NIESC_Logo.png" width="175" height="114"></td>
					<td style="Font-Family: Arial; Font-Size: 18px; Font-Weight: Bold">#DateFormat(Session.FormResponse.Info.ReportStartDate, "yyyy")# - #DateFormat(Session.FormResponse.Info.ReportEndDate, "yyyy")#<br />Year End Event Report</td>
				</tr>
			</table>
		<cfloop array="#Session.YearlyEvents#" index="RecNo">
			<cfif ArrayLen(RecNo) IS 2>
				<cfset GetRegistrationUsers = #RecNo[2]#>
				<p style="Font-Family: Arial; Font-Size: 14px;">#RecNo[1]["ShortTitle"]# - #DateFormat(RecNo[1]['EventDate'], "full")# - Total Registrations (#GetRegistrationUsers.RecordCount#)<br>Member Cost: #DollarFormat(RecNo[1]["MemberCost"])# / NonMember Cost: #DollarFormat(RecNo[1]["NonMemberCost"])#</p>
			<cfelse>
				<p style="Font-Family: Arial; Font-Size: 14px;">#RecNo[1]["ShortTitle"]# - #DateFormat(RecNo[1]['EventDate'], "full")# - Total Registrations (0)<br>Member Cost: #DollarFormat(RecNo[1]["MemberCost"])# / NonMember Cost: #DollarFormat(RecNo[1]["NonMemberCost"])#</p>
			</cfif>
			<cfif ArrayLen(RecNo) EQ 1></li>
			<cfelse>
				<ul>
					<cfset GetRegistrationUsers = #RecNo[2]#>
					<cfset TotalRegistrations = #Variables.TotalRegistrations# + #GetRegistrationUsers.RecordCount#>
					<cfquery name="DistinctDomain" dbtype="query">Select Distinct EmailDomain from GetRegistrationUsers</cfquery>
					<cfloop query="DistinctDomain">
						<cfquery name="RegistrationDomain" dbtype="query">Select * from GetRegistrationUsers Where EmailDomain = '#DistinctDomain.EmailDomain#' Order by LName</cfquery>
						<li><strong>#DistinctDomain.EmailDomain#</strong> - <Font Color="Red">Total #RegistrationDomain.RecordCount#</Font>
						<cfif Session.FormResponse.Info.ShowParticipants EQ 1>
							<ul><cfloop query="RegistrationDomain">
								<li>#RegistrationDomain.LName#, #RegistrationDomain.FName# (#RegistrationDomain.Email#)</li>
							</cfloop></ul>
						<cfelse>
							<cfif DistinctDomain.EmailDomain CONTAINS "k12.in.us">
							<cfelseif DistinctDomain.EmailDomain CONTAINS "baugo.org">
							<cfelseif DistinctDomain.EmailDomain CONTAINS "wanee.org">
							<cfelseif DistinctDomain.EmailDomain CONTAINS "goshenschools.org">
							<cfelseif DistinctDomain.EmailDomain CONTAINS "zebras.net">
							<cfelse>
								<ul><cfloop query="RegistrationDomain">
									<li>#RegistrationDomain.LName#, #RegistrationDomain.FName# (#RegistrationDomain.Email#)</li>
								</cfloop></ul>
							</cfif>
						</cfif>
						</li>
					</cfloop>
				</UL>
			</cfif>
			<br />
		</cfloop>
		Total Registrations Between #DateFormat(Session.FormResponse.Info.ReportStartDate, "mmm dd, yyyy")# and #DateFormat(Session.FormResponse.Info.ReportEndDate, "mmm dd, yyyy")# was #Variables.TotalRegistrations#<br />
		Total Unique Registrations Between #DateFormat(Session.FormResponse.Info.ReportStartDate, "mmm dd, yyyy")# and #DateFormat(Session.FormResponse.Info.ReportEndDate, "mmm dd, yyyy")# was #Session.UniqueRegistrations.RecordCount#<br />
		</cfdocument>
		<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tbody>
				<tr>
					<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
						<embed src="/plugins/EventRegistration/library/ReportExports/#Variables.ReportName#" width="850" height="600">
					</td>
				</tr>
			</tbody>
		</table>
	</cfif>
</cfoutput>