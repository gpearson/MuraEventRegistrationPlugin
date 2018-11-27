<cfif LEN(arguments.MailServerUsername) and LEN(arguments.MailServerPassword)>
	<cfmail To="#getRegistrationInfo.ParticipantFName# #getRegistrationInfo.ParticipantLName# <#getRegistrationInfo.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Event Confirmation Email for: #getRegistrationInfo.ShortTitle#" server="#Arguments.mailServerHostname#" username="#Arguments.MailServerUsername#" password="#Arguments.MailServerPassword#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
		<cfmailparam file="#Variables.ReportExportLoc#" type="application/pdf" disposition="attachment">
	<cfmailparam file="#Variables.UserRegistrationiCalAbsoluteFilename#" type="text/calendar" disposition="attachment">
	<cfmailpart type="text/plain">
#getRegistrationInfo.ParticipantFName# #getRegistrationInfo.ParticipantLName#,

You have been registered for #getRegistrationInfo.ShortTitle# (#DateFormat(getRegistrationInfo.EventDate, "mm/dd/yyyy")#) through the #rc.$.siteConfig('site')#. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system. Attached is a PDF Document with your event confirmation for your records. PGP Certificates (if available) will be issued electronically after the event.

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegistrationInfo.ParticipantFName# #getRegistrationInfo.ParticipantLName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have been registered for #getRegistrationInfo.ShortTitle# (#DateFormat(getRegistrationInfo.EventDate, "mm/dd/yyyy")#) through the #rc.$.siteConfig('site')#. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system. Attached is a PDF Document with your event confirmation for your records. PGP Certificates (if available) will be issued electronically after the event.<br><br><br>Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</a></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>		
<cfelse>
	<cfmail To="#getRegistrationInfo.ParticipantFName# #getRegistrationInfo.ParticipantLName# <#getRegistrationInfo.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Event Confirmation Email for: #getRegistrationInfo.ShortTitle#" server="#Arguments.mailServerHostname#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
		<cfmailparam file="#Variables.ReportExportLoc#" type="application/pdf" disposition="attachment">
		<cfmailparam file="#Variables.UserRegistrationiCalAbsoluteFilename#" type="text/calendar" disposition="attachment">
		<cfmailpart type="text/plain">
#getRegistrationInfo.ParticipantFName# #getRegistrationInfo.ParticipantLName#,

You have been registered for #getRegistrationInfo.ShortTitle# (#DateFormat(getRegistrationInfo.EventDate, "mm/dd/yyyy")#) through the #rc.$.siteConfig('site')#. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system. Attached is a PDF Document with your event confirmation for your records. PGP Certificates (if available) will be issued electronically after the event.

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
		</cfmailpart>
		<cfmailpart type="text/html">
		<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegistrationInfo.ParticipantFName# #getRegistrationInfo.ParticipantLName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have been registered for #getRegistrationInfo.ShortTitle# (#DateFormat(getRegistrationInfo.EventDate, "mm/dd/yyyy")#) through the #rc.$.siteConfig('site')#. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system. Attached is a PDF Document with your event confirmation for your records. PGP Certificates (if available) will be issued electronically after the event.<br><br><br>Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</a></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
		</table>
		</body></html>
		</cfmailpart>
	</cfmail>
</cfif>