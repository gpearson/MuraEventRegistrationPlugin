<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2016 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<cfif isDefined("URL.SiteConfigUpdated")>
		<cfswitch expression="#URL.SiteConfigUpdated#">
			<cfcase value="True">
				<div class="panel panel-default">
					<div class="panel-heading"><h3>Site Configuration Updated</h3></div>
					<div class="panel-body alert alert-success">
						<p>You have successfully updated site configuration settings of this plugin</p>
					</div>
				</div>
			</cfcase>
			<cfcase value="False">

			</cfcase>
		</cfswitch>
	</cfif>
	<h2>Event Coordinator's Administration Menu</h2>
	<p>This is where all of the management of this site as an event facilitor handles the day to day activities of this system.
		<ul>
			<li><strong>Caterers</strong> is where information is entered for the locations where an event would acquire meals from</li>
			<li><strong>Facilities</strong> is where an event will be held at</li>
			<li><strong>Membership</strong> is a listing of organizations who belong to this organization and would receive special 'Member' pricing based on the email address / domain name of the member organization</li>
			<li><strong>Users</strong> is where you can add/update user account information</li>
			<li><strong>Events</strong> is where you can manage your specific events</li>
		</ul>
	</p>
</cfoutput>
