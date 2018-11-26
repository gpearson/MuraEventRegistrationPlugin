<cfmail To="#Arguments.ActPayableContactName# <#Arguments.ActPayableContactEmail#>" from="#Session.Mura.Fname# #Session.Mura.LName# <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: Corporation Statement of Attendance" server="127.0.0.1">
<cfmailparam file="#Arguments.ReportLocFilename#" type="application/pdf">
<cfmailpart type="text/plain">
#Arguments.ActPayableContactName#,

Attached to this email message is a a statement of attendance for participants that participated in an event/workshop titled #Arguments.ShortTitle# from #Arguments.OrganizationName#.

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ActPayableContactName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Attached to this email message is a a statement of attendance for participants that participated in an event/workshop titled #Arguments.ShortTitle# from #Arguments.OrganizationName#.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>