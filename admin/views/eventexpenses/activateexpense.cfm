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
<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Activate Expense Category</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete the following information to activate this expense category.</div>
			<hr>
			<uForm:form action="" method="Post" id="ActivateExpenses" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
				submitValue="Activate Expense Category" loadValidation="true" loadMaskUI="true" loadDateUI="false"
				loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="EventExpenseID" value="#URL.ExpenseID#">
				<uForm:fieldset legend="Expense Information">
					<uform:field label="Expense Name" name="ExpenseName" id="ExpenseName" isRequired="true" value="#Session.UserSuppliedInfo.ExpenseName#" isDisabled="true" type="text" hint="Name of Expense that can be associated with an Event" />
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>