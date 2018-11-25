<cfmail To="#Arguments.ActPayableContactName# <#Arguments.ActPayableContactEmail#>" from="#Session.Mura.Fname# #Session.Mura.LName# <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: Invoice For Event" server="127.0.0.1">
<cfmailparam file="#Arguments.ReportLocFilename#" type="application/pdf">
<cfmailpart type="text/plain">
#Arguments.ActPayableContactName#,

Attached to this email message is an invoice for participants that participated in an event/workshop titled #Arguments.ShortTitle# from your organization.

Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ActPayableContactName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Attached to this email message is an invoice for participants that participated in an event/workshop titled #Arguments.ShortTitle# from your organization.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>