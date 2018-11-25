<cfmail To="#Arguments.Info.Registration.FName# #Arguments.Info.Registration.LName# <#Arguments.Info.Registration.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Registration Cancelled: #Arguments.Info.Registration.ShortTitle#" server="127.0.0.1">
<cfmailpart type="text/plain">
#Arguments.Info.Registration.FName# #Arguments.Info.Registration.LName#,

Here is a copy of your registration cancellation for your records. This event has been cancelled by the Event Facilitator.

Event Title: #Arguments.Info.Registration.ShortTitle#
Event Date: #Arguments.Info.Registration.EventDateFormat#


This event has been cancelled from your account.


Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.Info.Registration.FName# #Arguments.Info.Registration.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Here is a copy of your registration cancellation for your records. This event has been cancelled by the Event Facilitator.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Title: #Arguments.Info.Registration.ShortTitle#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Date: #Arguments.Info.Registration.EventDateFormat#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">This event has been cancelled from your account.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>