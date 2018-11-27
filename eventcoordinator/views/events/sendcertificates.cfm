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
<cfif LEN(cgi.path_info)><cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# ><cfelse><cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action#></cfif>
</cfsilent>
<cfoutput>
	<cfif Session.getSelectedEvent.EventCancelled EQ 1>
		<div id="modelWindowDialog" class="modal fade">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
						<h3>PGP Certificates can not be sent at this time.</h3>
					</div>
					<div class="modal-body">
						<p class="alert alert-warning">PGP Certificates for this event can not be sent at this time. This is due to this event being cancelled or not active.</p>
						<p class="alert alert-warning">To return to the Event Listing Page. Please click <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default">here</a></p>
					</div>
					<div class="modal-footer">
						<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
					</div>
				</div>
			</div>
		</div>
		<script type='text/javascript'>
			(function() {
				'use strict';
				function remoteModal(idModal){
				var vm = this;
				vm.modal = $(idModal);
				if( vm.modal.length == 0 ) { return false; } else { openModal(); }
					if( window.location.hash == idModal ){ openModal(); }
						var services = { open: openModal, close: closeModal };
						return services;
						function openModal(){
							vm.modal.modal('show');
						}
						function closeModal(){
							vm.modal.modal('hide');
						}
					}
					Window.prototype.remoteModal = remoteModal;
				})();
				$(function(){
					window.remoteModal('##modelWindowDialog');
				});
		</script>
	</cfif>
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<cfset ParticipantsGettingCertificate = 0>
	<cfloop query="#Session.EventNumberRegistrationsForCertificates#">
		<cfif (Session.EventNumberRegistrationsForCertificates.RegisterForEventDate1 EQ 1 and Session.EventNumberRegistrationsForCertificates.AttendedEventDate1 EQ 1) OR (Session.EventNumberRegistrationsForCertificates.RegisterForEventDate2 EQ 1 and Session.EventNumberRegistrationsForCertificates.AttendedEventDate2 EQ 1) OR (Session.EventNumberRegistrationsForCertificates.RegisterForEventDate3 EQ 1 and Session.EventNumberRegistrationsForCertificates.AttendedEventDate3 EQ 1) OR (Session.EventNumberRegistrationsForCertificates.RegisterForEventDate4 EQ 1 and Session.EventNumberRegistrationsForCertificates.AttendedEventDate4 EQ 1) OR (Session.EventNumberRegistrationsForCertificates.RegisterForEventDate5 EQ 1 and Session.EventNumberRegistrationsForCertificates.AttendedEventDate5 EQ 1) OR (Session.EventNumberRegistrationsForCertificates.RegisterForEventDate6 EQ 1 and Session.EventNumberRegistrationsForCertificates.AttendedEventDate6 EQ 1)>
			<cfset ParticipantsGettingCertificate = #Variables.ParticipantsGettingCertificate# + 1>
		</cfif>
	</cfloop>
	<div class="panel panel-default">
		<fieldset style="text-align: center">
			<legend><h2>Send PGP Certificate to Participant who attended event titled:<br>#Session.getSelectedEvent.ShortTitle#<hr>Number of Attended Participants Receiving Certificate: #Variables.ParticipantsGettingCertificate#</h2></legend>
		</fieldset>
		<cfform action="" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<div class="panel-body">
				<div class="alert alert-info"><p>PGP Certificates will be attached to the Email message sent as a PDF Document.</p></div>
				<div class="form-group">
					<label for="MsgToparticipants" class="control-label col-sm-3">Message to Participants:&nbsp;</label>
					<div class="col-sm-8">
						<textarea height="15" width="250" class="form-control" id="EmailMsg" name="EmailMsg"></textarea>
						<script>CKEDITOR.replace('EmailMsg', {
							// Define the toolbar groups as it is a more accessible solution.
							toolbarGroups: [
								{"name":"basicstyles","groups":["basicstyles"]},
								{"name":"links","groups":["links"]},
								{"name":"paragraph","groups":["list","blocks"]},
								{"name":"document","groups":["mode"]},
								{"name":"insert","groups":["insert"]},
								{"name":"styles","groups":["styles"]},
								{"name":"about","groups":["about"]}
							],
							// Remove the redundant buttons from toolbar groups defined above.
							removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
						} );</script>
					</div>
				</div>
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
				<cfif Session.EventNumberRegistrationsForCertificates.RecordCount GT 0>
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send PGP Certificates">
				</cfif><br /><br />
			</div>
		</cfform>
	</div>
<!--- 
	<cfdump var="#Session.EventNumberRegistrationsForCertificates#" abort="True">
	<div class="panel panel-default">
		<cfform action="#Variables.newurl#=eventcoordinator:events.default" method="post" id="AddEvent" class="form-horizontal">
			<fieldset>
				<legend><h2>Event Signin Sheet: #Session.getSelectedEvent.ShortTitle#</h2></legend>
			</fieldset>
			<div class="alert alert-info">Below is the PDF Document with Registered Participants who are currently signed up for this event.</div>
			<div class="panel-body">
				<cfif Len(Session.getSelectedEvent.EventDate1) or Len(Session.getSelectedEvent.EventDate2) or Len(Session.getSelectedEvent.EventDate3) or Len(Session.getSelectedEvent.EventDate4) or Len(Session.getSelectedEvent.EventDate5) or Len(Session.getSelectedEvent.EventDate6)>
					<table class="table" width="100%" cellspacing="0" cellpadding="0">
						<tr>
							<cfif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) EQ 0 and Len(Session.getSelectedEvent.EventDate3) EQ 0 and Len(Session.getSelectedEvent.EventDate4) EQ 0and Len(Session.getSelectedEvent.EventDate5) EQ 0 and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
							<cfelseif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) and Len(Session.getSelectedEvent.EventDate3) EQ 0 and Len(Session.getSelectedEvent.EventDate4) EQ 0 and Len(Session.getSelectedEvent.EventDate5) EQ 0 and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
							<cfelseif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) and Len(Session.getSelectedEvent.EventDate3) and Len(Session.getSelectedEvent.EventDate4) EQ 0 and Len(Session.getSelectedEvent.EventDate5) EQ 0 and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td>
							<cfelseif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) and Len(Session.getSelectedEvent.EventDate3) and Len(Session.getSelectedEvent.EventDate4) and Len(Session.getSelectedEvent.EventDate5) EQ 0 and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td>
							<cfelseif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) and Len(Session.getSelectedEvent.EventDate3) and Len(Session.getSelectedEvent.EventDate4) and Len(Session.getSelectedEvent.EventDate5) and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td>
							<cfelse>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td>
								<td><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#URL.EventID#&EventDatePos=6">SignIn Sheet Day 6</a></td>
							</cfif>
						</tr>
					</table>
				</cfif>
				<embed src="#Session.NameTagReport#" width="100%" height="650">
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Return to Event Listing"><br /><br />
			</div>
		</cfform>
	</div>
--->
</cfoutput>