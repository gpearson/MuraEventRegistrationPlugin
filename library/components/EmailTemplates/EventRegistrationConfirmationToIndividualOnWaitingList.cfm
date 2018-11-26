<cfmail To="#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# <#getRegisteredUserInfo.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Confirmation Email for: #getEvent.ShortTitle# - Waiting List" server="127.0.0.1">
	<cfmailparam file="#Variables.UserRegistrationPDFAbsoluteFilename#" type="application/pdf" disposition="attachment">
	<cfmailparam file="#Variables.UserRegistrationiCalAbsoluteFilename#" type="text/calendar" disposition="attachment">
<cfmailpart type="text/plain">
#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,

Thank you for registering for the event titled #getEvent.ShortTitle#. At the time of your registration the event was full and you have been placed on our Waiting List. In the event of someone cancelling their registration, the system will pick the next person in line and send an email stating that the registration has been moved from the waiting list. Attached is a PDF Document with your event confirmation so you can print to keep with your records.

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Thank you for registering for the event titled #getEvent.ShortTitle#. At the time of your registration the event was full and you have been placed on our Waiting List. In the event of someone cancelling their registration, the system will pick the next person in line and send an email stating that the registration has been moved from the waiting list. Attached is a PDF Document with your event confirmation so you can print to keep with your records.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>