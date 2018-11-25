<cfmail To="#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName# <#Arguments.ParticipantInfo.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: PGP Certificate on Completed Workshop" server="127.0.0.1">
<cfmailparam file="#Arguments.ParticipantInfo.PGPCertificateFilename#" type="application/pdf">
<cfmailpart type="text/plain">
#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,

You are receiving the email because you completed an Event or Worshop titled #Arguments.ParticipantInfo.EventShortTitle# and has #Arguments.ParticipantInfo.NumberPGPPoints# Professional Growth Points associated with it. You can acquire any certificate by logging into your account and selecting the User Administration navigational menu then selecting Print Certificate and selecting the event's certificate you are wanting.

Message Details Below

#Arguments.ParticipantInfo.EmailMessageBody#

Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You are receiving the email because you completed an Event or Worshop titled #Arguments.ParticipantInfo.EventShortTitle# and has #Arguments.ParticipantInfo.NumberPGPPoints# Professional Growth Points associated with it. You can acquire any certificate by logging into your account and selecting the User Administration navigational menu then selecting Print Certificate and selecting the event's certificate you are wanting.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Message Details Below</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ParticipantInfo.EmailMessageBody#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>

<!---  --->