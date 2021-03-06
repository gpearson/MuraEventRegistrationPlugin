<cfsilent>
<!---
	This file is part of Mura Event Registration Plugin

	Copyright 2010-2018 Graham Pearson
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

	<cfswitch expression="#Server.Coldfusion.ProductName#">
		<cfcase value="Lucee">
			<cfset ReportLibraryJars = #this.javaSettings.Loadpaths[1]#>
			<cfif not isDefined("Session.ReportLibraryJars")><cfset Session.ReportLibraryJars = #Variables.ReportLibraryJars#></cfif>
		</cfcase>
	</cfswitch>
	<cfset FileTest1 = #Variables.ReportLibraryJars# & "/itextpdf-5.3.3.jar">
	<cfset FileTest2 = #Variables.ReportLibraryJars# & "/itext-pdfa-5.3.3.jar">
	<cfset FileTest3 = #Variables.ReportLibraryJars# & "/itext-xtra-5.3.3.jar">
	<cfset FileTest4 = #Variables.ReportLibraryJars# & "/twitter4j.jar">

</cfsilent>
<cfoutput>
	<h2>Site Configuration</h2>
	<cfif Session.SiteConfigSettings.recordcount EQ 0 and not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteID')#">
				<cfinput type="hidden" name="JavaLibraryJars" value="#Variables.ReportLibraryJars#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Modify Site Configuration Settings</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to modify site configuration settings</div>
					<div class="form-group">
						<label for="SiteID" class="col-lg-3 col-md-3">Site ID:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SiteID" name="SiteID" disabled value="#$.siteConfig('siteid')#"></div>
					</div>
					<cfif FileExists(Variables.FileTest1) EQ false or FileExists(Variables.FileTest2) EQ false or FileExists(Variables.FileTest3) EQ false or FileExists(Variables.FileTest4) EQ false>
						<fieldset>
							<legend><h2>Required JAR Files not installed</h2></legend>
						</fieldset>
						<div class="alert alert-info">To Generate various PDF Documents, required library files will need to be installed. If required files are not installed then PDF documents can not be generated</div>
						<div class="form-group">
							<label for="CFMLProductName" class="col-lg-3 col-md-3">Coldfusion Product Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="CFMLProductName" name="CFMLProductName" disabled value="#Server.Coldfusion.ProductName#"></div>
						</div>
						<div class="form-group">
							<label for="InstallJarFiles" class="col-lg-3 col-md-3">Install Required JAR Files:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="InstallJarFiles" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value= "----">Install Required Files?</option></cfselect></div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Stripe Payment Processor Configuration</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to enable Stripe Payment Processing for this plugin. For more information on the Stripe Processing Service, please visit <a href="http://www.stripe.com" target="_blank">Stripe.com</a></div>
					<div class="form-group">
						<label for="ProcessPaymentsStripe" class="col-lg-3 col-md-3">Process Stripe Payments:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="ProcessPaymentsStripe" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Process Online Payments with Stripe?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="StripeTestMode" class="col-lg-3 col-md-3">Stripe Test Mode:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="StripeTestMode" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Stripe Test Mode Enabled?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="StripeTestAPIKey" class="col-lg-3 col-md-3">Stripe Test API Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StripeTestAPIKey" name="StripeTestAPIKey"></div>
					</div>
					<div class="form-group">
						<label for="StripeLiveAPIKey" class="col-lg-3 col-md-3">Stripe Live API Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StripeLiveAPIKey" name="StripeLiveAPIKey"></div>
					</div>
					<fieldset>
						<legend><h2>Facebook Application Configuration</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="FacebookEnabled" class="col-lg-3 col-md-3">Publish to Facebook Page:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="FacebookEnabled" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Publish Events to Facebook Company Page?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="FacebookAppID" class="col-lg-3 col-md-3">Facebook Application ID:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppID" name="FacebookAppID"></div>
					</div>
					<div class="form-group">
						<label for="FacebookAppSecretKey" class="col-lg-3 col-md-3">Facebook App Secret Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppSecretKey" name="FacebookAppSecretKey"></div>
					</div>
					<div class="form-group">
						<label for="FacebookPageID" class="col-lg-3 col-md-3">Facebook Page ID:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookPageID" name="FacebookPageID"></div>
					</div>
					<div class="form-group">
						<label for="FacebookAppScope" class="col-lg-3 col-md-3">Facebook Application Scope:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppScope" name="FacebookAppScope"></div>
					</div>
					<fieldset>
						<legend><h2>Twitter Application Configuration</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="TwitterEnabled" class="col-lg-3 col-md-3">Send Tweets regarding events:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="TwitterEnabled" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Publish Events to Companies Twitter Handle?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="TwitterConsumerKey" class="col-lg-3 col-md-3">Twitter Consumer Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterConsumerKey" name="TwitterConsumerKey"></div>
					</div>
					<div class="form-group">
						<label for="TwitterConsumerSecretKey" class="col-lg-3 col-md-3">Twitter Consumer Secret Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterConsumerSecretKey" name="TwitterConsumerSecretKey"></div>
					</div>
					<div class="form-group">
						<label for="TwitterAccessToken" class="col-lg-3 col-md-3">Twitter Access Token:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterAccessToken" name="TwitterAccessToken"></div>
					</div>
					<div class="form-group">
						<label for="TwitterAccessTokenSecret" class="col-lg-3 col-md-3">Twitter Access Token Secret:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterAccessTokenSecret" name="TwitterAccessTokenSecret"></div>
					</div>
					<fieldset>
						<legend><h2>Google ReCaptcha Form Protection</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to enable Google ReCaptcha Form Protections for this plugin. For more information on Google ReCaptcha Service, please visit <a href="https://www.google.com/recaptcha/" target="_blank">Google ReCaptcha Site</a></div>
					<div class="form-group">
						<label for="GoogleReCaptchaEnabled" class="col-lg-3 col-md-3">Google ReCaptcha Enabled:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="GoogleReCaptchaEnabled" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Enable Google ReCaptcha Form Protection?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="GoogleReCaptchaSiteKey" class="col-lg-3 col-md-3">Site Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleReCaptchaSiteKey" name="GoogleReCaptchaSiteKey"></div>
					</div>
					<div class="form-group">
						<label for="GoogleReCaptchaSecretKey" class="col-lg-3 col-md-3">Secret Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleReCaptchaSecretKey" name="GoogleReCaptchaSecretKey"></div>
					</div>
					<fieldset>
						<legend><h2>Smarty Streets Address Verification Service</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to enable Smarty Streets Processing for this plugin. For more information on the Smarty Streets Service, please visit <a href="http://www.smartystreets.com" target="_blank">SmartyStreets.com</a></div>
					<div class="form-group">
						<label for="SmartyStreetsEnabled" class="col-lg-3 col-md-3">Smarty Streets Enabled:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="SmartyStreetsEnabled" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Enable Smarty Streets API?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="SmartyStreetsAPIID" class="col-lg-3 col-md-3">API ID:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SmartyStreetsAPIID" name="SmartyStreetsAPIID"></div>
					</div>
					<div class="form-group">
						<label for="SmartyStreetsAPITOKEN" class="col-lg-3 col-md-3">API Token:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SmartyStreetsAPITOKEN" name="SmartyStreetsAPITOKEN"></div>
					</div>
					<fieldset>
						<legend><h2>Company Specific Plugin Features</h2></legend>
					</fieldset>
					<div class="alert alert-info">Does your company have policies in place for the following procedures?</div>
					<div class="form-group">
						<label for="BillForNoShowRegistration" class="col-lg-3 col-md-3">Bill Participant For NoShow:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="BillForNoShowRegistration" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Should Application Bill Participant for NoShows?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="RequireEventSurveyToGetCertificate" class="col-lg-3 col-md-3">Require Survey to Get Certificate:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="RequireEventSurveyToGetCertificate" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Require Submission of Event Survey to Obtain Completion Certiifcate?</option></cfselect></div>
					</div>
					<fieldset>
						<legend><h2>Social Media Profiles</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to display social media profile icons to visitors of this plugin</div>
					<div class="form-group">
						<label for="GitHubProfileURL" class="col-lg-3 col-md-3">GitHub Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GitHubProfileURL" name="GitHubProfileURL"></div>
					</div>
					<div class="form-group">
						<label for="TwitterProfileURL" class="col-lg-3 col-md-3">Twitter Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterProfileURL" name="TwitterProfileURL"></div>
					</div>
					<div class="form-group">
						<label for="FacebookProfileURL" class="col-lg-3 col-md-3">Facebook Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookProfileURL" name="FacebookProfileURL"></div>
					</div>
					<div class="form-group">
						<label for="GoogleProfileURL" class="col-lg-3 col-md-3">Google+ Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleProfileURL" name="GoogleProfileURL"></div>
					</div>
					<div class="form-group">
						<label for="LinkedInProfileURL" class="col-lg-3 col-md-3">LinkedIn Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LinkedInProfileURL" name="LinkedInProfileURL"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Insert Site Configuration"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif Session.SiteConfigSettings.recordcount EQ 0 and isDefined("URL.FormRetry")>
		<cfif StructCount(Session.FormInput) EQ 0><cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default" ><cflocation url="#variables.newurl#" addtoken="false"></cfif>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteID')#">
				<cfinput type="hidden" name="JavaLibraryJars" value="#Variables.ReportLibraryJars#">
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
				<div class="panel-body">
					<fieldset>
						<legend><h2>Modify Site Configuration Settings</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to modify site configuration settings</div>
					<div class="form-group">
						<label for="SiteID" class="col-lg-3 col-md-3">Site ID:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SiteID" name="SiteID" disabled value="#$.siteConfig('siteid')#"></div>
					</div>
					<cfif FileExists(Variables.FileTest1) EQ false or FileExists(Variables.FileTest2) EQ false or FileExists(Variables.FileTest3) EQ false or FileExists(Variables.FileTest4) EQ false>
						<fieldset>
							<legend><h2>Required JAR Files not installed</h2></legend>
						</fieldset>
						<div class="alert alert-info">To Generate various PDF Documents, required library files will need to be installed. If required files are not installed then PDF documents can not be generated</div>
						<div class="form-group">
							<label for="CFMLProductName" class="col-lg-3 col-md-3">Coldfusion Product Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="CFMLProductName" name="CFMLProductName" disabled value="#Server.Coldfusion.ProductName#"></div>
						</div>
						<div class="form-group">
							<label for="InstallJarFiles" class="col-lg-3 col-md-3">Install Required JAR Files:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="InstallJarFiles" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value= "----">Install Required Files?</option></cfselect></div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Stripe Payment Processor Configuration</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to enable Stripe Payment Processing for this plugin. For more information on the Stripe Processing Service, please visit <a href="http://www.stripe.com" target="_blank">Stripe.com</a></div>
					<div class="form-group">
						<label for="ProcessPaymentsStripe" class="col-lg-3 col-md-3">Process Stripe Payments:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="ProcessPaymentsStripe" class="form-control" required="no" selected="#Session.FormInput.ProcessPaymentsStripe#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Process Online Payments with Stripe?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="StripeTestMode" class="col-lg-3 col-md-3">Stripe Test Mode:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="StripeTestMode" class="form-control" required="no" selected="#Session.FormInput.StripeTestMode#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Stripe Test Mode Enabled?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="StripeTestAPIKey" class="col-lg-3 col-md-3">Stripe Test API Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StripeTestAPIKey" name="StripeTestAPIKey" value="#Session.FormInput.StripeTestAPIKey#"></div>
					</div>
					<div class="form-group">
						<label for="StripeLiveAPIKey" class="col-lg-3 col-md-3">Stripe Live API Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StripeLiveAPIKey" name="StripeLiveAPIKey" value="#Session.FormInput.StripeLiveAPIKey#"></div>
					</div>
					<fieldset>
						<legend><h2>Facebook Application Configuration</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="FacebookEnabled" class="col-lg-3 col-md-3">Publish to Facebook Page:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="FacebookEnabled" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.FacebookEnabled#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Publish Events to Facebook Company Page?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="FacebookAppID" class="col-lg-3 col-md-3">Facebook Application ID:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppID" name="FacebookAppID" value="#Session.FormInput.FacebookAppID#"></div>
					</div>
					<div class="form-group">
						<label for="FacebookAppSecretKey" class="col-lg-3 col-md-3">Facebook App Secret Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppSecretKey" name="FacebookAppSecretKey" value="#Session.FormInput.FacebookAppSecretKey#"></div>
					</div>
					<div class="form-group">
						<label for="FacebookPageID" class="col-lg-3 col-md-3">Facebook Page ID:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookPageID" name="FacebookPageID" value="#Session.FormInput.FacebookPageID#"></div>
					</div>
					<div class="form-group">
						<label for="FacebookAppScope" class="col-lg-3 col-md-3">Facebook Application Scope:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppScope" name="FacebookAppScope" value="#Session.FormInput.FacebookAppScope#"></div>
					</div>
					<fieldset>
						<legend><h2>Twitter Application Configuration</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="TwitterEnabled" class="col-lg-3 col-md-3">Send Tweets regarding events:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="TwitterEnabled" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.TwitterEnabled#" queryposition="below"><option value="----">Publish Events to Companies Twitter Handle?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="TwitterConsumerKey" class="col-lg-3 col-md-3">Twitter Consumer Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterConsumerKey" name="TwitterConsumerKey" value="#Session.FormInput.TwitterConsumerKey#"></div>
					</div>
					<div class="form-group">
						<label for="TwitterConsumerSecretKey" class="col-lg-3 col-md-3">Twitter Consumer Secret Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterConsumerSecretKey" name="TwitterConsumerSecretKey" value="#Session.FormInput.TwitterConsumerSecretKey#"></div>
					</div>
					<div class="form-group">
						<label for="TwitterAccessToken" class="col-lg-3 col-md-3">Twitter Access Token:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterAccessToken" name="TwitterAccessToken" value="#Session.FormInput.TwitterAccessToken#"></div>
					</div>
					<div class="form-group">
						<label for="TwitterAccessTokenSecret" class="col-lg-3 col-md-3">Twitter Access Token Secret:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterAccessTokenSecret" name="TwitterAccessTokenSecret" value="#Session.FormInput.TwitterAccessTokenSecret#"></div>
					</div>
					<fieldset>
						<legend><h2>Google ReCaptcha Form Protection</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to enable Google ReCaptcha Form Protections for this plugin. For more information on Google ReCaptcha Service, please visit <a href="https://www.google.com/recaptcha/" target="_blank">Google ReCaptcha Site</a></div>
					<div class="form-group">
						<label for="GoogleReCaptchaEnabled" class="col-lg-3 col-md-3">Google ReCaptcha Enabled:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="GoogleReCaptchaEnabled" class="form-control" required="no" selected="#Session.FormInput.GoogleReCaptchaEnabled#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Enable Google ReCaptcha Form Protection?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="GoogleReCaptchaSiteKey" class="col-lg-3 col-md-3">Site Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleReCaptchaSiteKey" name="GoogleReCaptchaSiteKey" value="#Session.FormInput.GoogleReCaptchaSiteKey#"></div>
					</div>
					<div class="form-group">
						<label for="GoogleReCaptchaSecretKey" class="col-lg-3 col-md-3">Secret Key:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleReCaptchaSecretKey" name="GoogleReCaptchaSecretKey" value="#Session.FormInput.GoogleReCaptchaSecretKey#"></div>
					</div>
					<fieldset>
						<legend><h2>Smarty Streets Address Verification Service</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to enable Smarty Streets Processing for this plugin. For more information on the Smarty Streets Service, please visit <a href="http://www.smartystreets.com" target="_blank">SmartyStreets.com</a></div>
					<div class="form-group">
						<label for="SmartyStreetsEnabled" class="col-lg-3 col-md-3">Smarty Streets Enabled:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="SmartyStreetsEnabled" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.SmartyStreetsEnabled#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Enable Smarty Streets API?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="SmartyStreetsAPIID" class="col-lg-3 col-md-3">API ID:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SmartyStreetsAPIID" name="SmartyStreetsAPIID" value="#Session.FormInput.SmartyStreetsAPIID#"></div>
					</div>
					<div class="form-group">
						<label for="SmartyStreetsAPITOKEN" class="col-lg-3 col-md-3">API Token:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SmartyStreetsAPITOKEN" name="SmartyStreetsAPITOKEN" value="#Session.FormInput.SmartyStreetsAPITOKEN#"></div>
					</div>
					<fieldset>
						<legend><h2>Company Specific Plugin Features</h2></legend>
					</fieldset>
					<div class="alert alert-info">Does your company have policies in place for the following procedures?</div>
					<div class="form-group">
						<label for="BillForNoShowRegistration" class="col-lg-3 col-md-3">Bill Participant For NoShow:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="BillForNoShowRegistration" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.BillForNoShowRegistration#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Should Application Bill Participant for NoShows?</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="RequireEventSurveyToGetCertificate" class="col-lg-3 col-md-3">Require Survey to Get Certificate:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfselect name="RequireEventSurveyToGetCertificate" class="form-control" required="no" Multiple="No" query="YesNoQuery" selected="#Session.FormInput.RequireEventSurveyToGetCertificate#" value="ID" Display="OptionName" queryposition="below"><option value="----">Require Submission of Event Survey to Obtain Completion Certiifcate?</option></cfselect></div>
					</div>
					<fieldset>
						<legend><h2>Social Media Profiles</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to display social media profile icons to visitors of this plugin</div>
					<div class="form-group">
						<label for="GitHubProfileURL" class="col-lg-3 col-md-3">GitHub Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GitHubProfileURL" name="GitHubProfileURL" value="#Session.FormInput.GitHubProfileURL#"></div>
					</div>
					<div class="form-group">
						<label for="TwitterProfileURL" class="col-lg-3 col-md-3">Twitter Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterProfileURL" name="TwitterProfileURL" value="#Session.FormInput.TwitterProfileURL#"></div>
					</div>
					<div class="form-group">
						<label for="FacebookProfileURL" class="col-lg-3 col-md-3">Facebook Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookProfileURL" name="FacebookProfileURL" value="#Session.FormInput.FacebookProfileURL#"></div>
					</div>
					<div class="form-group">
						<label for="GoogleProfileURL" class="col-lg-3 col-md-3">Google+ Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleProfileURL" name="GoogleProfileURL" value="#Session.FormInput.GoogleProfileURL#"></div>
					</div>
					<div class="form-group">
						<label for="LinkedInProfileURL" class="col-lg-3 col-md-3">LinkedIn Profile URL:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LinkedInProfileURL" name="LinkedInProfileURL" value="#Session.FormInput.LinkedInProfileURL#"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Insert Site Configuration"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelse>
		<cfif not isDefined("URL.FormRetry")>
			<div class="panel panel-default">
				<cfform action="" method="post" id="AddEvent" class="form-horizontal">
					<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteID')#">
					<cfinput type="hidden" name="JavaLibraryJars" value="#Variables.ReportLibraryJars#">
					<cfinput type="hidden" name="formSubmit" value="true">
					<div class="panel-body">
						<fieldset>
							<legend><h2>Modify Site Configuration Settings</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to modify site configuration settings</div>
						<div class="form-group">
							<label for="SiteID" class="col-lg-3 col-md-3">Site ID:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SiteID" name="SiteID" disabled value="#$.siteConfig('siteid')#"></div>
						</div>
						<cfif FileExists(Variables.FileTest1) EQ false or FileExists(Variables.FileTest2) EQ false or FileExists(Variables.FileTest3) EQ false or FileExists(Variables.FileTest4) EQ false>
							<fieldset>
								<legend><h2>Required JAR Files not installed</h2></legend>
							</fieldset>
							<div class="alert alert-info">To Generate various PDF Documents, required library files will need to be installed. If required files are not installed then PDF documents can not be generated</div>
							<div class="form-group">
								<label for="CFMLProductName" class="col-lg-3 col-md-3">Coldfusion Product Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="CFMLProductName" name="CFMLProductName" disabled value="#Server.Coldfusion.ProductName#"></div>
							</div>
							<div class="form-group">
								<label for="InstallJarFiles" class="col-lg-3 col-md-3">Install Required JAR Files:&nbsp;</label>
								<div class="col-lg-9 col-md-9"><cfselect name="InstallJarFiles" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value= "----">Install Required Files?</option></cfselect></div>
							</div>
						</cfif>
						<fieldset>
							<legend><h2>Stripe Payment Processor Configuration</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to enable Stripe Payment Processing for this plugin. For more information on the Stripe Processing Service, please visit <a href="http://www.stripe.com" target="_blank">Stripe.com</a></div>
						<div class="form-group">
							<label for="ProcessPaymentsStripe" class="col-lg-3 col-md-3">Process Stripe Payments:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="ProcessPaymentsStripe" class="form-control" required="no" Multiple="No" selected="#Session.SiteConfigSettings.Stripe_ProcessPayments#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Process Online Payments with Stripe?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="StripeTestMode" class="col-lg-3 col-md-3">Stripe Test Mode:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="StripeTestMode" class="form-control" required="no" Multiple="No" selected="#Session.SiteConfigSettings.Stripe_TestMode#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Stripe Test Mode Enabled?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="StripeTestAPIKey" class="col-lg-3 col-md-3">Stripe Test API Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StripeTestAPIKey" value="#Session.SiteConfigSettings.Stripe_TestAPIKey#" name="StripeTestAPIKey"></div>
						</div>
						<div class="form-group">
							<label for="StripeLiveAPIKey" class="col-lg-3 col-md-3">Stripe Live API Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StripeLiveAPIKey" name="StripeLiveAPIKey" value="#Session.SiteConfigSettings.Stripe_LiveAPIKey#"></div>
						</div>
						<fieldset>
							<legend><h2>Facebook Application Configuration</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="FacebookEnabled" class="col-lg-3 col-md-3">Publish to Facebook Page:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="FacebookEnabled" class="form-control" required="no" Multiple="No" selected="#Session.SiteConfigSettings.Facebook_Enabled#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Publish Events to Facebook Company Page?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="FacebookAppID" class="col-lg-3 col-md-3">Facebook Application ID:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppID" name="FacebookAppID" value="#Session.SiteConfigSettings.Facebook_AppID#"></div>
						</div>
						<div class="form-group">
							<label for="FacebookAppSecretKey" class="col-lg-3 col-md-3">Facebook App Secret Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppSecretKey" name="FacebookAppSecretKey" value="#Session.SiteConfigSettings.Facebook_AppSecretKey#"></div>
						</div>
						<div class="form-group">
							<label for="FacebookPageID" class="col-lg-3 col-md-3">Facebook Page ID:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookPageID" name="FacebookPageID" value="#Session.SiteConfigSettings.Facebook_PageID#"></div>
						</div>
						<div class="form-group">
							<label for="FacebookAppScope" class="col-lg-3 col-md-3">Facebook Application Scope:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppScope" name="FacebookAppScope" value="#Session.SiteConfigSettings.Facebook_AppScope#"></div>
						</div>
						<fieldset>
							<legend><h2>Twitter Application Configuration</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="TwitterEnabled" class="col-lg-3 col-md-3">Send Tweets regarding events:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="TwitterEnabled" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.SiteConfigSettings.Twitter_Enabled#" queryposition="below"><option value="----">Publish Events to Companies Twitter Handle?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="TwitterConsumerKey" class="col-lg-3 col-md-3">Twitter Consumer Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterConsumerKey" name="TwitterConsumerKey" value="#Session.SiteConfigSettings.Twitter_ConsumerKey#"></div>
						</div>
						<div class="form-group">
							<label for="TwitterConsumerSecretKey" class="col-lg-3 col-md-3">Twitter Consumer Secret Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterConsumerSecretKey" name="TwitterConsumerSecretKey" value="#Session.SiteConfigSettings.Twitter_ConsumerSecret#"></div>
						</div>
						<div class="form-group">
							<label for="TwitterAccessToken" class="col-lg-3 col-md-3">Twitter Access Token:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterAccessToken" name="TwitterAccessToken" value="#Session.SiteConfigSettings.Twitter_AccessToken#"></div>
						</div>
						<div class="form-group">
							<label for="TwitterAccessTokenSecret" class="col-lg-3 col-md-3">Twitter Access Token Secret:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterAccessTokenSecret" name="TwitterAccessTokenSecret" value="#Session.SiteConfigSettings.Twitter_AccessTokenSecret#"></div>
						</div>
						<fieldset>
							<legend><h2>Google ReCaptcha Form Protection</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to enable Google ReCaptcha Form Protections for this plugin. For more information on Google ReCaptcha Service, please visit <a href="https://www.google.com/recaptcha/" target="_blank">Google ReCaptcha Site</a></div>
						<div class="form-group">
							<label for="GoogleReCaptchaEnabled" class="col-lg-3 col-md-3">Google ReCaptcha Enabled:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="GoogleReCaptchaEnabled" class="form-control" required="no" selected="#Session.SiteConfigSettings.GoogleReCaptcha_Enabled#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Enable Google ReCaptcha Form Protection?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="GoogleReCaptchaSiteKey" class="col-lg-3 col-md-3">Site Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleReCaptchaSiteKey" name="GoogleReCaptchaSiteKey" value="#Session.SiteConfigSettings.GoogleReCaptcha_SiteKey#"></div>
						</div>
						<div class="form-group">
							<label for="GoogleReCaptchaSecretKey" class="col-lg-3 col-md-3">Secret Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleReCaptchaSecretKey" name="GoogleReCaptchaSecretKey" value="#Session.SiteConfigSettings.GoogleReCaptcha_SecretKey#"></div>
						</div>
						<fieldset>
							<legend><h2>Smarty Streets Address Verification Service</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to enable Smarty Streets Processing for this plugin. For more information on the Smarty Streets Service, please visit <a href="http://www.smartystreets.com" target="_blank">SmartyStreets.com</a></div>
						<div class="form-group">
							<label for="SmartyStreetsEnabled" class="col-lg-3 col-md-3">Smarty Streets Enabled:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="SmartyStreetsEnabled" class="form-control" required="no" Multiple="No" selected="#Session.SiteConfigSettings.SmartyStreets_Enabled#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Enable Smarty Streets API?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="SmartyStreetsAPIID" class="col-lg-3 col-md-3">API ID:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SmartyStreetsAPIID" name="SmartyStreetsAPIID" value="#Session.SiteConfigSettings.SmartyStreets_APIID#"></div>
						</div>
						<div class="form-group">
							<label for="SmartyStreetsAPITOKEN" class="col-lg-3 col-md-3">API Token:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SmartyStreetsAPITOKEN" name="SmartyStreetsAPITOKEN" value="#Session.SiteConfigSettings.SmartyStreets_APIToken#"></div>
						</div>
						<fieldset>
							<legend><h2>Company Specific Plugin Features</h2></legend>
						</fieldset>
						<div class="alert alert-info">Does your company have policies in place for the following procedures?</div>
						<div class="form-group">
							<label for="BillForNoShowRegistration" class="col-lg-3 col-md-3">Bill Participant For NoShow:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="BillForNoShowRegistration" class="form-control" required="no" Multiple="No" selected="#Session.SiteConfigSettings.BillForNoShowRegistrations#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Should Application Bill Participant for NoShows?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="RequireEventSurveyToGetCertificate" class="col-lg-3 col-md-3">Require Survey to Get Certificate:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="RequireEventSurveyToGetCertificate" class="form-control" required="no" Multiple="No" selected="#Session.SiteConfigSettings.RequireSurveyToGetCertificate#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Require Submission of Event Survey to Obtain Completion Certiifcate?</option></cfselect></div>
						</div>
						<fieldset>
							<legend><h2>Social Media Profiles</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to display social media profile icons to visitors of this plugin</div>
						<div class="form-group">
							<label for="GitHubProfileURL" class="col-lg-3 col-md-3">GitHub Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GitHubProfileURL" name="GitHubProfileURL" value="#Session.SiteConfigSettings.GitHub_URL#"></div>
						</div>
						<div class="form-group">
							<label for="TwitterProfileURL" class="col-lg-3 col-md-3">Twitter Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterProfileURL" name="TwitterProfileURL" value="#Session.SiteConfigSettings.Twitter_URL#"></div>
						</div>
						<div class="form-group">
							<label for="FacebookProfileURL" class="col-lg-3 col-md-3">Facebook Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookProfileURL" name="FacebookProfileURL" value="#Session.SiteConfigSettings.Facebook_URL#"></div>
						</div>
						<div class="form-group">
							<label for="GoogleProfileURL" class="col-lg-3 col-md-3">Google+ Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleProfileURL" name="GoogleProfileURL" value="#Session.SiteConfigSettings.GoogleProfile_URL#"></div>
						</div>
						<div class="form-group">
							<label for="LinkedInProfileURL" class="col-lg-3 col-md-3">LinkedIn Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LinkedInProfileURL" name="LinkedInProfileURL" value="#Session.SiteConfigSettings.LinkedIn_URL#"></div>
						</div>
					</div>
					<div class="panel-footer">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Site Configuration"><br /><br />
					</div>
				</cfform>
			</div>
		<cfelseif isDefined("URL.FormRetry")>
			<div class="panel panel-default">
				<cfform action="" method="post" id="AddEvent" class="form-horizontal">
					<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteID')#">
					<cfinput type="hidden" name="JavaLibraryJars" value="#Variables.ReportLibraryJars#">
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
					<div class="panel-body">
						<fieldset>
							<legend><h2>Modify Site Configuration Settings</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to modify site configuration settings</div>
						<div class="form-group">
							<label for="SiteID" class="col-lg-3 col-md-3">Site ID:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SiteID" name="SiteID" disabled value="#$.siteConfig('siteid')#"></div>
						</div>
						<cfif FileExists(Variables.FileTest1) EQ false or FileExists(Variables.FileTest2) EQ false or FileExists(Variables.FileTest3) EQ false or FileExists(Variables.FileTest4) EQ false>
							<fieldset>
								<legend><h2>Required JAR Files not installed</h2></legend>
							</fieldset>
							<div class="alert alert-info">To Generate various PDF Documents, required library files will need to be installed. If required files are not installed then PDF documents can not be generated</div>
							<div class="form-group">
								<label for="CFMLProductName" class="col-lg-3 col-md-3">Coldfusion Product Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="CFMLProductName" name="CFMLProductName" disabled value="#Server.Coldfusion.ProductName#"></div>
							</div>
							<div class="form-group">
								<label for="InstallJarFiles" class="col-lg-3 col-md-3">Install Required JAR Files:&nbsp;</label>
								<div class="col-lg-9 col-md-9"><cfselect name="InstallJarFiles" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value= "----">Install Required Files?</option></cfselect></div>
							</div>
						</cfif>
						<fieldset>
							<legend><h2>Stripe Payment Processor Configuration</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to enable Stripe Payment Processing for this plugin. For more information on the Stripe Processing Service, please visit <a href="http://www.stripe.com" target="_blank">Stripe.com</a></div>
						<div class="form-group">
							<label for="ProcessPaymentsStripe" class="col-lg-3 col-md-3">Process Stripe Payments:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="ProcessPaymentsStripe" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.ProcessPaymentsStripe#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Process Online Payments with Stripe?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="StripeTestMode" class="col-lg-3 col-md-3">Stripe Test Mode:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="StripeTestMode" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.StripeTestMode#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Stripe Test Mode Enabled?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="StripeTestAPIKey" class="col-lg-3 col-md-3">Stripe Test API Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StripeTestAPIKey" value="#Session.FormInput.StripeTestAPIKey#" name="StripeTestAPIKey"></div>
						</div>
						<div class="form-group">
							<label for="StripeLiveAPIKey" class="col-lg-3 col-md-3">Stripe Live API Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="StripeLiveAPIKey" name="StripeLiveAPIKey" value="#Session.FormInput.StripeLiveAPIKey#"></div>
						</div>
						<fieldset>
							<legend><h2>Facebook Application Configuration</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="FacebookEnabled" class="col-lg-3 col-md-3">Publish to Facebook Page:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="FacebookEnabled" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.FacebookEnabled#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Publish Events to Facebook Company Page?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="FacebookAppID" class="col-lg-3 col-md-3">Facebook Application ID:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppID" name="FacebookAppID" value="#Session.FormInput.FacebookAppID#"></div>
						</div>
						<div class="form-group">
							<label for="FacebookAppSecretKey" class="col-lg-3 col-md-3">Facebook App Secret Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppSecretKey" name="FacebookAppSecretKey" value="#Session.FormInput.FacebookAppSecretKey#"></div>
						</div>
						<div class="form-group">
							<label for="FacebookPageID" class="col-lg-3 col-md-3">Facebook Page ID:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookPageID" name="FacebookPageID" value="#Session.FormInput.FacebookPageID#"></div>
						</div>
						<div class="form-group">
							<label for="FacebookAppScope" class="col-lg-3 col-md-3">Facebook Application Scope:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookAppScope" name="FacebookAppScope" value="#Session.FormInput.FacebookAppScope#"></div>
						</div>
						<fieldset>
							<legend><h2>Twitter Application Configuration</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="TwitterEnabled" class="col-lg-3 col-md-3">Send Tweets regarding events:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="TwitterEnabled" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.TwitterEnabled#" queryposition="below"><option value="----">Publish Events to Companies Twitter Handle?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="TwitterConsumerKey" class="col-lg-3 col-md-3">Twitter Consumer Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterConsumerKey" name="TwitterConsumerKey" value="#Session.FormInput.TwitterConsumerKey#"></div>
						</div>
						<div class="form-group">
							<label for="TwitterConsumerSecretKey" class="col-lg-3 col-md-3">Twitter Consumer Secret Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterConsumerSecretKey" name="TwitterConsumerSecretKey" value="#Session.FormInput.TwitterConsumerSecretKey#"></div>
						</div>
						<div class="form-group">
							<label for="TwitterAccessToken" class="col-lg-3 col-md-3">Twitter Access Token:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterAccessToken" name="TwitterAccessToken" value="#Session.FormInput.TwitterAccessToken#"></div>
						</div>
						<div class="form-group">
							<label for="TwitterAccessTokenSecret" class="col-lg-3 col-md-3">Twitter Access Token Secret:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterAccessTokenSecret" name="TwitterAccessTokenSecret" value="#Session.FormInput.TwitterAccessTokenSecret#"></div>
						</div>
						<fieldset>
							<legend><h2>Google ReCaptcha Form Protection</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to enable Google ReCaptcha Form Protections for this plugin. For more information on Google ReCaptcha Service, please visit <a href="https://www.google.com/recaptcha/" target="_blank">Google ReCaptcha Site</a></div>
						<div class="form-group">
							<label for="GoogleReCaptchaEnabled" class="col-lg-3 col-md-3">Google ReCaptcha Enabled:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="GoogleReCaptchaEnabled" class="form-control" required="no" selected="#Session.FormInput.GoogleReCaptchaEnabled#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Enable Google ReCaptcha Form Protection?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="GoogleReCaptchaSiteKey" class="col-lg-3 col-md-3">Site Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleReCaptchaSiteKey" name="GoogleReCaptchaSiteKey" value="#Session.FormInput.GoogleReCaptchaSiteKey#"></div>
						</div>
						<div class="form-group">
							<label for="GoogleReCaptchaSecretKey" class="col-lg-3 col-md-3">Secret Key:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleReCaptchaSecretKey" name="GoogleReCaptchaSecretKey" value="#Session.FormInput.GoogleReCaptchaSecretKey#"></div>
						</div>
						<fieldset>
							<legend><h2>Smarty Streets Address Verification Service</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to enable Smarty Streets Processing for this plugin. For more information on the Smarty Streets Service, please visit <a href="http://www.smartystreets.com" target="_blank">SmartyStreets.com</a></div>
						<div class="form-group">
							<label for="SmartyStreetsEnabled" class="col-lg-3 col-md-3">Smarty Streets Enabled:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="SmartyStreetsEnabled" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.SmartyStreetsEnabled#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Enable Smarty Streets API?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="SmartyStreetsAPIID" class="col-lg-3 col-md-3">API ID:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SmartyStreetsAPIID" name="SmartyStreetsAPIID" value="#Session.FormInput.SmartyStreetsAPIID#"></div>
						</div>
						<div class="form-group">
							<label for="SmartyStreetsAPITOKEN" class="col-lg-3 col-md-3">API Token:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="SmartyStreetsAPITOKEN" name="SmartyStreetsAPITOKEN" value="#Session.FormInput.SmartyStreetsAPITOKEN#"></div>
						</div>
						<fieldset>
							<legend><h2>Company Specific Plugin Features</h2></legend>
						</fieldset>
						<div class="alert alert-info">Does your company have policies in place for the following procedures?</div>
						<div class="form-group">
							<label for="BillForNoShowRegistration" class="col-lg-3 col-md-3">Bill Participant For NoShow:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="BillForNoShowRegistration" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.BillForNoShowRegistration#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Should Application Bill Participant for NoShows?</option></cfselect></div>
						</div>
						<div class="form-group">
							<label for="RequireEventSurveyToGetCertificate" class="col-lg-3 col-md-3">Require Survey to Get Certificate:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfselect name="RequireEventSurveyToGetCertificate" class="form-control" required="no" Multiple="No" selected="#Session.FormInput.RequireEventSurveyToGetCertificate#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Require Submission of Event Survey to Obtain Completion Certiifcate?</option></cfselect></div>
						</div>
						<fieldset>
							<legend><h2>Social Media Profiles</h2></legend>
						</fieldset>
						<div class="alert alert-info">Please complete the following information to display social media profile icons to visitors of this plugin</div>
						<div class="form-group">
							<label for="GitHubProfileURL" class="col-lg-3 col-md-3">GitHub Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GitHubProfileURL" name="GitHubProfileURL" value="#Session.FormInput.GitHubProfileURL#"></div>
						</div>
						<div class="form-group">
							<label for="TwitterProfileURL" class="col-lg-3 col-md-3">Twitter Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="TwitterProfileURL" name="TwitterProfileURL" value="#Session.FormInput.TwitterProfileURL#"></div>
						</div>
						<div class="form-group">
							<label for="FacebookProfileURL" class="col-lg-3 col-md-3">Facebook Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="FacebookProfileURL" name="FacebookProfileURL" value="#Session.FormInput.FacebookProfileURL#"></div>
						</div>
						<div class="form-group">
							<label for="GoogleProfileURL" class="col-lg-3 col-md-3">Google+ Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="GoogleProfileURL" name="GoogleProfileURL" value="#Session.FormInput.GoogleProfileURL#"></div>
						</div>
						<div class="form-group">
							<label for="LinkedInProfileURL" class="col-lg-3 col-md-3">LinkedIn Profile URL:&nbsp;</label>
							<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="LinkedInProfileURL" name="LinkedInProfileURL" value="#Session.FormInput.LinkedInProfileURL#"></div>
						</div>
					</div>
					<div class="panel-footer">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Site Configuration"><br /><br />
					</div>
				</cfform>
			</div>
		</cfif>
	</cfif>
</cfoutput>