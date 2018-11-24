<cfif GetRegistration.User_ID EQ getRegistration.RegisterByUserID>
<cfmail To="#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# <#getRegisteredUserInfo.Email#>" from="Event Registration System <registrationsystem@niesc.k12.in.us>" subject="Confirmation Email for: #getEvent.ShortTitle#" server="127.0.0.1">
	<cfmailparam file="#Variables.UserRegistrationPDFAbsoluteFilename#" type="application/pdf" disposition="attachment">
	<cfmailparam file="#Variables.UserRegistrationiCalAbsoluteFilename#" type="text/calendar" disposition="attachment">
<cfmailpart type="text/plain">
#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,

Thank you for registering for the event titled #getEvent.ShortTitle#. Attached is a PDF Document with your event confirmation so you can print to keep with your records.

Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Thank you for registering for the event titled #getEvent.ShortTitle#. Attached is a PDF Document with your event confirmation so you can print to keep with your records.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>
<cfelse>
<cfmail To="#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName# <#getRegisteredUserInfo.Email#>" from="Event Registration System <registrationsystem@niesc.k12.in.us>" subject="Confirmation Email for: #getEvent.ShortTitle#" server="127.0.0.1">
	<cfmailparam file="#Variables.UserRegistrationPDFAbsoluteFilename#" type="application/pdf" disposition="attachment">
	<cfmailparam file="#Variables.UserRegistrationiCalAbsoluteFilename#" type="text/calendar" disposition="attachment">
<cfmailpart type="text/plain">
#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,

Thank you for registering for the event titled #getEvent.ShortTitle#. You have been registered for this event by #getWhoRegisteredUserInfo.Fname# #getWhoRegisteredUserInfo.Lname#. Attached is a PDF Document with your event confirmation so you can print to keep with your records.

Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Thank you for registering for the event titled #getEvent.ShortTitle#. You have been registered for this event by #getWhoRegisteredUserInfo.Fname# #getWhoRegisteredUserInfo.Lname#. Attached is a PDF Document with your event confirmation so you can print to keep with your records.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>
</cfif>