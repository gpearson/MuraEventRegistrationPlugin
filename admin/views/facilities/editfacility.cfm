<cfsilent>
<!---

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
			<cfform action="" method="post" id="AddNewUser" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="FacilityRoomUpdated">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Facility Room Updated</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have made changes to the Facility Room Information for this facility</p>
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
						</cfcase>
						<cfcase value="FacilityRoomAdded">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Facility Room Added</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have added a new facility room to this facility</p>
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
						</cfcase>
					</cfswitch>
				</cfif>
				<div class="panel-heading"><h2>Update Facility</h2></div>
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding this Facility</div>
					<div class="form-group">
						<label for="FacilityName" class="col-lg-5 col-md-5">Facility Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" value="#Session.getSelectedFacility.FacilityName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-5 col-md-5">Physical Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.getSelectedFacility.PhysicalAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-5 col-md-5">Address City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.getSelectedFacility.PhysicalCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-5 col-md-5">Address State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.getSelectedFacility.PhysicalState#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-5 col-md-5">Address ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.getSelectedFacility.PhysicalZipCode#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="col-lg-5 col-md-5">Voice Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.getSelectedFacility.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="col-lg-5 col-md-5">Website:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.getSelectedFacility.BusinessWebsite#" required="no"></div>
					</div>
					<legend><h2>Contact Person's Information</h2></legend>
					<div class="form-group">
						<label for="ContactName" class="col-lg-5 col-md-5">Contact Person:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" value="#Session.getSelectedFacility.ContactName#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="col-lg-5 col-md-5">Phone Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" value="#Session.getSelectedFacility.ContactPhoneNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="col-lg-5 col-md-5">Contact Email:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" value="#Session.getSelectedFacility.ContactEmail#" required="no"></div>
					</div>
					<legend><h2>Facility Notes</h2></legend>
					<div class="form-group">
						<label for="PaymentTerms" class="col-lg-5 col-md-5">Payment Terms:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="PaymentTerms" id="PaymentTerms" height="45">#Trim(Session.getSelectedFacility.PaymentTerms)#</textarea></div>
					</div>
					<div class="form-group">
						<label for="AdditionalNotes" class="col-lg-5 col-md-5">Additional Notes:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="AdditionalNotes" id="AdditionalNotes" height="45">#Trim(Session.getSelectedFacility.AdditionalNotes)#</textarea></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-5 col-md-5">Facility Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="Active" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.getSelectedFacility.Active#" queryposition="below">
							<option value="----">Facility Active?</option>
						</cfselect></div>
					</div>
					<legend><h2>Facility Room Information</h2></legend>
					<div class="form-group">
						<table class="table table-striped table-bordered">
							<cfif Session.getSelectedFacilityRooms.RecordCount>
								<thead class="thead-default">
									<tr>
										<th width="40%">Room Name</th>
										<th  width="15%">Room Capacity</th>
										<th  width="15%">Room Fees</th>
										<th width="15%">Room Active</th>
										<th width="15%">Actions</th>
									</tr>
								</thead>
								<tfoot>
									<tr>
										<td colspan="5">Add a new meeting room to this Facility by clicking <a href="#buildURL('admin:facilities.addfacilityroom')#&FacilityID=#URL.FacilityID#" class="btn btn-primary btn-small">here</a></td>
									</tr>
								</tfoot>
								<tbody>
									<cfloop query="Session.getSelectedFacilityRooms">
										<tr>
											<td>#Session.getSelectedFacilityRooms.RoomName#</td>
											<td>#Session.getSelectedFacilityRooms.Capacity#</td>
											<td>#DollarFormat(Session.getSelectedFacilityRooms.RoomFees)#</td>
											<td><cfswitch expression="#Session.getSelectedFacilityRooms.Active#"><cfcase value="1">Yes</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch></td>
											<td><a href="#buildURL('admin:facilities.editfacilityroom')#&FacilityID=#URL.FacilityID#&FacilityRoomID=#Session.getSelectedFacilityRooms.TContent_ID#" class="btn btn-primary btn-small">Update</a></td>
										</tr>
									</cfloop>
								</tbody>
							<cfelse>
								<tfoot>
									<tr>
										<td colspan="5">Add a new meeting room to this Facility by clicking <a href="#buildURL('admin:facilities.addfacilityroom')#&FacilityID=#URL.FacilityID#" class="btn btn-primary btn-small">here</a></td>
									</tr>
								</tfoot>
							</cfif>
						</table>
					</div>
					<legend><h2>Facility Location Information</h2></legend>
					<div class="form-group">
						<label for="isAddressVerified" class="col-lg-5 col-md-5">Address Verified:&nbsp;</label>
						<div class="col-sm-7 form-control-static"><cfswitch expression="#Session.getSelectedFacility.Physical_isAddressVerified#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></div>
					</div>
					<cfif Session.getSelectedFacility.Physical_isAddressVerified eq 1>
						<div class="form-group">
							<label for="AddressGeocodeLocation" class="col-lg-5 col-md-5">Address GeoCode Location:&nbsp;</label>
							<div class="col-sm-7 form-control-static">LAT: #Session.getSelectedFacility.Physical_Latitude# / LON: #Session.getSelectedFacility.Physical_Longitude#</div>
						</div>
						<div class="form-group">
							<label for="USPSDeliveryPoint" class="col-lg-5 col-md-5">USPS DeliveryPoint:&nbsp;</label>
							<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.Physical_USPSDeliveryPoint#</div>
						</div>
						<div class="form-group">
							<label for="USPSCheckDigit" class="col-lg-5 col-md-5">USPS Check Digit:&nbsp;</label>
							<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.Physical_USPSCheckDigit#</div>
						</div>
						<div class="form-group">
							<label for="USPSCarrierRoute" class="col-lg-5 col-md-5">USPS Carrier Route:&nbsp;</label>
							<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.Physical_USPSCarrierRoute#</div>
						</div>
						<div class="form-group">
							<label for="AddressDST" class="col-lg-5 col-md-5">Daylight Savings Time Observed:&nbsp;</label>
							<div class="col-sm-7 form-control-static"><cfswitch expression="#Session.getSelectedFacility.Physical_DST#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></div>
						</div>
						<div class="form-group">
							<label for="LocationTimeZone" class="col-lg-5 col-md-5">Timezone:&nbsp;</label>
							<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.Physical_TimeZone# (GMT Offset: #Session.getSelectedFacility.Physical_UTCOffset#)</div>
						</div>
					</cfif>
					<legend><h2>Facility Record Information</h2></legend>
					<div class="form-group">
						<label for="dateCreated" class="col-lg-5 col-md-5">Date Created:&nbsp;</label>
						<div class="col-sm-7 form-control-static">#DateFormat(Session.getSelectedFacility.dateCreated, "Full")#</div>
					</div>
					<div class="form-group">
						<label for="lastUpdated" class="col-lg-5 col-md-5">Last Updated:&nbsp;</label>
						<div class="col-sm-7 form-control-static">#DateFormat(Session.getSelectedFacility.lastUpdated, "Full")#</div>
					</div>
					<div class="form-group">
						<label for="lastUpdateBy" class="col-lg-5 col-md-5">Last Updated By:&nbsp;</label>
						<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.lastUpdateBy#</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left BtnSameSize" value="Back to Facility Listing">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right BtnSameSize" value="Update Facility Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewUser" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
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
				<div class="panel-heading"><h2>Update Facility</h2></div>
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding this Facility</div>
					<div class="form-group">
						<label for="FacilityName" class="col-lg-5 col-md-5">Facility Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" value="#Session.FormInput.FacilityName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-5 col-md-5">Physical Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.FormInput.PhysicalAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-5 col-md-5">Address City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.FormInput.PhysicalCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-5 col-md-5">Address State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.FormInput.PhysicalState#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-5 col-md-5">Address ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.FormInput.PhysicalZipCode#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="col-lg-5 col-md-5">Voice Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.FormInput.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="col-lg-5 col-md-5">Website:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.FormInput.BusinessWebsite#" required="no"></div>
					</div>
					<legend><h2>Contact Person's Information</h2></legend>
					<div class="form-group">
						<label for="ContactName" class="col-lg-5 col-md-5">Contact Person:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" value="#Session.FormInput.ContactName#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="col-lg-5 col-md-5">Phone Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" value="#Session.FormInput.ContactPhoneNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="col-lg-5 col-md-5">Contact Email:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" value="#Session.FormInput.ContactEmail#" required="no"></div>
					</div>
					<legend><h2>Facility Notes</h2></legend>
					<div class="form-group">
						<label for="PaymentTerms" class="col-lg-5 col-md-5">Payment Terms:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="PaymentTerms" id="PaymentTerms" height="45">#Trim(Session.FormInput.PaymentTerms)#</textarea></div>
					</div>
					<div class="form-group">
						<label for="AdditionalNotes" class="col-lg-5 col-md-5">Additional Notes:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="AdditionalNotes" id="AdditionalNotes" height="45">#Trim(Session.FormInput.AdditionalNotes)#</textarea></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-5 col-md-5">Facility Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="Active" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.Active#" queryposition="below">
							<option value="----">Facility Active?</option>
						</cfselect></div>
					</div>
					<legend><h2>Facility Location Information</h2></legend>
					<div class="form-group">
						<label for="isAddressVerified" class="col-lg-5 col-md-5">Address Verified:&nbsp;</label>
						<div class="col-sm-7 form-control-static"><cfswitch expression="#Session.getSelectedFacility.Physical_isAddressVerified#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></div>
					</div>
					<cfif Session.getSelectedFacility.Physical_isAddressVerified eq 1>
						<div class="form-group">
							<label for="AddressGeocodeLocation" class="col-lg-5 col-md-5">Address GeoCode Location:&nbsp;</label>
							<div class="col-sm-7 form-control-static">LAT: #Session.getSelectedFacility.Physical_Latitude# / LON: #Session.getSelectedFacility.Physical_Longitude#</div>
						</div>
						<div class="form-group">
							<label for="USPSDeliveryPoint" class="col-lg-5 col-md-5">USPS DeliveryPoint:&nbsp;</label>
							<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.Physical_USPSDeliveryPoint#</div>
						</div>
						<div class="form-group">
							<label for="USPSCheckDigit" class="col-lg-5 col-md-5">USPS Check Digit:&nbsp;</label>
							<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.Physical_USPSCheckDigit#</div>
						</div>
						<div class="form-group">
							<label for="USPSCarrierRoute" class="col-lg-5 col-md-5">USPS Carrier Route:&nbsp;</label>
							<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.Physical_USPSCarrierRoute#</div>
						</div>
						<div class="form-group">
							<label for="AddressDST" class="col-lg-5 col-md-5">Daylight Savings Time Observed:&nbsp;</label>
							<div class="col-sm-7 form-control-static"><cfswitch expression="#Session.getSelectedFacility.Physical_DST#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></div>
						</div>
						<div class="form-group">
							<label for="LocationTimeZone" class="col-lg-5 col-md-5">Timezone:&nbsp;</label>
							<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.Physical_TimeZone# (GMT Offset: #Session.getSelectedFacility.Physical_UTCOffset#)</div>
						</div>
					</cfif>
					<legend><h2>Facility Record Information</h2></legend>
					<div class="form-group">
						<label for="dateCreated" class="col-lg-5 col-md-5">Date Created:&nbsp;</label>
						<div class="col-sm-7 form-control-static">#DateFormat(Session.getSelectedFacility.dateCreated, "Full")#</div>
					</div>
					<div class="form-group">
						<label for="lastUpdated" class="col-lg-5 col-md-5">Last Updated:&nbsp;</label>
						<div class="col-sm-7 form-control-static">#DateFormat(Session.getSelectedFacility.lastUpdated, "Full")#</div>
					</div>
					<div class="form-group">
						<label for="lastUpdateBy" class="col-lg-5 col-md-5">Last Updated By:&nbsp;</label>
						<div class="col-sm-7 form-control-static">#Session.getSelectedFacility.lastUpdateBy#</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left BtnSameSize" value="Back to Facility Listing">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right BtnSameSize" value="Update Facility Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
