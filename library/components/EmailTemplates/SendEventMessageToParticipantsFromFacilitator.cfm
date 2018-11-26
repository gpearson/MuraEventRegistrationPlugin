<cfif Arguments.ParticipantInfo.EmailType EQ "EmailAttended">
<cfmail To="#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName# <#Arguments.ParticipantInfo.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: Message From Event Facilitator Regarding Event" server="127.0.0.1">
<cfmailpart type="text/plain">
#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,

You are receiving the email because the facilitator of the event titled #Arguments.ParticipantInfo.EventShortTitle# has something they want to relay to you as a participant of this event.

Message Details Below

#Arguments.ParticipantInfo.EmailMessageTextBody#

<cfif StructKeyExists(Arguments.ParticipantInfo, "WebLinksInEmail")>Web Link(s):
<cfloop query="#Arguments.ParticipantInfo.WebLinksInEmail#">#Arguments.ParticipantInfo.WebLinksInEmail.ResourceLink#<br></cfloop>
</cfif>

<cfif StructKeyExists(Arguments.ParticipantInfo, "DocumentLinksInEmail")>Event Document(s):
<cfloop query="#Arguments.ParticipantInfo.DocumentLinksInEmail#">http://#cgi.server_name##Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.DocumentLinksInEmail.ResourceDocument#<br></cfloop>
</cfif>

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You are receiving the email because the facilitator of the event titled #Arguments.ParticipantInfo.EventShortTitle# has something they want to relay to you as a participant of this event.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Message Details Below</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ParticipantInfo.EmailMessageHTMLBody#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<cfif StructKeyExists(Arguments.ParticipantInfo, "WebLinksInEmail")>
				<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Web Link(s):<br>
				<cfloop query="#Arguments.ParticipantInfo.WebLinksInEmail#"><a href="#Arguments.ParticipantInfo.WebLinksInEmail.ResourceLink#" target="_blank">#Arguments.ParticipantInfo.WebLinksInEmail.ResourceLink#</a><br></cfloop>
				</td></tr>
			</cfif>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<cfif StructKeyExists(Arguments.ParticipantInfo, "DocumentLinksInEmail")>
				<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Web Documents(s):<br>
				<cfloop query="#Arguments.ParticipantInfo.DocumentLinksInEmail#"><a href="http://#cgi.server_name##Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.DocumentLinksInEmail.ResourceDocument#" target="_blank">#Arguments.ParticipantInfo.DocumentLinksInEmail.ResourceDocument#</a><br></cfloop>
				</td></tr>
			</cfif>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>
<cfelse>
<cfmail To="#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName# <#Arguments.ParticipantInfo.Email#>" from="Event Registration System <registrationsystem@#CGI.Server_Name#>" subject="Event Registration: Message From Event Facilitator Regarding Upcoming Event" server="127.0.0.1">
<cfmailpart type="text/plain">
#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,

You are receiving the email because the facilitator of the event titled #Arguments.ParticipantInfo.EventShortTitle# has something they want to relay to you as a participant of this event.

Message Details Below

#Arguments.ParticipantInfo.EmailMessageTextBody#

<cfif StructKeyExists(Arguments.ParticipantInfo, "WebLinksInEmail")>Web Link(s):
<cfloop query="#Arguments.ParticipantInfo.WebLinksInEmail#">#Arguments.ParticipantInfo.WebLinksInEmail.ResourceLink#<br></cfloop>
</cfif>

<cfif StructKeyExists(Arguments.ParticipantInfo, "DocumentLinksInEmail")>Event Document(s):
<cfloop query="#Arguments.ParticipantInfo.DocumentLinksInEmail#">http://#cgi.server_name##Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.DocumentLinksInEmail.ResourceDocument#<br></cfloop>
</cfif>

Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#
</cfmailpart>
<cfmailpart type="text/html">
	<html><body>
		<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ParticipantInfo.FName# #Arguments.ParticipantInfo.LName#,</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">You are receiving the email because the facilitator of the event titled #Arguments.ParticipantInfo.EventShortTitle# has something they want to relay to you as a participant of this event.</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Message Details Below</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">#Arguments.ParticipantInfo.EmailMessageHTMLBody#</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<cfif StructKeyExists(Arguments.ParticipantInfo, "WebLinksInEmail")>
				<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Web Link(s):<br>
				<cfloop query="#Arguments.ParticipantInfo.WebLinksInEmail#"><a href="#Arguments.ParticipantInfo.WebLinksInEmail.ResourceLink#" target="_blank">#Arguments.ParticipantInfo.WebLinksInEmail.ResourceLink#</a><br></cfloop>
				</td></tr>
			</cfif>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<cfif StructKeyExists(Arguments.ParticipantInfo, "DocumentLinksInEmail")>
				<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Web Documents(s):<br>
				<cfloop query="#Arguments.ParticipantInfo.DocumentLinksInEmail#"><a href="http://#cgi.server_name##Arguments.ParticipantInfo.WebEventDirectory##Arguments.ParticipantInfo.DocumentLinksInEmail.ResourceDocument#" target="_blank">#Arguments.ParticipantInfo.DocumentLinksInEmail.ResourceDocument#</a><br></cfloop>
				</td></tr>
			</cfif>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">&nbsp;</td></tr>
			<tr><td Style="Font-Family: Arial; Font-Size: 12px; Font-Weight: Normal; Color: Black;">Note: Replies to this automated email address are not monitored by staff. If you have questions or issues contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')#</td></tr>
		</table>
	</body></html>
</cfmailpart>
</cfmail>
</cfif>


