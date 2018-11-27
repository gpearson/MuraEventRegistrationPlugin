<cfif LEN(arguments.MailServerUsername) and LEN(arguments.MailServerPassword)>
	<cfmail To="#Session.Mura.Fname# #Session.Mura.Lname# <#Session.Mura.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Event Registration Summary Confirmation Email for: #getSelectedEvent.ShortTitle#" server="#Arguments.mailServerHostname#" username="#Arguments.MailServerUsername#" password="#Arguments.MailServerPassword#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
	<cfmailpart type="text/plain">
#Session.Mura.Fname# #Session.Mura.Lname#,

<cfif ListLen(Arguments.RegisterIndividuals) EQ 1>
Thank you for registering the following individual from your organization to #getSelectedEvent.ShortTitle# on #DateFormat(getSelectedEvent.EventDate, "full")#:
<cfelse>
Thank you for registering the following individuals from your organization to #getSelectedEvent.ShortTitle# on #DateFormat(getSelectedEvent.EventDate, "full")#:
</cfif>
<cfloop list="#Arguments.RegisterIndividuals#" delimiters="," index="i"><cfquery name="getRegisteredUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select Fname, Lname, Email From tusers Where UserID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"></cfquery>#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# (#getRegisteredUserInfo.Email#)</cfloop>

<cfif Session.FormInput.RegisterStep1.EmailConfirmations Contains 1>Each Individual registered will also receive an event confirmation email</cfif>

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"#Session.Mura.Fname# #Session.Mura.Lname#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><cfif ListLen(Arguments.RegisterIndividuals) EQ 1>Thank you for registering the following individual from your organization to #getSelectedEvent.ShortTitle# on #DateFormat(getSelectedEvent.EventDate, "full")#:<cfelse>Thank you for registering the following individuals from your organization to #getSelectedEvent.ShortTitle# on #DateFormat(getSelectedEvent.EventDate, "full")#:</cfif></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<cfloop list="#Arguments.RegisterIndividuals#" delimiters="," index="i"><cfquery name="getRegisteredUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select Fname, Lname, Email From tusers Where UserID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"></cfquery><tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# (#getRegisteredUserInfo.Email#)</td></tr></cfloop>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><cfif Session.FormInput.RegisterStep1.EmailConfirmations Contains 1>Each Individual registered will also receive an event confirmation email</cfif></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>		
<cfelse>
	<cfmail To="#Session.Mura.Fname# #Session.Mura.Lname# <#Session.Mura.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Event Confirmation Email for: #getSelectedEvent.ShortTitle#" server="#Arguments.mailServerHostname#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
	<cfmailpart type="text/plain">
#Session.Mura.Fname# #Session.Mura.Lname#,

<cfif ListLen(Arguments.RegisterIndividuals) EQ 1>
Thank you for registering the following individual from your organization to #getSelectedEvent.ShortTitle# on #DateFormat(getSelectedEvent.EventDate, "full")#:
<cfelse>
Thank you for registering the following individuals from your organization to #getSelectedEvent.ShortTitle# on #DateFormat(getSelectedEvent.EventDate, "full")#:
</cfif>
<cfloop list="#Arguments.RegisterIndividuals#" delimiters="," index="i"><cfquery name="getRegisteredUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select Fname, Lname, Email From tusers Where UserID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"></cfquery>#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# (#getRegisteredUserInfo.Email#)</cfloop>

<cfif Session.FormInput.RegisterStep1.EmailConfirmations Contains 1>Each Individual registered will also receive an event confirmation email</cfif>

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"#Session.Mura.Fname# #Session.Mura.Lname#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><cfif ListLen(Arguments.RegisterIndividuals) EQ 1>Thank you for registering the following individual from your organization to #getSelectedEvent.ShortTitle# on #DateFormat(getSelectedEvent.EventDate, "full")#:<cfelse>Thank you for registering the following individuals from your organization to #getSelectedEvent.ShortTitle# on #DateFormat(getSelectedEvent.EventDate, "full")#:</cfif></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<cfloop list="#Arguments.RegisterIndividuals#" delimiters="," index="i"><cfquery name="getRegisteredUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select Fname, Lname, Email From tusers Where UserID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar"></cfquery><tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# (#getRegisteredUserInfo.Email#)</td></tr></cfloop>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><cfif Session.FormInput.RegisterStep1.EmailConfirmations Contains 1>Each Individual registered will also receive an event confirmation email</cfif></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>
</cfif>