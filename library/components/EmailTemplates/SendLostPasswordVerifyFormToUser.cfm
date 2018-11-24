<cfmail To="#GetAccountUsername.fName# #GetAccountUsername.lName# <#GetAccountUsername.Email#>" from="Event Registration System <registrationsystem@niesc.k12.in.us>" subject="Event Registration - Account Lost Password Verify" server="127.0.0.1">
<cfmailpart type="text/plain">
#GetAccountUsername.fName# #GetAccountUsername.lName#,

The Event Registration System received a request to retrieve a lost password for your account and we wanted to make sure you wanted to do this. If you intended for this to happen, please click the link below so we can send you a new password for you to login with otherwise simple delete this message so nothing will change with your account.

#Variables.AccountActiveLink#

Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#GetAccountUsername.fName# #GetAccountUsername.lName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">The Event Registration System received a request to retrieve a lost password for your account and we wanted to make sure you wanted to do this. If you intended for this to happen, please click the link below so we can send you a new password for you to login with otherwise simple delete this message so nothing will change with your account.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Variables.AccountActiveLink#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>