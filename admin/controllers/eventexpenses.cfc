/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
	</cffunction>

	<cffunction name="addexpense" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfif not isDefined("Session.UserSuppliedInfo")>
					<cfset Session.UserSuppliedInfo = StructNew()>
					<cfset Session.UserSuppliedInfo.NewRecNo = 0>
				</cfif>
			</cflock>
			<cftry>
				<cfquery name="insertNewEventExpense" result="insertNewEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into eEvent_ExpenseList(Site_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy)
					Values (
						<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#FORM.ExpenseName#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#FORM.ExpenseActive#" cfsqltype="CF_SQL_BIT">,
						<cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">,
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
					)
				</cfquery>
				<cfcatch type="Database">
					<cfdump var="#CFCATCH#"><cfabort>
				</cfcatch>
			</cftry>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:eventexpenses.default&Successful=True&UserAction=AddExpenseCategory" addtoken="false">
		<cfelse>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif not isDefined("Session.UserSuppliedInfo")>
					<cfset Session.UserSuppliedInfo = StructNew()>
					<cfset Session.UserSuppliedInfo.NewRecNo = 0>
				</cfif>
			</cflock>
		</cfif>
	</cffunction>

	<cffunction name="updateexpense" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cftry>
				<cfquery name="insertNewEventExpense" result="insertNewEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eEvent_ExpenseList
					Set Expense_Name = <cfqueryparam value="#FORM.ExpenseName#" cfsqltype="cf_sql_varchar">,
						Active = <cfqueryparam value="#FORM.ExpenseActive#" cfsqltype="CF_SQL_BIT">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventExpenseID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfcatch type="Database">
					<cfdump var="#CFCATCH#"><cfabort>
				</cfcatch>
			</cftry>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:eventexpenses.default&Successful=True&UserAction=UpdateExpenseCategory" addtoken="false">
		<cfelse>
			<cfquery name="getExpenseCategory" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Site_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy
				From eEvent_ExpenseList
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.ExpenseID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.ExpenseName = #getExpenseCategory.Expense_Name#>
				<cfset Session.UserSuppliedInfo.Active = #getExpenseCategory.Active#>
				<cfset Session.UserSuppliedInfo.dateCreated = #getExpenseCategory.dateCreated#>
				<cfset Session.UserSuppliedInfo.lastUpdated = #getExpenseCategory.lastUpdated#>
				<cfset Session.UserSuppliedInfo.lastUpdateBy = #getExpenseCategory.lastUpdateBy#>
			</cflock>
		</cfif>
	</cffunction>

	<cffunction name="deactivateexpense" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cftry>
				<cfquery name="insertNewEventExpense" result="insertNewEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eEvent_ExpenseList
					Set Active = <cfqueryparam value="0" cfsqltype="CF_SQL_BIT">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventExpenseID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfcatch type="Database">
					<cfdump var="#CFCATCH#"><cfabort>
				</cfcatch>
			</cftry>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:eventexpenses.default&Successful=True&UserAction=DeactivateExpenseCategory" addtoken="false">
		<cfelse>
			<cfquery name="getExpenseCategory" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Site_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy
				From eEvent_ExpenseList
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.ExpenseID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.ExpenseName = #getExpenseCategory.Expense_Name#>
				<cfset Session.UserSuppliedInfo.Active = #getExpenseCategory.Active#>
				<cfset Session.UserSuppliedInfo.dateCreated = #getExpenseCategory.dateCreated#>
				<cfset Session.UserSuppliedInfo.lastUpdated = #getExpenseCategory.lastUpdated#>
				<cfset Session.UserSuppliedInfo.lastUpdateBy = #getExpenseCategory.lastUpdateBy#>
			</cflock>
		</cfif>
	</cffunction>

	<cffunction name="activateexpense" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cftry>
				<cfquery name="updateEventExpense" result="updateEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eEvent_ExpenseList
					Set Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="CF_SQL_DATE">,
						lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#FORM.EventExpenseID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfcatch type="Database">
					<cfdump var="#CFCATCH#"><cfabort>
				</cfcatch>
			</cftry>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:eventexpenses.default&Successful=True&UserAction=ActivateExpenseCategory" addtoken="false">
		<cfelse>
			<cfquery name="getExpenseCategory" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Site_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy
				From eEvent_ExpenseList
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.ExpenseID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo = StructNew()>
				<cfset Session.UserSuppliedInfo.ExpenseName = #getExpenseCategory.Expense_Name#>
				<cfset Session.UserSuppliedInfo.Active = #getExpenseCategory.Active#>
				<cfset Session.UserSuppliedInfo.dateCreated = #getExpenseCategory.dateCreated#>
				<cfset Session.UserSuppliedInfo.lastUpdated = #getExpenseCategory.lastUpdated#>
				<cfset Session.UserSuppliedInfo.lastUpdateBy = #getExpenseCategory.lastUpdateBy#>
			</cflock>
		</cfif>
	</cffunction>
</cfcomponent>