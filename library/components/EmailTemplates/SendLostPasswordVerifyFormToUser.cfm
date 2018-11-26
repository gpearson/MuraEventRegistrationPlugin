<cfmail To="#Arguments.AccountQuery.fName# #Arguments.AccountQuery.lName# <#Arguments.AccountQuery.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration - Account Lost Password" server="127.0.0.1">
<cfmailpart type="text/plain">
#Arguments.AccountQuery.fName# #Arguments.AccountQuery.lName#,

Someone, hopefully you, requested a lost password from the #rc.$.siteConfig('site')#. If this was you, simply click the link below to enter a new password. If not, simply disregard this message and your password will not be updated.

#Arguments.PasswordLink#

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.AccountQuery.fName# #Arguments.AccountQuery.lName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Someone, hopefully you, requested a lost password from the #rc.$.siteConfig('site')#. If this was you, simply click the link below to enter a new password. If not, simply disregard this message and your password will not be updated.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.PasswordLink#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>
