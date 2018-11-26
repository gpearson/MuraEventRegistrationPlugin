<cfif not isDefined("FORM.formRetry")>
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
						<label for="FName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.getUserProfile.Fname#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LName" class="control-label col-sm-3">Last Name:&nbsp;</label>
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