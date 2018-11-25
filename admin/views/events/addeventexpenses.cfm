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
<cfif isDefined("URL.Successful")>
	<cfswitch expression="#URL.Successful#">
		<cfcase value="true">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="AddedEventExpense">
						<div class="alert-box success">
							<p>Your have successfully added a new expense for this event.</p>
						</div>
					</cfcase>
				</cfswitch>
			</cfif>
		</cfcase>
		<cfcase value="false">
			<cfswitch expression="#URL.UserAction#">
				<cfcase value="NoRegistrations">
					<div class="alert-box notice">
						<p>The Event you tried to send an email to did not have any users registered for it. For this reason emails were not sent from this system.</p>
					</div>
				</cfcase>
			</cfswitch>
		</cfcase>
	</cfswitch>
</cfif>
<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Add new Event Expense for #Session.getEvent.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete the following information to add a new event expense.</div>
			<hr>
			<uForm:form action="" method="Post" id="AddEventExpenses" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
				submitValue="Add Event Expense" loadValidation="true" loadMaskUI="true" loadDateUI="false"
				loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="EventID" value="#URL.EventID#">
				<uForm:fieldset legend="Expense Information">
					<uform:field label="Expense Name" name="EventExpenseID" id="EventExpenseID" isRequired="true" type="select" hint="Name of Expense that can be associated with an Event">
						<uform:option display="Select Expense from List" value="0" isSelected="true" />
						<cfloop query="Session.getEventExpenseList">
							<uform:option display="#Session.getEventExpenseList.Expense_Name#" value="#Session.getEventExpenseList.TContent_ID#" />
						</cfloop>
					</uform:field>
					<uform:field label="Expense Amount" name="ExpenseAmount" type="text" value="#NumberFormat('0.00', '9999.99')#" hint="The Amount of the Expense. Just enter Dollars and Cents Only" />
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>