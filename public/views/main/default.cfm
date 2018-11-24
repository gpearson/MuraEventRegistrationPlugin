<cfsilent>
	<!---
		This file is part of MuraFW1

		Copyright 2010-2015 Stephen J. Withington, Jr.
		Licensed under the Apache License, Version v2.0
		http://www.apache.org/licenses/LICENSE-2.0
	--->
	<cfif Session.Mura.IsLoggedIn EQ True>
		<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
		<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
		<cfparam name="Session.Mura.SuperAdminRole" default="0" type="boolean">
		<cfset UserMembershipQuery = #$.currentUser().getMembershipsQuery()#>
		<cfloop query="#Variables.UserMembershipQuery#">
			<cfif UserMembershipQuery.GroupName EQ "Event Facilitator"><cfset Session.Mura.EventCoordinatorRole = true></cfif>
			<cfif UserMembershipQuery.GroupName EQ "Event Presentator"><cfset Session.Mura.EventPresenterRole = true></cfif>
		</cfloop>
		<cfif Session.Mura.Username EQ "admin"><cfset Session.Mura.SuperAdminRole = true></cfif>

		<cfif Session.Mura.EventCoordinatorRole EQ "True">
			<cfoutput>#Variables.this.redirect("eventcoord:main.default")#</cfoutput>
		</cfif>

		<cfif Session.Mura.SuperAdminRole EQ "true">
			<cfoutput>#Variables.this.redirect("siteadmin:main.default")#</cfoutput>
		</cfif>

	<cfelse>
		<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
		<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
		<cfparam name="Session.Mura.SuperAdminRole" default="0" type="boolean">
	</cfif>

</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading"><h1>Current Events and/or Workshops</h1></div>
		<div class="panel-body">

		</div>
	</div>
</cfoutput>
