<cfmail To="#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# <#getRegisteredUserInfo.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Confirmation Email for: #getEvent.ShortTitle#" server="127.0.0.1">
	<cfmailparam file="#Variables.ReportExportLoc#" type="application/pdf" disposition="attachment">
	<cfmailparam file="#Variables.UserRegistrationiCalAbsoluteFilename#" type="text/calendar" disposition="attachment">
<cfmailpart type="text/plain">
#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,

You have been registered for #getEvent.ShortTitle# (#DateFormat(getEvent.EventDate, "mm/dd/yyyy")#) through the #rc.$.siteConfig('site')#. Attached is a PDF Document with your event confirmation for your records. PGP Certiciates (if available) will be issued electronically after the event.

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have been registered for #getEvent.ShortTitle# (#DateFormat(getEvent.EventDate, "mm/dd/yyyy")#) through the #rc.$.siteConfig('site')#. Attached is a PDF Document with your event confirmation for your records. PGP Certiciates (if available) will be issued electronically after the event.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>
