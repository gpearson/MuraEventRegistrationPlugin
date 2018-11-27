<cfif LEN(arguments.MailServerUsername) and LEN(arguments.MailServerPassword)>
	<cfmail To="#getUserAccount.FName# #getUserAccount.Lname# <#getUserAccount.Email#>" from="#Arguments.RequestInfo.DBInfo.ContactName# <#Arguments.RequestInfo.DBInfo.ContactEmail#>" subject="Event Registration - Account Activation Email" server="#Arguments.mailServerHostname#" username="#Arguments.MailServerUsername#" password="#Arguments.MailServerPassword#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
	<cfmailpart type="text/plain">
#getUserAccount.FName# #getUserAccount.Lname#,

You have been registered for an account on the #Arguments.RequestInfo.DBInfo.SiteName#. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system.
Please click the link below to activate your account. Failure to click the link below will prevent you from registering for future events in the system.

#Variables.AccountActiveLink#

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #Arguments.RequestInfo.DBInfo.ContactName# at #Arguments.RequestInfo.DBInfo.ContactEmail# or call #Arguments.RequestInfo.DBInfo.ContactPhone#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.FName# #getUserAccount.Lname#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have been registered for an account on the #Arguments.RequestInfo.DBInfo.SiteName#. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system. Please click the link below to activate your account. Failure to click the link below will prevent you from registering for future events in the system.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><a href="#Variables.AccountActiveLink#" target="_blank">#Variables.AccountActiveLink#</a></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #Arguments.RequestInfo.DBInfo.ContactName# at #Arguments.RequestInfo.DBInfo.ContactEmail# or call #Arguments.RequestInfo.DBInfo.ContactPhone#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
</cfmail>		
<cfelse>
	<cfmail To="#getUserAccount.FName# #getUserAccount.Lname# <#getUserAccount.Email#>" from="#Arguments.RequestInfo.DBInfo.ContactName# <#Arguments.RequestInfo.DBInfo.ContactEmail#>" subject="Event Registration - Account Activation Email" server="#Arguments.mailServerHostname#" usessl="#Arguments.MailServerSSL#" port="#Arguments.MailServerPort#">
	<cfmailpart type="text/plain">
#getUserAccount.FName# #getUserAccount.Lname#,

You have been registered for an account on the #Arguments.RequestInfo.DBInfo.SiteName#. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system.
Please click the link below to activate your account. Failure to click the link below will prevent you from registering for future events in the system.

#Variables.AccountActiveLink#

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #Arguments.RequestInfo.DBInfo.ContactName# at #Arguments.RequestInfo.DBInfo.ContactEmail# or call #Arguments.RequestInfo.DBInfo.ContactPhone#
	</cfmailpart>
	<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getUserAccount.FName# #getUserAccount.Lname#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You have been registered for an account on the #Arguments.RequestInfo.DBInfo.SiteName#. #Session.Mura.Fname# #Session.Mura.LName# registered you for an event on the system. Please click the link below to activate your account. Failure to click the link below will prevent you from registering for future events in the system.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><a href="#Variables.AccountActiveLink#" target="_blank">#Variables.AccountActiveLink#</a></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #Arguments.RequestInfo.DBInfo.ContactName# at #Arguments.RequestInfo.DBInfo.ContactEmail# or call #Arguments.RequestInfo.DBInfo.ContactPhone#</td></tr>
		</table>
	</body></html>
	</cfmailpart>
	</cfmail>
</cfif>