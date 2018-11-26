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
			<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Edit Caterer Information</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Caterer</div>
					<div class="form-group">
						<label for="BusinessName" class="col-lg-3 col-md-3">Business Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="BusinessName" name="BusinessName" value="#Session.getSelectedCaterer.FacilityName#" required="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Physical Location Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-3 col-md-3">Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.getSelectedCaterer.Physical_Address#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-3 col-md-3">City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.getSelectedCaterer.Physical_City#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-3 col-md-3">State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.getSelectedCaterer.Physical_State#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-3 col-md-3">ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.getSelectedCaterer.Physical_ZipCode#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="col-lg-3 col-md-3">Voice Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.getSelectedCaterer.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="col-lg-3 col-md-3">Website:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.getSelectedCaterer.BusinessWebsite#" required="NO"></div>
					</div>
					<fieldset>
						<legend><h2>Mailing Address Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MailingAddress" class="col-lg-3 col-md-3">Address:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" value="#Session.getSelectedCaterer.Mailing_Address#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="col-lg-3 col-md-3">City:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" value="#Session.getSelectedCaterer.Mailing_City#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="col-lg-3 col-md-3">State:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" value="#Session.getSelectedCaterer.Mailing_State#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="col-lg-3 col-md-3">ZipCode:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.getSelectedCaterer.Mailing_ZipCode#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ContactName" class="col-lg-3 col-md-3">Name:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" value="#Session.getSelectedCaterer.ContactName#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="col-lg-3 col-md-3">Phone Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" value="#Session.getSelectedCaterer.ContactPhoneNumber#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="col-lg-3 col-md-3">Email Address:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" value="#Session.getSelectedCaterer.ContactEmail#" required="NO"></div>
					</div>
					<fieldset>
						<legend><h2>Additional Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Active" class="col-lg-3 col-md-3">Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfselect name="Active" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.getSelectedCaterer.Active#" queryposition="below">
							<option value="----">Is facility Active?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="PaymentTerms" class="col-lg-3 col-md-3">Payment Terms:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><textarea name="PaymentTerms" id="PaymentTerms" class="form-control" >#Session.getSelectedCaterer.PaymentTerms#</textarea></div>
					</div>
					<div class="form-group">
						<label for="DeliveryInfo" class="col-lg-3 col-md-3">Delivery Information:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><textarea name="DeliveryInfo" id="DeliveryInfo" class="form-control" >#Session.getSelectedCaterer.DeliveryInfo#</textarea></div>
					</div>
					<div class="form-group">
						<label for="GuaranteeInformation" class="col-lg-3 col-md-3">Guarantee Information:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><textarea name="GuaranteeInformation" id="GuaranteeInformation" class="form-control" >#Session.getSelectedCaterer.GuaranteeInformation#</textarea></div>
					</div>
					<div class="form-group">
						<label for="AdditionalNotes" class="col-lg-3 col-md-3">Additional Notes:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><textarea name="AdditionalNotes" id="AdditionalNotes" class="form-control" >#Session.getSelectedCaterer.AdditionalNotes#</textarea></div>
					</div>
					<fieldset>
						<legend><h2>Location Addtional Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="USPSDeliveryPoint" class="col-lg-3 col-md-3">USPS Delivery Point:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSDeliveryPoint" name="USPSDeliveryPoint" value="#Session.getSelectedCaterer.Mailing_USPSDeliveryPoint#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="USPSCheckDigit" class="col-lg-3 col-md-3">USPS Check Digit:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSCheckDigit" name="USPSCheckDigit" value="#Session.getSelectedCaterer.Mailing_USPSCheckDigit#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="USPSCarrierRoute" class="col-lg-3 col-md-3">USPS Carrier Route:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSCarrierRoute" name="USPSCarrierRoute" value="#Session.getSelectedCaterer.Mailing_USPSCarrierRoute#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationTimeZone" class="col-lg-3 col-md-3">Facility TimeZone:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationTimeZone" name="LocationTimeZone" value="#Session.getSelectedCaterer.Physical_TimeZone#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationTimeOffset" class="col-lg-3 col-md-3">Facility UTC Offset:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationTimeOffset" name="LocationTimeOffset" value="#Session.getSelectedCaterer.Physical_UTCOffset#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationCongressionalDistrict" class="col-lg-3 col-md-3">Facility Congressional District:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationCongressionalDistrict" name="LocationCongressionalDistrict" value="#Session.getSelectedCaterer.Physical_CongressionalDistrict#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationCountyFIPS" class="col-lg-3 col-md-3">Facility County FIPS Code:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationCountyFIPS" name="LocationCountyFIPS" value="#Session.getSelectedCaterer.Physical_CountyFIPS#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationDST" class="col-lg-3 col-md-3">DayLight Savings Time Observed:&nbsp;</label>
						<div class="col-lg-9 col-md-9">
							<cfif Session.getSelectedCaterer.Physical_DST EQ true>
								<cfinput type="text" class="form-control" id="LocationDST" name="LocationDST" value="Yes" disabled="yes">
							<cfelse>
								<cfinput type="text" class="form-control" id="LocationDST" name="LocationDST" value="No" disabled="yes">
							</cfif>
						</div>
					</div>
					<div class="form-group" align="center">
						<div class="col-lg-12 col-md-12">
							<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
							<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
							<div id="map" style="width: 475px; height: 300px;"></div>
							<script>
								var facilitymarker;
								var map = L.map('map');
								map.setView(new L.LatLng(#Session.getSelectedCaterer.Physical_Latitude#, #Session.getSelectedCaterer.Physical_Longitude#), 12);
								L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
								var FacilityMarker = L.icon({
									iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
								});
								var marker = L.marker([#Session.getSelectedCaterer.Physical_Latitude#, #Session.getSelectedCaterer.Physical_Longitude#], {icon: FacilityMarker}).addTo(map);
							</script>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Edit Caterer"><br /><br />
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
						<legend><h2>Edit Caterer Information</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Caterer</div>
					<div class="form-group">
						<label for="BusinessName" class="col-lg-3 col-md-3">Business Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="BusinessName" name="BusinessName" value="#Session.FormInput.BusinessName#" required="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Physical Location Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-3 col-md-3">Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.FormInput.PhysicalAddress#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-3 col-md-3">City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.FormInput.PhysicalCity#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-3 col-md-3">State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.FormInput.PhysicalState#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-3 col-md-3">ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.FormInput.PhysicalZipCode#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="col-lg-3 col-md-3">Voice Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.FormInput.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="col-lg-3 col-md-3">Website:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.FormInput.BusinessWebsite#" required="NO"></div>
					</div>
					<fieldset>
						<legend><h2>Mailing Address Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MailingAddress" class="col-lg-3 col-md-3">Address:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" value="#Session.FormInput.MailingAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="col-lg-3 col-md-3">City:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" value="#Session.FormInput.MailingCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="col-lg-3 col-md-3">State:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" value="#Session.FormInput.MailingState#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="col-lg-3 col-md-3">ZipCode:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.FormInput.MailingZipCode#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ContactName" class="col-lg-3 col-md-3">Name:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" value="#Session.FormInput.ContactName#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="col-lg-3 col-md-3">Phone Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" value="#Session.FormInput.ContactPhoneNumber#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="col-lg-3 col-md-3">Email Address:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" value="#Session.FormInput.ContactEmail#" required="NO"></div>
					</div>
					<fieldset>
						<legend><h2>Additional Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Active" class="col-lg-3 col-md-3">Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfselect name="Active" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.Active#" queryposition="below">
							<option value="----">Is facility Active?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="PaymentTerms" class="col-lg-3 col-md-3">Payment Terms:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><textarea name="PaymentTerms" id="PaymentTerms" class="form-control" >#Session.FormInput.PaymentTerms#</textarea></div>
					</div>
					<div class="form-group">
						<label for="DeliveryInfo" class="col-lg-3 col-md-3">Delivery Information:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><textarea name="DeliveryInfo" id="DeliveryInfo" class="form-control" >#Session.FormInput.DeliveryInfo#</textarea></div>
					</div>
					<div class="form-group">
						<label for="GuaranteeInformation" class="col-lg-3 col-md-3">Guarantee Information:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><textarea name="GuaranteeInformation" id="GuaranteeInformation" class="form-control" >#Session.FormInput.GuaranteeInformation#</textarea></div>
					</div>
					<div class="form-group">
						<label for="AdditionalNotes" class="col-lg-3 col-md-3">Additional Notes:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><textarea name="AdditionalNotes" id="AdditionalNotes" class="form-control" >#Session.FormInput.AdditionalNotes#</textarea></div>
					</div>
					<fieldset>
						<legend><h2>Location Addtional Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="USPSDeliveryPoint" class="col-lg-3 col-md-3">USPS Delivery Point:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSDeliveryPoint" name="USPSDeliveryPoint" value="#Session.getSelectedCaterer.Mailing_USPSDeliveryPoint#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="USPSCheckDigit" class="col-lg-3 col-md-3">USPS Check Digit:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSCheckDigit" name="USPSCheckDigit" value="#Session.getSelectedCaterer.Mailing_USPSCheckDigit#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="USPSCarrierRoute" class="col-lg-3 col-md-3">USPS Carrier Route:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSCarrierRoute" name="USPSCarrierRoute" value="#Session.getSelectedCaterer.Mailing_USPSCarrierRoute#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationTimeZone" class="col-lg-3 col-md-3">Facility TimeZone:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationTimeZone" name="LocationTimeZone" value="#Session.getSelectedCaterer.Physical_TimeZone#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationTimeOffset" class="col-lg-3 col-md-3">Facility UTC Offset:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationTimeOffset" name="LocationTimeOffset" value="#Session.getSelectedCaterer.Physical_UTCOffset#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationCongressionalDistrict" class="col-lg-3 col-md-3">Facility Congressional District:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationCongressionalDistrict" name="LocationCongressionalDistrict" value="#Session.getSelectedCaterer.Physical_CongressionalDistrict#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationCountyFIPS" class="col-lg-3 col-md-3">Facility County FIPS Code:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationCountyFIPS" name="LocationCountyFIPS" value="#Session.getSelectedCaterer.Physical_CountyFIPS#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationDST" class="col-lg-3 col-md-3">DayLight Savings Time Observed:&nbsp;</label>
						<div class="col-lg-9 col-md-9">
							<cfif Session.getSelectedCaterer.Physical_DST EQ true>
								<cfinput type="text" class="form-control" id="LocationDST" name="LocationDST" value="Yes" disabled="yes">
							<cfelse>
								<cfinput type="text" class="form-control" id="LocationDST" name="LocationDST" value="No" disabled="yes">
							</cfif>
						</div>
					</div>
					<div class="form-group" align="center">
						<div class="col-lg-12 col-md-12">
							<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
							<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
							<div id="map" style="width: 475px; height: 300px;"></div>
							<script>
								var facilitymarker;
								var map = L.map('map');
								map.setView(new L.LatLng(#Session.getSelectedCaterer.Physical_Latitude#, #Session.getSelectedCaterer.Physical_Longitude#), 12);
								L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
								var FacilityMarker = L.icon({
									iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
								});
								var marker = L.marker([#Session.getSelectedCaterer.Physical_Latitude#, #Session.getSelectedCaterer.Physical_Longitude#], {icon: FacilityMarker}).addTo(map);
							</script>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Edit Catering Facility"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
