<cfif LEN(arguments.MailServerUsername) and LEN(arguments.MailServerPassword)>
	<cfmail To="#Arguments.ActPayableContactName# <#Arguments.ActPayableContactEmail#>" from="#Session.Mura.Fname# #Session.Mura.LName# <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: Event Summary of Corporation Attendance Report" server="#Arguments.mailServerHostname#" username="#Arguments.MailServerUsername#" password="#Arguments.MailServerPassword#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
		<cfmailpart type="text/plain">
#Arguments.ActPayableContactName#,

Attached to this email message is a a statement of attendance for districts who participated in an event/workshop titled #Arguments.ShortTitle#.

<cfloop from="1" to="#ArrayLen(Arguments.ReportLocFilename)#" index="i">
#Arguments.ReportLocFilename[i][1]#
</cfloop>

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ActPayableContactName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Attached to this email message is a a statement of attendance for districts who participated in an event/workshop titled #Arguments.ShortTitle#.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<cfloop from="1" to="#ArrayLen(Arguments.ReportLocFilename)#" index="i">
				<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><a href="#Arguments.ReportLocFilename[i][1]#" target="_blank">#Arguments.ReportLocFilename[i][2]#</a></td></tr>
			</cfloop>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>		
<cfelse>
	<cfmail To="#Arguments.ActPayableContactName# <#Arguments.ActPayableContactEmail#>" from="#Session.Mura.Fname# #Session.Mura.LName# <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: Event Summary of Corporation Attendance Report" server="#Arguments.mailServerHostname#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
		<cfmailpart type="text/plain">
Attached to this email message is a a statement of attendance for districts who participated in an event/workshop titled #Arguments.ShortTitle#.

<cfloop from="1" to="#ArrayLen(Arguments.ReportLocFilename)#" index="i">
#Arguments.ReportLocFilename[i][1]#
</cfloop>

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
		<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ActPayableContactName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Attached to this email message is a a statement of attendance for districts who participated in an event/workshop titled #Arguments.ShortTitle#.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<cfloop from="1" to="#ArrayLen(Arguments.ReportLocFilename)#" index="i">
				<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><a href="#Arguments.ReportLocFilename[i][1]#" target="_blank">#Arguments.ReportLocFilename[i][2]#</a></td></tr>
			</cfloop>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>
</cfif>