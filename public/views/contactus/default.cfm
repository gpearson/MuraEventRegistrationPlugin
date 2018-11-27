<cfsilent>
	<cfset BestContactMethodQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
	<cfset temp = QueryAddRow(BestContactMethodQuery, 1)>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "ID", 0)#>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "OptionName", "By Email")#>
	<cfset temp = QueryAddRow(BestContactMethodQuery, 1)>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "ID", 1)#>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "OptionName", "By Telephone")#>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cfset Session.PluginFramework = StructCopy(Variables.Framework)>
		</cflock>
	</cfif>
</cfsilent>
<cfoutput>
	<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
		<cfscript>lang = 'en';</cfscript>
		<cfsavecontent variable="htmlhead"><cfoutput><script src='https://www.google.com/recaptcha/api.js?h1=#lang#'></script></cfoutput></cfsavecontent>
		<cfhtmlhead text="#htmlhead#" />
	</cfif>
	<cfif Session.Mura.IsLoggedIn EQ True><cfset userRecord = #rc.$.getBean('user').loadBy(username='#Session.Mura.Username#', siteid='#rc.$.siteConfig("siteid")#').getAllValues()#></cfif>
	<div class="panel panel-default">
		<div class="panel-heading"><h2>Send Us your Inquiry/Feedback</h2></div>
		<cfif not isDefined("URL.FormRetry")>
			<cfform action="" method="post" id="ContactUsForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<br />
				<div class="alert alert-info">Please complete the following form to send us your inquiry and/or feedback on this website</div>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Your Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="YourFirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ true>
								<cfinput type="text" class="form-control" value="#Variables.userRecord.FName#" id="ContactFirstName" name="ContactFirstName" required="no" placeholder="Enter Your First Name" disabled="true">
								<cfinput type="hidden" name="ContactFirstName" value="#Variables.userRecord.FName#">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactFirstName" name="ContactFirstName" required="no" placeholder="Enter Your First Name">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="YourLastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfinput type="text" class="form-control" value="#Variables.userRecord.LName#" id="ContactLastName" name="ContactLastName" required="no" placeholder="Enter Your Last Name" disabled="true">
								<cfinput type="hidden" name="ContactLastName" value="#Variables.userRecord.LName#">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactLastName" name="ContactLastName" required="no" placeholder="Enter Your Last Name">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="YourEmail" class="control-label col-sm-3">Your Email:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfinput type="text" class="form-control" value="#Variables.userRecord.Email#" id="ContactEmail" name="ContactEmail" required="no" placeholder="Enter Your Email Address" disabled="true">
								<cfinput type="hidden" name="ContactEmail" value="#Variables.userRecord.Email#">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" required="no" placeholder="Enter Your Email Address">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="YourTelephone" class="control-label col-sm-3">Your Phone:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfinput type="text" class="form-control" value="#Variables.userRecord.mobilePhone#" id="ContactPhone" name="ContactPhone" required="no" placeholder="Enter Your Best Contact Number">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactPhone" name="ContactPhone" required="no" placeholder="Enter Your Best Contact Number">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="BestContactMethod" class="control-label col-sm-3">Best Contact Method:&nbsp;</label>
						<div class="col-sm-9">
							<cfselect name="BestContactMethod" class="form-control" Required="no" Multiple="No" query="BestContactMethodQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Select Best Contact Method</option>
							</cfselect>
						</div>
					</div>
					<cfif isDefined("URL.EventID") or isDefined("URL.SendTo")>
						<cfif isDefined("URL.EventID")>
							<fieldset>
								<legend><h2>Inquiry Regarding Specific Event</h2></legend>
							</fieldset>
							<div class="form-group">
								<label for="EventTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
								<div class="col-sm-9">
									<input type="Hidden" Name="EventTitle" Value="#Session.EventInfo.SelectedEvent.ShortTitle#">
									<input type="Hidden" name="EventID" Value="#URL.EventID#">
									<cfinput type="text" class="form-control" id="EventTitle" name="EventTitle" disabled="yes" value="#Session.EventInfo.SelectedEvent.ShortTitle#">
								</div>
							</div>
						</cfif>
					</cfif>
					<fieldset>
						<legend><h2>Your Inquiry and/or Feedback</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="InquiryMessage" class="control-label col-sm-3">Inquiry:&nbsp;</label>
						<div class="col-sm-9">
							<textarea class="form-control" name="InquiryMessage" id="InquiryMessage" height="45"></textarea>
						</div>
					</div>
					<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.GoogleReCaptcha_SiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Send Inquiry"><br /><br />
				</div>
			</cfform>
		<cfelseif isDefined("URL.FormRetry")>
			<cfform action="" method="post" id="ContactUsForm" class="form-horizontal">
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
				<br />
				<div class="alert alert-info">Please complete the following form to send us your inquiry and/or feedback on this website</div>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Your Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="YourFirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ true>
								<cfinput type="text" class="form-control" value="#Variables.userRecord.FName#" id="ContactFirstName" name="ContactFirstName" required="no" placeholder="Enter Your First Name" disabled="true">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactFirstName" name="ContactFirstName" value="#Session.FormInput.ContactFirstName#" required="no" placeholder="Enter Your First Name">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="YourLastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfinput type="text" class="form-control" value="#Variables.userRecord.LName#" id="ContactLastName" name="ContactLastName" required="no" placeholder="Enter Your Last Name" disabled="true">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactLastName" name="ContactLastName" value="#Session.FormInput.ContactLastName#" required="no" placeholder="Enter Your Last Name">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="YourEmail" class="control-label col-sm-3">Your Email:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfinput type="text" class="form-control" value="#Variables.userRecord.Email#" id="ContactEmail" name="ContactEmail" required="no" placeholder="Enter Your Email Address" disabled="true">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" required="no" value="#Session.FormInput.ContactEmail#" placeholder="Enter Your Email Address">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="YourTelephone" class="control-label col-sm-3">Your Phone:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfinput type="text" class="form-control" value="#Variables.userRecord.mobilePhone#" id="ContactPhone" name="ContactPhone" required="no" placeholder="Enter Your Best Contact Number">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactPhone" name="ContactPhone" required="no" value="#Session.FormInput.ContactPhone#" placeholder="Enter Your Best Contact Number">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="BestContactMethod" class="control-label col-sm-3">Best Contact Method:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.FormInput.BestContactMethod NEQ "----">
								<cfselect name="BestContactMethod" class="form-control" Required="no" Multiple="No" selected="#Session.FormInput.BestContactMethod#" query="BestContactMethodQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Select Best Contact Method</option>
								</cfselect>
							<cfelse>
								<cfselect name="BestContactMethod" class="form-control" Required="no" Multiple="No" query="BestContactMethodQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Select Best Contact Method</option>
								</cfselect>
							</cfif>
						</div>
					</div>
					<cfif isDefined("URL.EventID") or isDefined("URL.SendTo")>
						<cfif isDefined("URL.EventID")>
							<fieldset>
								<legend><h2>Inquiry Regarding Specific Event</h2></legend>
							</fieldset>
							<div class="form-group">
								<label for="EventTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
								<div class="col-sm-9">
									<input type="Hidden" Name="EventTitle" Value="#Session.EventInfo.SelectedEvent.ShortTitle#">
									<input type="Hidden" name="EventID" Value="#URL.EventID#">
									<cfinput type="text" class="form-control" id="EventTitle" name="EventTitle" disabled="yes" value="#Session.EventInfo.SelectedEvent.ShortTitle#">
								</div>
							</div>
						</cfif>
					</cfif>
					<fieldset>
						<legend><h2>Your Inquiry and/or Feedback</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="InquiryMessage" class="control-label col-sm-3">Inquiry:&nbsp;</label>
						<div class="col-sm-9">
							<textarea class="form-control" name="InquiryMessage" id="InquiryMessage" height="45">#Session.FormInput.InquiryMessage#</textarea>
						</div>
					</div>
					<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.GoogleReCaptcha_SiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Send Inquiry"><br /><br />
				</div>
			</cfform>
		</cfif>
	</div>
</cfoutput>