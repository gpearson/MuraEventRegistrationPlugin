<cfif LEN(arguments.MailServerUsername) and LEN(arguments.MailServerPassword)>
	<cfmail To="#getUserAccount.FName# #getUserAccount.Lname# <#getUserAccount.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Event Registration Lost Password Retrieval" server="#Arguments.mailServerHostname#" username="#Arguments.MailServerUsername#" password="#Arguments.MailServerPassword#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
	<cfmailpart type="text/plain">
#getUserAccount.FName# #getUserAccount.Lname#,

Someone, hopefully you, has changed the password to this account on the #rc.$.siteConfig('site')#. If this was you, you can now login with your email address and the password which you have set. If this was not you, then someone has access to your email account and has clicked the link to change your password.


Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.FName# #getUserAccount.Lname#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Someone, hopefully you, has changed the password to this account on the #rc.$.siteConfig('site')#. If this was you, you can now login with your email address and the password which you have set. If this was not you, then someone has access to your email account and has clicked the link to change your password.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
</cfmail>		
<cfelse>
	<cfmail To="#getUserAccount.FName# #getUserAccount.Lname# <#getUserAccount.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Event Registration Lost Password Retrieval" server="#Arguments.mailServerHostname#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
	<cfmailpart type="text/plain">
#getUserAccount.FName# #getUserAccount.Lname#,

Someone, hopefully you, has changed the password to this account on the #rc.$.siteConfig('site')#. If this was you, you can now login with your email address and the password which you have set. If this was not you, then someone has access to your email account and has clicked the link to change your password.


Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.FName# #getUserAccount.Lname#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Someone, hopefully you, has changed the password to this account on the #rc.$.siteConfig('site')#. If this was you, you can now login with your email address and the password which you have set. If this was not you, then someone has access to your email account and has clicked the link to change your password.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>
</cfif>