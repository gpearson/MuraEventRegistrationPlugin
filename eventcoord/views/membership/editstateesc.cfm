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
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="MembershipID" value="#URL.MembershipID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Edit State Educational Service Center/Agency</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add information regarding this Organization's Membership</div>
					<div class="form-group">
						<label for="OrganizationName" class="col-lg-3 col-md-3">Organization Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="OrganizationName" name="OrganizationName" value="#Session.getSelectedESC.OrganizationName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="OrganizationDomainName" class="col-lg-3 col-md-3">Organization Domain Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="OrganizationDomainName" name="OrganizationDomainName" value="#Session.getSelectedESC.OrganizationDomainName#"  required="yes"></div>
					</div>
					<div class="form-group">
						<label for="StateDOEIDNumber" class="col-lg-3 col-md-3">State DOE ID Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StateDOEIDNumber" name="StateDOEIDNumber" value="#Session.getSelectedESC.StateDOE_IDNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="StateDOEState" class="col-lg-3 col-md-3">State DOE State:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StateDOEState" name="StateDOEState" value="#Session.getSelectedESC.StateDOE_State#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Mailing Address Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MailingAddress" class="col-lg-3 col-md-3">Address:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" value="#Session.getSelectedESC.Mailing_Address#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="col-lg-3 col-md-3">City:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" value="#Session.getSelectedESC.Mailing_City#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="col-lg-3 col-md-3">State:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" value="#Session.getSelectedESC.Mailing_State#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="col-lg-3 col-md-3">ZipCode:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.getSelectedESC.Mailing_ZipCode#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipPlus4" class="col-lg-3 col-md-3">Zip + 4:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="MailingZipPlus4" name="MailingZipPlus4" value="#Session.getSelectedESC.Mailing_ZipPlus4#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Physical Address Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-3 col-md-3">Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.getSelectedESC.Physical_Address#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-3 col-md-3">City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.getSelectedESC.Physical_City#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-3 col-md-3">State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.getSelectedESC.Physical_State#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-3 col-md-3">ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.getSelectedESC.Physical_ZipCode#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipPlus4" class="col-lg-3 col-md-3">Zip + 4:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PhysicalZipPlus4" name="PhysicalZipPlus4" value="#Session.getSelectedESC.Physical_ZipPlus4#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Phone Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PrimaryPhoneNumber" class="col-lg-3 col-md-3">Voice Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PrimaryPhoneNumber" name="PrimaryPhoneNumber" value="#Session.getSelectedESC.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryFaxNumber" class="col-lg-3 col-md-3">Fax Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PrimaryFaxNumber" name="PrimaryFaxNumber" value="#Session.getSelectedESC.PrimaryFaxNumber#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Location Addtional Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="USPSDeliveryPoint" class="col-lg-3 col-md-3">USPS Delivery Point:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSDeliveryPoint" name="USPSDeliveryPoint" value="#Session.getSelectedESC.Mailing_USPSDeliveryPoint#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="USPSCheckDigit" class="col-lg-3 col-md-3">USPS Check Digit:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSCheckDigit" name="USPSCheckDigit" value="#Session.getSelectedESC.Mailing_USPSCheckDigit#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="USPSCarrierRoute" class="col-lg-3 col-md-3">USPS Carrier Route:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSCarrierRoute" name="USPSCarrierRoute" value="#Session.getSelectedESC.Mailing_USPSCarrierRoute#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationTimeZone" class="col-lg-3 col-md-3">Facility TimeZone:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationTimeZone" name="LocationTimeZone" value="#Session.getSelectedESC.Physical_TimeZone#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationTimeOffset" class="col-lg-3 col-md-3">Facility UTC Offset:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationTimeOffset" name="LocationTimeOffset" value="#Session.getSelectedESC.Physical_UTCOffset#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationCongressionalDistrict" class="col-lg-3 col-md-3">Facility Congressional District:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationCongressionalDistrict" name="LocationCongressionalDistrict" value="#Session.getSelectedESC.Physical_CongressionalDistrict#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationCountyFIPS" class="col-lg-3 col-md-3">Facility County FIPS Code:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationCountyFIPS" name="LocationCountyFIPS" value="#Session.getSelectedESC.Physical_CountyFIPS#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationDST" class="col-lg-3 col-md-3">DayLight Savings Time Observed:&nbsp;</label>
						<div class="col-lg-9 col-md-9">
							<cfif Session.getSelectedESC.Physical_DST EQ true>
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
								map.setView(new L.LatLng(#Session.getSelectedESC.Physical_Latitude#, #Session.getSelectedESC.Physical_Longitude#), 12);
								L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
								var FacilityMarker = L.icon({
									iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
								});
								var marker = L.marker([#Session.getSelectedESC.Physical_Latitude#, #Session.getSelectedESC.Physical_Longitude#], {icon: FacilityMarker}).addTo(map);
							</script>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Edit State ESC Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="MembershipID" value="#URL.MembershipID#">
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
						<legend><h2>Edit State Educational Service Center/Agency</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Organization's Membership</div>
					<div class="form-group">
						<label for="OrganizationName" class="col-lg-3 col-md-3">Organization Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="OrganizationName" name="OrganizationName" value="#Session.FormInput.OrganizationName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="OrganizationDomainName" class="col-lg-3 col-md-3">Organization Domain Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="OrganizationDomainName" name="OrganizationDomainName" value="#Session.FormInput.OrganizationDomainName#"  required="yes"></div>
					</div>
					<div class="form-group">
						<label for="StateDOEIDNumber" class="col-lg-3 col-md-3">State DOE ID Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StateDOEIDNumber" name="StateDOEIDNumber" value="#Session.FORMInput.StateDOEIDNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="StateDOEState" class="col-lg-3 col-md-3">State DOE State:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StateDOEState" name="StateDOEState" value="#Session.FormInput.StateDOEState#" required="no"></div>
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
						<legend><h2>Physical Address Information</h2></legend>
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
					<fieldset>
						<legend><h2>Phone Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PrimaryPhoneNumber" class="col-lg-3 col-md-3">Voice Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PrimaryPhoneNumber" name="PrimaryPhoneNumber" value="#Session.FormInput.PrimaryPhoneNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryFaxNumber" class="col-lg-3 col-md-3">Fax Number:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="PrimaryFaxNumber" name="PrimaryFaxNumber" value="#Session.FormInput.PrimaryFaxNumber#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Location Addtional Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="USPSDeliveryPoint" class="col-lg-3 col-md-3">USPS Delivery Point:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSDeliveryPoint" name="USPSDeliveryPoint" value="#Session.getSelectedESC.Mailing_USPSDeliveryPoint#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="USPSCheckDigit" class="col-lg-3 col-md-3">USPS Check Digit:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSCheckDigit" name="USPSCheckDigit" value="#Session.getSelectedESC.Mailing_USPSCheckDigit#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="USPSCarrierRoute" class="col-lg-3 col-md-3">USPS Carrier Route:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="USPSCarrierRoute" name="USPSCarrierRoute" value="#Session.getSelectedESC.Mailing_USPSCarrierRoute#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationTimeZone" class="col-lg-3 col-md-3">Facility TimeZone:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationTimeZone" name="LocationTimeZone" value="#Session.getSelectedESC.Physical_TimeZone#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationTimeOffset" class="col-lg-3 col-md-3">Facility UTC Offset:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationTimeOffset" name="LocationTimeOffset" value="#Session.getSelectedESC.Physical_UTCOffset#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationCongressionalDistrict" class="col-lg-3 col-md-3">Facility Congressional District:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationCongressionalDistrict" name="LocationCongressionalDistrict" value="#Session.getSelectedESC.Physical_CongressionalDistrict#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationCountyFIPS" class="col-lg-3 col-md-3">Facility County FIPS Code:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LocationCountyFIPS" name="LocationCountyFIPS" value="#Session.getSelectedESC.Physical_CountyFIPS#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LocationDST" class="col-lg-3 col-md-3">DayLight Savings Time Observed:&nbsp;</label>
						<div class="col-lg-9 col-md-9">
							<cfif Session.getSelectedESC.Physical_DST EQ true>
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
								map.setView(new L.LatLng(#Session.getSelectedESC.Physical_Latitude#, #Session.getSelectedESC.Physical_Longitude#), 12);
								L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
								var FacilityMarker = L.icon({
									iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
								});
								var marker = L.marker([#Session.getSelectedESC.Physical_Latitude#, #Session.getSelectedESC.Physical_Longitude#], {icon: FacilityMarker}).addTo(map);
							</script>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Edit State ESC Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
