<cfsilent>
	<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>

	<cfif Session.getActiveMembership.RecordCount EQ 1>
		<cfset UserActiveMembership = "Yes">
	<cfelse>
		<cfset UserActiveMembership = "No">
	</cfif>
</cfsilent>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventID" value="#Session.UserRegistrationInfo.EventID#">
				<div class="panel-body">
					<fieldset>
						<legend>Registering for Event: #Session.getSelectedEvent.ShortTitle#</legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to register for this event. All electronic communication from this system will be sent to the Participant's Email Address
					<cfif Session.getSelectedEvent.EventHasDailySessions EQ 1><p align="center"><hr>
					<strong>Session 1:</strong> #timeFormat(Session.getSelectedEvent.Session1BeginTime, "hh:mm tt")# till #timeFormat(Session.getSelectedEvent.Session1EndTime, "hh:mm tt")#<br>
					<strong>Session 2:</strong> #timeFormat(Session.getSelectedEvent.Session2BeginTime, "hh:mm tt")# till #timeFormat(Session.getSelectedEvent.Session2EndTime, "hh:mm tt")#<br>
					</p></cfif>
					</div>
					<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)>
						<p class="alert alert-info">You will be registered for the First Date of this event by default.<br>Event Date: #DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#<br>
							<cfif isDate(Session.getSelectedEvent.EventDate1)>
							Second Date: #DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#<br>
							</cfif>
							<cfif isDate(Session.getSelectedEvent.EventDate2)>
							Third Date: #DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#<br>
							</cfif>
							<cfif isDate(Session.getSelectedEvent.EventDate3)>
							Fourth Date: #DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#<br>
							</cfif>
							<cfif isDate(Session.getSelectedEvent.EventDate4)>
							Fifth Date: #DateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#<br>
							</cfif>
							<cfif isDate(Session.getSelectedEvent.EventDate5)>
							Sixth Date: #DateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#<br>
							</cfif>
						</p>
					</cfif>
					<div class="form-group">
						<label for="RegistrationName" class="control-label col-sm-3">Your Name:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.Mura.FName# #Session.Mura.LName#</p></div>
					</div>
					<div class="form-group">
						<label for="RegistrationEmail" class="control-label col-sm-3">Your Email:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.Mura.Email#</p></div>
					</div>
					<cfif Session.getSelectedEvent.PGPAvailable EQ 1>
						<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">PGP Points:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#NumberFormat(Session.getSelectedEvent.PGPPoints, "999.99")#</p></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Active Membership:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Variables.UserActiveMembership#</p></div>
					</div>
					<div class="form-group">
						<label for="RegisterAdditionalIndividuals" class="control-label col-sm-3">Register Additional Individuals?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfif Session.UserRegistrationInfo.UserAlreadyRegistered EQ true>
								<cfselect name="RegisterAdditionalIndividuals" class="form-control" Required="Yes" Multiple="No" selected="1" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to Register Additional Individuals</option></cfselect>
							<cfelse>
								<cfselect name="RegisterAdditionalIndividuals" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to Register Additional Individuals</option></cfselect>
							</cfif>
						</div>
					</div>
					<cfif Session.getSelectedEvent.EventHasDailySessions EQ 1>
						<div class="form-group">
						<label for="AttendSession1" class="control-label col-sm-3">Attend Session 1:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="AttendSession1" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you be attending session 1</option></cfselect></div>
						</div>
						<div class="form-group">
						<label for="AttendSession2" class="control-label col-sm-3">Attend Session 2:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="AttendSession2" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you be attending session 2</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.MealProvided EQ 1>
						<div class="form-group">
						<label for="StayForMeal" class="control-label col-sm-3">Staying for Meal?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="StayForMeal" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="1" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you be staying for Meal</option></cfselect></div>
						</div>
					</cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)>
						<div class="form-group">
						<label for="RegisterAllDates" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="RegisterDate" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
						</div>
						<cfif isDate(Session.getSelectedEvent.EventDate1)>
							<div class="form-group">
							<label for="RegisterDate2" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfselect name="RegisterDate1" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
							</div>
						</cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate2)>
							<div class="form-group">
							<label for="RegisterDate3" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfselect name="RegisterDate2" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
							</div>
						</cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate3)>
							<div class="form-group">
							<label for="RegisterDate4" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfselect name="RegisterDate3" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
							</div>
						</cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate4)>
							<div class="form-group">
							<label for="RegisterDate5" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfselect name="RegisterDate4" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
							</div>
						</cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate5)>
							<div class="form-group">
							<label for="RegisterDate6" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#?&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8"><cfselect name="RegisterDate5" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
							</div>
						</cfif>
					</cfif>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
						<label for="AttendViaWebinar" class="control-label col-sm-3">Attend via Webinar?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="AttendViaWebinar" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend via Webinar Option</option></cfselect></div>
						</div>
					<cfelseif Session.getSelectedEvent.WebinarAvailable EQ 0>
						<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
							<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.UserEventEarlyBirdPrice)# <cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)> Per Event Date</cfif></p></div>
							</div>
						<cfelseif Session.UserRegistrationInfo.GroupPricingAvailable EQ "True">
							<div class="form-group">
								<p class="alert alert-info">This Pricing will be updated by the Facilitator once the Special Pricing Requirements have been met. If Group Price Requirements have not been met, then Event Pricing will be #DollarFormat(Session.UserRegistrationInfo.UserEventPrice)# to attend  <cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)> each date of this event<cfelse> this event</cfif></p></div></p>
								<label for="RegistrationEmail" class="control-label col-sm-3">Group Requirements:&nbsp;</label>
								<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.GroupPriceRequirements#</p></div>
							</div>
							<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">Group Price:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.GroupEventPrice)#</p></div>
							</div>
							<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">Cost to Participate<br>(Without Discount):&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.UserEventPrice)#<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)> Per Event Date</cfif></p></div>
							</div>
						<cfelse>
							<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.UserEventPrice)# <cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)> Per Event Date</cfif></p></div>
							</div>
						</cfif>
					</cfif>
					<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
						<div class="form-group">
						<label for="AttendViaIVC" class="control-label col-sm-3">Attend via Video Conference?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="AttendViaIVC" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Will you attend via Video Conferencing Equipment</option></cfselect></div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register For Event"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventID" value="#Session.FormInput.EventID#">
				<cfif isDefined("Session.FormErrors")>
					<cfif ArrayLen(Session.FormErrors)>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information to Register for Event</h3>
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
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="UserAlreadyRegistered">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Account Already Registered for Event</h3>
										</div>
										<div class="modal-body">
											<div class="alert alert-danger">You are already registered for this event. If you would like to register additional individuals, simply select the option to Register Additional Indivduals. If you would like to cancel your registration you can do that from the User Menu and select Manage Registrations.</div>
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
						</cfcase>
					</cfswitch>
				</cfif>
				<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)>
					<div class="panel-body">
						<p class="alert alert-info">You will be registered for the First Date of this event by default.<br>Event Date: #DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#<br>
							<cfif isDate(Session.getSelectedEvent.EventDate1)>
							Second Date: #DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#<br>
							</cfif>
							<cfif isDate(Session.getSelectedEvent.EventDate2)>
							Third Date: #DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#<br>
							</cfif>
							<cfif isDate(Session.getSelectedEvent.EventDate3)>
							Fourth Date: #DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#<br>
							</cfif>
							<cfif isDate(Session.getSelectedEvent.EventDate4)>
							Fifth Date: #DateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#<br>
							</cfif>
							<cfif isDate(Session.getSelectedEvent.EventDate5)>
							Sixth Date: #DateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#<br>
							</cfif>
						</p>
					</div>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend>Registering for Event: #Session.getSelectedEvent.ShortTitle#</legend>
					</fieldset>
					<p class="alert alert-info">Please complete the following information to register for this event. All electronic communication from this system will be sent to the Participant's Email Address</p>
					<div class="form-group">
						<label for="RegistrationName" class="control-label col-sm-3">Your Name:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.Mura.FName# #Session.Mura.LName#</p></div>
					</div>
					<div class="form-group">
						<label for="RegistrationEmail" class="control-label col-sm-3">Your Email:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.Mura.Email#</p></div>
					</div>
					<cfif Session.getSelectedEvent.PGPAvailable EQ 1>
						<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">PGP Points:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#NumberFormat(Session.getSelectedEvent.PGPPoints, "999.99")#</p></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Active Membership:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Variables.UserActiveMembership#</p></div>
					</div>
					<div class="form-group">
						<label for="RegisterAdditionalIndividuals" class="control-label col-sm-3">Register Additional Individuals?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfif Session.UserRegistrationInfo.UserAlreadyRegistered EQ true>
								<cfselect name="RegisterAdditionalIndividuals" class="form-control" Required="Yes" Multiple="No" selected="1" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to Register Additional Individuals</option></cfselect>
							<cfelse>
								<cfif isDefined("Session.FormInput.RegisterAdditionalIndividuals")>
									<cfselect name="RegisterAdditionalIndividuals" class="form-control" selected="#Session.FormInput.RegisterAdditionalIndividuals#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to Register Additional Individuals</option></cfselect>
								<cfelse>
									<cfselect name="RegisterAdditionalIndividuals" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to Register Additional Individuals</option></cfselect>
								</cfif>
							</cfif>
						</div>
					</div>
					<cfif Session.getSelectedEvent.EventHasDailySessions EQ 1>
						<div class="form-group">
						<label for="AttendSession1" class="control-label col-sm-3">Attend Session 1:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="AttendSession1" class="form-control" Required="Yes" Multiple="No" selected="#Session.FormInput.AttendSession1#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you be attending session 1</option></cfselect></div>
						</div>
						<div class="form-group">
						<label for="AttendSession2" class="control-label col-sm-3">Attend Session 2:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="AttendSession2" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.FormInput.AttendSession2#" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you be attending session 2</option></cfselect></div>
						</div>
					</cfif>

					<cfif Session.getSelectedEvent.MealProvided EQ 1>
						<div class="form-group">
						<label for="StayForMeal" class="control-label col-sm-3">Staying for Meal?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfif isDefined("Session.FormInput.StayForMeal")>
								<cfselect name="StayForMeal" class="form-control" selected="#Session.FormInput.StayForMeal#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you be staying for Meal</option></cfselect>
							<cfelse>
								<cfselect name="StayForMeal" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you be staying for Meal</option></cfselect>
							</cfif></div>
						</div>
					</cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)>
						<div class="form-group">
						<label for="RegisterAllDates" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfif isDefined("Session.FormInput.RegisterDate")>
								<cfselect name="RegisterDate" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.FormInput.RegisterDate#" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
							<cfelse>
								<cfselect name="RegisterDate" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
							</cfif>
						</div>
						<cfif isDate(Session.getSelectedEvent.EventDate1)>
							<div class="form-group">
							<label for="RegisterDate2" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.FormInput.RegisterDate1")>
									<cfselect name="RegisterDate1" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.FormInput.RegisterDate1#" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								<cfelse>
									<cfselect name="RegisterDate1" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								</cfif>
							</div>
						</cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate2)>
							<div class="form-group">
							<label for="RegisterDate3" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.FormInput.RegisterDate2")>
									<cfselect name="RegisterDate2" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.FormInput.RegisterDate2#" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								<cfelse>
									<cfselect name="RegisterDate2" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								</cfif>
							</div>
						</cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate3)>
							<div class="form-group">
							<label for="RegisterDate4" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.FormInput.RegisterDate3")>
									<cfselect name="RegisterDate3" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery"  selected="#Session.FormInput.RegisterDate3#" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								<cfelse>
									<cfselect name="RegisterDate3" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								</cfif>
							</div>
						</cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate4)>
							<div class="form-group">
							<label for="RegisterDate5" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.FormInput.RegisterDate4")>
									<cfselect name="RegisterDate4" class="form-control" Required="Yes" Multiple="No"  selected="#Session.FormInput.RegisterDate4#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								<cfelse>
									<cfselect name="RegisterDate4" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								</cfif>
							</div>
						</cfif>
						<cfif isDate(Session.getSelectedEvent.EventDate5)>
							<div class="form-group">
							<label for="RegisterDate6" class="control-label col-sm-3">Register for #DateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfif isDefined("Session.FormInput.RegisterDate5")>
									<cfselect name="RegisterDate5" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.FormInput.RegisterDate5#" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								<cfelse>
									<cfselect name="RegisterDate5" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend this event date</option></cfselect></div>
								</cfif>
							</div>
						</cfif>
					</cfif>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
						<label for="AttendViaWebinar" class="control-label col-sm-3">Attend via Webinar?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfif isDefined("Session.FormInput.AttendViaWebinar")>
								<cfselect name="AttendViaWebinar" class="form-control" Selected="#Session.FormInput.AttendViaWebinar#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend via Webinar Option</option></cfselect>
							<cfelse>
								<cfselect name="AttendViaWebinar" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you attend via Webinar Option</option></cfselect>
							</cfif>
						</div>
						</div>
					<cfelseif Session.getSelectedEvent.WebinarAvailable EQ 0>
						<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
							<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.UserEventEarlyBirdPrice)# <cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)> Per Event Date</cfif></p></div>
							</div>
						<cfelseif Session.UserRegistrationInfo.GroupPricingAvailable EQ "True">
							<div class="form-group">
								<p class="alert alert-info">This Pricing will be updated by the Facilitator once the Special Pricing Requirements have been met. If Group Price Requirements have not been met, then Event Pricing will be #DollarFormat(Session.UserRegistrationInfo.UserEventPrice)# to attend  <cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)> each date of this event<cfelse> this event</cfif></p></div></p>
								<label for="RegistrationEmail" class="control-label col-sm-3">Group Requirements:&nbsp;</label>
								<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.GroupPriceRequirements#</p></div>
							</div>
							<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">Group Price:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.GroupEventPrice)#</p></div>
							</div>
							<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">Cost to Participate<br>(Without Discount):&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.UserEventPrice)#<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)> Per Event Date</cfif></p></div>
							</div>
						<cfelse>
							<div class="form-group">
							<label for="RegistrationEmail" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.UserRegistrationInfo.UserEventPrice)# <cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)> Per Event Date</cfif></p></div>
							</div>
						</cfif>
					</cfif>
					<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
						<div class="form-group">
						<label for="AttendViaIVC" class="control-label col-sm-3">Attend via Video Conference?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfif isDefined("Session.FormInput.AttendViaWebinar")>
								<cfselect name="AttendViaIVC" class="form-control" Selected="#Session.FormInput.AttendViaIVC#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Will you attend via Video Conferencing Equipment</option></cfselect>
							<cfelse>
								<cfselect name="AttendViaIVC" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Will you attend via Video Conferencing Equipment</option></cfselect>
							</cfif>
						</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register For Event"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>