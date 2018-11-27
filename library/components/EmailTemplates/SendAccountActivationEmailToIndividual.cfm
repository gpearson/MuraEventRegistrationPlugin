<cfif LEN(arguments.MailServerUsername) and LEN(arguments.MailServerPassword)>
	<cfmail To="#getUserAccount.FName# #getUserAccount.Lname# <#getUserAccount.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Event Registration - Account Activation Email" server="#Arguments.mailServerHostname#" username="#Arguments.MailServerUsername#" password="#Arguments.MailServerPassword#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
	<cfmailpart type="text/plain">
#getUserAccount.fName# #getUserAccount.lName#,

You have successfully registered an account on the #rc.$.siteConfig('site')#. Please click the link below to activate your account. Failure to click the link below will prevent you from registering for upcoming events.

#Variables.AccountActiveLink#

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.fName# #getUserAccount.lName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have successfully registered an account on the #rc.$.siteConfig('site')#. Please click the link below to activate your account. Failure to click the link below will prevent you from registering for upcoming events.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><a href="#Variables.AccountActiveLink#" target="_blank">#Variables.AccountActiveLink#</a></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>		
<cfelse>
	<cfmail To="#getUserAccount.FName# #getUserAccount.Lname# <#getUserAccount.Email#>" from="#rc.$.siteConfig('ContactName')# <#rc.$.siteConfig('ContactEmail')#>" subject="Event Registration - Account Activation Email" server="#Arguments.mailServerHostname#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
	<cfmailpart type="text/plain">
#getUserAccount.fName# #getUserAccount.lName#,

You have successfully registered an account on the #rc.$.siteConfig('site')#. Please click the link below to activate your account. Failure to click the link below will prevent you from registering for upcoming events.

#Variables.AccountActiveLink#

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.fName# #getUserAccount.lName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have successfully registered an account on the #rc.$.siteConfig('site')#. Please click the link below to activate your account. Failure to click the link below will prevent you from registering for upcoming events.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><a href="#Variables.AccountActiveLink#" target="_blank">#Variables.AccountActiveLink#</a></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>
</cfif>