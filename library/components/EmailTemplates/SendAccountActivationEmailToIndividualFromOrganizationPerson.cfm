<cfmail To="#getUserAccount.fName# #getUserAccount.lName# <#getUserAccount.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration - Account Activation Email" server="127.0.0.1">
<cfmailpart type="text/plain">
#getUserAccount.fName# #getUserAccount.lName#,

You have been registered for an account on the #rc.DBInfo.SiteName# event registration system. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system.
Please click the link below to activate your account. Failure to click the link below will prevent you from registering for future events in the system.

#Variables.AccountActiveLink#

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.DBInfo.ContactName# at #rc.DBInfo.ContactEmail# or call #rc.DBInfo.ContactPhone#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.fName# #getUserAccount.lName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have been registered for an account on the #rc.DBInfo.SiteName# event registration system. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Please click the link below to activate your account. Failure to click the link below will prevent you from registering for future events in the system.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Variables.AccountActiveLink#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.DBInfo.ContactName# at #rc.DBInfo.ContactEmail# or call #rc.DBInfo.ContactPhone#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>