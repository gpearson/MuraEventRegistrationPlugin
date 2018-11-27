<cfif LEN(arguments.MailServerUsername) and LEN(arguments.MailServerPassword)>
	<cfmail To="#Arguments.Info.FName# #Arguments.Info.LName# <#Arguments.Info.Email#>" from="#Arguments.Info.CancelledByFName# #Arguments.Info.CancelledByLName# <#Arguments.Info.CancelledByEmail#>" subject="Registration Cancelled: #Arguments.Info.EventShortTitle#" server="#Arguments.mailServerHostname#" username="#Arguments.MailServerUsername#" password="#Arguments.MailServerPassword#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
		<cfmailpart type="text/plain">
#Arguments.Info.FName# #Arguments.Info.LName#,

Here is a copy of your registration cancellation for your records. This event has been cancelled by the Event Facilitator.

Event Title: #Arguments.Info.EventShortTitle#
Event Date: #DateFormat(Arguments.Info.EventDate, "full")#

#Arguments.Info.EmailMessageTextBody#



This event has been cancelled from your account. Due to this event being cancelled, if you know other individuls who would benefit from this event please let them know. If we can get a individual interested in this event we will hold it at a future date.


Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.Info.FName# #Arguments.Info.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Here is a copy of your registration cancellation for your records. This event has been cancelled by the Event Facilitator.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Title: #Arguments.Info.EventShortTitle#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Date: #DateFormat(Arguments.Info.EventDate, "full")#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.Info.EmailMessageHTMLBody#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">This event has been cancelled from your account. Due to this event being cancelled, if you know other individuls who would benefit from this event please let them know. If we can get a individual interested in this event we will hold it at a future date.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>		
<cfelse>
	<cfmail To="#Arguments.Info.FName# #Arguments.Info.LName# <#Arguments.Info.Email#>" from="#Arguments.Info.CancelledByFName# #Arguments.Info.CancelledByLName# <#Arguments.Info.CancelledByEmail#>" subject="Registration Cancelled: #Arguments.Info.EventShortTitle#" server="#Arguments.mailServerHostname#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
		<cfmailpart type="text/plain">
#Arguments.Info.FName# #Arguments.Info.LName#,

Here is a copy of your registration cancellation for your records. This event has been cancelled by the Event Facilitator.

Event Title: #Arguments.Info.EventShortTitle#
Event Date: #DateFormat(Arguments.Info.EventDate, "full")#

#Arguments.Info.EmailMessageTextBody#



This event has been cancelled from your account. Due to this event being cancelled, if you know other individuls who would benefit from this event please let them know. If we can get a individual interested in this event we will hold it at a future date.


Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
		</cfmailpart>
		<cfmailpart type="text/html">
		<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.Info.FName# #Arguments.Info.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Here is a copy of your registration cancellation for your records. This event has been cancelled by the Event Facilitator.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Title: #Arguments.Info.EventShortTitle#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Date: #DateFormat(Arguments.Info.EventDate, "full")#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.Info.EmailMessageHTMLBody#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">This event has been cancelled from your account. Due to this event being cancelled, if you know other individuls who would benefit from this event please let them know. If we can get a individual interested in this event we will hold it at a future date.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
		</cfmailpart>
	</cfmail>
</cfif>