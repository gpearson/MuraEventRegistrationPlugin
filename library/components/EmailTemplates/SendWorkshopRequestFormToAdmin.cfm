<cfmail To="#getAdminGroup.Email# <#getAdminGroup.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration Request Event Inquiry" server="127.0.0.1">
<cfmailpart type="text/plain">
Event Registration Administrator,

The individual listed below submitted the following information through the Request Event Form.


Individual's Name': #Arguments.EmailInfo.CommentFormName#
Email Address: #Arguments.EmailInfo.ContactFormEmail#
Telephone Number: #Arguments.EmailInfo.ContactFormNumber#
Best Contact Method: #Arguments.EmailInfo.ContactBy#

Potential Event Description:

#Arguments.EmailInfo.WorkshopDescription#

Possible Presenter: #Arguments.EmailInfo.WorkshopPresenter#
Presenter's Email: #Arguments.EmailInfo.WorkshopPresenterEmail#


Please contact this indivudal with the Best Contact Method Listed above. 

Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Event Registration Administrator,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">The individual listed below submitted the following information through the Request Event Form.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Individual's Name': #Arguments.EmailInfo.CommentFormName#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Email Address: #Arguments.EmailInfo.ContactFormEmail#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Telephone Number: #Arguments.EmailInfo.ContactFormNumber#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Best Contact Method: #Arguments.EmailInfo.ContactBy#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Potential Event Description: #Arguments.EmailInfo.WorkshopDescription#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Possible Presenter: #Arguments.EmailInfo.WorkshopPresenter#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Presenter's Email: #Arguments.EmailInfo.WorkshopPresenterEmail#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Please contact this indivudal with the Best Contact Method Listed above.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>