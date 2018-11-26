<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
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
	<cfelse>
		<cfset ParticipantsGettingCertificate = 0>
		<cfloop query="#Session.EventNumberRegistrations#">
			<cfif (Session.EventNumberRegistrations.RegisterForEventDate1 EQ 1 and Session.EventNumberRegistrations.AttendedEventDate1 EQ 1) OR (Session.EventNumberRegistrations.RegisterForEventDate2 EQ 1 and Session.EventNumberRegistrations.AttendedEventDate2 EQ 1) OR (Session.EventNumberRegistrations.RegisterForEventDate3 EQ 1 and Session.EventNumberRegistrations.AttendedEventDate3 EQ 1) OR (Session.EventNumberRegistrations.RegisterForEventDate4 EQ 1 and Session.EventNumberRegistrations.AttendedEventDate4 EQ 1) OR (Session.EventNumberRegistrations.RegisterForEventDate5 EQ 1 and Session.EventNumberRegistrations.AttendedEventDate5 EQ 1) OR (Session.EventNumberRegistrations.RegisterForEventDate6 EQ 1 and Session.EventNumberRegistrations.AttendedEventDate6 EQ 1)>
			<cfset ParticipantsGettingCertificate = #Variables.ParticipantsGettingCertificate# + 1>
			</cfif>
		</cfloop>

		<script src="/requirements/ckeditor/ckeditor.js"></script>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Send PGP Certificate to Participant who attended event titled:</h1><h3>#Session.getSelectedEvent.ShortTitle#</h3><br><p>Number of Attended Participants Receiving Certificate: #Variables.ParticipantsGettingCertificate#</p></div>
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
							} );
							</script>
					</div>
				</div>
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
				<cfif Session.EventNumberRegistrations.RecordCount GT 0>
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send PGP Certificates">
				</cfif><br /><br />
			</div>
		</cfform>
		</div>	
	</cfif>
	
</cfoutput>