<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cfif isDefined("URL.EventID")>
	<cfif not isDefined("FORM.FormErrors")>
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfset Session.FormErrors = #ArrayNew()#>
		</cflock>
	</cfif>
	
	<cfquery name="getEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4
		From eEvents
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
			TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order by EventDate ASC
	</cfquery>
	
	<cfquery name="getRegisteredAttendee" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select 	eEvents.TContent_ID, eRegistrations.UserID, eRegistrations.RegistrationID, eRegistrations.RegistrationDate, eRegistrations.AttendedEvent,
			eRegistrations.Comments, tusers.Fname, tusers.Lname, tusers.Email, tusers.Company
		FROM eEvents RIGHT OUTER JOIN eRegistrations ON eRegistrations.EventID = eEvents.TContent_ID LEFT OUTER JOIN tusers ON tusers.UserID = eRegistrations.UserID
		WHERE eEvents.TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> AND eRegistrations.AttendedEvent = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
		ORDER BY tusers.Lname ASC, tusers.Fname ASC
	</cfquery>
		
	<cfoutput>
		<div class="container-fluid">
			<cfif isDefined("URL.SuccessfullAttendeeSignin")>
				<div class="row-fluid">
					<div class="span12">
						<cfif URL.SuccessfullAttendeeSignin EQ "True" and not isDefined("URL.MultipleAttendee")>
							<div class="alert alert-success">
								<p>You have successfully signed in an attendee electronically for this workshop. Below is a list of the attendees who have still not been signed in to this event.</p>
							</div>
						<cfelseif URL.SuccessfullAttendeeSignin EQ "False" and not isDefined("URL.MultipleAttendee")>
							<div class="alert alert-danger">
								<p>An error has occured when trying to sign in attendee for this workshop. Below is a list of the attendees who have still not been signed in to this event.</p>
							</div>
						<cfelseif URL.SuccessfullAttendeeSignin EQ "True" and isDefined("URL.MultipleAttendee")>
							<div class="alert alert-success">
								<p>You have successfully signed in a walkin attendee electronically for this workshop. Below is a list of the attendees who have still not been signed in to this event.</p>
							</div>
						</cfif>
					</div>
				</div>
			</cfif>
			<div class="row-fluid">
			<div class="span12">
				<form class="form-inline" role="form" method="post" action="">
					<input type="hidden" name="formSubmit" value="true">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<table class="table table-striped table-hover" cellspacing="0" cellpadding="0" width="95%">
					<thead>
						<tr>
							<td colspan="4"><h1 class="text-center">Attendee Electronic Signin Sheet<br><small>#getEvents.ShortTitle# on #DateFormat(getEvents.EventDate, "mmm dd, yyyy")#</small></h1></td>
						</tr>
					</thead>
					<tbody>
						<cfif getRegisteredAttendee.RecordCount>
							<cfloop query="getRegisteredAttendee">
								<cfset CurrentCellPos = #getRegisteredAttendee.CurrentRow# MOD 4>
								#Variables.CurrentCellPos#
								<cfswitch expression="#Variables.CurrentCellPos#">
									<cfcase value="1">
										<tr><td width="25%">
											<table class="table" cellspacing="0" cellpadding="0">
												<tr>
													<td width="75%">#getRegisteredAttendee.Lname#, #getRegisteredAttendee.Fname#</td>
													<td width="25%" align="center"><input type="checkbox" name="AttendeeUserID" value="#getRegisteredAttendee.UserID#"></td>
												</tr>
											</table>
											</td>
									</cfcase>
									<cfcase value="0">
										<td width="25%">
											<table class="table" cellspacing="0" cellpadding="0">
												<tr>
													<td width="75%">#getRegisteredAttendee.Lname#, #getRegisteredAttendee.Fname#</td>
													<td width="25%" align="center"><input type="checkbox" name="AttendeeUserID" value="#getRegisteredAttendee.UserID#"></td>
												</tr>
											</table>
										</td>
										</td></tr>
									</cfcase>
									<cfdefaultcase>
										<td width="25%">
											<table class="table" cellspacing="0" cellpadding="0">
												<tr>
													<td width="75%">#getRegisteredAttendee.Lname#, #getRegisteredAttendee.Fname#</td>
													<td width="25%" align="center"><input type="checkbox" name="AttendeeUserID" value="#getRegisteredAttendee.UserID#"></td>
												</tr>
											</table>
										</td>
									</cfdefaultcase>
								</cfswitch>
							</cfloop>
							<cfswitch expression="#Variables.CurrentCellPos#">
								<cfcase value="1">
									<td colspan="3" width="75%">&nbsp;</td>
								</cfcase>
								<cfcase value="2">
									<td colspan="2" width="50%">&nbsp;</td>
								</cfcase>
								<cfcase value="3">
									<td width="25%">&nbsp;</td>
								</cfcase>
								<cfdefaultcase>
									End: #Variables.CurrentCellPos#
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<tr>
							<td colspan="4"><button type="submit" name="SignInAttendee" value="SignInAttendee" class="btn btn-default btn-sm">Sign In Attendee</button>&nbsp;&nbsp;<button type="submit" name="WalkInAttendee" value="WalkInAttendee" class="btn btn-success btn-sm">Walk In Attendee</button></td>
						</tr>
					</tbody>
				</table>
				</form>
			</div>
			</div>
		</div>			
	</cfoutput>
<cfelse>
	<cflocation addtoken="false" url="/index.cfm">
</cfif>
