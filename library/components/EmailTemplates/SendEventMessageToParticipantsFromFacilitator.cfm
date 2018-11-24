<cfmail To="#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName# <#Arguments.ParticipantInfo.Email#>" from="Event Registration System <registrationsystem@niesc.k12.in.us>" subject="Event Registration: Message From Event Facilitator Regarding Upcoming Event" server="127.0.0.1">
<cfmailpart type="text/plain">
#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,

You are receiving the email because the facilitator of the event titled #Arguments.ParticipantInfo.EventShortTitle# has something they want to relay to you as a participant to this event.

Message Details Below

#Arguments.ParticipantInfo.EmailMessageBody#


<cfif isDefined("Arguments.ParticipantInfo.WebLinksInEmail")><cfif Arguments.ParticipantInfo.WebLinksInEmail EQ 1>Web Link(s):
	 #Arguments.ParticipantInfo.WebLink1#
	 #Arguments.ParticipantInfo.WebLink1#
</cfif></cfif>

<cfif isDefined("Arguments.ParticipantInfo.DocLinksInEmail")><cfif Arguments.ParticipantInfo.DocLinksInEmail EQ 1>Here are the links to the Event Documents for your reference:

	<cfif isDefined("Arguments.ParticipantInfo.EmailFileOne")>http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameOne#</cfif>
	<cfif isDefined("Arguments.ParticipantInfo.EmailFileTwo")>http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameTwo#</cfif>
	<cfif isDefined("Arguments.ParticipantInfo.EmailFileThree")>http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameThree#</cfif>
	<cfif isDefined("Arguments.ParticipantInfo.EmailFileFour")>http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameFour#</cfif>
	<cfif isDefined("Arguments.ParticipantInfo.EmailFileFive")>http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameFive#</cfif>
</cfif></cfif>


Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You are receiving the email because the facilitator of the event titled #Arguments.ParticipantInfo.EventShortTitle# has something they want to relay to you as a participant to this event.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Message Details Below</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ParticipantInfo.EmailMessageBody#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><cfif isDefined("Arguments.ParticipantInfo.WebLinksInEmail")><cfif Arguments.ParticipantInfo.WebLinksInEmail EQ 1>Web Link(s):<br><A href="#Arguments.ParticipantInfo.WebLink1#">#Arguments.ParticipantInfo.WebLink1#</A><br /><A href="#Arguments.ParticipantInfo.WebLink2#">#Arguments.ParticipantInfo.WebLink2#</A></cfif></cfif></td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><cfif isDefined("Arguments.ParticipantInfo.DocLinksInEmail")><cfif Arguments.ParticipantInfo.DocLinksInEmail EQ 1>Here are the links to the Event Documents for your reference:
			<br />
			<cfif isDefined("Arguments.ParticipantInfo.EmailFileOne")><a href="http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameOne#">http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameOne#</a><br /></cfif>
			<cfif isDefined("Arguments.ParticipantInfo.EmailFileTwo")><A href="http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameTwo#">http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameTwo#</a><br /></cfif>
			<cfif isDefined("Arguments.ParticipantInfo.EmailFileThree")><a href="http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameThree#">http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameThree#</a><br /></cfif>
			<cfif isDefined("Arguments.ParticipantInfo.EmailFileFour")><a href="http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameFour#">http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameFour#</a><br /></cfif>
			<cfif isDefined("Arguments.ParticipantInfo.EmailFileFive")><a href="http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameFive#">http://#cgi.server_name#/plugins/#Arguments.ParticipantInfo.EmailFileNameFive#</a><br /></cfif>
			</cfif></cfif>
			</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: This email address is not valid and is not read by a human individual. This email address is strictly for system notifications that are sent from this system.</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>