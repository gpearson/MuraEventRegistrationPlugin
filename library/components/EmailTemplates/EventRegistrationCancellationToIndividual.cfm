<cfif LEN(arguments.MailServerUsername) and LEN(arguments.MailServerPassword)>
	<cfmail To="#Session.Mura.Fname# #Session.Mura.LName# <#Session.Mura.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Registration Cancelled: #Session.GetSelectedEvent.ShortTitle#" server="#Arguments.mailServerHostname#" username="#Arguments.MailServerUsername#" password="#Arguments.MailServerPassword#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
		<cfmailpart type="text/plain">
#Session.Mura.Fname# #Session.Mura.LName#,

Here is a copy of your registration cancellation for your records.

Event Title: #Session.GetSelectedEvent.ShortTitle#
Event Date: #DateFormat(Session.GetSelectedEvent.EventDate, "full")#


This event has been cancelled from your account. If this was done in error you will need to reregister for this event if space is available.


Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Session.Mura.Fname# #Session.Mura.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Here is a copy of your registration cancellation for your records.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Title: #Session.GetSelectedEvent.ShortTitle#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Date: #DateFormat(Session.GetSelectedEvent.EventDate, "full")#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">This event has been cancelled from your account. If this was done in error you will need to reregister for this event if space is available.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>		
<cfelse>
	<cfmail To="#Session.Mura.Fname# #Session.Mura.LName# <#Session.Mura.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Registration Cancelled: #Session.GetSelectedEvent.ShortTitle#" server="#Arguments.mailServerHostname#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
		<cfmailpart type="text/plain">
#Session.Mura.Fname# #Session.Mura.LName#,

Here is a copy of your registration cancellation for your records.

Event Title: #Session.GetSelectedEvent.ShortTitle#
Event Date: #DateFormat(Session.GetSelectedEvent.EventDate, "full")#


This event has been cancelled from your account. If this was done in error you will need to reregister for this event if space is available.


Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Session.Mura.Fname# #Session.Mura.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Here is a copy of your registration cancellation for your records.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Title: #Session.GetSelectedEvent.ShortTitle#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Date: #DateFormat(Session.GetSelectedEvent.EventDate, "full")#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">This event has been cancelled from your account. If this was done in error you will need to reregister for this event if space is available.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>
</cfif>