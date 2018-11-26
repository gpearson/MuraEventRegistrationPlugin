<cfmail To="#getUserAccount.fName# #getUserAccount.lName# <#getUserAccount.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration - Account Activation Confirmation Email" server="127.0.0.1">
<cfmailpart type="text/plain">
#getUserAccount.fName# #getUserAccount.lName#,

You have successfully activated your account on the #rc.$.siteConfig('site')# event registration system. You may now login with your email address and password you entered while creating your account.


Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.fName# #getUserAccount.lName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have successfully activated your account on the #rc.$.siteConfig('site')# event registration system. You may now login with your email address and password you entered while creating your account.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>