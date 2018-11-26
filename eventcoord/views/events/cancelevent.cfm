<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Cancel Event: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.LongDescription#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.Registration_Deadline, "mm/dd/yyyy")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Registration Begin Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Registration_BeginTime, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Start Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_StartTime, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event End Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_EndTime, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventAgenda#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventTargetAudience#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventStrategies#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventSpecialInstructions#</p></div>
					</div>
					<div class="form-group">
						<label for="CancelEvent" class="control-label col-sm-3">Really Cancel Event?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="CancelEvent" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Select Yes to Cancel Event</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Cancel Event"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormErrors")>
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
				<div class="panel-body">
					<fieldset>
						<legend><h2>Cancel Event: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.LongDescription#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.Registration_Deadline, "mm/dd/yyyy")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Registration Begin Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Registration_BeginTime, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Start Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_StartTime, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event End Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_EndTime, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventAgenda#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventTargetAudience#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventStrategies#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventSpecialInstructions#</p></div>
					</div>
					<div class="form-group">
						<label for="CancelEvent" class="control-label col-sm-3">Really Cancel Event?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="CancelEvent" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Select Yes to Cancel Event</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Cancel Event"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>