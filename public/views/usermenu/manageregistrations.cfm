<cfif not isDefined("FORM.formSubmit") and not isDefined("FORM.EventID")>
	<cfquery name="GetRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT eEvents.TContent_ID as EventID, eEvents.ShortTitle, eEvents.EventDate, eRegistrations.RequestsMeal, eEvents.PGPAvailable,
			eEvents.PGPPoints, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice, eRegistrations.WebinarParticipant, eRegistrations.AttendedEvent,
			eRegistrations.TContent_ID as RegistrationID
		FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID
		WHERE eRegistrations.Site_ID = <cfqueryparam value="#Session.Mura.SiteID#" cfsqltype="cf_sql_varchar"> AND
			eRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
		ORDER BY eRegistrations.RegistrationDate DESC
	</cfquery>
	<cfparam name="HaveCertificatesAvailable" default="false">
	<cfoutput>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Listing of Events you have registered for:</h3>
			</div>
			<div class="art-blockcontent">
				<Form method="Post" action="" id="">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="formSubmit" value="true">
					<table class="art-article" style="width: 100%;" cellspacing="0" cellpadding="0">
						<tbody>
							<tr>
								<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
									<table class="art-article" style="width: 100%;">
										<thead>
											<tr style="font-face: Arial; font-weight: bold; font-size: 12px;">
												<td width="200" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Event Title</td>
												<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Event Date</td>
												<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Requests Meal</td>
												<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Distance Learning</td>
												<td width="70" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Webinar</td>
												<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Event Price</td>
												<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Actions</td>
											</tr>
										</thead>
										<tbody>
											<cfloop query="GetRegisteredEvents">
												<tr>
													<td width="200" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">#GetRegisteredEvents.ShortTitle#</td>
													<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">#DateFormat(GetRegisteredEvents.EventDate, "mmm dd, yyyy")#</td>
													<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;"><cfif GetRegisteredEvents.RequestsMeal EQ 0>No<cfelse>Yes</cfif></td>
													<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;"><cfif GetRegisteredEvents.IVCParticipant EQ 0>No<cfelse>Yes</cfif></td>
													<td width="70" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;"><cfif GetRegisteredEvents.WebinarParticipant EQ 0>No<cfelse>Yes</cfif></td>
													<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">#DollarFormat(GetRegisteredEvents.AttendeePrice)#</td>
													<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
														<cfif DateDiff("d", Now(), GetRegisteredEvents.EventDate) GTE 0><Input type="Radio" name="CancelEventID" value="#GetRegisteredEvents.RegistrationID#" >Cancel Registration<br></cfif>
														<Input type="Radio" name="ViewRegistrationID" value="#GetRegisteredEvents.RegistrationID#" >View Registration<br>
														<cfif GetRegisteredEvents.PGPAvailable EQ 1 and GetRegisteredEvents.AttendedEvent EQ 1>
															<Input type="Radio" name="CertificatelEventID" value="#GetRegisteredEvents.RegistrationID#" >View Certificate
														</cfif>
													</td>
												</tr>
											</cfloop>
										</tbody>
										<tfoot>
											<tr>
												<td colspan="7" align="center" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;"><input type="Submit" Name="GetCertificate" class="art-button" Value="Perform Selected Action"></td>
											</tr>
										</tfoot>
									</table>
								</td>
							</tr>
						</tbody>
					</table>
				</form>
			</div>
		</div>
	</cfoutput>
</cfif>