<cfsilent>
<!---

--->
</cfsilent>

<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">

<cfif not isDefined("URL.PerformAction")>
	<cflock timeout="60" scope="SESSION" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.UserSuppliedInfo = #StructNew()#>
	</cflock>
	<cfoutput>
		<script>
		$(function() {
			$("##YearBeginDate").datepicker();
			$("##YearEndDate").datepicker();
		});
	</script>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Year End Report by Events</h3>
			</div>
			<div class="art-blockcontent">
				<p class="alert-box notice">Please complete the following information to generate the Year End Report by Events</p>
				<hr>
				<uForm:form action="" method="Post" id="YearEndByEvents" errors="#Session.FormErrors#" errorMessagePlacement="both"
					commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
					cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:caterers&compactDisplay=false"
					submitValue="Display Year End Report" loadValidation="true" loadMaskUI="true" loadDateUI="false"
					loadTimeUI="false">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="formSubmit" value="true">
					<uForm:fieldset legend="Required Fields">
						<uForm:field label="Year Begin Date" name="YearBeginDate" isRequired="true" type="date" hint="Date to Begin the Report With" />
						<uForm:field label="Year End Date" name="YearEndDate" isRequired="true" type="date" hint="Date to End the Report With" />
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.PerformAction")>
	<cfswitch expression="#URL.PerformAction#">
		<cfcase value="DisplayReport">
			<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
			<cfset LogoPath = ArrayNew(1)>
			<cfloop from="1" to="#Session.ReportQuery.RecordCount#" step="1" index="i">
				<cfset LogoPath[i] = #ExpandPath("/plugins/EventRegistration/library/images/NIESC_Logo.png")#>
			</cfloop>
			<cfloop query="#Session.ReportQuery#" from="1" to="1">
				<cfset YearRangeFilename = #DateFormat(Session.ReportQuery.ReportFromDate, "yyyy")# & "_-_" & #DateFormat(Session.ReportQuery.ReportToDate, "yyyy")# & "_">
				<cfset YearRangeReportDate = #DateFormat(Session.ReportQuery.ReportFromDate, "yyyy")# & " - " & #DateFormat(Session.ReportQuery.ReportToDate, "yyyy")#>
			</cfloop>
			<cfif not #ListContainsNoCase(Session.ReportQuery.columnList, "NIESCLogoPath", ",")#>
				<cfset temp = QueryAddColumn(Session.ReportQuery, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
			</cfif>
			<cfset ReportDirectory = #ExpandPath("/plugins/EventRegistration/library/reports/")# >
			<cfset ReportExportLoc = #ExpandPath("/plugins/EventRegistration/library/ReportExports/")# & #Variables.YearRangeFilename# & "YearEndEventReport.pdf" >
			<cfset WebReportExportLoc = "/plugins/EventRegistration/library/ReportExports/" & #Variables.YearRangeFilename# & "YearEndEventReport.pdf">

			<jr:jasperreport jrxml="#ReportDirectory#/ProfitLossReportofEvents.jrxml" query="#Session.ReportQuery#" exportfile="#ReportExportLoc#" exportType="pdf" />
			<cfoutput><embed src="#Variables.WebReportExportLoc#" width="850" height="650"></cfoutput>
		</cfcase>
		<cfdefaultcase>
			<cfdump var="#URL#">
			<cfdump var="#Session#">
			<cfabort>
		</cfdefaultcase>
	</cfswitch>
</cfif>