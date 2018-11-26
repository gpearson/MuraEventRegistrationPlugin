<cfmail To="#GetAccountUsername.fName# #GetAccountUsername.lName# <#GetAccountUsername.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration - Account Temporary Password" server="127.0.0.1">
<cfmailpart type="text/plain">
#GetAccountUsername.fName# #GetAccountUsername.lName#,

Here is the requested temporary password for your account. You will now be able to login with your username and this password. Once you have logged into the system, please edit your profile and change your password to something easier to remember.

#Variables.strPassword#

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#GetAccountUsername.fName# #GetAccountUsername.lName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Here is the requested temporary password for your account. You will now be able to login with your username and this password. Once you have logged into the system, please edit your profile and change your password to something easier to remember.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Variables.strPassword#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>