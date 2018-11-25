<cfmail To="#getAdminGroup.Email# <#getAdminGroup.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration Comment Inquiry" server="127.0.0.1">
<cfmailpart type="text/plain">
Event Registration Administrator,

The individual listed below submitted the following information through the Comment Form.


Individual's Name': #Arguments.EmailInfo.ContactFirstName# #Arguments.EmailInfo.ContactLastName#
Email Address: #Arguments.EmailInfo.ContactEmail#
Telephone Number: #Arguments.EmailInfo.ContactPhone#
Best Contact Method: #Arguments.EmailInfo.BestContactMethod#

Question:

#Arguments.EmailInfo.InquiryMessage#


Please contact this indivudal with the Best Contact Method Listed above.

Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Registration Administrator,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">The individual listed below submitted the following information through the Comment Form.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Individual's Name': #Arguments.EmailInfo.ContactFirstName# #Arguments.EmailInfo.ContactLastName#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Email Address: #Arguments.EmailInfo.ContactEmail#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Telephone Number: #Arguments.EmailInfo.ContactPhone#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Best Contact Method: #Arguments.EmailInfo.BestContactMethod#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Question: #Arguments.EmailInfo.InquiryMessage#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Please contact this indivudal with the Best Contact Method Listed above.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>