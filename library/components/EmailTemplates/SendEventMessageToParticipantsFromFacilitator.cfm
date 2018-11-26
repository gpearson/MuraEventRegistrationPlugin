<cfmail To="#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName# <#Arguments.ParticipantInfo.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: Message From Event Facilitator Regarding Upcoming Event" server="127.0.0.1">
<cfmailpart type="text/plain">
#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,

You are receiving the email because the facilitator of the event titled #Arguments.ParticipantInfo.EventShortTitle# has something they want to relay to you as a participant to this event.

Message Details Below

#Arguments.ParticipantInfo.EmailMessageBody#

<cfif Arguments.ParticipantInfo.WebLinksInEmail EQ 1>Web Link(s):
	<cfif LEN(Arguments.ParticipantInfo.WebLink1)>#Arguments.ParticipantInfo.WebLink1#</cfif>
	<cfif LEN(Arguments.ParticipantInfo.WebLink2)>#Arguments.ParticipantInfo.WebLink2#</cfif>
	<cfif LEN(Arguments.ParticipantInfo.WebLink3)>#Arguments.ParticipantInfo.WebLink3#</cfif>
</cfif>

<cfif Arguments.ParticipantInfo.PreviousDocLinksInEmail EQ 1>
Here are the links to the Event Documents for your reference:
	<cfloop query="Arguments.ParticipantInfo.AllEventDocuments">
		http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.AllEventDocuments.name#
	</cfloop>
</cfif>

<cfif ListLen(Arguments.ParticipantInfo.EventDocNames, ",")>
Here are the links to new Event Documents for your reference:
	<cfloop list="Arguments.ParticipantInfo.EventDocNames" delimiters="," index="Docs">
		http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Docs#
	</cfloop>
</cfif>


Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
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
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">
				<cfif Arguments.ParticipantInfo.WebLinksInEmail EQ 1>Web Link(s):
					<cfif LEN(Arguments.ParticipantInfo.WebLink1)>#Arguments.ParticipantInfo.WebLink1#</cfif>
					<cfif LEN(Arguments.ParticipantInfo.WebLink2)>#Arguments.ParticipantInfo.WebLink2#</cfif>
					<cfif LEN(Arguments.ParticipantInfo.WebLink3)>#Arguments.ParticipantInfo.WebLink3#</cfif>
				</cfif>
			</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">
				<cfif Arguments.ParticipantInfo.PreviousDocLinksInEmail EQ 1>
					Here are the links to the Event Documents for your reference:
					<cfloop query="Arguments.ParticipantInfo.AllEventDocuments"><a href="http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.AllEventDocuments.name#">http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.AllEventDocuments.name#</a><br /></cfloop>
				</cfif>
			</td></tr>
			<cfif ListLen(Arguments.ParticipantInfo.EventDocNames, ",")>
				<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Here are the links to new Event Documents for your reference:<br>
				<cfloop list="#Arguments.ParticipantInfo.EventDocNames#" delimiters="," index="Docs"><a href="http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Docs#">http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Docs#</a><br /></cfloop>
				</td></tr>
			</cfif>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>
