<cfmail To="#Arguments.EmailInfo.FacilitatorInfo.FName# #Arguments.EmailInfo.FacilitatorInfo.LName# <#Arguments.EmailInfo.FacilitatorInfo.Email#>" from="Event Registration System <registrationsystem@niesc.k12.in.us>" replyto="#Arguments.EmailInfo.Fname# #Arguments.EmailInfo.LName# <#Arguments.EmailInfo.EmailAddr#>" subject="Question about Event: #getEvent.ShortTitle#" server="127.0.0.1">
<cfmailpart type="text/plain">
#Arguments.EmailInfo.FacilitatorInfo.FName# #Arguments.EmailInfo.FacilitatorInfo.LName#,

The individual listed below has a question regarding one of the events listed on the registration website.

Event with Question: #getEvent.ShortTitle#

First Name: #Arguments.EmailInfo.FName#
Last Name: #Arguments.EmailInfo.LName#
Email Address: #Arguments.EmailInfo.EmailAddr#
Telephone Number: #Arguments.EmailInfo.ContactNumber#
Best Contact Method: #Arguments.EMailInfo.ContactBy#
Question:

#Arguments.EmailInfo.EventQuestion#


Please contact this indivudal with the Best Contact Method Listed above. 

Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.EmailInfo.FacilitatorInfo.FName# #Arguments.EmailInfo.FacilitatorInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">The individual listed below has a question regarding one of the events listed on the registration website.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event with Question: #getEvent.ShortTitle#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">First Name: #Arguments.EmailInfo.FName#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Last Name: #Arguments.EmailInfo.LName#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Email Address: #Arguments.EmailInfo.EmailAddr#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Telephone Number: #Arguments.EmailInfo.ContactNumber#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Best Contact Method: #Arguments.EMailInfo.ContactBy#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Question: #Arguments.EmailInfo.EventQuestion#</td></tr>
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