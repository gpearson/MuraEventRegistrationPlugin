<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("URL.EventRecID")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>

	<cfquery name="getEventExpenses" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		SELECT p_EventRegistration_ExpenseList.Expense_Name, p_EventRegistration_EventExpenses.Event_ID, p_EventRegistration_EventExpenses.Cost_Amount, p_EventRegistration_EventExpenses.dateCreated, p_EventRegistration_EventExpenses.lastUpdated, p_EventRegistration_EventExpenses.lastUpdateBy, p_EventRegistration_EventExpenses.lastUpdateByID, p_EventRegistration_EventExpenses.Active, p_EventRegistration_EventExpenses.Cost_Verified, p_EventRegistration_EventExpenses.TContent_ID
		FROM p_EventRegistration_EventExpenses INNER JOIN p_EventRegistration_ExpenseList ON p_EventRegistration_ExpenseList.TContent_ID = p_EventRegistration_EventExpenses.Expense_ID
		Where p_EventRegistration_EventExpenses.Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and p_EventRegistration_EventExpenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
	</cfquery>
	
	<cfquery name="getAvailableExpenseList" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_ExpenseList
		where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		Order by Expense_Name
	</cfquery>
	<cfset Session.getSelectedEvent = #StructCopy(getSelectedEvent)#>
	<cfset Session.getAvailableExpenseList = #StructCopy(getAvailableExpenseList)#>
	<cfset Session.getEventExpenses = #StructCopy(getEventExpenses)#>
<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("FORM.UserAction")>
	<cfif FORM.UserAction EQ "Back to Events Menu">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "SiteConfigSettings")>
		<cfset temp = StructDelete(Session, "getAllEvents")>
		<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
		<cfset temp = StructDelete(Session, "getEventExpenses")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfif FORM.UserAction EQ "Back to Event Expenses">
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=" & URL.EventID >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=" & URL.EventID >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput = #StructCopy(FORM)#>
	</cflock>

	<cfswitch expression="#FORM.UserAction#">
		<cfcase value="Expenses Entered and Verified">
			<cfquery name="updateEventExpense" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Update p_EventRegistration_EventExpenses
				Set Cost_Verified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
					lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
					lastUpdateByID =<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
				Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and Cost_Verified = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventExpensesCostVerified&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventExpensesCostVerified&Successful=True">
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfcase>
		
		<cfcase value="Update Event Expense">
			<cfif not isNumeric(FORM.ExpenseAmount)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the amount of the expense. System detected a non-numeric character in the amount field."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>

				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&EventRecID=#URL.EventRecID#&UserAction=UpdateExpense&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&EventRecID=#URL.EventRecID#&UserAction=UpdateExpense&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
			<cfset NewMemberCost = #EventServicesCFC.ConvertCurrencyToDecimal(FORM.ExpenseAmount)#>
			<cfquery name="updateEventExpense" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Update p_EventRegistration_EventExpenses
				Set Cost_Amount = <cfqueryparam value="#NumberFormat(Variables.NewMemberCost, '999999.99')#" cfsqltype="cf_sql_decimal">,
					lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
					lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
				Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and TContent_ID = <cfqueryparam value="#URL.EventRecID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&UserAction=ExpenseUpdated&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&UserAction=ExpenseUpdated&Successful=True">
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfcase>
		<cfcase value="Add Expense">
			<cfif FORM.ExpenseID EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select one of the Expenses from the DropDown Box. If all expenses have been entered and amounts verified, simply click the button 'Generate Profit/Loss Report'"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			</cfif>
			<cfif not isNumeric(FORM.ExpenseAmount)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the amount of the expense. System detected a non-numeric character in the amount field."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			</cfif>
			<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
			<cfset NewMemberCost = #EventServicesCFC.ConvertCurrencyToDecimal(FORM.ExpenseAmount)#>
			<cfquery name="insertNewEventExpense" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Insert into p_EventRegistration_EventExpenses(Site_ID, Event_ID, Cost_Amount, Expense_ID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, Cost_Verified)
				Values(
					<cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#NumberFormat(Variables.NewMemberCost, '999999.99')#" cfsqltype="cf_sql_decimal">,
					<cfqueryparam value="#FORM.ExpenseID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
					<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">
				)
			</cfquery>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&UserAction=ExpenseAdded&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&UserAction=ExpenseAdded&Successful=True">
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfcase>
	</cfswitch>
<cfelseif isDefined("URL.EventID") and isDefined("URL.EventRecID") and isDefined("URL.UserAction")>
	<cfquery name="getSelectedEventExpense" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		SELECT p_EventRegistration_ExpenseList.Expense_Name, p_EventRegistration_EventExpenses.Event_ID, p_EventRegistration_EventExpenses.Cost_Amount, p_EventRegistration_EventExpenses.dateCreated, p_EventRegistration_EventExpenses.lastUpdated, p_EventRegistration_EventExpenses.lastUpdateBy, p_EventRegistration_EventExpenses.lastUpdateByID, p_EventRegistration_EventExpenses.Active, p_EventRegistration_EventExpenses.Cost_Verified, p_EventRegistration_EventExpenses.TContent_ID
		FROM p_EventRegistration_EventExpenses INNER JOIN p_EventRegistration_ExpenseList ON p_EventRegistration_ExpenseList.TContent_ID = p_EventRegistration_EventExpenses.Expense_ID
		Where p_EventRegistration_EventExpenses.Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and p_EventRegistration_EventExpenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_EventExpenses.TContent_ID = <cfqueryparam value="#URL.EventRecID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset Session.getSelectedEventExpense = #StructCopy(getSelectedEventExpense)#>
</cfif>