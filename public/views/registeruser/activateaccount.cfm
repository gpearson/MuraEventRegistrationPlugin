<cfif not isDefined("URL.Key")><cflocation url="/index.cfm" addtoken="false"></cfif>
<cfif isDefined("URL.Key")>
	<cfset DecryptedURLString = #ToString(ToBinary(URL.Key))#>
	<cfset UserID = #ListFirst(Variables.DecryptedURLString, "&")#>
	<cfset DateSentCreated = #ListLast(Variables.DecryptedURLString, "&")#>

	<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

	<cfif not isDefined("Session.FormData")>
		<cfset Session.FormData = #StructNew()#>
		<cfset Session.FormData.PluginInfo = StructNew()>
		<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
		<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
		<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
		<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
		<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
	<cfelseif isDefined("Session.FormData")>
		<cfif StructCount(Session.FormData) EQ 0>
			<cfset Session.FormData = #StructNew()#>
			<cfset Session.FormData.PluginInfo = StructNew()>
			<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
			<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
			<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
			<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
			<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
		</cfif>
	</cfif>

	<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select Fname, Lname, UserName, Email, created
		From tusers
		Where UserID = <cfqueryparam value="#ListLast(Variables.UserID, '=')#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif DateDiff("n", ListLast(Variables.DateSentCreated, '='), Now()) LTE 45>
		<!--- Allow Up To 45 Minutes for user to click on the link to activate the account --->
		<cftry>
			<cfquery name="updateUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update tusers
				Set inActive = 0, LastUpdateBy = 'System', LastUpdateByID = '', LastUpdate = #Now()#
				Where UserID = <cfqueryparam value="#ListLast(Variables.UserID, '=')#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfcatch type="database">
				<cfdump var="#cfcatch#">
			</cfcatch>
		</cftry>

		<cfset SendActivationEmailConfirmation = #SendEmailCFC.SendAccountActivationEmailConfirmation(ListLast(Variables.UserID, '='))#>
		<cflocation url="/?UserRegistrationActive=true" addtoken="false">
	<cfelse>
		<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmail(ListLast(Variables.UserID, '='))#>
		<cflocation url="/?UserRegistrationActive=failed" addtoken="false">
	</cfif>
</cfif>
