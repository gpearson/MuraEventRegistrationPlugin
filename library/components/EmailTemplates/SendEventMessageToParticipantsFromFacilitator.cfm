<cfmail To="#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName# <#Arguments.ParticipantInfo.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: Message From Event Facilitator Regarding Upcoming Event" server="127.0.0.1">
<cfmailpart type="text/plain">
#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,

You are receiving the email because the facilitator of the event titled #Arguments.ParticipantInfo.EventShortTitle# has something they want to relay to you as a participant to this event.

Message Details Below

#Arguments.ParticipantInfo.EmailMessageBody#

<cfif Arguments.ParticipantInfo.WebLinksInEmail EQ 1><cfif LEN(Arguments.ParticipantInfo.WebLink1)>#Arguments.ParticipantInfo.WebLink1#</cfif>
	<cfif LEN(Arguments.ParticipantInfo.WebLink2)>#Arguments.ParticipantInfo.WebLink2#</cfif>
	<cfif LEN(Arguments.ParticipantInfo.WebLink3)>#Arguments.ParticipantInfo.WebLink3#</cfif>
</cfif>

<cfif isDefined("Arguments.ParticipantInfo.WebLinksInEmail")><cfif Arguments.ParticipantInfo.WebLinksInEmail EQ 1>Web Link(s):
	 #Arguments.ParticipantInfo.WebLink1#
	 #Arguments.ParticipantInfo.WebLink1#
</cfif></cfif>

<cfif isDefined("Arguments.ParticipantInfo.DocLinksInEmail")><cfif Arguments.ParticipantInfo.DocLinksInEmail EQ 1>Here are the links to the Event Documents for your reference:
	<cfloop query="Arguments.ParticipantInfo.EventDocuments">
		http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.EventDocuments.name#
	</cfloop>
</cfif></cfif>


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
				<cfif Arguments.ParticipantInfo.WebLinksInEmail EQ 1>
					<cfif LEN(Arguments.ParticipantInfo.WebLink1)><a href="#Arguments.ParticipantInfo.WebLink1#">#Arguments.ParticipantInfo.WebLink1#</a><br></cfif>
					<cfif LEN(Arguments.ParticipantInfo.WebLink2)><a href="#Arguments.ParticipantInfo.WebLink2#">#Arguments.ParticipantInfo.WebLink2#</a><br></cfif>
					<cfif LEN(Arguments.ParticipantInfo.WebLink3)><a href="#Arguments.ParticipantInfo.WebLink3#">#Arguments.ParticipantInfo.WebLink3#<a/><br></cfif>
				</cfif>
			</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;"><cfif isDefined("Arguments.ParticipantInfo.DocLinksInEmail")><cfif Arguments.ParticipantInfo.DocLinksInEmail EQ 1>Here are the links to the Event Documents for your reference:
			<br />
			<cfloop query="Arguments.ParticipantInfo.EventDocuments">
				<a href="http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.EventDocuments.name#">http://#cgi.server_name#/#Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.EventDocuments.name#</a><br />
			</cfloop>
			</cfif></cfif>
			</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>
