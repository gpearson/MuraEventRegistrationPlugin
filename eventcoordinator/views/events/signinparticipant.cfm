<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
</cfsilent>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="EventDocumentsForm" class="form-horizontal" enctype="multipart/form-data">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset style="text-align: center">
						<legend><h4>Signin Participant who attended the event titled:<br>#Session.getSelectedEvent.ShortTitle#</h4></legend>
					</fieldset>
					<br>
					<cfif LEN(Session.getSelectedEvent.EventDate1) or LEN(Session.getSelectedEvent.EventDate2) or LEN(Session.getSelectedEvent.EventDate3) or LEN(Session.getSelectedEvent.EventDate4) or LEN(Session.getSelectedEvent.EventDate5)>
						<div class="panel-body"><div class="alert alert-warning"><cfif LEN(Session.getSelectedEvent.EventDate1)><p>Day 1: #DateFormat(Session.getSelectedEvent.EventDate, "full")#</p><p>Day 2: #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</p></cfif><cfif LEN(Session.getSelectedEvent.EventDate2)><p>Day 3: #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</p></cfif><cfif LEN(Session.getSelectedEvent.EventDate3)><p>Day 4: #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</p></cfif><cfif LEN(Session.getSelectedEvent.EventDate4)><p>Day 5: #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</p></cfif><cfif LEN(Session.getSelectedEvent.EventDate5)><p>Day 6: #DateFormat(Session.getSelectedEvent.EventDate5, "full")#</p></cfif></div></div>
					</cfif>
										
					<cfset ColWidth = 100 / #Session.EventNumberOfDays# >
					<cfif Session.getRegisteredParticipants.RecordCount>
						<cfset NumberAlreadySignIn = 0>
						<cfset TotalNumberParticipants = 0>
						<cfloop query="Session.getRegisteredparticipants">
							<cfif LEN(Session.getRegisteredParticipants.User_ID)><cfset TotalNumberParticipants = #Variables.TotalNumberParticipants# + 1></cfif>
							<cfswitch expression="#Session.EventNumberOfDays#">
								<cfcase value="1">
									<cfif Session.getRegisteredParticipants.AttendedEventDate1 EQ 1><cfset NumberAlreadySignIn = #Variables.NumberAlreadySignIn# + 1></cfif>
								</cfcase>
							</cfswitch>	
						</cfloop>

						<div class="alert alert-info"><span id="NumberParticipantsRegistered">#Variables.NumberAlreadySignIn# out of #Variables.TotalNumberParticipants# Participants Signed In</span></div>
						<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
							<cfloop query="Session.getRegisteredParticipants">
								<cfset CurrentModRow = #Session.getRegisteredParticipants.CurrentRow# MOD 4>
								<cfswitch expression="#Session.EventNumberOfDays#">
									<cfcase value="1">
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr>
													<td width="25%">
														<cfinclude template="signinparticipant_tablelayout.cfm">
													</td>
											</cfcase>
											<cfcase value="0">
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
												</tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
											</cfdefaultcase>
										</cfswitch>
									</cfcase>
									<cfdefaultcase>
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr>
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
											</cfcase>
											<cfcase value="0">
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
												</tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
											</cfdefaultcase>
										</cfswitch>
									</cfdefaultcase>
								</cfswitch>
							</cfloop>
						</table>
					</cfif>			
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="Back to Event Listing">&nbsp; | &nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="SignIn All Participants">
					<br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
	<script type="text/javascript">
		jQuery(document).ready(function() {
			jQuery("input[type=checkbox][name=ParticipantEmployee]").on('click',function(event){
				var currentObj = jQuery(event.currentTarget);
				
				if(currentObj.prop("checked") === true) {
					var ajaxurl = "/plugins/#Session.PluginFramework.CFCBase#/eventcoordinator/controllers/events.cfc?method=SignInParticipantToDatabase&Action=SignIn&UserID=" + currentObj[0]['value'] + "&EventID=" + #URL.EventID#;
					jQuery.ajax({
						url:ajaxurl
					})
					.done(function(response) {
						var obj = JSON.parse(response);
						$('##NumberParticipantsRegistered').text(obj.PARTICIPANTSSIGNEDIN + " of " + obj.TOTALPARTICIPANTS + " Participants Signed In");
					})
					.fail(function(jqXHR, textStatus, errorMessage) {
						console.log("errorMessage",errorMessage);
					});
				} else {
					var ajaxurl = "/plugins/#Session.PluginFramework.CFCBase#/eventcoordinator/controllers/events.cfc?method=SignInParticipantToDatabase&Action=SignOut&UserID=" + currentObj[0]['value'] + "&EventID=" + #URL.EventID#;
					jQuery.ajax({
						url:ajaxurl
					})
					.done(function(response) {
						var obj = JSON.parse(response);
						$('##NumberParticipantsRegistered').text(obj.PARTICIPANTSSIGNEDIN + " of " + obj.TOTALPARTICIPANTS + " Participants Signed In");
					})
					.fail(function(jqXHR, textStatus, errorMessage) {
						console.log("errorMessage",errorMessage);
					});
				}
			});
		});
	</script>
</cfoutput>