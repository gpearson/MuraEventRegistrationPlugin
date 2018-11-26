<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfif not isDefined("URL.formRetry")>
	<cfoutput>
		<div class="panel panel-default">
			<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="UserID" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend>Update Account Profile</legend>
					</fieldset>
					<div class="alert alert-info">If your username/email or organization need to be updated, please contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')# for assistance.</div>
					<div class="form-group">
						<label for="Username" class="control-label col-sm-3">Username:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getUserProfile.Username#</p></div>
					</div>
					<div class="form-group">
						<label for="FName" class="control-label col-sm-3">First Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.getUserProfile.Fname#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LName" class="control-label col-sm-3">Last Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.getUserProfile.LName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.getUserProfile.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-3">Desired Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="Password" name="Password" required="no"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.getUserProfile.mobilePhone#" validate="telephone" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Organization:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.getUserProfile.Company#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="jobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="jobTitle" name="jobTitle" value="#Session.getUserProfile.jobTitle#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="website" class="control-label col-sm-3">Website:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="website" name="website" value="#Session.getUserProfile.website#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="GradeLevel" class="control-label col-sm-3">Teaching Grade Level:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeLevel" class="form-control" Required="No" selected="#Session.getUserProfile.TeachingGrade#" Multiple="No" query="Session.getGradeLevels" value="TContent_ID" Display="GradeLevel"  queryposition="below"><option value="----">Select Grade Level you Teach</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="GradeSubjects" class="control-label col-sm-3">Teaching Subject:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeSubjects" class="form-control" Required="No" selected="#Session.getUserProfile.TeachingSubject#" Multiple="No" query="Session.getGradeSubjects" value="TContent_ID" Display="GradeSubject"  queryposition="below"><option value="----">Select Subject you Teach</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="ReceiveMarketingFlyers" class="control-label col-sm-3">Receive Upcoming Event Flyers:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="ReceiveMarketingFlyers" class="form-control" Required="No" selected="#Session.getUserProfile.ReceiveMarketingFlyers#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to receive Upcoming Event Flyers</option></cfselect></div>
					</div>
					<fieldset>
						<legend>System Account Information</legend>
					</fieldset>
					<div class="form-group">
						<label for="inActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getUserProfile.InActive#"><cfcase value="1">Yes</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch></p></div>
					</div>
					<div class="form-group">
						<label for="Created" class="control-label col-sm-3">Date Created:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DateFormat(Session.getUserProfile.created, "dddd, mmm dd, yyyy")# at #TimeFormat(Session.getUserProfile.created, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="LastLogin" class="control-label col-sm-3">Last Login:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfif LEN(Session.getUserProfile.LastLogin)>#DateFormat(Session.getUserProfile.LastLogin, "dddd, mmm dd, yyyy")# at #TimeFormat(Session.getUserProfile.LastLogin, "hh:mm tt")#<cfelse></cfif></p></div>
					</div>
					<div class="form-group">
						<label for="LastUpdate" class="control-label col-sm-3">Last Update:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfif LEN(Session.getUserProfile.LastUpdate)>#DateFormat(Session.getUserProfile.LastUpdate, "dddd, mmm dd, yyyy")# at #TimeFormat(Session.getUserProfile.LastUpdate, "hh:mm tt")#<cfelse></cfif></p></div>
					</div>
					<div class="form-group">
						<label for="LastUpdate" class="control-label col-sm-3">Last Update By:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getUserProfile.LastUpdateBy#</p></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="Back to Event Listing"> |
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="My Event History"> |
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="My Upcoming Events">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Account Profile"><br /><br />
				</div>
			</cfform>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.FormRetry")>
	<cfoutput>
		<div class="panel panel-default">
			<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="UserID" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormErrors")>
					<cfif ArrayLen(Session.FormErrors)>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information to Update Profile</h3>
								</div>
								<div class="modal-body">
									<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
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
								///////////////

								// method to open modal
								function openModal(){
									vm.modal.modal('show');
								}

								// method to close modal
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
				<div class="panel-body">
					<fieldset>
						<legend>Update Account Profile</legend>
					</fieldset>
					<div class="alert alert-info">If your username/email or organization need to be updated, please contact #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')# or call #rc.$.siteConfig('ContactPhone')# for assistance.</div>
					<div class="form-group">
						<label for="Username" class="control-label col-sm-3">Username:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getUserProfile.Username#</p></div>
					</div>
					<div class="form-group">
						<label for="FName" class="control-label col-sm-3">First Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.FormData.Fname#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LName" class="control-label col-sm-3">Last Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.FormData.LName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.getUserProfile.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-3">Desired Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="Password" value="#Session.FormData.Password#" name="Password" required="no"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.FormData.mobilePhone#" validate="telephone" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Organization:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.getUserProfile.Company#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="jobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="jobTitle" name="jobTitle" value="#Session.FormData.jobTitle#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="website" class="control-label col-sm-3">Website:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="website" name="website" value="#Session.FormData.website#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="GradeLevel" class="control-label col-sm-3">Teaching Grade Level:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeLevel" class="form-control" Required="No" selected="#Session.FormData.GradeLevel#" Multiple="No" query="Session.getGradeLevels" value="TContent_ID" Display="GradeLevel"  queryposition="below"><option value="----">Select Grade Level you Teach</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="GradeSubjects" class="control-label col-sm-3">Teaching Subject:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeSubjects" class="form-control" Required="No" selected="#Session.FormData.GradeSubjects#" Multiple="No" query="Session.getGradeSubjects" value="TContent_ID" Display="GradeSubject"  queryposition="below"><option value="----">Select Subject you Teach</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="ReceiveMarketingFlyers" class="control-label col-sm-3">Receive Upcoming Event Flyers:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="ReceiveMarketingFlyers" class="form-control" Required="No" selected="#Session.FormData.ReceiveMarketingFlyers#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to receive Upcoming Event Flyers</option></cfselect></div>
					</div>
					<fieldset>
						<legend>System Account Information</legend>
					</fieldset>
					<div class="form-group">
						<label for="inActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getUserProfile.InActive#"><cfcase value="1">Yes</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch></p></div>
					</div>
					<div class="form-group">
						<label for="Created" class="control-label col-sm-3">Date Created:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DateFormat(Session.getUserProfile.created, "dddd, mmm dd, yyyy")# at #TimeFormat(Session.getUserProfile.created, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="LastLogin" class="control-label col-sm-3">Last Login:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfif LEN(Session.getUserProfile.LastLogin)>#DateFormat(Session.getUserProfile.LastLogin, "dddd, mmm dd, yyyy")# at #TimeFormat(Session.getUserProfile.LastLogin, "hh:mm tt")#<cfelse></cfif></p></div>
					</div>
					<div class="form-group">
						<label for="LastUpdate" class="control-label col-sm-3">Last Update:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfif LEN(Session.getUserProfile.LastUpdate)>#DateFormat(Session.getUserProfile.LastUpdate, "dddd, mmm dd, yyyy")# at #TimeFormat(Session.getUserProfile.LastUpdate, "hh:mm tt")#<cfelse></cfif></p></div>
					</div>
					<div class="form-group">
						<label for="LastUpdate" class="control-label col-sm-3">Last Update By:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getUserProfile.LastUpdateBy#</p></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="Back to Event Listing"> |
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="My Event History"> |
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="My Upcoming Events">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Account Profile"><br /><br />
				</div>
			</cfform>
		</div>
	</cfoutput>
</cfif>