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
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<cfform action="#Variables.newurl#=eventcoordinator:events.cancelevent&EventID=#URL.EventID#" method="post" id="CancelEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="EmailConfirmations" value="0">
			<div class="panel panel-default">
				<fieldset>
					<legend><h3>Cancelling Event: #Session.getSelectedEvent.ShortTitle# <cfif Len(Session.getSelectedEvent.PresenterID)>(#Session.getSelectedEventPresenter.FName# #Session.getSelectedEventPresenter.Lname#)</cfif></h3></legend>
				</fieldset>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to cancel this event and if selected notify participants who are registered.</p></div>
					<div class="form-group">
						<label for="EventDate" class="col-lg-3 col-md-3">Event Date(s):&nbsp;</label>
						<div class="col-lg-9 col-md-9 form-control-static">
							#DateFormat(Session.getSelectedEvent.EventDate, "full")#
							<cfif LEN(Session.getSelectedEvent.EventDate1)>, #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate2)>, #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate3)>, #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate4)>, #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</cfif>
						</div>
					</div>
					<cfif Session.getRegisteredParticipants.RecordCount GT 0>
						<div class="form-group">
							<label for="EventDate" class="col-lg-3 col-md-3">Number Registered Participants:&nbsp;</label>
							<div class="col-lg-9 col-md-9 form-control-static">#Session.getRegisteredParticipants.RecordCount#</div>
						</div>
						<div class="form-group">
							<label for="EmailConfirmations" class="col-lg-3 col-md-3">Send Email Confirmations:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Send Email Confirmation of Request</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="EmailMsg" class="col-lg-3 col-md-3">Message to Participants:&nbsp;</label>
							<div class="col-lg-9 col-md-9">
								<textarea height="15" width="100%" class="form-control" id="EmailMsg" name="EmailMsg"></textarea>
								<script type="text/javascript">
									CKEDITOR.replace('EmailMsg', {
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
					<cfelse>
						<div class="form-group"><div class="alert alert-info"><p>This event did not have anyone registered.</p></div></div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Cancel Event"><br /><br />
				</div>
			</div>
		</cfform>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<cfform action="#Variables.newurl#=eventcoordinator:events.cancelevent&EventID=#URL.EventID#" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif isDefined("Session.FormErrors")>
				<cfif ArrayLen(Session.FormErrors)>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">#Session.FormErrors[1].Message#</p>
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
			</cfif>
			<div class="panel panel-default">
				<fieldset>
					<legend><h3>Cancelling Event: #Session.getSelectedEvent.ShortTitle# <cfif Len(Session.getSelectedEvent.PresenterID)>(#Session.getSelectedEventPresenter.FName# #Session.getSelectedEventPresenter.Lname#)</cfif></h3></legend>
				</fieldset>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to cancel this event and if selected notify participants who are registered.</p></div>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Event Date(s):&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">
							#DateFormat(Session.getSelectedEvent.EventDate, "full")#
							<cfif LEN(Session.getSelectedEvent.EventDate1)>, #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate2)>, #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate3)>, #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate4)>, #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</cfif>
						</div>
					</div>
					<cfif Session.getRegisteredParticipants.RecordCount GT 0>
						<div class="form-group">
							<label for="EventDate" class="col-lg-3 col-md-3">Number Registered Participants:&nbsp;</label>
							<div class="col-lg-9 col-md-9 form-control-static">#Session.getRegisteredParticipants.RecordCount#</div>
						</div>
						<div class="form-group">
							<label for="EmailConfirmations" class="col-lg-3 col-md-3">Send Email Confirmations:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Send Email Confirmation of Request</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="EmailMsg" class="col-lg-3 col-md-3">Message to Participants:&nbsp;</label>
							<div class="col-lg-9 col-md-9">
								<textarea height="15" width="100%" class="form-control" id="EmailMsg" name="EmailMsg">#Session.FormInput.EmailMsg#</textarea>
								<script type="text/javascript">
									CKEDITOR.replace('EmailMsg', {
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
					<cfelse>
						<div class="form-group"><div class="alert alert-info"><p>This event did not have anyone registered.</p></div></div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Cancel Event"><br /><br />
				</div>
			</div>
		</cfform>
	</cfif>
</cfoutput>